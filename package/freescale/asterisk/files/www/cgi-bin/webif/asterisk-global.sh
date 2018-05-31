#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
. /etc/functions.sh
uci_load "asterisk"

G711_SPACES="&nbsp;&nbsp;"
G722_SPACES="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
G723_1_SPACES="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
G726_SPACES="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
G729A_SPACES="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
ILBC_SPACES="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
AMR_SPACES="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
AMR_WB_SPACES="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
FORM_active_channels=$(asterisk -rx "mspd count active lines" | grep "lines active" | cut -d: -f 2)
! empty "$FORM_set_default" && {
  uci_set asterisk general dial_timeout "8000"
  uci_set asterisk general interdigit_timeout "1300"
}

! empty "$FORM_hs_regstration_enable" && {
  asterisk -rx "dect register on"  >&- 2>&- <&-
}

! empty "$FORM_down_codec" && {
  codec_id=$FORM_down_codec
  uci_rename asterisk codec${codec_id} temp
  uci_rename asterisk codec`expr $codec_id + 1` codec${codec_id}
  uci_rename asterisk temp codec`expr $codec_id + 1`
  FORM_save=""
}

! empty "$FORM_up_codec" && {
  codec_id=$FORM_up_codec
  uci_rename asterisk codec${codec_id} temp
  uci_rename asterisk codec`expr $codec_id - 1` codec${codec_id}
  uci_rename asterisk temp codec`expr $codec_id - 1`
  FORM_save=""
}
uci_load "asterisk"

config_get no_of_codecs general no_of_codecs
i=1
while [ $i -le $no_of_codecs ]
do
  config_get codec${i}_name codec${i} name
  config_get codec${i}_bit_rate  codec${i} bit_rate
  config_get codec_name codec${i} codec_name
  if [ "$codec_name" = "g723" ] ; then
    codec_g723_id=$i
  elif [ "$codec_name" = "iLBC" ] ; then
    codec_ilbc_id=$i
  fi
  i=`expr $i + 1`
done

if empty "$FORM_save"; then
  i=1
  while [ $i -le $no_of_codecs ]
  do
    config_get codec${i}_name codec${i} name
    config_get FORM_codec${i}  codec${i} value
    config_get codec${i}_bit_rate  codec${i} bit_rate
    i=`expr $i + 1`
  done
  config_get FORM_bitrate_codec_amr general bitrate_codec_amr
  config_get FORM_bitrate_codec_amr_wb general bitrate_codec_amr_wb

  config_get FORM_echo_cancel_type general echo_cancel_type

  config_get FORM_field_dfec_init_control_enable general field_dfec_init_control_enable
  config_get FORM_field_dfec_nlp_control_enable general field_dfec_nlp_control_enable
  config_get FORM_field_dfec_tail general field_dfec_tail
  config_get FORM_field_dfec_master_echo_canceller_enable general field_dfec_master_echo_canceller_enable
  config_get FORM_field_dfec_transmit_input_dc_filter_disable general field_dfec_transmit_input_dc_filter_disable
  config_get FORM_field_dfec_tone_transmitter general field_dfec_tone_transmitter
  config_get FORM_field_dfec_filter_coefficient_freeze general field_dfec_filter_coefficient_freeze
  config_get FORM_field_dfec_dynamic_attenuation general field_dfec_dynamic_attenuation
  config_get FORM_field_dfec_background_noise_replacement general field_dfec_background_noise_replacement
  config_get FORM_field_dfec_sparse_foreground_filter general field_dfec_sparse_foreground_filter
  config_get FORM_field_dfec_nlp_comfort_noise_generation general field_dfec_nlp_comfort_noise_generation
  config_get FORM_field_dfec_echo_path_filter_control general field_dfec_echo_path_filter_control
  config_get FORM_field_dfec_recieve_input_dc_filter_enable general field_dfec_recieve_input_dc_filter_enable

  config_get FORM_field_ec_enable general field_ec_enable
  config_get FORM_field_dc_filter_enable general field_dc_filter_enable
  config_get FORM_field_hec_filter_enable general field_hec_filter_enable
  config_get FORM_field_nlp_control_enable general field_nlp_control_enable
  config_get FORM_field_nlp_tune general field_nlp_tune
  config_get FORM_field_comfort_noise general field_comfort_noise
  config_get FORM_field_ec_tail general field_ec_tail

  config_get FORM_field_full_filter general field_full_filter
  config_get FORM_field_fast_convergence_control general field_fast_convergence_control

  config_get FORM_dial_timeout general dial_timeout
  config_get FORM_interdigit_timeout general interdigit_timeout
  config_get FORM_ntt general ntt
  config_get FORM_band general band
  config_get FORM_fax_mode general fax_mode
  config_get FORM_flash_mode general flash_mode
  config_get FORM_3wc_band general 3wc_band
  config_get FORM_bwe_master general bwe_master
  config_get FORM_bwe_high_band general bwe_high_band
  config_get FORM_bwe_low_band general bwe_low_band
  config_get FORM_rsp_bwe_master general rsp_bwe_master
  config_get FORM_rsp_bwe_high_band general rsp_bwe_high_band
  config_get FORM_rsp_bwe_low_band general rsp_bwe_low_band
  config_get FORM_base_registration general base_registration
  if [ -f /usr/lib/libdspg_dect.so ] ; then
    config_get FORM_dect_pin general dect_pin
  fi
  config_get FORM_voicemail general voicemail
  config_get FORM_dsp_acp general dsp_acp
  config_get FORM_vad general vad
  config_get FORM_rtpcutthru_mode general rtpcutthru_mode
