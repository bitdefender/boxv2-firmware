#!/usr/bin/webif-page "-U /tmp -u 16384"
<?
. /usr/lib/webif/webif.sh

LOG_FILE=/tmp/upgrade.log
ERR_LOG_FILE=/tmp/upgrade_err.log
board_type=$(cat /proc/cpuinfo 2>/dev/null | sed 2,20d | cut -c16-)
machinfo=$(uname -a 2>/dev/null)
if $(echo "$machinfo" | grep -q "mips"); then
	if $(echo "$board_type" | grep -q "Atheros"); then
		target="atheros-2.6"
	elif $(echo "$board_type" | grep -q "WP54"); then
		target="adm5120-2.6"
	elif $(echo "$machinfo" | grep -q "2\.4"); then
		target="brcm"
	elif $(echo "$machinfo" | grep -q "2\.6"); then
		target="brcm"
	fi
elif $(echo "$machinfo" | grep -q " i[0-9]86 "); then
	target="x86-2.6"
elif $(echo "$machinfo" | grep -q " avr32 "); then
	target="avr32-2.6"
elif $(cat /proc/cpuinfo 2>/dev/null | grep -q "IXP4"); then
	target="ixp4xx-2.6"
elif $(echo "$machinfo" | grep -q " armv7l "); then
	target="arm"
fi

header "System" "Upgrade" "<img src=\"/images/upd.jpg\" alt=\"@TR<<Firmware Upgrade>>\" />&nbsp;@TR<<Firmware Upgrade>>" '' "$SCRIPT_NAME"


if [ "$target" = "x86-2.6" -o "$target" = "brcm" -o "$target" = "adm5120-2.6"  -o "$target" = "atheros-2.6" -o "$target" = "arm" ]; then
validate_error=""

REFRESH_PAGE()
{
cat <<EOF
&nbsp;&nbsp;&nbsp;<br /><br /><b>@TR<<Board reboot in few seconds. After reboot the page will refresh automatically>> ... </b><br /><br />
<script language="JavaScript" type="text/javascript">
setTimeout('top.location.href=\"/$1\"',"200000")
</script>
EOF
}

	if empty "$FORM_submit"; then
display_form <<EOF
start_form
field|@TR<<Firmware Image>>
upload|upgradefile
string|</td></tr><tr><td>
submit|upgrade| @TR<<Upgrade>> |
end_form
EOF
	else
	      rm -rf /tmp/upgradedir
	      mkdir -p /tmp/upgradedir
	      cd /tmp/upgradedir
	      echo "tar -zxf ${FORM_upgradefile}" >/tmp/testecho
	      verified_kernel="n"
	      verified_fs="n"
	      tar -zxf ${FORM_upgradefile}
              if [ $? -eq 0 ]; then
	       if [ $(ls /tmp/upgradedir | wc -l) -eq 2 ]; then
	        for file in $(ls /tmp/upgradedir); do
	          byte1=$(hexdump -n 2 $file | head -n 1 | cut -d' ' -f 2)
	          if [ "$byte1" = "0527" ]; then
                    byte2=$(hexdump -n 4 $file | head -n 1 | cut -d' ' -f 3)
                    if [ "$byte2" = "5619" ]; then
	              verified_kernel="y"
		      kernel_image="/tmp/upgradedir/${file}"
	            else
	              append validate_error "Invalid Kernel image."
	            fi
	          elif [ "$byte1" = "1985" ]; then
		    verified_fs="y"
		    fs_image="/tmp/upgradedir/${file}"
	          elif [ "$byte1" = "4255" ]; then
                    byte2=$(hexdump -n 4 $file | head -n 1 | cut -d' ' -f 3)
                    if [ "$byte2" = "2349" ]; then
	              verified_fs="y"
		      fs_image="/tmp/upgradedir/${file}"
	            else
	              append validate_error "Invalid UBI file system image."
	            fi
		  else
	            append validate_error "Invalid file system image."
	          fi
	        done
	       else
	        append validate_error "Invalid tar ball. Please upload the tar ball of kernel and fs image compressed with gzip compression."
	       fi
	      else
	        append validate_error1 "Invalid tar ball. Please upload the tar ball compressed with gzip compression."
	      fi
	      echo "verified_kernel=$verified_kernel verified_fs=$verified_fs validate_error=$validate_error" >>/tmp/testecho
	      if [ "$verified_kernel" = "y" -a "$verified_fs" = "y" ]; then
		echo "<br />Upgrading firmware, please wait ... <br />"
		kernel_boot_args=$(cat /proc/cmdline)
	 	i=1
		boot_arg=$(echo $kernel_boot_args | cut -d' ' -f $i)
#		echo "boot_arg=$boot_arg" >>/tmp/testecho
		while [ "$boot_arg" != "" ] 
		do
		  if [ $(echo $boot_arg | cut -d'=' -f 1) = "root" ]; then
		    if [ $(echo $boot_arg | grep mtdblock) = "$boot_arg" ]; then
		      rootfs_mtd_part="$(echo $boot_arg | cut -d'=' -f 2 | sed 's/\/dev\/mtdblock//g')"
