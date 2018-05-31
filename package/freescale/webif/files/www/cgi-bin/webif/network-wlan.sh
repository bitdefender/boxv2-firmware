#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
###################################################################
# Wireless configuration
#
# Description: Configures wireless interfaces.
#
# Load settings from the wireless config file.
###################################################################

uci_load wireless

########################################################
# Initializing variables                               #
########################################################
radio0_found=0
radio1_found=0
radio2_found=0
wifi_found=0
num_wifi_found=0
radio_gui_config_field=""
indexes=""
bgn_mode_channel_options="1 2 3 4 5 6 7 8 9 10 11 auto"
an_mode_channel_options="36 40 44 48 52 56 60 64 100 104 108 112 116 136 140 149 153 157 161 165"
b_mode_mrate_options="1 2 5.5 11"
bg_mode_mrate_options="1 2 5.5 6 9 11 12 18 24 36 48 54"
agn_mode_mrate_options="6 9 12 18 24 36 48 54"
an_gn_mode_1x_x1_chain_txrate_options="MCS0 MCS1 MCS2 MCS3 MCS4 MCS5 MCS6 MCS7"
an_gn_mode_rest_chain_txrate_options="MCS0 MCS1 MCS2 MCS3 MCS4 MCS5 MCS6 MCS7 MCS8 MCS9 MCS10 MCS11 MCS12 MCS13 MCS14 MCS15"

aggregation_support="n"
tx_rx_chain_mask_support="n"

####CHANNEL
channel_11bgn_mode_options=""
for i in $bgn_mode_channel_options; do
  channel_11bgn_mode_options="$channel_11bgn_mode_options 
                            option|$i|@TR<<$i>>"
done
channel_11an_mode_options=""
for i in $an_mode_channel_options; do
  channel_11an_mode_options="$channel_11an_mode_options 
                            option|$i|@TR<<$i>>"
done

#### MULTICAST RATE and TX RATE
mrate_11b_mode_options=""
for i in $b_mode_mrate_options; do
  mrate_11b_mode_options="$mrate_11b_mode_options 
                            option|$i|@TR<<$i>>"
done
tx_rate_11b_mode_options="$mrate_11b_mode_options"

mrate_11bg_mode_options=""
for i in $bg_mode_mrate_options; do
  mrate_11bg_mode_options="$mrate_11bg_mode_options 
                            option|$i|@TR<<$i>>"
done
tx_rate_11bg_mode_options="$mrate_11bg_mode_options"

mrate_11agn_mode_options=""
for i in $agn_mode_mrate_options; do
  mrate_11agn_mode_options="$mrate_11agn_mode_options 
                            option|$i|@TR<<$i>>"
done
tx_rate_11a_11g_mode_options="$mrate_11agn_mode_options"
tx_rate_11an_11gn_mode_1x_x1_chain_options="$mrate_11agn_mode_options"
tx_rate_11an_11gn_mode_rest_chain_options="$mrate_11agn_mode_options"

for i in $an_gn_mode_1x_x1_chain_txrate_options; do
  tx_rate_11an_11gn_mode_1x_x1_chain_options="$tx_rate_11an_11gn_mode_1x_x1_chain_options 
                                              option|$i|@TR<<$i>>"
done
for i in $an_gn_mode_rest_chain_txrate_options; do
  tx_rate_11an_11gn_mode_rest_chain_options="$tx_rate_11an_11gn_mode_rest_chain_options 
                                             option|$i|@TR<<$i>>"
done

########################################################
# Find cards and make enable radio button              #
########################################################

config_get radio0_found   general radio0_found
config_get radio1_found   general radio1_found
config_get radio2_found   general radio2_found

if [ "$radio0_found" = "1" -o "$radio1_found" = "1" -o "$radio2_found" = "1" ]; then
  wifi_found=1
else
  wifi_found=0
fi

if [ "$wifi_found" -eq 1 ]; then
  radio_gui_config_field="field|@TR<<Radio>>|radio_type"
  if [ "$radio0_found" -eq 1 ]; then
    radio_gui_config_field="$radio_gui_config_field
                            radio|radio_type|$FORM_radio_type|radio0|@TR<<Radio0 (PCIe0)>>"
    indexes="$indexes 0"
    num_wifi_found=`expr $num_wifi_found + 1`
  else
    radio_gui_config_field="$radio_gui_config_field
                            radio|radio_type|$FORM_radio_type|radio0|@TR<<Radio0 (PCIe0)>>|disabled"
  fi
  radio_gui_config_field="$radio_gui_config_field
                          string|<br>"
  if [ "$radio1_found" -eq 1 ]; then
    radio_gui_config_field="$radio_gui_config_field
                            radio|radio_type|$FORM_radio_type|radio1|@TR<<Radio1 (PCIe1)>>"
    indexes="$indexes 1"
    num_wifi_found=`expr $num_wifi_found + 1`
  else
    radio_gui_config_field="$radio_gui_config_field
                            radio|radio_type|$FORM_radio_type|radio1|@TR<<Radio1 (PCIe1)>>|disabled"
  fi
  radio_gui_config_field="$radio_gui_config_field
                          string|<br>"
  if [ "$radio2_found" -eq 1 ]; then
    radio_gui_config_field="$radio_gui_config_field
                            radio|radio_type|$FORM_radio_type|radio2|@TR<<Radio2 (USB)>>"
    indexes="$indexes 2"
    num_wifi_found=`expr $num_wifi_found + 1`
  else
    radio_gui_config_field="$radio_gui_config_field
                            radio|radio_type|$FORM_radio_type|radio2|@TR<<Radio2 (USB)>>|disabled"
  fi
  radio_gui_config_field="$radio_gui_config_field
                          string|<br>"
fi