else
  SAVED=1
  validation_success=""
  config_get ec_type_old general echo_cancel_type
  if [ -f /usr/lib/libdspg_dect.so ] ; then
    dect_pin_int="int|FORM_dect_pin|@TR<<PIN code>>|required min=0 max=9999|$FORM_dect_pin"
    dect_pin_string="string|FORM_dect_pin|@TR<<PIN code>>|required min=4 max=4|$FORM_dect_pin"
  else
    dect_pin_int=""
    dect_pin_string=""
  fi

validate <<EOF
int|FORM_dial_timeout|@TR<<Dial Timeout>>|min=8000|$FORM_dial_timeout
int|FORM_interdigit_timeout|@TR<<Interdigit Timeout>>|min=1300|$FORM_interdigit_timeout
$dect_pin_int
$dect_pin_string
int|FORM_bwe_high_band|@TR<<BWE High band>>|min=0 max=10 required|$FORM_bwe_high_band
int|FORM_bwe_low_band|@TR<<BWE Low band>>|min=0 max=10 required|$FORM_bwe_low_band
int|FORM_rsp_bwe_high_band|@TR<<BWE High band for RSP>>|min=0 max=10 required|$FORM_rsp_bwe_high_band
int|FORM_rsp_bwe_low_band|@TR<<BWE Low band for RSP>>|min=0 max=10 required|$FORM_rsp_bwe_low_band
EOF

  equal "$?" 0 && {
    validation_success="y"
	
    if [ "$FORM_active_channels" -eq 0 -o "$ec_type_old" = "$FORM_echo_cancel_type" ] ; then
      uci_set asterisk general echo_cancel_type "$FORM_echo_cancel_type"
      config_set general echo_cancel_type "$FORM_echo_cancel_type"
      uci_set asterisk general field_dfec_init_control_enable "$FORM_field_dfec_init_control_enable"
      uci_set asterisk general field_dfec_nlp_control_enable "$FORM_field_dfec_nlp_control_enable"
      uci_set asterisk general field_dfec_tail "$FORM_field_dfec_tail"
      uci_set asterisk general field_dfec_master_echo_canceller_enable "$FORM_field_dfec_master_echo_canceller_enable"
      uci_set asterisk general field_dfec_transmit_input_dc_filter_disable "$FORM_field_dfec_transmit_input_dc_filter_disable"
      uci_set asterisk general field_dfec_tone_transmitter "$FORM_field_dfec_tone_transmitter"
      uci_set asterisk general field_dfec_filter_coefficient_freeze "$FORM_field_dfec_filter_coefficient_freeze"
      uci_set asterisk general field_dfec_dynamic_attenuation "$FORM_field_dfec_dynamic_attenuation"
      uci_set asterisk general field_dfec_background_noise_replacement "$FORM_field_dfec_background_noise_replacement"
      uci_set asterisk general field_dfec_sparse_foreground_filter "$FORM_field_dfec_sparse_foreground_filter"
      uci_set asterisk general field_dfec_nlp_comfort_noise_generation "$FORM_field_dfec_nlp_comfort_noise_generation"
      uci_set asterisk general field_dfec_echo_path_filter_control "$FORM_field_dfec_echo_path_filter_control"
      uci_set asterisk general field_dfec_recieve_input_dc_filter_enable "$FORM_field_dfec_recieve_input_dc_filter_enable"
      uci_set asterisk general field_set_dfec_factory_value "$FORM_field_set_dfec_factory_value"
      config_set general field_dfec_init_control_enable "$FORM_field_dfec_init_control_enable"
      config_set general field_dfec_nlp_control_enable "$FORM_field_dfec_nlp_control_enable"
      config_set general field_dfec_tail "$FORM_field_dfec_tail"
      config_set general field_dfec_master_echo_canceller_enable "$FORM_field_dfec_master_echo_canceller_enable"
      config_set general field_dfec_transmit_input_dc_filter_disable "$FORM_field_dfec_transmit_input_dc_filter_disable"
      config_set general field_dfec_tone_transmitter "$FORM_field_dfec_tone_transmitter"
      config_set general field_dfec_filter_coefficient_freeze "$FORM_field_dfec_filter_coefficient_freeze"
      config_set general field_dfec_dynamic_attenuation "$FORM_field_dfec_dynamic_attenuation"
      config_set general field_dfec_background_noise_replacement "$FORM_field_dfec_background_noise_replacement"
      config_set general field_dfec_sparse_foreground_filter "$FORM_field_dfec_sparse_foreground_filter"
      config_set general field_dfec_nlp_comfort_noise_generation "$FORM_field_dfec_nlp_comfort_noise_generation"
      config_set general field_dfec_echo_path_filter_control "$FORM_field_dfec_echo_path_filter_control"
      config_set general field_dfec_recieve_input_dc_filter_enable "$FORM_field_dfec_recieve_input_dc_filter_enable"
      config_set general field_set_dfec_factory_value "$FORM_field_set_dfec_factory_value"
      config_set general echo_cancel_type "$FORM_echo_cancel_type"

      uci_set asterisk general field_ec_enable "$FORM_field_ec_enable"
      uci_set asterisk general field_dc_filter_enable "$FORM_field_dc_filter_enable"
      uci_set asterisk general field_hec_filter_enable "$FORM_field_hec_filter_enable"
      uci_set asterisk general field_nlp_control_enable "$FORM_field_nlp_control_enable"
      uci_set asterisk general field_nlp_tune "$FORM_field_nlp_tune"
      uci_set asterisk general field_comfort_noise "$FORM_field_comfort_noise"
      uci_set asterisk general field_ec_tail "$FORM_field_ec_tail"
      config_set general field_ec_enable "$FORM_field_ec_enable"
      config_set general field_dc_filter_enable "$FORM_field_dc_filter_enable"
      config_set general field_hec_filter_enable "$FORM_field_hec_filter_enable"
      config_set general field_nlp_control_enable "$FORM_field_nlp_control_enable"
      config_set general field_nlp_tune "$FORM_field_nlp_tune"
      config_set general field_comfort_noise "$FORM_field_comfort_noise"
      config_set general field_ec_tail "$FORM_field_ec_tail"

      uci_set asterisk general field_full_filter "$FORM_field_full_filter"
      uci_set asterisk general field_fast_convergence_control "$FORM_field_fast_convergence_control"
      config_set general field_full_filter "$FORM_field_full_filter"
      config_set general field_fast_convergence_control "$FORM_field_fast_convergence_control"
    else
      append validate_error "Presently Active channels are present. Echo Canceller change is not allowed."
      config_get FORM_echo_cancel_type general echo_cancel_type
      ERROR=" "
    fi

    i=1
    while [ $i -le $no_of_codecs ]
    do
      eval codec_val="\$FORM_codec${i}"
      uci_set asterisk codec${i} value "$codec_val"
      config_set codec${i} value "$codec_val"
      i=`expr $i + 1`
    done
    uci_set asterisk general bitrate_codec_amr "$FORM_bitrate_codec_amr"

    uci_set asterisk general bitrate_codec_amr_wb "$FORM_bitrate_codec_amr_wb"
    uci_set asterisk general dial_timeout "$FORM_dial_timeout"
    uci_set asterisk general interdigit_timeout "$FORM_interdigit_timeout"
    uci_set asterisk general ntt "$FORM_ntt"
    uci_set asterisk general band "$FORM_band"
    uci_set asterisk general fax_mode "$FORM_fax_mode"
    uci_set asterisk general flash_mode "$FORM_flash_mode"
    uci_set asterisk general 3wc_band "$FORM_3wc_band"
    uci_set asterisk general bwe_master "$FORM_bwe_master"
    uci_set asterisk general bwe_high_band "$FORM_bwe_high_band"
    uci_set asterisk general bwe_low_band "$FORM_bwe_low_band"
    uci_set asterisk general rsp_bwe_master "$FORM_rsp_bwe_master"
    uci_set asterisk general rsp_bwe_high_band "$FORM_rsp_bwe_high_band"
    uci_set asterisk general rsp_bwe_low_band "$FORM_rsp_bwe_low_band"
    if [ -f /usr/lib/libdspg_dect.so ] ; then
      uci_set asterisk general dect_pin "$FORM_dect_pin"
    fi
    uci_set asterisk general voicemail "$FORM_voicemail"
    uci_set asterisk general dsp_acp "$FORM_dsp_acp"
    uci_set asterisk general vad "$FORM_vad"
    uci_set asterisk general rtpcutthru_mode "$FORM_rtpcutthru_mode"

    config_set general bitrate_codec_amr "$FORM_bitrate_codec_amr"
    config_set general bitrate_codec_amr_wb "$FORM_bitrate_codec_amr_wb"

    config_set general dial_timeout "$FORM_dial_timeout"
    config_set general interdigit_timeout "$FORM_interdigit_timeout"
    config_set general ntt "$FORM_ntt"
    config_set general band "$FORM_band"
    config_set general fax_mode "$FORM_fax_mode"
    config_set general flash_mode "$FORM_flash_mode"
    config_set general 3wc_band "$FORM_3wc_band"
    config_set general bwe_master "$FORM_bwe_master"
    config_set general bwe_high_band "$FORM_bwe_high_band"
    config_set general bwe_low_band "$FORM_bwe_low_band"
    config_set general rsp_bwe_master "$FORM_rsp_bwe_master"
    config_set general rsp_bwe_high_band "$FORM_rsp_bwe_high_band"
    config_set general rsp_bwe_low_band "$FORM_rsp_bwe_low_band"
    config_set general base_registration "$FORM_base_registration"
    if [ -f /usr/lib/libdspg_dect.so ] ; then
      config_set general dect_pin "$FORM_dect_pin"
    fi
    config_set general voicemail "$FORM_voicemail"
    config_set general dsp_acp "$FORM_dsp_acp"
    config_set general vad "$FORM_vad"
    config_set general rtpcutthru_mode "$FORM_rtpcutthru_mode"
  }
