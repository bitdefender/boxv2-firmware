######################################################
# Webif base
#
# Description:
#        Holds primary functions. Header, footer, etc..
#
# Author(s) [in order of work date]:
#        A variety of people. Several X-Wrt developers.
#
# Major revisions:
#
# Configuration files referenced:
#


libdir=/usr/lib/webif
wwwdir=/www
cgidir=/www/cgi-bin/webif
rootdir=/cgi-bin/webif
cachedir=/tmp/.webcache
cachetime=7200			# cache time-out: 5 days

. /usr/lib/webif/functions.sh
. /lib/config/uci.sh


uci_load "webif"
_device="$CONFIG_general_device_name"

init_cache() {
	[ -d $cachedir ] || mkdir $cachedir 2>/dev/null 1>&2
	awk -F: -v rootdir="$rootdir" -v cachedir="$cachedir" -v USER="${1:-root}" \
	    -f /usr/lib/webif/common.awk -f /usr/lib/webif/acl.awk $cgidir/.categories $cgidir/*.sh 2>/dev/null
}

categories() {
	cachefile="$cachedir/cat_${REMOTE_USER:-root}"
	#awk -F: -v selected="$1" -f /usr/lib/webif/categories.awk $cachefile 2>/dev/null
	sed -e 's%^-:-$%<li>\&nbsp;</li>%' \
	    -e 's%^\([^:]*\):\(.*\)$%<li><a href="\2?cat=\1">@TR<<\1>></a></li>%' \
	    -e '/'"$1"'/s%^<li>\(.*\)$%<li class="selected">\1%' $cachefile 2>/dev/null
}

subcategories() {
	cachefile="$cachedir/subcat_${REMOTE_USER:-root}"
	#awk -F: -v category="$1" -v selected="$2" -f /usr/lib/webif/subcategories.awk $cachefile 2>/dev/null
	
	sed -e '/^'"$1"':/!d' \
	    -e 's%[^:]*:[^:]*:\([^:]*\):\(.*\)$%<li><a href="\2">@TR<<\1>></a></li>%' \
	    -e '/<<'"$2"'>>/s%^<li>\(.*\)$%<li class="selected">\1%' $cachefile 2>/dev/null
}

perm_denied() {
#	[ "$REMOTE_USER" = "root" -o "$REMOTE_USER" = "admin" ] && return 1
	[ "$SCRIPT_NAME" = "/cgi-bin/webif/config.sh" ] && return 1
#	cachefile="$cachedir/subcat_${REMOTE_USER:-root}"
#	grep -q "$SCRIPT_NAME" $cachefile 2>/dev/null && return 1
	
	return 0
}

ShowWIPWarning() {
	echo "<div class=\"warning\">@TR<<big_warning#WARNING>>: @TR<<page_incomplete#This page is incomplete and may not work correctly, or at all.>></div>"
}

ShowUntestedWarning() {
	echo "<div class=\"warning\">@TR<<big_warning#WARNING>>: @TR<<page_untested#This page is untested and may or may not work correctly.>></div>"
}

ShowNotUpdatedWarning() {
       echo "<div class=\"warning\">@TR<<big_warning#WARNING>>: @TR<<page_untested_kamikaze#This page has not been updated or checked for correct functionality under Kamikaze.>></div>"
}

update_changes() {
	CHANGES=$(($( (cat /tmp/.webif/config-* ; ls /tmp/.webif/file-*) 2>&- | wc -l)))
	EDITED_FILES=$(find "/tmp/.webif/edited-files" -type f 2>&- | wc -l)
	CHANGES=$(($CHANGES + $EDITED_FILES))
	# calculate and add number of pending uci changes
	for uci_tmp_file in $(ls /tmp/.uci/* 2>&- | grep -v "\\.lock\$" 2>&-); do
		CHANGES_CUR=$(cat "$uci_tmp_file" | grep "\\w" | wc -l)
		CHANGES=$(($CHANGES + $CHANGES_CUR))
	done
}

pcnt=0
nothave=0
_savebutton_bk=""

has_pkgs() {
	retval=0;
	for pkg in "$@"; do
		pcnt=$((pcnt + 1))
		empty $(opkg list_installed | grep "^$pkg ") && {
			echo -n "<p>@TR<<features_require_package#Features on this page require the package>>: \"<b>$pkg</b>\". &nbsp;<a href=\"/cgi-bin/webif/system-ipkg.sh?action=install&amp;pkg=$pkg&amp;prev=$SCRIPT_NAME\">@TR<<features_install#install now>></a>.</p>"
			retval=1;
			nothave=$((nothave + 1))
		}
	done
	[ -z "$_savebutton_bk" ] && _savebutton_bk=$_savebutton
	if [ "$pcnt" = "$nothave" ]; then
		_savebutton=""
	else
		_savebutton=$_savebutton_bk
	fi
	return $retval;
}

mini_header() {

cat <<EOF
Content-Type: text/html; charset=UTF-8
Pragma: no-cache

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<?xml version="1.0" encoding="UTF-8"?>
<head>
	<link rel="stylesheet" type="text/css" href="/themes/active/webif.css" />        
	<title></title>
	<style type="text/css">
		html, body { background-color: transparent; }
	</style>
</head>
EOF
}

header() {
	empty "$ERROR" && {
		_saved_title="${SAVED:+: @TR<<Settings saved>>}"
	} || {
		FORM_submit="";
		ERROR="<h3 class=\"warning\">$ERROR</h3>"
		_saved_title=": @TR<<Settings not saved>>"
	}

	# Initialize the categories cache if not done already
	[ -s "$cachedir/cat_${REMOTE_USER:-root}" ] || init_cache ${REMOTE_USER:-root}
	#cache_needs_update="$(find $cachedir -mmin -$cachetime -name cat_${REMOTE_USER:-root} 2>/dev/null | wc -l)"
	#[ "$cache_needs_update" = "0" ] && init_cache ${REMOTE_USER:-root}
	

	_category="$1"
	_firmware_version="$CONFIG_general_firmware_version"
	_firmware_name="$CONFIG_general_firmware_name"
	_firmware_subtitle="$CONFIG_general_firmware_subtitle"
	_use_progressbar="$CONFIG_general_use_progressbar"
	_uptime="$(uptime)"
	_loadavg="${_uptime#*load average: }"
	_uptime="${_uptime#*up }"
	_uptime="${_uptime%%, load *}"
	_hostname=$(cat /proc/sys/kernel/hostname)
	_webif_rev=$(cat /www/.version)
	_head="${3:+<h2>$3$_saved_title</h2>}"
	_form="${5:+<form enctype=\"multipart/form-data\" action=\"$5\" method=\"post\"><input type=\"hidden\" name=\"submit\" value=\"1\" />}"
	[ "$7" = "0" ] || _savebutton="${5:+<div class=\"page-save\"><input id=\"savebutton\" type=\"submit\" name=\"action\" value=\"@TR<<Save Changes>>\" /></div>}"
	_categories=$(categories $1)
	_subcategories=${2:+$(subcategories "$1" "$2")}
	_pagename="${2:+@TR<<$2>> - }"
	_time="`date +%T`"
	_date="`date +%F`"
	if ! equal $6 "" && ! equal $6 "0" ; then _pageload="<SCRIPT type='text/javascript'>start=0; end=$6</SCRIPT><SCRIPT src='/js/pageload.js' type='text/javascript'></SCRIPT><DIV id='loadmain'><SCRIPT type='text/javascript'>document.getElementById(\"loadmain\").style.display = \"none\";</SCRIPT>"; _JSload="<SCRIPT type='text/javascript'>load()</SCRIPT>"; fi

#	neq "${SCRIPT_NAME#/cgi-bin/}" "webif.sh" && grep 'root:!' /etc/passwd >&- 2>&- && {
	neq "${SCRIPT_NAME#/cgi-bin/}" "webif.sh" && grep 'root:x' /etc/shadow >&- 2>&- && {
		_nopasswd=1
		_form=""
		_savebutton=""
	}
	asterisk_ico_link=""
	[ -f /www/cgi-bin/webif/asterisk-extension.sh ] && asterisk_ico_link="<a href=\"asterisk-extension.sh\"  title=\"Voice\" class=\"tele_ico\">Voice</a>"
[ -f /www/themes/active/webif_header_info ] && . /www/themes/active/webif_header_info
cat <<EOF
Content-Type: text/html; charset=UTF-8
Pragma: no-cache

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<title>$_pagename$_firmware_name @TR<<Administrative Console>></title>
	<link rel="stylesheet" type="text/css" href="/themes/active/waitbox.css" media="screen" />
	<link rel="stylesheet" type="text/css" href="/themes/active/webif.css" />
	$webif_header_title
	<!--[if lt IE 7]>
		<link rel="stylesheet" type="text/css" href="/themes/active/ie_lt7.css" />
	<![endif]-->                
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="expires" content="-1" />
	<script type="text/javascript" src="/js/styleswitcher.js"></script>
$header_inject_head</head>
<body $4>$header_inject_body

<div id="top_container"> <!-- top - container -->
	<div id="header_wrap"> <!-- header_wrap  -->
		<div id="header"> <!-- header -->
			<h1>@TR<<X-Wrt Administration Console>></h1>
			<div id="test-status">
			  <a href="../../index.html"><img src="/images/logo.jpg" width="239" height="50" alt="logo" /></a>
		  	  <h3><strong>Freescale LS1024A</strong></h3>
			</div>
			<!--<div id="short-status">
			  <h3><strong>@TR<<Status>>:</strong></h3>
                          <ul>
                            <li class="sysname"><strong>$_firmware_name $_firmware_version</strong></li>
                            <li><strong>@TR<<Host>>: </strong>$_hostname</li>
                            <li><strong>@TR<<Date>>: </strong>$_date</li>
                            <li><strong>@TR<<Uptime>>: </strong>$_uptime</li>
                            <li><strong>@TR<<Time>>: </strong>$_time</li>
                            <li><strong>@TR<<Load>>: </strong>$_loadavg</li>
                          </ul>
                        </div>-->
			<div id="header_content">
			<span>Welcome: <strong>Admin</strong>&nbsp;|<!--3:30am 12th Dec 2009.--> <a href="logout.sh">Logout</a></span>
			
				<div id="header_favnav">
					<a href="dash.sh"  title="Dashboard" class="dash_ico">dashboard</a>
					<a href="status-connectivity.sh"  title="Status" class="status_ico">status</a>
					<a href="network-wlan.sh"  title="wifi" class="wifi_ico">wifi</a>
					<a href="network-wan.sh"  title="WAN" class="wan_ico">WAN</a>
					<a href="network-lan.sh"  title="LAN" class="lan_ico">LAN</a>
					$asterisk_ico_link
				</div>
			</div>
		</div> <!-- END header-->
	</div> <!-- END - header_wrap  -->	
	<div id="mainmenu_wrap"><!-- main top nav holder - mainmenu_wrap -->
		<div id="mainmenu_bg"> <!-- main menu background - mainmenu_bg -->
			<div id="mainmenu">  <!-- main menu  -->
			$_categories
			</div> <!-- END main menu  -->
		</div>  <!-- END - main menu background - mainmenu_bg -->

		<div id="submenu_bg"> <!-- sub menu background - mainmenu_bg -->
			<div id="submenu"> <!-- Submenu -->
			$_subcategories
			</div> <!-- END Submenu -->

		</div> <!-- END sub menu background - mainmenu_bg -->

	</div><!-- END - main top nav holder - mainmenu_wrap -->

 </div><!-- END top - container -->

$colorswitcher
EOF

if equal $_use_progressbar "1" ; then echo $_pageload
else echo "<script type='text/javascript'>function load() { }</script>"
fi

insert_httpd_password_settings() {
	echo "/cgi-bin/webif/:root:\$p\$root" >> /etc/httpd.conf
	echo "/cgi-bin/webif/:admin:\$p\$root" >> /etc/httpd.conf
	/etc/init.d/uhttpd restart
}

cat <<EOF
$_form
<div id="content_holder">  <!-- main content holder --> 
  <div id="content_wrap"> <!-- content wrap start --> 
    <div id="content_top"> <!-- content_top header --> 
      <div id="content_heading"> <!-- content_heading - headings of every page --> 
        <!-- <h2><% page_title ((show_info != "") ? (page_title ? ": ": "") show_info : "" ) %></h2>  -->
        $_head
      </div><!-- END content_heading - headings of every page -->
    </div><!-- END content_top header -->
  <div id="content_bg"> <!-- content_bg start -->
<div id="content"> <!-- content start -->

<!--	$_head -->
	$ERROR
EOF

	! empty "$_nopasswd" && neq "${SCRIPT_NAME#/cgi-bin/}" "webif.sh" && {
		! empty "$FORM_passwd1$FORM_passwd2" && {
			equal "$FORM_passwd1" "$FORM_passwd2" && {
				echo '<pre>'
				(
					echo "$FORM_passwd1"
					sleep 1
					echo "$FORM_passwd2"
				) | passwd root 2>&1 && apply_passwd && insert_httpd_password_settings
				echo '</pre><meta http-equiv="refresh" content="4; URL=/cgi-bin/webif/info.sh">'
				footer
				exit
			} || {
				echo "<h3 class=\"warning\">@TR<<Password_mismatch#The entered passwords do not match!>></h3>"
			}
		}
		equal "$_nopasswd" 1 && {
			cat <<EOF
<br />
<br />
<br />
<h3>@TR<<Warning>>: @TR<<Password_warning|You haven't set a password for the Web interface and SSH access.<br />Please enter one now (the user name in your browser will be 'root').>></h3>
<br />
<br />
EOF
			empty "$NOINPUT" && cat <<EOF
<form enctype="multipart/form-data" action="$SCRIPT_NAME" method="POST">
<table>
	<tr>
		<td>@TR<<New Password>>:</td>
		<td><input type="password" name="passwd1" /></td>
	</tr>
	<tr>
		<td>@TR<<Confirm Password>>:</td>
		<td><input type="password" name="passwd2" /></td>
	</tr>
	<tr>
		<td colspan="2"><input type="submit" name="action" value="@TR<<Set>>" /></td>
	</tr>
</table>
</form>
EOF
			footer
			exit
		} || {
			apply_passwd
		}
	}
#	{perm_denied "$_category") && {
	if [ $(perm_denied) = 0 ]; then
		echo "Permission Denied"
		footer
		exit
        fi
#	}
}

#######################################################
# footer
#
footer() {
	update_changes
	_changes=${CHANGES#0}
	_changes=${_changes:+(${_changes})}
	_endform=${_savebutton:+</form>}

cat <<EOF
      </div> <!-- END content -->
    </div> <!-- END content_bg -->
  </div> <!--END content_wrap -->
</div> <!-- END content_holder -->
<br />
<fieldset id="save">
	<legend><strong>@TR<<Proceed Changes>></strong></legend>
	$_savebutton
EOF
	equal "$_use_progressbar" "1" && {
	echo '<script type="text/javascript" src="/js/waitbox.js"></script>'
	}
cat <<EOF
	<ul class="apply">
		<li><a href="config.sh?mode=save&amp;cat=$_category&amp;prev=$SCRIPT_NAME" rel="lightbox" >@TR<<Apply Changes>> &laquo;</a></li>
		<li><a href="config.sh?mode=clear&amp;cat=$_category&amp;prev=$SCRIPT_NAME">@TR<<Clear Changes>> &laquo;</a></li>
		<li><a href="config.sh?mode=review&amp;cat=$_category&amp;prev=$SCRIPT_NAME">@TR<<Review Changes>> $_changes &laquo;</a></li>
	</ul>
</fieldset>
$_endform
<hr />
<div id="footer_wrap">
  <div id="footer">
    <div id="content_icons">
      <a href="config.sh?mode=save&amp;cat=$_category&amp;prev=$SCRIPT_NAME"  title="Apply "><img src="../../../images/apply_ico.jpg" alt="Apply changes icon" /> </a>
      <a href="config.sh?mode=review&amp;cat=$_category&amp;prev=$SCRIPT_NAME"  title="review "><img src="../../../images/review_changes.gif" alt="review changes" /> </a>
      <a href="config.sh?mode=clear&amp;cat=$_category&amp;prev=$SCRIPT_NAME"  title="clear "><img src="../../../images/clear_ico.jpg" alt="clear changes icon" /> </a>
    </div> <!-- End #content_icons -->
  </div> <!-- End #footer -->
</div> <!-- End #footer_wrap -->
</body>
</html>
EOF
}

#######################################################
apply_passwd() {
	case ${SERVER_SOFTWARE%% *} in
		mini_httpd/*)
			grep '^root:' /etc/passwd | cut -d: -f1,2 > $cgidir/.htpasswd
			killall -HUP mini_httpd
			;;
	esac
}

display_form() {
	if empty "$1"; then
		awk -F'|' -f /usr/lib/webif/common.awk -f /usr/lib/webif/form.awk
	else
		echo "$1" | awk -F'|' -f /usr/lib/webif/common.awk -f /usr/lib/webif/form.awk
	fi
}