if [ "$wifi_found" -eq 1 ]; then
  if empty "$FORM_save"; then
    for index in $indexes; do
      config_get FORM_mode_$index radio$index mode
      config_get FORM_channel_width_$index radio$index channel_width
      eval mode_field="\$FORM_mode_$index"
      if [ "$mode_field" = "11b" -o "$mode_field" = "11bg" -o "$mode_field" = "11g" -o "$mode_field" = "11gn" ]; then
        config_get FORM_channel_${index}_11bgn radio$index channel
      else
        config_get FORM_channel_${index}_11an radio$index channel
      fi
      if [ "$mode_field" = "11b" ]; then
        config_get FORM_multicast_rate_${index}_11b radio$index multicast_rate
      elif [ "$mode_field" = "11bg" ]; then
        config_get FORM_multicast_rate_${index}_11bg radio$index multicast_rate
      else
        config_get FORM_multicast_rate_${index}_11agn radio$index multicast_rate
      fi
      if [ "$tx_rx_chain_mask_support" = "y" ]; then
        config_get FORM_tx_chain_mask_$index radio$index tx_chain_mask
        eval tx_chain_mask_field="\$FORM_tx_chain_mask_$index"
        config_get FORM_rx_chain_mask_$index radio$index rx_chain_mask
        eval rx_chain_mask_field="\$FORM_rx_chain_mask_$index"
      fi
      if [ "$mode_field" = "11b" ]; then
        config_get FORM_tx_rate_${index}_11b radio$index tx_rate
      elif [ "$mode_field" = "11bg" ]; then
        config_get FORM_tx_rate_${index}_11bg radio$index tx_rate
      elif [ "$mode_field" = "11a" -o "$mode_field" = "11g" ]; then
        config_get FORM_tx_rate_${index}_11a_11g radio$index tx_rate
      elif [ "$mode_field" = "11an" -o "$mode_field" = "11gn" -o "$mode_field" = "11ac" ]; then
        if [ "$tx_rx_chain_mask_support" = "y" ]; then
          if [ "$tx_chain_mask_field" = "1" -o "$rx_chain_mask_field" = "1" ]; then
            config_get FORM_tx_rate_${index}_11an_11gn_1x_x1 radio$index tx_rate
          else
            config_get FORM_tx_rate_${index}_11an_11gn_rest radio$index tx_rate
          fi
        else
          config_get FORM_tx_rate_${index}_11an_11gn_rest radio$index tx_rate
        fi
      fi
      config_get FORM_rts_threshold_$index radio$index rts_threshold
      config_get FORM_cts_threshold_$index radio$index cts_threshold
      if [ "$aggregation_support" = "y" ]; then
        config_get FORM_aggregation_$index radio$index aggregation
        config_get FORM_aggregation_frames_$index radio$index aggregation_frames
        config_get FORM_aggregation_size_$index radio$index aggregation_size
        config_get FORM_aggregation_min_size_$index radio$index aggregation_min_size
      fi
      eval var1="\$FORM_mode_$index"
    done
  else
    radio0_validations=""
    radio1_validations=""
    radio2_validations=""
    if [ "$radio0_found" = "1" ]; then
     if [ "$aggregation_support" = "y" ]; then
      if [ -n "$FORM_aggregation_min_size_0" ]; then
        if [ $FORM_aggregation_min_size_0 -lt 4096 -o $FORM_aggregation_min_size_0 -gt 65536 ]; then
          min_aggregation_size=4096
        else
          min_aggregation_size=$FORM_aggregation_min_size_0
        fi
      else
        min_aggregation_size=4096
      fi
      if [ -n "$FORM_aggregation_size_0" ]; then
        if [ $FORM_aggregation_size_0 -lt 4096 -o $FORM_aggregation_size_0 -gt 65536 ]; then
          max_aggregation_min_size=65536
        else
          max_aggregation_min_size=$FORM_aggregation_size_0
        fi
      else
        max_aggregation_min_size=65536
      fi
      radio0_validations="int|FORM_rts_threshold_0|@TR<<RTS Threshold in Radio0(PCIe0)>>|required min=0 max=2347|$FORM_rts_threshold_0
int|FORM_cts_threshold_0|@TR<<CTS Threshold in Radio0(PCIe0)>>|required min=0 max=2347|$FORM_cts_threshold_0
int|FORM_aggregation_frames_0|@TR<<Aggregation Frames in Radio0(PCIe0)>>|required min=2 max=64|$FORM_aggregation_frames_0
int|FORM_aggregation_size_0|@TR<<Aggregation Size in Radio0(PCIe0)>>|required min=$min_aggregation_size max=65536|$FORM_aggregation_size_0
int|FORM_aggregation_min_size_0|@TR<<Aggregation Min Size in Radio0(PCIe0)>>|required min=4096 max=$max_aggregation_min_size|$FORM_aggregation_min_size_0"
     else
      radio0_validations="int|FORM_rts_threshold_0|@TR<<RTS Threshold in Radio0(PCIe0)>>|required min=0 max=2347|$FORM_rts_threshold_0
int|FORM_cts_threshold_0|@TR<<CTS Threshold in Radio0(PCIe0)>>|required min=0 max=2347|$FORM_cts_threshold_0"
     fi
    fi
    if [ "$radio1_found" = "1" ]; then
     if [ "$aggregation_support" = "y" ]; then
      if [ -n "$FORM_aggregation_min_size_1" ]; then
        if [ $FORM_aggregation_min_size_1 -lt 4096 -o $FORM_aggregation_min_size_1 -gt 65536 ]; then
          min_aggregation_size=4096
        else
          min_aggregation_size=$FORM_aggregation_min_size_1
        fi
      else
        min_aggregation_size=4096
      fi
      if [ -n "$FORM_aggregation_size_1" ]; then
        if [ $FORM_aggregation_size_1 -lt 4096 -o $FORM_aggregation_size_1 -gt 65536 ]; then
          max_aggregation_min_size=65536
        else
          max_aggregation_min_size=$FORM_aggregation_size_1
        fi
      else
        max_aggregation_min_size=65536
      fi
      radio1_validations="int|FORM_rts_threshold_1|@TR<<RTS Threshold in Radio1(PCIe1)>>|required min=1 max=2347|$FORM_rts_threshold_1
int|FORM_cts_threshold_1|@TR<<CTS Threshold in Radio1(PCIe1)>>|required min=0 max=2347|$FORM_cts_threshold_1
int|FORM_aggregation_frames_1|@TR<<Aggregation Frames in Radio1(PCIe1)>>|required min=2 max=64|$FORM_aggregation_frames_1
int|FORM_aggregation_size_1|@TR<<Aggregation Size in Radio1(PCIe1)>>|required min=$min_aggregation_size max=65536|$FORM_aggregation_size_1
int|FORM_aggregation_min_size_1|@TR<<Aggregation Min Size in Radio1(PCIe1)>>|required min=4096 max=$max_aggregation_min_size|$FORM_aggregation_min_size_1"
     else
      radio1_validations="int|FORM_rts_threshold_1|@TR<<RTS Threshold in Radio1(PCIe1)>>|required min=1 max=2347|$FORM_rts_threshold_1