fi


header "Telephony" "Global Config" "@TR<<Global Configuration>>" 'onload="setcodecsstatinwbmode();seteclinks();document.forms[0].onsubmit=function(){return checkcodecs()}"' "$SCRIPT_NAME"
cat <<EOF
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">
<!--
function checkcodecs()
{
  var no_code_selected = 0 ;
  
  if ( ( document.forms[0].codec1.checked ) ||
       ( document.forms[0].codec2.checked ) ||
       ( document.forms[0].codec3.checked ) ||
       ( document.forms[0].codec4.checked ) ||
       ( document.forms[0].codec5.checked ) ||
       ( document.forms[0].codec6.checked ) ||
       ( document.forms[0].codec7.checked ) ||
       ( document.forms[0].codec8.checked ) ||
       ( document.forms[0].codec9.checked ) ||
       ( document.forms[0].codec10.checked ) ||
       ( document.forms[0].codec11.checked ) ||
       ( document.forms[0].codec12.checked ) ||
       ( document.forms[0].codec13.checked ) )
  {
    no_code_selected = 0 ;
  }
  else
  {
    no_code_selected = 1 ;
  }
  if ( no_code_selected )
  {
    answer = confirm("No codec selected. Do you want to continue?")
    if ( answer )
    {
      return true ;
    }
    else
    {
      return false ;
    }
  }
  return true ;
}