#		      echo "rootfs_mtd_part=$rootfs_mtd_part"
		    elif [ $(echo $boot_arg | grep rootfs) = "$boot_arg" ]; then
		      i=`expr $i + 1`
		      boot_arg=$(echo $kernel_boot_args | cut -d' ' -f $i)
		      if [ $(echo $boot_arg | grep "ubi\.mtd") = "$boot_arg" ]; then
		        rootfs_mtd_part="$(echo $boot_arg | cut -d'=' -f 2)"
			if [ $(echo $rootfs_mtd_part | grep ",") = "$rootfs_mtd_part" ]; then
		          rootfs_mtd_part="$(echo $boot_arg | cut -d',' -f 1)"
			fi
		      else 
		        echo "ERROR: ubi rootfs mtd partition value not found."
		      fi
		    else
		        echo "ERROR: Invalid root parameter."
		    fi
		    break
		  fi
		  i=`expr $i + 1`
		  boot_arg=$(echo $kernel_boot_args | cut -d' ' -f $i)
		done
		if [ -n $rootfs_mtd_part ]; then
		  if [ $rootfs_mtd_part -eq 4 ]; then
		    nor_flash="y"
		    nand_flash="n"
		  elif [ $rootfs_mtd_part -eq 8 ]; then
		    nor_flash="n"
		    nand_flash="y"
		  else
		    nor_flash="n"
		    nand_flash="n"
		  fi
		  if [ "$nor_flash" = "y" ]; then
		    echo "<br />Erasing the File system partition ... <br />"
		    $DEBUG mtd erase /dev/mtd${rootfs_mtd_part}
		    if [ $? -eq 1 ]; then
		      echo "Failed to erase rootfs partition"
		    fi
		    echo "@TR<<done>>."
		    echo "<br />Writing new image on the File system partition ... <br />"
		    $DEBUG mtd write -q ${fs_image} /dev/mtd${rootfs_mtd_part}
		    if [ $? -eq 1 ]; then
		      echo "Failed to write image on File system partition"
		    fi
		    echo "@TR<<done>>."
		    sync
		    echo "<br />Erasing the Kernel partition ... <br />"
		    $DEBUG mtd erase /dev/mtd`expr $rootfs_mtd_part - 1`
		    if [ $? -eq 1 ]; then
		      echo "Failed to erase Kernel partition"
		    fi
		    echo "@TR<<done>>."
		    echo "<br />Writing new image on the Kernel partition ... <br />"
		    REFRESH_PAGE cgi-bin/webif/system-upgrade.sh
		    $DEBUG mtd write -q -r ${kernel_image} /dev/mtd`expr $rootfs_mtd_part - 1`
		    if [ $? -eq 1 ]; then
		      echo "Failed to write image on Kernel partition"
		    fi
		    echo "@TR<<done>>."
		  elif [ "$nand_flash" = "y" ]; then
		    echo "<br />Erasing the File system partition ... <br />"
		    $DEBUG flash_eraseall -j /dev/mtd${rootfs_mtd_part}
		    if [ $? -eq 1 ]; then
		      echo "Failed to erase File system partition"
		    fi
		    echo "@TR<<done>>."
		    echo "<br />Writing new image on the File system partition ... <br />"
		    $DEBUG nandwrite -p /dev/mtd${rootfs_mtd_part} ${fs_image} >>$LOG_FILE 2>$ERR_LOG_FILE
		    if [ $? -eq 1 ]; then
		      echo "Failed to write image on File system partition"
		    fi
		    echo "@TR<<done>>."
		    sync
		    echo "<br />Erasing the Kernel partition ... <br />"
		    $DEBUG flash_eraseall -j /dev/mtd`expr $rootfs_mtd_part - 1` >>$LOG_FILE 2>$ERR_LOG_FILE
		    if [ $? -eq 1 ]; then
		      echo "Failed to erase Kernel partition"
		    fi
		    echo "@TR<<done>>."
		    echo "<br />Writing new image on the Kernel partition ... <br />"
		    REFRESH_PAGE cgi-bin/webif/system-upgrade.sh
		    $DEBUG nandwrite -p /dev/mtd`expr $rootfs_mtd_part - 1` ${kernel_image}
		    if [ $? -eq 1 ]; then
		      echo "Failed to write image on Kernel partition"
		    fi
		    echo "@TR<<done>>."
		    reboot
		  else
		    echo "Found invalid flash. Neither NOR nor NAND flash."
		  fi
		fi
	      else
	        if [ -n "$validate_error" ]; then
	          echo "<span class="error">$validate_error</span>"
	        fi
	      fi
	fi
else
	echo "<br />The ability to upgrade your platform has not been implemented.<br />"
fi

footer
?>
<!--
##WEBIF:name:System:900:Upgrade
-->