int|FORM_cts_threshold_1|@TR<<CTS Threshold in Radio1(PCIe1)>>|required min=0 max=2347|$FORM_cts_threshold_1"
     fi
    fi
    if [ "$radio2_found" = "1" ]; then
     if [ "$aggregation_support" = "y" ]; then
      if [ -n "$FORM_aggregation_min_size_2" ]; then
        if [ $FORM_aggregation_min_size_2 -lt 4096 -o $FORM_aggregation_min_size_2 -gt 65536 ]; then
          min_aggregation_size=4096
        else
          min_aggregation_size=$FORM_aggregation_min_size_2
        fi
      else
        min_aggregation_size=4096
      fi
      if [ -n "$FORM_aggregation_size_2" ]; then
        if [ $FORM_aggregation_size_2 -lt 4096 -o $FORM_aggregation_size_2 -gt 65536 ]; then
          max_aggregation_min_size=65536
        else
          max_aggregation_min_size=$FORM_aggregation_size_2
        fi
      else
        max_aggregation_min_size=65536
      fi
      radio2_validations="int|FORM_rts_threshold_2|@TR<<RTS Threshold in Radio2(USB)>>|required min=1 max=2347|$FORM_rts_threshold_2
int|FORM_cts_threshold_2|@TR<<CTS Threshold in Radio2(USB)>>|required min=0 max=2347|$FORM_cts_threshold_2
int|FORM_aggregation_frames_2|@TR<<Aggregation Frames in Radio2(USB)>>|required min=2 max=64|$FORM_aggregation_frames_2
int|FORM_aggregation_size_2|@TR<<Aggregation Size in Radio2(USB)>>|required min=$min_aggregation_size max=65536|$FORM_aggregation_size_2
int|FORM_aggregation_min_size_2|@TR<<Aggregation Min Size in Radio2(USB)>>|required min=4096 max=$max_aggregation_min_size|$FORM_aggregation_min_size_2"
     else
      radio2_validations="int|FORM_rts_threshold_2|@TR<<RTS Threshold in Radio2(USB)>>|required min=1 max=2347|$FORM_rts_threshold_2
int|FORM_cts_threshold_2|@TR<<CTS Threshold in Radio2(USB)>>|required min=0 max=2347|$FORM_cts_threshold_2"
     fi
    fi
validate <<EOF
$radio0_validations
$radio1_validations
$radio2_validations
EOF
   equal "$?" 0 && {
    for index in $indexes; do
      eval mode_field="\$FORM_mode_$index"
      uci_set wireless "radio$index" mode "$mode_field"
      if [ "$mode_field" != "11ac" ]; then
        eval channel_width_field="\$FORM_channel_width_$index"
        uci_set wireless "radio$index" channel_width "$channel_width_field"
      fi
      if [ "$mode_field" = "11b" -o "$mode_field" = "11bg" -o "$mode_field" = "11g" -o "$mode_field" = "11gn" ]; then
        eval channel_field="\$FORM_channel_${index}_11bgn"
      else
        eval channel_field="\$FORM_channel_${index}_11an"
      fi
      uci_set wireless "radio$index" channel "$channel_field"
      if [ "$mode_field" = "11b" ]; then
        eval multicast_rate_field="\$FORM_multicast_rate_${index}_11b"
      elif [ "$mode_field" = "11bg" ]; then
        eval multicast_rate_field="\$FORM_multicast_rate_${index}_11bg"
      else
        eval multicast_rate_field="\$FORM_multicast_rate_${index}_11agn"
      fi
      uci_set wireless "radio$index" multicast_rate "$multicast_rate_field"
      if [ "$tx_rx_chain_mask_support" = "y" ]; then
        eval tx_chain_mask_field="\$FORM_tx_chain_mask_$index"
        uci_set wireless "radio$index" tx_chain_mask "$tx_chain_mask_field"
        eval rx_chain_mask_field="\$FORM_rx_chain_mask_$index"
        uci_set wireless "radio$index" rx_chain_mask "$rx_chain_mask_field"
      fi
      if [ "$mode_field" = "11b" ]; then
        eval tx_rate_field="\$FORM_tx_rate_${index}_11b"
      elif [ "$mode_field" = "11bg" ]; then
        eval tx_rate_field="\$FORM_tx_rate_${index}_11bg"
      elif [ "$mode_field" = "11a" -o "$mode_field" = "11g" ]; then
        eval tx_rate_field="\$FORM_tx_rate_${index}_11a_11g"
      elif [ "$mode_field" = "11an" -o "$mode_field" = "11gn" -o "$mode_field" = "11ac" ]; then
        if [ "$tx_rx_chain_mask_support" = "y" ]; then
          if [ "$tx_chain_mask_field" = "1" -o "$rx_chain_mask_field" = "1" ]; then
            eval tx_rate_field="\$FORM_tx_rate_${index}_11an_11gn_1x_x1"
          else
            eval tx_rate_field="\$FORM_tx_rate_${index}_11an_11gn_rest"
          fi
        else
          eval tx_rate_field="\$FORM_tx_rate_${index}_11an_11gn_rest"
        fi
      fi
      uci_set wireless "radio$index" tx_rate "$tx_rate_field"
      eval rts_threshold_field="\$FORM_rts_threshold_$index"
      uci_set wireless "radio$index" rts_threshold "$rts_threshold_field"
      eval cts_threshold_field="\$FORM_cts_threshold_$index"
      uci_set wireless "radio$index" cts_threshold "$cts_threshold_field"
      if [ "$aggregation_support" = "y" ]; then
        eval aggregation_field="\$FORM_aggregation_$index"
        uci_set wireless "radio$index" aggregation "$aggregation_field"
        eval aggregation_frames_field="\$FORM_aggregation_frames_$index"
        uci_set wireless "radio$index" aggregation_frames "$aggregation_frames_field"
        eval aggregation_size_field="\$FORM_aggregation_size_$index"
        uci_set wireless "radio$index" aggregation_size "$aggregation_size_field"
        eval aggregation_min_size_field="\$FORM_aggregation_min_size_$index"
        uci_set wireless "radio$index" aggregation_min_size "$aggregation_min_size_field"
      fi
    done
   }
  fi