function selectall()
{
    document.forms[0].codec1.checked    = true ;
    document.forms[0].codec2.checked    = true ;
    document.forms[0].codec3.checked    = true ;
    document.forms[0].codec4.checked    = true ;
    document.forms[0].codec5.checked    = true ;
    document.forms[0].codec6.checked    = true ;
    document.forms[0].codec7.checked  = true ;
    document.forms[0].codec8.checked = true ;
    document.forms[0].codec9.checked = true ;
    document.forms[0].codec10.checked = true ;
    document.forms[0].codec11.checked = true ;
    document.forms[0].codec12.checked     = true ;
    document.forms[0].codec13.checked  = true ; 

    return true ;
}
function clearall()
{
    document.forms[0].codec1.checked    = false ;
    document.forms[0].codec2.checked    = false ;
    document.forms[0].codec3.checked    = false ;
    document.forms[0].codec4.checked    = false ;
    document.forms[0].codec5.checked    = false ;
    document.forms[0].codec6.checked    = false ;
    document.forms[0].codec7.checked  = false ;
    document.forms[0].codec8.checked = false ;
    document.forms[0].codec9.checked = false ;
    document.forms[0].codec10.checked = false ;
    document.forms[0].codec11.checked = false ;
    document.forms[0].codec12.checked     = false ;
    document.forms[0].codec13.checked  = false ; 

    return true ;
}
function setcodecsstatinwbmode()
{
  if ( document.getElementById('band') != null )
  {
//    alert("entered defined section");
    if ( document.forms[0].band[1].checked == true )
    {
	document.forms[0].codec${codec_g723_id}.checked    = false ;
	document.forms[0].codec${codec_ilbc_id}.checked    = false ;
	document.forms[0].codec${codec_g723_id}.disabled   = true  ;
	document.forms[0].codec${codec_ilbc_id}.disabled   = true  ;
    }
    else
    {
	document.forms[0].codec${codec_g723_id}.disabled   = false  ;
	document.forms[0].codec${codec_ilbc_id}.disabled   = false  ;
    }
  }
  else
  {
 //   alert("entered undefined section");
  }
}

function seteclinks()
{
  //alert("set ec links entered");
  if ( document.forms[0].echo_cancel_type[0].checked )
  {
      set_visible( 'ec_help_link1', true);
      set_visible( 'ec_help_link2', true);
      set_visible( 'dfec_help_link1', false);
    set_visible('field_show_ec_yes_enable', 1);
    set_visible('field_show_ec_no_enable', 0);
    set_visible('field_show_enh_ec_yes_enable', 1);
    set_visible('field_show_enh_ec_no_enable', 0);
    set_visible('field_show_dfec_yes_enable', 0);
    set_visible('field_show_dfec_no_enable', 0);
    set_visible('field_dfec_init_control_enable', 0);
    set_visible('field_dfec_nlp_control_enable', 0);
    set_visible('field_dfec_tail', 0);
    set_visible('field_dfec_master_echo_canceller_enable', 0);
    set_visible('field_dfec_transmit_input_dc_filter_disable', 0);
    set_visible('field_dfec_tone_transmitter', 0);
    set_visible('field_dfec_filter_coefficient_freeze', 0);
    set_visible('field_dfec_dynamic_attenuation', 0);
    set_visible('field_dfec_background_noise_replacement', 0);
    set_visible('field_dfec_sparse_foreground_filter', 0);
    set_visible('field_dfec_nlp_comfort_noise_generation', 0);
    set_visible('field_dfec_echo_path_filter_control', 0);
    set_visible('field_dfec_recieve_input_dc_filter_enable', 0);
    set_visible('field_set_dfec_factory_value_enable', 0);
  }
  else if ( document.forms[0].echo_cancel_type[1].checked )
  {
      set_visible( 'ec_help_link1', false);
      set_visible( 'ec_help_link2', false);
      set_visible( 'dfec_help_link1', true);
    set_visible('field_show_ec_yes_enable', 0);
    set_visible('field_show_ec_no_enable', 0);
    set_visible('field_show_enh_ec_yes_enable', 0);
    set_visible('field_show_enh_ec_no_enable', 0);
    set_visible('field_show_dfec_yes_enable', 1);
    set_visible('field_show_ec_no_enable', 0);
    set_visible('field_ec_enable', 0);
    set_visible('field_dc_filter_enable', 0);
    set_visible('field_hec_filter_enable', 0);
    set_visible('field_nlp_control_enable', 0);
    set_visible('field_comfort_noise', 0);
    set_visible('field_nlp_tune', 0);
    set_visible('field_ec_tail', 0);
    set_visible('field_set_ec_factory_value_enable', 0);
    set_visible('field_full_filter', 0);
    set_visible('field_fast_convergence_control', 0);
    set_visible('field_set_enh_ec_factory_value_enable', 0);
  }
}



function setecdefaultvalues()
{
    document.forms[0].field_ec_enable.checked          = true  ;
    document.forms[0].field_dc_filter_enable.checked   = true  ;
    document.forms[0].field_hec_filter_enable.checked  = false ;
    document.forms[0].field_nlp_control_enable.checked = true  ;
    document.forms[0].field_comfort_noise.checked      = true  ;
    document.forms[0].field_nlp_tune.selectedIndex           = 0     ;
    document.forms[0].field_ec_tail.selectedIndex      = 0     ;
}

function setenhecdefaultvalues()
{
    document.forms[0].field_full_filter.checked              = true  ;
    document.forms[0].field_fast_convergence_control.checked = false ;
}

function setdfecdefaultvalues()
{
  //  var item = document.getElementById('field_dfec_master_echo_canceller_enable');

    document.forms[0].field_dfec_init_control_enable.checked  = false ;
    document.forms[0].field_dfec_nlp_control_enable.checked   = true  ;
    document.forms[0].field_dfec_tail.selectedIndex           = 7     ;

      document.forms[0].field_dfec_master_echo_canceller_enable.checked     = true  ;
      document.forms[0].field_dfec_transmit_input_dc_filter_disable.checked = true  ;
      document.forms[0].field_dfec_tone_transmitter.checked                 = false ;
      document.forms[0].field_dfec_filter_coefficient_freeze.checked        = true  ;
      document.forms[0].field_dfec_dynamic_attenuation.checked              = false ;
      document.forms[0].field_dfec_background_noise_replacement.checked     = false ;
      document.forms[0].field_dfec_sparse_foreground_filter.checked         = false ;
      document.forms[0].field_dfec_nlp_comfort_noise_generation.checked     = true  ;
      document.forms[0].field_dfec_echo_path_filter_control.checked         = true  ;
      document.forms[0].field_dfec_recieve_input_dc_filter_enable.checked   = false ;
}