fi



#####################################################################
# modechange script
#
header "Network" "Wireless" "@TR<<Wireless Configuration>>" 'onload="init()"' "$SCRIPT_NAME"
cat <<EOF
$wep_passphrase_error
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">
<!--
function visible_radio_configuration(radio_slot, status)
{
  var aggregation_status;
  var tx_rx_chain_mask_status;

  if ( '$aggregation_support' == "y" )
  {
    aggregation_status = status;
  }
  else
  {
    aggregation_status = false;
  }
  if ( '$tx_rx_chain_mask_support' == "y" )
  {
    tx_rx_chain_mask_status = status;
  }
  else
  {
    tx_rx_chain_mask_status = false;
  }
  if ( radio_slot == 0 )
  {
    set_visible('heading_0', status);
    set_visible('mode_0', status);
    if ( document.forms[0].mode_0.value == "11ac"  ) 
    {
      set_visible('channel_width_0', false);
    }
    else
    {
      set_visible('channel_width_0', status);
    }
//    set_visible_channel(radio_slot, status);
    if ( ( document.forms[0].mode_0.value == "11b"  ) ||
         ( document.forms[0].mode_0.value == "11bg" ) ||
         ( document.forms[0].mode_0.value == "11g"  ) ||
         ( document.forms[0].mode_0.value == "11gn" ) )
    {
      set_visible('channel_0_11bgn', status);
      set_visible('channel_0_11an', false);
    }
    else
    {
      set_visible('channel_0_11an', status);
      set_visible('channel_0_11bgn', false);
    }
    if ( document.forms[0].mode_0.value == "11b"  ) 
    {
      set_visible('multicast_rate_0_11b', status);
      set_visible('multicast_rate_0_11bg', false);
      set_visible('multicast_rate_0_11agn', false);
    }
    else if ( document.forms[0].mode_0.value == "11bg"  ) 
    {
      set_visible('multicast_rate_0_11bg', status);
      set_visible('multicast_rate_0_11b', false);
      set_visible('multicast_rate_0_11agn', false);
    }
    else 
    {
      set_visible('multicast_rate_0_11agn', status);
      set_visible('multicast_rate_0_11b', false);
      set_visible('multicast_rate_0_11bg', false);
    }
    if ( document.forms[0].mode_0.value == "11b"  ) 
    {
      set_visible('tx_rate_0_11b', status);
      set_visible('tx_rate_0_11bg', false);
      set_visible('tx_rate_0_11a_11g', false);
      set_visible('tx_rate_0_11an_11gn_1x_x1', false);
      set_visible('tx_rate_0_11an_11gn_rest', false);
    }
    else if ( document.forms[0].mode_0.value == "11bg"  ) 
    {
      set_visible('tx_rate_0_11bg', status);
      set_visible('tx_rate_0_11b', false);
      set_visible('tx_rate_0_11a_11g', false);
      set_visible('tx_rate_0_11an_11gn_1x_x1', false);
      set_visible('tx_rate_0_11an_11gn_rest', false);
    }
    else if ( ( document.forms[0].mode_0.value == "11a"  ) ||
              ( document.forms[0].mode_0.value == "11g"  ) )
    {
      set_visible('tx_rate_0_11a_11g', status);
      set_visible('tx_rate_0_11b', false);
      set_visible('tx_rate_0_11bg', false);
      set_visible('tx_rate_0_11an_11gn_1x_x1', false);
      set_visible('tx_rate_0_11an_11gn_rest', false);
    }
    else if ( ( document.forms[0].mode_0.value == "11an"  ) ||
              ( document.forms[0].mode_0.value == "11ac"  ) ||
              ( document.forms[0].mode_0.value == "11gn"  ) )
    {
      if ( '$tx_rx_chain_mask_support' == "y" )
      {
        if ( ( document.forms[0].tx_chain_mask_0.value == "1"  ) ||
             ( document.forms[0].rx_chain_mask_0.value == "1"  ) )
        {
          set_visible('tx_rate_0_11an_11gn_1x_x1', status);
          set_visible('tx_rate_0_11b', false);
          set_visible('tx_rate_0_11bg', false);
          set_visible('tx_rate_0_11a_11g', false);
          set_visible('tx_rate_0_11an_11gn_rest', false);
        }
        else
        {
          set_visible('tx_rate_0_11an_11gn_rest', status);
          set_visible('tx_rate_0_11b', false);
          set_visible('tx_rate_0_11bg', false);
          set_visible('tx_rate_0_11a_11g', false);
          set_visible('tx_rate_0_11an_11gn_1x_x1', false);
        }
      }
      else
      {
        set_visible('tx_rate_0_11an_11gn_rest', status);
        set_visible('tx_rate_0_11b', false);
        set_visible('tx_rate_0_11bg', false);
        set_visible('tx_rate_0_11a_11g', false);
        set_visible('tx_rate_0_11an_11gn_1x_x1', false);
      }
    }
    set_visible('rts_threshold_0', status);
    set_visible('cts_threshold_0', status);
    set_visible('aggregation_0', aggregation_status);
    set_visible('aggregation_frames_0', aggregation_status);
    set_visible('aggregation_size_0', aggregation_status);
    set_visible('aggregation_min_size_0', aggregation_status);
    set_visible('tx_chain_mask_0', tx_rx_chain_mask_status);
    set_visible('rx_chain_mask_0', tx_rx_chain_mask_status);
  }
  else if ( radio_slot == 1 )
  {
    set_visible('heading_1', status);
    set_visible('mode_1', status);
    if ( document.forms[0].mode_1.value == "11ac"  ) 
    {
      set_visible('channel_width_1', false);
    }
    else
    {
      set_visible('channel_width_1', status);
    }
//    set_visible('channel_1', status);
    if ( ( document.forms[0].mode_1.value == "11b"  ) ||
         ( document.forms[0].mode_1.value == "11bg" ) ||
         ( document.forms[0].mode_1.value == "11g"  ) ||
         ( document.forms[0].mode_1.value == "11gn" ) )
    {
      set_visible('channel_1_11bgn', status);
      set_visible('channel_1_11an', false);
    }
    else
    {
      set_visible('channel_1_11an', status);
      set_visible('channel_1_11bgn', false);
    }
    if ( document.forms[0].mode_1.value == "11b"  ) 
    {
      set_visible('multicast_rate_1_11b', status);
      set_visible('multicast_rate_1_11bg', false);
      set_visible('multicast_rate_1_11agn', false);
    }
    else if ( document.forms[0].mode_1.value == "11bg"  ) 
    {
      set_visible('multicast_rate_1_11bg', status);
      set_visible('multicast_rate_1_11b', false);
      set_visible('multicast_rate_1_11agn', false);
    }
    else 
    {
      set_visible('multicast_rate_1_11agn', status);
      set_visible('multicast_rate_1_11b', false);
      set_visible('multicast_rate_1_11bg', false);
    }
    if ( document.forms[0].mode_1.value == "11b"  ) 
    {
      set_visible('tx_rate_1_11b', status);
      set_visible('tx_rate_1_11bg', false);
      set_visible('tx_rate_1_11a_11g', false);
      set_visible('tx_rate_1_11an_11gn_1x_x1', false);
      set_visible('tx_rate_1_11an_11gn_rest', false);
    }
    else if ( document.forms[0].mode_1.value == "11bg"  ) 
    {
      set_visible('tx_rate_1_11bg', status);
      set_visible('tx_rate_1_11b', false);
      set_visible('tx_rate_1_11a_11g', false);
      set_visible('tx_rate_1_11an_11gn_1x_x1', false);
      set_visible('tx_rate_1_11an_11gn_rest', false);
    }
    else if ( ( document.forms[0].mode_1.value == "11a"  ) ||
              ( document.forms[0].mode_1.value == "11g"  ) )
    {
      set_visible('tx_rate_1_11a_11g', status);
      set_visible('tx_rate_1_11b', false);
      set_visible('tx_rate_1_11bg', false);
      set_visible('tx_rate_1_11an_11gn_1x_x1', false);
      set_visible('tx_rate_1_11an_11gn_rest', false);
    }
    else if ( ( document.forms[0].mode_1.value == "11an"  ) ||
              ( document.forms[0].mode_1.value == "11ac"  ) ||
              ( document.forms[0].mode_1.value == "11gn"  ) )
    {
      if ( '$tx_rx_chain_mask_support' == "y" )
      {
        if ( ( document.forms[0].tx_chain_mask_1.value == "1"  ) ||
             ( document.forms[0].rx_chain_mask_1.value == "1"  ) )
        {
          set_visible('tx_rate_1_11an_11gn_1x_x1', status);
          set_visible('tx_rate_1_11b', false);
          set_visible('tx_rate_1_11bg', false);
          set_visible('tx_rate_1_11a_11g', false);
          set_visible('tx_rate_1_11an_11gn_rest', false);
        }
        else
        {
          set_visible('tx_rate_1_11an_11gn_rest', status);
          set_visible('tx_rate_1_11b', false);
          set_visible('tx_rate_1_11bg', false);
          set_visible('tx_rate_1_11a_11g', false);
          set_visible('tx_rate_1_11an_11gn_1x_x1', false);
        }
      }
      else
      {
        set_visible('tx_rate_1_11an_11gn_rest', status);
        set_visible('tx_rate_1_11b', false);
        set_visible('tx_rate_1_11bg', false);
        set_visible('tx_rate_1_11a_11g', false);
        set_visible('tx_rate_1_11an_11gn_1x_x1', false);
      }
    }
    set_visible('rts_threshold_1', status);
    set_visible('cts_threshold_1', status);
    set_visible('aggregation_1', aggregation_status);
    set_visible('aggregation_frames_1', aggregation_status);
    set_visible('aggregation_size_1', aggregation_status);
    set_visible('aggregation_min_size_1', aggregation_status);
    set_visible('tx_chain_mask_1', tx_rx_chain_mask_status);
    set_visible('rx_chain_mask_1', tx_rx_chain_mask_status);
  }
  else if ( radio_slot == 2 )
  {
    set_visible('heading_2', status);
    set_visible('mode_2', status);
    if ( document.forms[0].mode_2.value == "11ac"  ) 
    {
      set_visible('channel_width_2', false);
    }
    else
    {
      set_visible('channel_width_2', status);
    }
//    set_visible('channel_2', status);
    if ( ( document.forms[0].mode_2.value == "11b"  ) ||
         ( document.forms[0].mode_2.value == "11bg" ) ||
         ( document.forms[0].mode_2.value == "11g"  ) ||
         ( document.forms[0].mode_2.value == "11gn" ) )
    {
      set_visible('channel_2_11bgn', status);
      set_visible('channel_2_11an', false);
    }
    else
    {
      set_visible('channel_2_11an', status);
      set_visible('channel_2_11bgn', false);
    }
    if ( document.forms[0].mode_2.value == "11b"  ) 
    {
      set_visible('multicast_rate_2_11b', status);
      set_visible('multicast_rate_2_11bg', false);
      set_visible('multicast_rate_2_11agn', false);
    }
    else if ( document.forms[0].mode_2.value == "11bg"  ) 
    {
      set_visible('multicast_rate_2_11bg', status);
      set_visible('multicast_rate_2_11b', false);
      set_visible('multicast_rate_2_11agn', false);
    }
    else 
    {
      set_visible('multicast_rate_2_11agn', status);
      set_visible('multicast_rate_2_11b', false);
      set_visible('multicast_rate_2_11bg', false);
    }
    if ( document.forms[0].mode_2.value == "11b"  ) 
    {
      set_visible('tx_rate_2_11b', status);
      set_visible('tx_rate_2_11bg', false);
      set_visible('tx_rate_2_11a_11g', false);
      set_visible('tx_rate_2_11an_11gn_1x_x1', false);
      set_visible('tx_rate_2_11an_11gn_rest', false);
    }
    else if ( document.forms[0].mode_2.value == "11bg"  ) 
    {
      set_visible('tx_rate_2_11bg', status);
      set_visible('tx_rate_2_11b', false);
      set_visible('tx_rate_2_11a_11g', false);
      set_visible('tx_rate_2_11an_11gn_1x_x1', false);
      set_visible('tx_rate_2_11an_11gn_rest', false);
    }
    else if ( ( document.forms[0].mode_2.value == "11a"  ) ||
              ( document.forms[0].mode_2.value == "11g"  ) )
    {
      set_visible('tx_rate_2_11a_11g', status);
      set_visible('tx_rate_2_11b', false);
      set_visible('tx_rate_2_11bg', false);
      set_visible('tx_rate_2_11an_11gn_1x_x1', false);
      set_visible('tx_rate_2_11an_11gn_rest', false);
    }
    else if ( ( document.forms[0].mode_2.value == "11an"  ) ||
              ( document.forms[0].mode_2.value == "11ac"  ) ||
              ( document.forms[0].mode_2.value == "11gn"  ) )
    {
      if ( '$tx_rx_chain_mask_support' == "y" )
      {
        if ( ( document.forms[0].tx_chain_mask_2.value == "1"  ) ||
             ( document.forms[0].rx_chain_mask_2.value == "1"  ) )
        {
          set_visible('tx_rate_2_11an_11gn_1x_x1', status);
          set_visible('tx_rate_2_11b', false);
          set_visible('tx_rate_2_11bg', false);
          set_visible('tx_rate_2_11a_11g', false);
          set_visible('tx_rate_2_11an_11gn_rest', false);
        }
        else
        {
          set_visible('tx_rate_2_11an_11gn_rest', status);
          set_visible('tx_rate_2_11b', false);
          set_visible('tx_rate_2_11bg', false);
          set_visible('tx_rate_2_11a_11g', false);
          set_visible('tx_rate_2_11an_11gn_1x_x1', false);
        }
      }
      else
      {
        set_visible('tx_rate_2_11an_11gn_rest', status);
        set_visible('tx_rate_2_11b', false);
        set_visible('tx_rate_2_11bg', false);
        set_visible('tx_rate_2_11a_11g', false);
        set_visible('tx_rate_2_11an_11gn_1x_x1', false);
      }
    }
    set_visible('rts_threshold_2', status);
    set_visible('cts_threshold_2', status);
    set_visible('aggregation_2', aggregation_status);
    set_visible('aggregation_frames_2', aggregation_status);
    set_visible('aggregation_size_2', aggregation_status);
    set_visible('aggregation_min_size_2', aggregation_status);
    set_visible('tx_chain_mask_2', tx_rx_chain_mask_status);
    set_visible('rx_chain_mask_2', tx_rx_chain_mask_status);
  }
  else
  {
    alert ('Invalid radio slot' + radio_slot + 'passed to the visible_radio_configuration().');
    return false ;
  }

  return true ;
}

function radiomodechange()
{
  if ( document.forms[0].radio_type[0].checked )
  {
    visible_radio_configuration(0, true);
    visible_radio_configuration(1, false);
    visible_radio_configuration(2, false);
  }
  else if ( document.forms[0].radio_type[1].checked )
  {
    visible_radio_configuration(0, false);
    visible_radio_configuration(1, true);
    visible_radio_configuration(2, false);
  }
  else if ( document.forms[0].radio_type[2].checked )
  {
    visible_radio_configuration(0, false);
    visible_radio_configuration(1, false);
    visible_radio_configuration(2, true);
  }
  else
  {
    visible_radio_configuration(0, false);
    visible_radio_configuration(1, false);
    visible_radio_configuration(2, false);
  }
  
  return true ;
}

function init()
{
  if ( '$num_wifi_found' == 0)
  {
    alert('No Wi-Fi card present.');
    return true ;
  }

  if ( ( document.forms[0].radio_type[0].checked != true ) &&
       ( document.forms[0].radio_type[1].checked != true ) &&
       ( document.forms[0].radio_type[2].checked != true ) )
  {
    if ( '$radio0_found' == 1 )
    {
      document.forms[0].radio_type[0].checked = true ;
    }
    else if ( '$radio1_found' == 1 )
    {
      document.forms[0].radio_type[1].checked = true ;
    }
    else if ( '$radio2_found' == 1 )
    {
      document.forms[0].radio_type[2].checked = true ;
    }
  }

  if ( '$num_wifi_found' == 1)
  {
    set_visible('radio_type', false);
  }

  radiomodechange();

  return true ;
}