function advance( show )
{
  
  var item = document.getElementById('field_dfec_master_echo_canceller_enable');
  if ( item.style.display == 'none' )
  {
    set_visible('field_show_yes_enable', 0);
    set_visible('field_show_no_enable', 1);
    set_visible('field_dfec_master_echo_canceller_enable', 1);
    set_visible('field_dfec_transmit_input_dc_filter_disable', 1);
    set_visible('field_dfec_tone_transmitter', 1);
    set_visible('field_dfec_filter_coefficient_freeze', 1);
    set_visible('field_dfec_dynamic_attenuation', 1);
    set_visible('field_dfec_background_noise_replacement', 1);
    set_visible('field_dfec_sparse_foreground_filter', 1);
    set_visible('field_dfec_nlp_comfort_noise_generation', 1);
    set_visible('field_dfec_echo_path_filter_control', 1);
    set_visible('field_dfec_recieve_input_dc_filter_enable', 1);
  }
  else
  {
    set_visible('field_show_yes_enable', 1);
    set_visible('field_show_no_enable', 0);
    set_visible('field_dfec_master_echo_canceller_enable', 0);
    set_visible('field_dfec_transmit_input_dc_filter_disable', 0);
    set_visible('field_dfec_tone_transmitter', 0);
    set_visible('field_dfec_filter_coefficient_freeze', 0);
    set_visible('field_dfec_dynamic_attenuation', 0);
    set_visible('field_dfec_background_noise_replacement', 0);
    set_visible('field_dfec_sparse_foreground_filter', 0);
    set_visible('field_dfec_nlp_comfort_noise_generation', 0);
    set_visible('field_dfec_echo_path_filter_control', 0);
    set_visible('field_dfec_recieve_input_dc_filter_enable', 0);
  }
}

function ec_advance( show )
{
  
  var item = document.getElementById('field_ec_enable');
  if ( item.style.display == 'none' )
  {
    set_visible('field_show_ec_yes_enable', 0);
    set_visible('field_show_ec_no_enable', 1);
    set_visible('field_ec_enable', 1);
    set_visible('field_dc_filter_enable', 1);
    set_visible('field_hec_filter_enable', 1);
    set_visible('field_nlp_control_enable', 1);
    set_visible('field_comfort_noise', 1);
    set_visible('field_nlp_tune', 1);
    set_visible('field_ec_tail', 1);
    set_visible('field_set_ec_factory_value_enable', 1);
  }
  else
  {
    set_visible('field_show_ec_yes_enable', 1);
    set_visible('field_show_ec_no_enable', 0);
    set_visible('field_ec_enable', 0);
    set_visible('field_dc_filter_enable', 0);
    set_visible('field_hec_filter_enable', 0);
    set_visible('field_nlp_control_enable', 0);
    set_visible('field_comfort_noise', 0);
    set_visible('field_nlp_tune', 0);
    set_visible('field_ec_tail', 0);
    set_visible('field_set_ec_factory_value_enable', 0);
  }
}

function enh_ec_advance( show )
{
  
  var item = document.getElementById('field_full_filter');
  if ( item.style.display == 'none' )
  {
    set_visible('field_show_enh_ec_yes_enable', 0);
    set_visible('field_show_enh_ec_no_enable', 1);
    set_visible('field_full_filter', 1);
    set_visible('field_fast_convergence_control', 1);
    set_visible('field_set_enh_ec_factory_value_enable', 1);
  }
  else
  {
    set_visible('field_show_enh_ec_yes_enable', 1);
    set_visible('field_show_enh_ec_no_enable', 0);
    set_visible('field_full_filter', 0);
    set_visible('field_fast_convergence_control', 0);
    set_visible('field_set_enh_ec_factory_value_enable', 0);
  }
}

function dfec_advance( show )
{
  
  var item = document.getElementById('field_dfec_master_echo_canceller_enable');
  if ( item.style.display == 'none' )
  {
    set_visible('field_show_dfec_yes_enable', 0);
    set_visible('field_show_dfec_no_enable', 1);
    set_visible('field_dfec_init_control_enable', 1);
    set_visible('field_dfec_nlp_control_enable', 1);
    set_visible('field_dfec_tail', 1);
    set_visible('field_dfec_master_echo_canceller_enable', 1);
    set_visible('field_dfec_transmit_input_dc_filter_disable', 1);
    set_visible('field_dfec_tone_transmitter', 1);
    set_visible('field_dfec_filter_coefficient_freeze', 1);
    set_visible('field_dfec_dynamic_attenuation', 1);
    set_visible('field_dfec_background_noise_replacement', 1);
    set_visible('field_dfec_sparse_foreground_filter', 1);
    set_visible('field_dfec_nlp_comfort_noise_generation', 1);
    set_visible('field_dfec_echo_path_filter_control', 1);
    set_visible('field_dfec_recieve_input_dc_filter_enable', 1);
    set_visible('field_set_dfec_factory_value_enable', 1);
  }
  else
  {
    set_visible('field_show_dfec_yes_enable', 1);
    set_visible('field_show_dfec_no_enable', 0);
    set_visible('field_dfec_init_control_enable', 0);
    set_visible('field_dfec_nlp_control_enable', 0);
    set_visible('field_dfec_tail', 0);
    set_visible('field_dfec_master_echo_canceller_enable', 0);
    set_visible('field_dfec_transmit_input_dc_filter_disable', 0);
    set_visible('field_dfec_tone_transmitter', 0);
    set_visible('field_dfec_filter_coefficient_freeze', 0);
    set_visible('field_dfec_dynamic_attenuation', 0);
    set_visible('field_dfec_background_noise_replacement', 0);
    set_visible('field_dfec_sparse_foreground_filter', 0);
    set_visible('field_dfec_nlp_comfort_noise_generation', 0);
    set_visible('field_dfec_echo_path_filter_control', 0);
    set_visible('field_dfec_recieve_input_dc_filter_enable', 0);
    set_visible('field_set_dfec_factory_value_enable', 0);
  }
}