function modechange()
{
	var v;
	$js

	hide('save');
	show('save');
}
-->
</script>

EOF

#echo "<tr id=\"heading_0\" style=\"display: none;\"> <th colspan=\"15\"><font size=\"2\" color=\"#0000FF\"> Radio0 (PCIe0) Configuration: </font></th></tr>"
#echo "<tr id=\"heading_1\" style=\"display: none;\"> <th colspan=\"15\"><font size=\"2\" color=\"#0000FF\"> Radio1 (PCIe1) Configuration: </font></th></tr>"
#echo "<tr id=\"heading_2\" style=\"display: none;\"> <th colspan=\"15\"><font size=\"2\" color=\"#0000FF\"> Radio2 (USB) Configuration: </font></th></tr>"
#$validate_error
#$ERROR
#$forms
for radioindex in 0 1 2; do
config_get devname "radio$radioindex" devname
deviceid=`cat /sys/class/net/$devname/device/device`
if [ -n "$deviceid" ]; then
  if [ "$deviceid" = "0x003c" -o "$deviceid" = "0xabcd" ]; then
    if [ $radioindex = 0 ]; then
      radio0_11ac_config="option|11ac|@TR<<A+C>>"
    elif [ $radioindex = 1 ]; then
      radio1_11ac_config="option|11ac|@TR<<A+C>>"
    elif [ $radioindex = 2 ]; then
      radio2_11ac_config="option|11ac|@TR<<A+C>>"
    fi
  fi
fi
done