function CheckActiveChannels()
{
 // alert('$FORM_active_channels');
  if ( '$FORM_active_channels' > 0 )
  {
    if ( ( document.forms[0].echo_cancel_type[0].checked ) &&
         ( '$FORM_echo_cancel_type' == "DFEC" ) )
    {
      alert("Presently Active channels are present. This operation is not allowed");
      document.forms[0].echo_cancel_type[1].checked=true;
 //     document.forms[0].echo_cancel_type[0].checked=false;
    }
    if ( ( document.forms[0].echo_cancel_type[1].checked ) &&
           ( '$FORM_echo_cancel_type' == "EC" ) )
    {
      alert("Presently Active channels are present. This operation is not allowed");
      document.forms[0].echo_cancel_type[0].checked=true;
  //    document.forms[0].echo_cancel_type[1].checked=false;
    }
  }
  else
  {
    seteclinks();
  }
}

-->
</script>
EOF

! empty "$validate_error" && {
echo "<span class="error">$validate_error</span>"
#echo "</div>"
}

board=`uci get webif.general.device_name`
if [ "$board" != "Mindspeed Comcerto 100" ];then
form_band=" onclick|setcodecsstatinwbmode
start_form|@TR<<VoIP Calling Band Selection>>
field|@TR<<Band>>|field_band
radio|band|$FORM_band|narrow|@TR<<Narrow Band>>
radio|band|$FORM_band|wide|@TR<<Wide Band>>
end_form"
three_wc_conference_band="field|@TR<<3WC Conference Band>>|3wc_band
radio|3wc_band|$FORM_3wc_band|narrow|@TR<<Narrow Band>>
radio|3wc_band|$FORM_3wc_band|wide|@TR<<Wide Band>>"
fi

echelplink1="<a href=\"javascript:ec_advance(1)\">EchoCanceller Parameters &gt;&gt;</a>"
echelplink2="<a href=\"javascript:enh_ec_advance(1)\">Enhanced EchoCanceller Parameters &gt;&gt;</a>"
dfechelplink1="<a href=\"javascript:dfec_advance(1)\">Dual Filter EchoCanceller Parameters &gt;&gt;</a>"

i=1
while [ $i -le $no_of_codecs ]
do
  if [ $i -eq 1 ] ; then
    codecs_field="field|@TR<<Codecs>>|field_codecs
                  string|<a href=\"$SCRIPT_NAME?down_codec=$i\"><img alt=\"@TR<<down>>\" src=\"/images/down.gif\" title=\"@TR<<down>>\" /></a>
                  string|<a href=\"$SCRIPT_NAME?down_codec=$i\"><img alt=\"@TR<<down>>\" src=\"/images/down.gif\" title=\"@TR<<down>>\" /></a>"
  elif [ $i -eq $no_of_codecs ] ; then
    codecs_field="$codecs_field
                  field|@TR<<>>
                  string|<a href=\"$SCRIPT_NAME?up_codec=$i\"><img alt=\"@TR<<up>>\" src=\"/images/up.gif\" title=\"@TR<<up>>\" /></a>
                  string|<a href=\"$SCRIPT_NAME?up_codec=$i\"><img alt=\"@TR<<up>>\" src=\"/images/up.gif\" title=\"@TR<<up>>\" /></a>"
  else
    codecs_field="$codecs_field
                  field|@TR<<>>
                  string|<a href=\"$SCRIPT_NAME?down_codec=$i\"><img alt=\"@TR<<down>>\" src=\"/images/down.gif\" title=\"@TR<<down>>\" /></a>
                  string|<a href=\"$SCRIPT_NAME?up_codec=$i\"><img alt=\"@TR<<up>>\" src=\"/images/up.gif\" title=\"@TR<<up>>\" /></a>"
  fi
  eval codec_val="\$FORM_codec${i}"
  eval codec_name="\$codec${i}_name"
  eval codec_bit_rate="\$codec${i}_bit_rate"
  case "$codec_name" in
    "G.711 u-Law"|"G.711 a-Law")  
               alignement_spaces=$G711_SPACES   ;;
    "G.722")   alignement_spaces=$G722_SPACES   ;;  
    "G.723.1") alignement_spaces=$G723_1_SPACES ;;  
    "G.726")   alignement_spaces=$G726_SPACES   ;;  
    "G.729a")  alignement_spaces=$G729A_SPACES  ;;   
    "iLBC")    alignement_spaces=$ILBC_SPACES   ;;   
    "AMR")     alignement_spaces=$AMR_SPACES    ;;   
    "AMR-WB")  alignement_spaces=$AMR_WB_SPACES ;;   
  esac
  codecs_field="$codecs_field
                checkbox|codec${i}|$codec_val|yes|$codec_name $alignement_spaces $codec_bit_rate"
  if [ "$codec_name" = "AMR" ] ; then
  codecs_field="$codecs_field
                select|bitrate_codec_amr|$FORM_bitrate_codec_amr
                option|7|12.20 kb/s
                option|6|10.20 kb/s
                option|5|7.95 kb/s
                option|4|7.40 kb/s
                option|3|6.70 kb/s
                option|2|5.90 kb/s
                option|1|5.15 kb/s
                option|0|4.75 kb/s"
  elif [ "$codec_name" = "AMR-WB" ] ; then
  codecs_field="$codecs_field
                select|bitrate_codec_amr_wb|$FORM_bitrate_codec_amr_wb
                option|8|23.85 kb/s
                option|7|23.05 kb/s
                option|6|19.85 kb/s
                option|5|18.25 kb/s
                option|4|15.85 kb/s
                option|3|14.25 kb/s
                option|2|12.65 kb/s
                option|1|8.85 kb/s
                option|0|6.60 kb/s"
  fi
  i=`expr $i + 1`