[ "$wifi_found" -eq 1 ] && {

display_form <<EOF
start_form|@TR<<Radio Configuration>>
onchange|radiomodechange

field||heading_0|hidden
string| @TR<< <b>Radio0 (PCIe0) Configuration : </b> >>
field||heading_1|hidden
string| @TR<< <b>Radio1 (PCIe1) Configuration : </b> >>
field||heading_2|hidden
string| @TR<< <b>Radio2 (USB) Configuration : </b> >>

$radio_gui_config_field

field|@TR<<Mode>>|mode_0|hidden
select|mode_0|$FORM_mode_0
option|11b|@TR<<B only>>
option|11bg|@TR<<B+G>>
option|11gn|@TR<<G+N>>
option|11g|@TR<<G only>>
option|11a|@TR<<A only>>
option|11an|@TR<<A+N>>
$radio0_11ac_config
field|@TR<<Channel Width>>|channel_width_0|hidden
select|channel_width_0|$FORM_channel_width_0
option|20|@TR<<20>>
option|40+|@TR<<40+>>
option|40-|@TR<<40->>
field|@TR<<Channel>>|channel_0_11bgn|hidden
select|channel_0_11bgn|$FORM_channel_0_11bgn
$channel_11bgn_mode_options
field|@TR<<Channel>>|channel_0_11an|hidden
select|channel_0_11an|$FORM_channel_0_11an
$channel_11an_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_0_11b|hidden
select|multicast_rate_0_11b|$FORM_multicast_rate_0_11b
$mrate_11b_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_0_11bg|hidden
select|multicast_rate_0_11bg|$FORM_multicast_rate_0_11bg
$mrate_11bg_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_0_11agn|hidden
select|multicast_rate_0_11agn|$FORM_multicast_rate_0_11agn
$mrate_11agn_mode_options
field|@TR<<Tx Rate>>|tx_rate_0_11b|hidden
select|tx_rate_0_11b|$FORM_tx_rate_0_11b
$tx_rate_11b_mode_options
field|@TR<<Tx Rate>>|tx_rate_0_11bg|hidden
select|tx_rate_0_11bg|$FORM_tx_rate_0_11bg
$tx_rate_11bg_mode_options
field|@TR<<Tx Rate>>|tx_rate_0_11a_11g|hidden
select|tx_rate_0_11a_11g|$FORM_tx_rate_0_11a_11g
$tx_rate_11a_11g_mode_options
field|@TR<<Tx Rate>>|tx_rate_0_11an_11gn_1x_x1|hidden
select|tx_rate_0_11an_11gn_1x_x1|$FORM_tx_rate_0_11an_11gn_1x_x1
$tx_rate_11an_11gn_mode_1x_x1_chain_options
field|@TR<<Tx Rate>>|tx_rate_0_11an_11gn_rest|hidden
select|tx_rate_0_11an_11gn_rest|$FORM_tx_rate_0_11an_11gn_rest
$tx_rate_11an_11gn_mode_rest_chain_options
field|@TR<<RTS Threshold>>|rts_threshold_0|hidden
text|rts_threshold_0|$FORM_rts_threshold_0
field|@TR<<CTS Threshold>>|cts_threshold_0|hidden
text|cts_threshold_0|$FORM_cts_threshold_0
field|@TR<<Aggregation>>|aggregation_0|hidden
radio|aggregation_0|$FORM_aggregation_0|enable|@TR<<Enable>>
radio|aggregation_0|$FORM_aggregation_0|disable|@TR<<Disable>>
field|@TR<<Aggregation Frames>>|aggregation_frames_0|hidden
text|aggregation_frames_0|$FORM_aggregation_frames_0
field|@TR<<Aggregation Size>>|aggregation_size_0|hidden
text|aggregation_size_0|$FORM_aggregation_size_0
field|@TR<<Aggregation Min Size>>|aggregation_min_size_0|hidden
text|aggregation_min_size_0|$FORM_aggregation_min_size_0
field|@TR<<Tx Chain Mask>>|tx_chain_mask_0|hidden
select|tx_chain_mask_0|$FORM_tx_chain_mask_0
option|1|@TR<<1>>
option|2/2|@TR<<2/2>>
option|2/3|@TR<<2/3>>
option|3/3|@TR<<3/3>>
option|auto|@TR<<Auto>>
field|@TR<<Rx Chain Mask>>|rx_chain_mask_0|hidden
select|rx_chain_mask_0|$FORM_rx_chain_mask_0
option|1|@TR<<1>>
option|2/2|@TR<<2/2>>
option|2/3|@TR<<2/3>>
option|3/3|@TR<<3/3>>
option|auto|@TR<<Auto>>

field|@TR<<Mode>>|mode_1|hidden
select|mode_1|$FORM_mode_1
option|11b|@TR<<B only>>
option|11bg|@TR<<B+G>>
option|11gn|@TR<<G+N>>
option|11g|@TR<<G only>>
option|11a|@TR<<A only>>
option|11an|@TR<<A+N>>
$radio1_11ac_config
field|@TR<<Channel Width>>|channel_width_1|hidden
select|channel_width_1|$FORM_channel_width_1
option|20|@TR<<20>>
option|40+|@TR<<40+>>
option|40-|@TR<<40->>
field|@TR<<Channel>>|channel_1_11bgn|hidden
select|channel_1_11bgn|$FORM_channel_1_11bgn
$channel_11bgn_mode_options
field|@TR<<Channel>>|channel_1_11an|hidden
select|channel_1_11an|$FORM_channel_1_11an
$channel_11an_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_1_11b|hidden
select|multicast_rate_1_11b|$FORM_multicast_rate_1_11b
$mrate_11b_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_1_11bg|hidden
select|multicast_rate_1_11bg|$FORM_multicast_rate_1_11bg
$mrate_11bg_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_1_11agn|hidden
select|multicast_rate_1_11agn|$FORM_multicast_rate_1_11agn
$mrate_11agn_mode_options
field|@TR<<Tx Rate>>|tx_rate_1_11b|hidden
select|tx_rate_1_11b|$FORM_tx_rate_1_11b
$tx_rate_11b_mode_options
field|@TR<<Tx Rate>>|tx_rate_1_11bg|hidden
select|tx_rate_1_11bg|$FORM_tx_rate_1_11bg
$tx_rate_11bg_mode_options
field|@TR<<Tx Rate>>|tx_rate_1_11a_11g|hidden
select|tx_rate_1_11a_11g|$FORM_tx_rate_1_11a_11g
$tx_rate_11a_11g_mode_options
field|@TR<<Tx Rate>>|tx_rate_1_11an_11gn_1x_x1|hidden
select|tx_rate_1_11an_11gn_1x_x1|$FORM_tx_rate_1_11an_11gn_1x_x1
$tx_rate_11an_11gn_mode_1x_x1_chain_options
field|@TR<<Tx Rate>>|tx_rate_1_11an_11gn_rest|hidden
select|tx_rate_1_11an_11gn_rest|$FORM_tx_rate_1_11an_11gn_rest
$tx_rate_11an_11gn_mode_rest_chain_options
field|@TR<<RTS Threshold>>|rts_threshold_1|hidden
text|rts_threshold_1|$FORM_rts_threshold_1
field|@TR<<CTS Threshold>>|cts_threshold_1|hidden
text|cts_threshold_1|$FORM_cts_threshold_1
field|@TR<<Aggregation>>|aggregation_1|hidden
radio|aggregation_1|$FORM_aggregation_1|enable|@TR<<Enable>>
radio|aggregation_1|$FORM_aggregation_1|disable|@TR<<Disable>>
field|@TR<<Aggregation Frames>>|aggregation_frames_1|hidden
text|aggregation_frames_1|$FORM_aggregation_frames_1
field|@TR<<Aggregation Size>>|aggregation_size_1|hidden
text|aggregation_size_1|$FORM_aggregation_size_1
field|@TR<<Aggregation Min Size>>|aggregation_min_size_1|hidden
text|aggregation_min_size_1|$FORM_aggregation_min_size_1
field|@TR<<Tx Chain Mask>>|tx_chain_mask_1|hidden
select|tx_chain_mask_1|$FORM_tx_chain_mask_1
option|1|@TR<<1>>
option|2/2|@TR<<2/2>>
option|2/3|@TR<<2/3>>
option|3/3|@TR<<3/3>>
option|auto|@TR<<Auto>>
field|@TR<<Rx Chain Mask>>|rx_chain_mask_1|hidden
select|rx_chain_mask_1|$FORM_rx_chain_mask_1
option|1|@TR<<1>>
option|2/2|@TR<<2/2>>
option|2/3|@TR<<2/3>>
option|3/3|@TR<<3/3>>
option|auto|@TR<<Auto>>

field|@TR<<Mode>>|mode_2|hidden
select|mode_2|$FORM_mode_2
option|11b|@TR<<B only>>
option|11bg|@TR<<B+G>>
option|11gn|@TR<<G+N>>
option|11g|@TR<<G only>>
option|11a|@TR<<A only>>
option|11an|@TR<<A+N>>
$radio2_11ac_config
field|@TR<<Channel Width>>|channel_width_2|hidden
select|channel_width_2|$FORM_channel_width_2
option|20|@TR<<20>>
option|40+|@TR<<40+>>
option|40-|@TR<<40->>
field|@TR<<Channel>>|channel_2_11bgn|hidden
select|channel_2_11bgn|$FORM_channel_2_11bgn
$channel_11bgn_mode_options
field|@TR<<Channel>>|channel_2_11an|hidden
select|channel_2_11an|$FORM_channel_2_11an
$channel_11an_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_2_11b|hidden
select|multicast_rate_2_11b|$FORM_multicast_rate_2_11b
$mrate_11b_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_2_11bg|hidden
select|multicast_rate_2_11bg|$FORM_multicast_rate_2_11bg
$mrate_11bg_mode_options
field|@TR<<Multicast Rate>>|multicast_rate_2_11agn|hidden
select|multicast_rate_2_11agn|$FORM_multicast_rate_2_11agn
$mrate_11agn_mode_options
field|@TR<<Tx Rate>>|tx_rate_2_11b|hidden
select|tx_rate_2_11b|$FORM_tx_rate_2_11b
$tx_rate_11b_mode_options
field|@TR<<Tx Rate>>|tx_rate_2_11bg|hidden
select|tx_rate_2_11bg|$FORM_tx_rate_2_11bg
$tx_rate_11bg_mode_options
field|@TR<<Tx Rate>>|tx_rate_2_11a_11g|hidden
select|tx_rate_2_11a_11g|$FORM_tx_rate_2_11a_11g
$tx_rate_11a_11g_mode_options
field|@TR<<Tx Rate>>|tx_rate_2_11an_11gn_1x_x1|hidden
select|tx_rate_2_11an_11gn_1x_x1|$FORM_tx_rate_2_11an_11gn_1x_x1
$tx_rate_11an_11gn_mode_1x_x1_chain_options
field|@TR<<Tx Rate>>|tx_rate_2_11an_11gn_rest|hidden
select|tx_rate_2_11an_11gn_rest|$FORM_tx_rate_2_11an_11gn_rest
$tx_rate_11an_11gn_mode_rest_chain_options
field|@TR<<RTS Threshold>>|rts_threshold_2|hidden
text|rts_threshold_2|$FORM_rts_threshold_2
field|@TR<<CTS Threshold>>|cts_threshold_2|hidden
text|cts_threshold_2|$FORM_cts_threshold_2
field|@TR<<Aggregation>>|aggregation_2|hidden
radio|aggregation_2|$FORM_aggregation_2|enable|@TR<<Enable>>
radio|aggregation_2|$FORM_aggregation_2|disable|@TR<<Disable>>
field|@TR<<Aggregation Frames>>|aggregation_frames_2|hidden
text|aggregation_frames_2|$FORM_aggregation_frames_2
field|@TR<<Aggregation Size>>|aggregation_size_2|hidden
text|aggregation_size_2|$FORM_aggregation_size_2
field|@TR<<Aggregation Min Size>>|aggregation_min_size_2|hidden
text|aggregation_min_size_2|$FORM_aggregation_min_size_2
field|@TR<<Tx Chain Mask>>|tx_chain_mask_2|hidden
select|tx_chain_mask_2|$FORM_tx_chain_mask_2
option|1|@TR<<1>>
option|2/2|@TR<<2/2>>
option|2/3|@TR<<2/3>>
option|3/3|@TR<<3/3>>
option|auto|@TR<<Auto>>
field|@TR<<Rx Chain Mask>>|rx_chain_mask_2|hidden
select|rx_chain_mask_2|$FORM_rx_chain_mask_2
option|1|@TR<<1>>
option|2/2|@TR<<2/2>>
option|2/3|@TR<<2/3>>
option|3/3|@TR<<3/3>>
option|auto|@TR<<Auto>>

field||spacer1
string|<br />
submit|save|@TR<<Save>>
end_form
field|@TR<<>>
string|<a href="network-wlan-advance.sh" ><b>VAP configuration</b></a>
EOF

}


footer ?>
<!--
##WEBIF:name:Network:300:Wireless
-->