done

display_form <<EOF
start_form|@TR<<Phone Settings>>
$codecs_field
field|@TR<<>>
string|<a href="#" onclick="selectall()" >Select ALL Codecs</a>
string|<a href="#" onclick="clearall()" >clear ALL Codecs</a>
field|@TR<<>>
field|@TR<<Voicemail>>|voicemail
checkbox|voicemail|$FORM_voicemail|enable
field|@TR<<DSP on ACP>>|dsp_acp
checkbox|dsp_acp|$FORM_dsp_acp|enable
field|@TR<<VAD>>|vad
checkbox|vad|$FORM_vad|enable
end_form
onclick|CheckActiveChannels
start_form|@TR<<Echo Canceller>>
field|@TR<<Echo Canceller Type>>|field_echo_cancel_type
radio|echo_cancel_type|$FORM_echo_cancel_type|EC|@TR<<Standard EC>>
radio|echo_cancel_type|$FORM_echo_cancel_type|DFEC|@TR<<DFEC>>
field|@TR<<>>|field_active_channels|hidden
text|active_channels|$FORM_active_channels
onclick|
field||ec_help_link1|hidden
field|@TR<<>>|field_show_ec_yes_enable|hidden
string|$echelplink1
field|@TR<<>>|field_show_ec_no_enable|hidden
string|<a href="javascript:ec_advance(1)">&lt;&lt;Echo Canceller Parameters</a>
field|@TR<<Enable Echo Canceller>>|field_ec_enable|hidden
checkbox|field_ec_enable|$FORM_field_ec_enable|enable
field|@TR<<Enable DC Removal Filter>>|field_dc_filter_enable|hidden
checkbox|field_dc_filter_enable|$FORM_field_dc_filter_enable|enable
field|@TR<<Freeze HEC Filter Coefficient>>|field_hec_filter_enable|hidden
checkbox|field_hec_filter_enable|$FORM_field_hec_filter_enable|enable
field|@TR<<Enable NLP Control>>|field_nlp_control_enable|hidden
checkbox|field_nlp_control_enable|$FORM_field_nlp_control_enable|enable
field|@TR<<NLP Tune>>|field_nlp_tune|hidden
select|field_nlp_tune|$FORM_field_nlp_tune
option|00|00
option|01|01
option|10|10
field|@TR<<Comfort Noise Generation>>|field_comfort_noise|hidden
checkbox|field_comfort_noise|$FORM_field_comfort_noise|enable
field|@TR<<Network Echo Canceller Tail Length>>|field_ec_tail|hidden
select|field_ec_tail|$FORM_field_ec_tail
option|0001|16 ms
option|0011|32 ms
option|0101|48 ms
option|0111|64 ms
field|@TR<<>>|save_ec_enh_ec|hidden
text|save_ec_enh_ec|0
field|@TR<<>>|field_set_ec_factory_value_enable|hidden
string|<a href="#" onclick="setecdefaultvalues()" >Set Factory Default Values</a>
field||ec_help_link2|hidden
field|@TR<<>>|field_show_enh_ec_yes_enable|hidden
string|$echelplink2
field|@TR<<>>|field_show_enh_ec_no_enable|hidden
string|<a href="javascript:enh_ec_advance(1)">&lt;&lt;Enhanced Echo Canceller Parameters</a>
field|@TR<<Full-Filter Echo Path Change Detection>>|field_full_filter|hidden
checkbox|field_full_filter|$FORM_field_full_filter|enable
field|@TR<<Fast Convergence Control>>|field_fast_convergence_control|hidden
checkbox|field_fast_convergence_control|$FORM_field_fast_convergence_control|enable
field|@TR<<>>|field_set_enh_ec_factory_value_enable|hidden
string|<a href="#" onclick="setenhecdefaultvalues()" >Set Factory Default Values</a>
field||dfec_help_link1|hidden
field|@TR<<>>|field_show_dfec_yes_enable|hidden
string|$dfechelplink1
field|@TR<<>>|field_show_dfec_no_enable|hidden
string|<a href="javascript:dfec_advance(1)">&lt;&lt;Dual Filter Echo Canceller Parameters</a>
field|@TR<<Initialization Control>>|field_dfec_init_control_enable|hidden
checkbox|field_dfec_init_control_enable|$FORM_field_dfec_init_control_enable|enable
field|@TR<<Enable NLP Control>>|field_dfec_nlp_control_enable|hidden
checkbox|field_dfec_nlp_control_enable|$FORM_field_dfec_nlp_control_enable|enable
field|@TR<<Echo Path Filter Length>>|field_dfec_tail|hidden
select|field_dfec_tail|$FORM_field_dfec_tail
option|0000|8   ms
option|0001|16  ms
option|0010|24  ms
option|0011|32  ms
option|0100|40  ms
option|0101|48  ms
option|0110|56  ms
option|0111|64  ms
option|1000|72  ms
option|1001|80  ms
option|1010|88  ms
option|1011|96  ms
option|1100|104 ms
option|1101|112 ms
option|1110|120 ms
option|1111|128 ms
field|@TR<<Enable Master Echo Canceller>>|field_dfec_master_echo_canceller_enable|hidden
checkbox|field_dfec_master_echo_canceller_enable|$FORM_field_dfec_master_echo_canceller_enable|enable
field|@TR<<Transmit Input DC Filter Disable>>|field_dfec_transmit_input_dc_filter_disable|hidden
checkbox|field_dfec_transmit_input_dc_filter_disable|$FORM_field_dfec_transmit_input_dc_filter_disable|enable
field|@TR<<Tone Transmitter>>|field_dfec_tone_transmitter|hidden
checkbox|field_dfec_tone_transmitter|$FORM_field_dfec_tone_transmitter|enable
field|@TR<<Filter Coefficient Freeze>>|field_dfec_filter_coefficient_freeze|hidden
checkbox|field_dfec_filter_coefficient_freeze|$FORM_field_dfec_filter_coefficient_freeze|enable
field|@TR<<Dynamic Attentuation>>|field_dfec_dynamic_attenuation|hidden
checkbox|field_dfec_dynamic_attenuation|$FORM_field_dfec_dynamic_attenuation|enable
field|@TR<<Background Noise Replacement>>|field_dfec_background_noise_replacement|hidden
checkbox|field_dfec_background_noise_replacement|$FORM_field_dfec_background_noise_replacement|enable
field|@TR<<Sparse Foreground Filter>>|field_dfec_sparse_foreground_filter|hidden
checkbox|field_dfec_sparse_foreground_filter|$FORM_field_dfec_sparse_foreground_filter|enable
field|@TR<<NLP Comfort Noise Generation>>|field_dfec_nlp_comfort_noise_generation|hidden
checkbox|field_dfec_nlp_comfort_noise_generation|$FORM_field_dfec_nlp_comfort_noise_generation|enable
field|@TR<<Echo Path Filter Control>>|field_dfec_echo_path_filter_control|hidden
checkbox|field_dfec_echo_path_filter_control|$FORM_field_dfec_echo_path_filter_control|enable
field|@TR<<Recieve Input DC Filter Enable>>|field_dfec_recieve_input_dc_filter_enable|hidden
checkbox|field_dfec_recieve_input_dc_filter_enable|$FORM_field_dfec_recieve_input_dc_filter_enable|enable
field|@TR<<>>|field_set_dfec_factory_value_enable|hidden
string|<a href="#" onclick="setdfecdefaultvalues()" >Set Factory Default Values</a>
end_form
EOF

display_form <<EOF
onclick|
start_form|@TR<<Timeout Values>>
field|@TR<<Dial Timeout (msec)>>|dial_timeout
text|dial_timeout|$FORM_dial_timeout
field|@TR<<Interdigit Timeout (msec)>>|interdigit_timeout
text|interdigit_timeout|$FORM_interdigit_timeout
field|Set to Default Values
string|<a href="$SCRIPT_NAME?set_default=1">Set Factory Default Values</a>
end_form
start_form|@TR<<NTT Caller ID Support>>
field|@TR<<NTT Caller ID>>|ntt
checkbox|ntt|$FORM_ntt|yes
end_form
start_form|@TR<<Fax Support>>
field|@TR<<Fax Mode>>|fax_mode
select|fax_mode|$FORM_fax_mode
option|auto|auto
option|t38|t38
option|passthru|pass through
end_form
EOF

[ -f /usr/lib/libdspg_dect.so ] && {
display_form <<EOF
start_form|@TR<<DECT Configuration>>
field|@TR<<HS registration>>|base_registration
submit|hs_regstration_enable| @TR<<&nbsp;Enable&nbsp;>>
field|@TR<<PIN code>>|dect_pin
text|dect_pin|$FORM_dect_pin
helpitem|HS Registration
helptext|when you click "Enable" -  HS registration is enabled for short amount of time (1 minute). After that it is automatically disabled.
end_form
EOF
} 

display_form <<EOF
$form_band
start_form|@TR<<3-Way Calling Support>>
field|@TR<<Flash Mode>>|flash_mode
radio|flash_mode|$FORM_flash_mode|switch|@TR<<Switch call>>
radio|flash_mode|$FORM_flash_mode|threeway|@TR<<Three-way call>>
$three_wc_conference_band
end_form
EOF

display_form <<EOF
start_form|@TR<<Bandwidth extension for POTS/DECT phones>>
field|@TR<<BWE master>>|bwe_master
radio|bwe_master|$FORM_bwe_master|enable|@TR<<Enable>>
radio|bwe_master|$FORM_bwe_master|disable|@TR<<Disable>>
field|@TR<<High Band>>|bwe_high_band
text|bwe_high_band|$FORM_bwe_high_band
field|@TR<<Low Band>>|bwe_low_band
text|bwe_low_band|$FORM_bwe_low_band
end_form
EOF

display_form <<EOF
start_form|@TR<<Bandwidth extension for RSP participants>>
field|@TR<<BWE master>>|bwe_master
radio|rsp_bwe_master|$FORM_rsp_bwe_master|enable|@TR<<Enable>>
radio|rsp_bwe_master|$FORM_rsp_bwe_master|disable|@TR<<Disable>>
field|@TR<<High Band>>|rsp_bwe_high_band
text|rsp_bwe_high_band|$FORM_rsp_bwe_high_band
field|@TR<<Low Band>>|rsp_bwe_low_band
text|rsp_bwe_low_band|$FORM_rsp_bwe_low_band
end_form
EOF

display_form <<EOF
start_form|@TR<<RTP Cut-through Support>>
field|@TR<<RTP Cut-through>>|rtpcutthru_mode
radio|rtpcutthru_mode|$FORM_rtpcutthru_mode|enable|@TR<<Enable>>
radio|rtpcutthru_mode|$FORM_rtpcutthru_mode|disable|@TR<<Disable>>
helpitem|Activation
helptext|After changing this option Asterisk must be restarted
end_form
EOF

display_form <<EOF
submit|save|@TR<<Save>>
EOF

footer ?>

<!--
##WEBIF:name:Telephony:300:Global Config
-->
