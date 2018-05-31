#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
uci_load "asterisk"

! empty "$FORM_display_analog_phone" && {
  analogid=$FORM_display_analog_phone
  config_get FORM_analog_name analog$analogid name
  config_get FORM_analog_number analog$analogid number
  config_get FORM_field_analog_voicemail analog$analogid voicemail
  config_get FORM_field_dsp_acp analog$analogid field_dsp_acp
  config_get FORM_field_vad analog$analogid field_vad
  config_get FORM_phone_band analog$analogid phone_band
  config_get FORM_bwe_master analog$analogid bwe_master
  config_get FORM_bwe_high_band analog$analogid bwe_high_band
  [ "$FORM_bwe_high_band" = "default" ] && config_get FORM_bwe_high_band general bwe_high_band
  config_get FORM_bwe_low_band analog$analogid bwe_low_band
  [ "$FORM_bwe_low_band" = "default" ] && config_get FORM_bwe_low_band general bwe_low_band
}

! empty "$FORM_save_analog_phone" && {
  SAVED=1
  save_validate_success="n"
validate <<EOF
string|FORM_analog_name|@TR<<Analog phone name>>|required|$FORM_analog_name
int|FORM_analog_number|@TR<<Analog phone number>>|required|$FORM_analog_number
string|FORM_field_analog_voicemail|@TR<<Voice mail>>||$FORM_field_analog_voicemail
int|FORM_bwe_high_band|@TR<<BWE High band>>|min=0 max=10 required|$FORM_bwe_high_band
int|FORM_bwe_low_band|@TR<<BWE Low band>>|min=0 max=10 required|$FORM_bwe_low_band
EOF
  equal "$?" 0 && {
    uci_set asterisk analog$FORM_analogid name "$FORM_analog_name"
    uci_set asterisk analog$FORM_analogid number "$FORM_analog_number"
    uci_set asterisk analog$FORM_analogid voicemail "$FORM_field_analog_voicemail"
    uci_set asterisk analog$FORM_analogid ulaw "$FORM_codec_ulaw"
    uci_set asterisk analog$FORM_analogid alaw "$FORM_codec_alaw"
    uci_set asterisk analog$FORM_analogid g729 "$FORM_codec_g729"
    uci_set asterisk analog$FORM_analogid field_dsp_acp "$FORM_field_dsp_acp"
    uci_set asterisk analog$FORM_analogid field_vad "$FORM_field_vad"
    uci_set asterisk analog$FORM_analogid phone_band "$FORM_phone_band"
    uci_set asterisk analog$FORM_analogid bwe_master "$FORM_bwe_master"
    config_get global_bwe_high_band general bwe_high_band
    if [ "$FORM_bwe_high_band" = "$global_bwe_high_band" ]; then
        uci_set asterisk analog$FORM_analogid bwe_high_band "default"
    else
        uci_set asterisk analog$FORM_analogid bwe_high_band "$FORM_bwe_high_band"
    fi
    config_get global_bwe_low_band general bwe_low_band
    if [ "$FORM_bwe_low_band" = "$global_bwe_low_band" ]; then
        uci_set asterisk analog$FORM_analogid bwe_low_band "default"
    else
        uci_set asterisk analog$FORM_analogid bwe_low_band "$FORM_bwe_low_band"
    fi
    config_set analog$FORM_analogid name "$FORM_analog_name"
    config_set analog$FORM_analogid number "$FORM_analog_number"
    config_set analog$FORM_analogid voicemail "$FORM_field_analog_voicemail"
    config_set analog$FORM_analogid ulaw "$FORM_codec_ulaw"
    config_set analog$FORM_analogid alaw "$FORM_codec_alaw"
    config_set analog$FORM_analogid g729 "$FORM_codec_g729"
    config_set analog$FORM_analogid field_dsp_acp "$FORM_field_dsp_acp"
    config_set analog$FORM_analogid field_vad "$FORM_field_vad"
    config_set analog$FORM_analogid phone_band "$FORM_phone_band"
    config_set analog$FORM_analogid bwe_master "$FORM_bwe_master"
    config_set analog$FORM_analogid bwe_high_band "$FORM_bwe_high_band"
    config_set analog$FORM_analogid bwe_low_band "$FORM_bwe_low_band"
    save_validate_success="y"
  }
  [ "$save_validate_success" = "n" ] && FORM_display_analog_phone=$FORM_analogid
}

! empty "$FORM_display_analog_advance" && {
  analogid=$FORM_display_analog_advance
  config_get FORM_analog_name analog$analogid name
  config_get FORM_analog_number analog$analogid number
  config_get FORM_field_ec_enable analog$analogid field_ec_enable
  config_get FORM_field_dc_filter_enable analog$analogid field_dc_filter_enable
  config_get FORM_field_hec_filter_enable analog$analogid field_hec_filter_enable
  config_get FORM_field_nlp_control_enable analog$analogid field_nlp_control_enable
  config_get FORM_field_nlp_tune analog$analogid field_nlp_tune
  config_get FORM_field_comfort_noise analog$analogid field_comfort_noise
  config_get FORM_field_ec_tail analog$analogid field_ec_tail
}

! empty "$FORM_save_analog_advance" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk analog$FORM_analogid field_ec_enable "$FORM_field_ec_enable"
    uci_set asterisk analog$FORM_analogid field_dc_filter_enable "$FORM_field_dc_filter_enable"
    uci_set asterisk analog$FORM_analogid field_hec_filter_enable "$FORM_field_hec_filter_enable"
    uci_set asterisk analog$FORM_analogid field_nlp_control_enable "$FORM_field_nlp_control_enable"
    uci_set asterisk analog$FORM_analogid field_nlp_tune "$FORM_field_nlp_tune"
    uci_set asterisk analog$FORM_analogid field_comfort_noise "$FORM_field_comfort_noise"
    uci_set asterisk analog$FORM_analogid field_ec_tail "$FORM_field_ec_tail"
    config_set analog$FORM_analogid field_ec_enable "$FORM_field_ec_enable"
    config_set analog$FORM_analogid field_dc_filter_enable "$FORM_field_dc_filter_enable"
    config_set analog$FORM_analogid field_hec_filter_enable "$FORM_field_hec_filter_enable"
    config_set analog$FORM_analogid field_nlp_control_enable "$FORM_field_nlp_control_enable"
    config_set analog$FORM_analogid field_nlp_tune "$FORM_field_nlp_tune"
    config_set analog$FORM_analogid field_comfort_noise "$FORM_field_comfort_noise"
    config_set analog$FORM_analogid field_ec_tail "$FORM_field_ec_tail"
  }
}

! empty "$FORM_display_analog_advance_ec" && {
  analogid=$FORM_display_analog_advance_ec
  config_get FORM_analog_name analog$analogid name
  config_get FORM_analog_number analog$analogid number
  config_get FORM_field_full_filter analog$analogid field_full_filter
  config_get FORM_field_fast_convergence_control analog$analogid field_fast_convergence_control
}

! empty "$FORM_save_analog_advance_ec" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk analog$FORM_analogid field_full_filter "$FORM_field_full_filter"
    uci_set asterisk analog$FORM_analogid field_fast_convergence_control "$FORM_field_fast_convergence_control"
    config_set analog$FORM_analogid field_full_filter "$FORM_field_full_filter"
    config_set analog$FORM_analogid field_fast_convergence_control "$FORM_field_fast_convergence_control"
  }
}


#BEGIN DECT
! empty "$FORM_display_dect_phone" && {
  dectid=$FORM_display_dect_phone
  config_get FORM_dect_name dect$dectid name
  config_get FORM_dect_number dect$dectid number
  config_get FORM_field_dect_voicemail dect$dectid voicemail
  config_get FORM_field_dsp_acp dect$dectid field_dsp_acp
  config_get FORM_field_vad dect$dectid field_vad
  config_get FORM_bwe_master dect$dectid bwe_master
  config_get FORM_bwe_high_band dect$dectid bwe_high_band
  config_get FORM_bwe_low_band dect$dectid bwe_low_band
}

! empty "$FORM_save_dect_phone" && {
  SAVED=1
  save_validate_success="n"
validate <<EOF
string|FORM_dect_name|@TR<<DECT phone name>>|required|$FORM_dect_name
int|FORM_dect_number|@TR<<DECT phone number>>|required|$FORM_dect_number
string|FORM_field_dect_voicemail|@TR<<Voice mail>>||$FORM_field_dect_voicemail
int|FORM_bwe_high_band|@TR<<BWE High band>>|min=0 max=10 required|$FORM_bwe_high_band
int|FORM_bwe_low_band|@TR<<BWE Low band>>|min=0 max=10 required|$FORM_bwe_low_band
EOF
  equal "$?" 0 && {
    uci_set asterisk dect$FORM_dectid name "$FORM_dect_name"
    uci_set asterisk dect$FORM_dectid number "$FORM_dect_number"
    uci_set asterisk dect$FORM_dectid voicemail "$FORM_field_dect_voicemail"
    uci_set asterisk dect$FORM_dectid ulaw "$FORM_codec_ulaw"
    uci_set asterisk dect$FORM_dectid alaw "$FORM_codec_alaw"
    uci_set asterisk dect$FORM_dectid g729 "$FORM_codec_g729"
    uci_set asterisk dect$FORM_dectid field_dsp_acp "$FORM_field_dsp_acp"
    uci_set asterisk dect$FORM_dectid field_vad "$FORM_field_vad"
    uci_set asterisk dect$FORM_dectid bwe_master "$FORM_bwe_master"
    config_get global_bwe_high_band general bwe_high_band
    if [ "$FORM_bwe_high_band" = "$global_bwe_high_band" ]; then
        uci_set asterisk dect$FORM_dectid bwe_high_band "default"
    else
        uci_set asterisk dect$FORM_dectid bwe_high_band "$FORM_bwe_high_band"
    fi
    config_get global_bwe_low_band general bwe_low_band
    if [ "$FORM_bwe_low_band" = "$global_bwe_low_band" ]; then
        uci_set asterisk dect$FORM_dectid bwe_low_band "default"
    else
        uci_set asterisk dect$FORM_dectid bwe_low_band "$FORM_bwe_low_band"
    fi
    config_set dect$FORM_dectid name "$FORM_dect_name"
    config_set dect$FORM_dectid number "$FORM_dect_number"
    config_set dect$FORM_dectid voicemail "$FORM_field_dect_voicemail"
    config_set dect$FORM_dectid ulaw "$FORM_codec_ulaw"
    config_set dect$FORM_dectid alaw "$FORM_codec_alaw"
    config_set dect$FORM_dectid g729 "$FORM_codec_g729"
    config_set dect$FORM_dectid field_dsp_acp "$FORM_field_dsp_acp"
    config_set dect$FORM_dectid field_vad "$FORM_field_vad"
    config_set dect$FORM_dectid bwe_master "$FORM_bwe_master"
    config_set dect$FORM_dectid bwe_high_band "$FORM_bwe_high_band"
    config_set dect$FORM_dectid bwe_low_band "$FORM_bwe_low_band"
    save_validate_success="y"
  }
  [ "$save_validate_success" = "n" ] && FORM_display_dect_phone=$FORM_dectid
}

! empty "$FORM_display_dect_advance" && {
  dectid=$FORM_display_dect_advance
  config_get FORM_dect_name dect$dectid name
  config_get FORM_dect_number dect$dectid number
  config_get FORM_field_ec_enable dect$dectid field_ec_enable
  config_get FORM_field_dc_filter_enable dect$dectid field_dc_filter_enable
  config_get FORM_field_hec_filter_enable dect$dectid field_hec_filter_enable
  config_get FORM_field_nlp_control_enable dect$dectid field_nlp_control_enable
  config_get FORM_field_nlp_tune dect$dectid field_nlp_tune
  config_get FORM_field_comfort_noise dect$dectid field_comfort_noise
  config_get FORM_field_ec_tail dect$dectid field_ec_tail
}

! empty "$FORM_save_dect_advance" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk dect$FORM_dectid field_ec_enable "$FORM_field_ec_enable"
    uci_set asterisk dect$FORM_dectid field_dc_filter_enable "$FORM_field_dc_filter_enable"
    uci_set asterisk dect$FORM_dectid field_hec_filter_enable "$FORM_field_hec_filter_enable"
    uci_set asterisk dect$FORM_dectid field_nlp_control_enable "$FORM_field_nlp_control_enable"
    uci_set asterisk dect$FORM_dectid field_nlp_tune "$FORM_field_nlp_tune"
    uci_set asterisk dect$FORM_dectid field_comfort_noise "$FORM_field_comfort_noise"
    uci_set asterisk dect$FORM_dectid field_ec_tail "$FORM_field_ec_tail"
    config_set dect$FORM_dectid field_ec_enable "$FORM_field_ec_enable"
    config_set dect$FORM_dectid field_dc_filter_enable "$FORM_field_dc_filter_enable"
    config_set dect$FORM_dectid field_hec_filter_enable "$FORM_field_hec_filter_enable"
    config_set dect$FORM_dectid field_nlp_control_enable "$FORM_field_nlp_control_enable"
    config_set dect$FORM_dectid field_nlp_tune "$FORM_field_nlp_tune"
    config_set dect$FORM_dectid field_comfort_noise "$FORM_field_comfort_noise"
    config_set dect$FORM_dectid field_ec_tail "$FORM_field_ec_tail"
  }
}

! empty "$FORM_display_dect_advance_ec" && {
  dectid=$FORM_display_dect_advance_ec
  config_get FORM_dect_name dect$dectid name
  config_get FORM_dect_number dect$dectid number
  config_get FORM_field_full_filter dect$dectid field_full_filter
  config_get FORM_field_fast_convergence_control dect$dectid field_fast_convergence_control
}

! empty "$FORM_save_dect_advance_ec" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk dect$FORM_dectid field_full_filter "$FORM_field_full_filter"
    uci_set asterisk dect$FORM_dectid field_fast_convergence_control "$FORM_field_fast_convergence_control"
    config_set dect$FORM_dectid field_full_filter "$FORM_field_full_filter"
    config_set dect$FORM_dectid field_fast_convergence_control "$FORM_field_fast_convergence_control"
  }
}
#END DECT

! empty "$FORM_display_dfec" && {
  analogid=$FORM_display_dfec
  config_get FORM_analog_name analog$analogid name
  config_get FORM_analog_number analog$analogid number
  config_get FORM_field_dfec_init_control_enable analog$analogid field_dfec_init_control_enable
  config_get FORM_field_dfec_nlp_control_enable analog$analogid field_dfec_nlp_control_enable
  config_get FORM_field_dfec_tail analog$analogid field_dfec_tail
  config_get FORM_field_dfec_master_echo_canceller_enable analog$analogid field_dfec_master_echo_canceller_enable
  config_get FORM_field_dfec_transmit_input_dc_filter_disable analog$analogid field_dfec_transmit_input_dc_filter_disable
  config_get FORM_field_dfec_tone_transmitter analog$analogid field_dfec_tone_transmitter
  config_get FORM_field_dfec_filter_coefficient_freeze analog$analogid field_dfec_filter_coefficient_freeze
  config_get FORM_field_dfec_dynamic_attenuation analog$analogid field_dfec_dynamic_attenuation
  config_get FORM_field_dfec_background_noise_replacement analog$analogid field_dfec_background_noise_replacement
  config_get FORM_field_dfec_sparse_foreground_filter analog$analogid field_dfec_sparse_foreground_filter
  config_get FORM_field_dfec_nlp_comfort_noise_generation analog$analogid field_dfec_nlp_comfort_noise_generation
  config_get FORM_field_dfec_echo_path_filter_control analog$analogid field_dfec_echo_path_filter_control
  config_get FORM_field_dfec_recieve_input_dc_filter_enable analog$analogid field_dfec_recieve_input_dc_filter_enable
}

! empty "$FORM_display_dect_dfec" && {
  phoneid=dect$FORM_display_dect_dfec
  config_get FORM_dect_name $phoneid name
  config_get FORM_dect_number $phoneid number
  config_get FORM_field_dfec_init_control_enable $phoneid field_dfec_init_control_enable
  config_get FORM_field_dfec_nlp_control_enable $phoneid field_dfec_nlp_control_enable
  config_get FORM_field_dfec_tail $phoneid field_dfec_tail
  config_get FORM_field_dfec_master_echo_canceller_enable $phoneid field_dfec_master_echo_canceller_enable
  config_get FORM_field_dfec_transmit_input_dc_filter_disable $phoneid field_dfec_transmit_input_dc_filter_disable
  config_get FORM_field_dfec_tone_transmitter $phoneid field_dfec_tone_transmitter
  config_get FORM_field_dfec_filter_coefficient_freeze $phoneid field_dfec_filter_coefficient_freeze
  config_get FORM_field_dfec_dynamic_attenuation $phoneid field_dfec_dynamic_attenuation
  config_get FORM_field_dfec_background_noise_replacement $phoneid field_dfec_background_noise_replacement
  config_get FORM_field_dfec_sparse_foreground_filter $phoneid field_dfec_sparse_foreground_filter
  config_get FORM_field_dfec_nlp_comfort_noise_generation $phoneid field_dfec_nlp_comfort_noise_generation
  config_get FORM_field_dfec_echo_path_filter_control $phoneid field_dfec_echo_path_filter_control
  config_get FORM_field_dfec_recieve_input_dc_filter_enable $phoneid field_dfec_recieve_input_dc_filter_enable
}

! empty "$FORM_display_fxo_dfec" && {
  phoneid=fxo
  config_get FORM_fxo_name $phoneid name
  config_get FORM_fxo_number $phoneid number
  config_get FORM_field_dfec_init_control_enable $phoneid field_dfec_init_control_enable
  config_get FORM_field_dfec_nlp_control_enable $phoneid field_dfec_nlp_control_enable
  config_get FORM_field_dfec_tail $phoneid field_dfec_tail
  config_get FORM_field_dfec_master_echo_canceller_enable $phoneid field_dfec_master_echo_canceller_enable
  config_get FORM_field_dfec_transmit_input_dc_filter_disable $phoneid field_dfec_transmit_input_dc_filter_disable
  config_get FORM_field_dfec_tone_transmitter $phoneid field_dfec_tone_transmitter
  config_get FORM_field_dfec_filter_coefficient_freeze $phoneid field_dfec_filter_coefficient_freeze
  config_get FORM_field_dfec_dynamic_attenuation $phoneid field_dfec_dynamic_attenuation
  config_get FORM_field_dfec_background_noise_replacement $phoneid field_dfec_background_noise_replacement
  config_get FORM_field_dfec_sparse_foreground_filter $phoneid field_dfec_sparse_foreground_filter
  config_get FORM_field_dfec_nlp_comfort_noise_generation $phoneid field_dfec_nlp_comfort_noise_generation
  config_get FORM_field_dfec_echo_path_filter_control $phoneid field_dfec_echo_path_filter_control
  config_get FORM_field_dfec_recieve_input_dc_filter_enable $phoneid field_dfec_recieve_input_dc_filter_enable
}

! empty "$FORM_save_dfec" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk analog$FORM_analogid field_dfec_init_control_enable "$FORM_field_dfec_init_control_enable"
    uci_set asterisk analog$FORM_analogid field_dfec_nlp_control_enable "$FORM_field_dfec_nlp_control_enable"
    uci_set asterisk analog$FORM_analogid field_dfec_tail "$FORM_field_dfec_tail"
    uci_set asterisk analog$FORM_analogid field_dfec_master_echo_canceller_enable "$FORM_field_dfec_master_echo_canceller_enable"
    uci_set asterisk analog$FORM_analogid field_dfec_transmit_input_dc_filter_disable "$FORM_field_dfec_transmit_input_dc_filter_disable"
    uci_set asterisk analog$FORM_analogid field_dfec_tone_transmitter "$FORM_field_dfec_tone_transmitter"
    uci_set asterisk analog$FORM_analogid field_dfec_filter_coefficient_freeze "$FORM_field_dfec_filter_coefficient_freeze"
    uci_set asterisk analog$FORM_analogid field_dfec_dynamic_attenuation "$FORM_field_dfec_dynamic_attenuation"
    uci_set asterisk analog$FORM_analogid field_dfec_background_noise_replacement "$FORM_field_dfec_background_noise_replacement"
    uci_set asterisk analog$FORM_analogid field_dfec_sparse_foreground_filter "$FORM_field_dfec_sparse_foreground_filter"
    uci_set asterisk analog$FORM_analogid field_dfec_nlp_comfort_noise_generation "$FORM_field_dfec_nlp_comfort_noise_generation"
    uci_set asterisk analog$FORM_analogid field_dfec_echo_path_filter_control "$FORM_field_dfec_echo_path_filter_control"
    uci_set asterisk analog$FORM_analogid field_dfec_recieve_input_dc_filter_enable "$FORM_field_dfec_recieve_input_dc_filter_enable"
    config_set analog$FORM_analogid field_dfec_init_control_enable "$FORM_field_dfec_init_control_enable"
    config_set analog$FORM_analogid field_dfec_nlp_control_enable "$FORM_field_dfec_nlp_control_enable"
    config_set analog$FORM_analogid field_dfec_tail "$FORM_field_dfec_tail"
    config_set analog$FORM_analogid field_dfec_master_echo_canceller_enable "$FORM_field_dfec_master_echo_canceller_enable"
    config_set analog$FORM_analogid field_dfec_transmit_input_dc_filter_disable "$FORM_field_dfec_transmit_input_dc_filter_disable"
    config_set analog$FORM_analogid field_dfec_tone_transmitter "$FORM_field_dfec_tone_transmitter"
    config_set analog$FORM_analogid field_dfec_filter_coefficient_freeze "$FORM_field_dfec_filter_coefficient_freeze"
    config_set analog$FORM_analogid field_dfec_dynamic_attenuation "$FORM_field_dfec_dynamic_attenuation"
    config_set analog$FORM_analogid field_dfec_background_noise_replacement "$FORM_field_dfec_background_noise_replacement"
    config_set analog$FORM_analogid field_dfec_sparse_foreground_filter "$FORM_field_dfec_sparse_foreground_filter"
    config_set analog$FORM_analogid field_dfec_nlp_comfort_noise_generation "$FORM_field_dfec_nlp_comfort_noise_generation"
    config_set analog$FORM_analogid field_dfec_echo_path_filter_control "$FORM_field_dfec_echo_path_filter_control"
    config_set analog$FORM_analogid field_dfec_recieve_input_dc_filter_enable "$FORM_field_dfec_recieve_input_dc_filter_enable"
  }
}

! empty "$FORM_save_dect_dfec" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk dect$FORM_phoneid field_dfec_init_control_enable "$FORM_field_dfec_init_control_enable"
    uci_set asterisk dect$FORM_phoneid field_dfec_nlp_control_enable "$FORM_field_dfec_nlp_control_enable"
    uci_set asterisk dect$FORM_phoneid field_dfec_tail "$FORM_field_dfec_tail"
    uci_set asterisk dect$FORM_phoneid field_dfec_master_echo_canceller_enable "$FORM_field_dfec_master_echo_canceller_enable"
    uci_set asterisk dect$FORM_phoneid field_dfec_transmit_input_dc_filter_disable "$FORM_field_dfec_transmit_input_dc_filter_disable"
    uci_set asterisk dect$FORM_phoneid field_dfec_tone_transmitter "$FORM_field_dfec_tone_transmitter"
    uci_set asterisk dect$FORM_phoneid field_dfec_filter_coefficient_freeze "$FORM_field_dfec_filter_coefficient_freeze"
    uci_set asterisk dect$FORM_phoneid field_dfec_dynamic_attenuation "$FORM_field_dfec_dynamic_attenuation"
    uci_set asterisk dect$FORM_phoneid field_dfec_background_noise_replacement "$FORM_field_dfec_background_noise_replacement"
    uci_set asterisk dect$FORM_phoneid field_dfec_sparse_foreground_filter "$FORM_field_dfec_sparse_foreground_filter"
    uci_set asterisk dect$FORM_phoneid field_dfec_nlp_comfort_noise_generation "$FORM_field_dfec_nlp_comfort_noise_generation"
    uci_set asterisk dect$FORM_phoneid field_dfec_echo_path_filter_control "$FORM_field_dfec_echo_path_filter_control"
    uci_set asterisk dect$FORM_phoneid field_dfec_recieve_input_dc_filter_enable "$FORM_field_dfec_recieve_input_dc_filter_enable"
    config_set dect$FORM_phoneid field_dfec_init_control_enable "$FORM_field_dfec_init_control_enable"
    config_set dect$FORM_phoneid field_dfec_nlp_control_enable "$FORM_field_dfec_nlp_control_enable"
    config_set dect$FORM_phoneid field_dfec_tail "$FORM_field_dfec_tail"
    config_set dect$FORM_phoneid field_dfec_master_echo_canceller_enable "$FORM_field_dfec_master_echo_canceller_enable"
    config_set dect$FORM_phoneid field_dfec_transmit_input_dc_filter_disable "$FORM_field_dfec_transmit_input_dc_filter_disable"
    config_set dect$FORM_phoneid field_dfec_tone_transmitter "$FORM_field_dfec_tone_transmitter"
    config_set dect$FORM_phoneid field_dfec_filter_coefficient_freeze "$FORM_field_dfec_filter_coefficient_freeze"
    config_set dect$FORM_phoneid field_dfec_dynamic_attenuation "$FORM_field_dfec_dynamic_attenuation"
    config_set dect$FORM_phoneid field_dfec_background_noise_replacement "$FORM_field_dfec_background_noise_replacement"
    config_set dect$FORM_phoneid field_dfec_sparse_foreground_filter "$FORM_field_dfec_sparse_foreground_filter"
    config_set dect$FORM_phoneid field_dfec_nlp_comfort_noise_generation "$FORM_field_dfec_nlp_comfort_noise_generation"
    config_set dect$FORM_phoneid field_dfec_echo_path_filter_control "$FORM_field_dfec_echo_path_filter_control"
    config_set dect$FORM_phoneid field_dfec_recieve_input_dc_filter_enable "$FORM_field_dfec_recieve_input_dc_filter_enable"
  }
}

! empty "$FORM_display_fxo_advance" && {
  config_get FORM_fxo_name fxo name
  config_get FORM_fxo_number fxo number
  config_get FORM_field_ec_enable fxo field_ec_enable
  config_get FORM_field_dc_filter_enable fxo field_dc_filter_enable
  config_get FORM_field_hec_filter_enable fxo field_hec_filter_enable
  config_get FORM_field_nlp_control_enable fxo field_nlp_control_enable
  config_get FORM_field_nlp_tune fxo field_nlp_tune
  config_get FORM_field_comfort_noise fxo field_comfort_noise
  config_get FORM_field_ec_tail fxo field_ec_tail
}

! empty "$FORM_save_fxo_advance" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk fxo field_ec_enable "$FORM_field_ec_enable"
    uci_set asterisk fxo field_dc_filter_enable "$FORM_field_dc_filter_enable"
    uci_set asterisk fxo field_hec_filter_enable "$FORM_field_hec_filter_enable"
    uci_set asterisk fxo field_nlp_control_enable "$FORM_field_nlp_control_enable"
    uci_set asterisk fxo field_nlp_tune "$FORM_field_nlp_tune"
    uci_set asterisk fxo field_comfort_noise "$FORM_field_comfort_noise"
    uci_set asterisk fxo field_ec_tail "$FORM_field_ec_tail"
    config_set fxo field_ec_enable "$FORM_field_ec_enable"
    config_set fxo field_dc_filter_enable "$FORM_field_dc_filter_enable"
    config_set fxo field_hec_filter_enable "$FORM_field_hec_filter_enable"
    config_set fxo field_nlp_control_enable "$FORM_field_nlp_control_enable"
    config_set fxo field_nlp_tune "$FORM_field_nlp_tune"
    config_set fxo field_comfort_noise "$FORM_field_comfort_noise"
    config_set fxo field_ec_tail "$FORM_field_ec_tail"
  }
}

! empty "$FORM_display_fxo_advance_ec" && {
  config_get FORM_fxo_name fxo name
  config_get FORM_fxo_number fxo number
  config_get FORM_field_full_filter fxo field_full_filter
  config_get FORM_field_fast_convergence_control fxo field_fast_convergence_control
}

! empty "$FORM_save_fxo_advance_ec" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk fxo field_full_filter "$FORM_field_full_filter"
    uci_set asterisk fxo field_fast_convergence_control "$FORM_field_fast_convergence_control"
    config_set fxo field_full_filter "$FORM_field_full_filter"
    config_set fxo field_fast_convergence_control "$FORM_field_fast_convergence_control"
  }
}

! empty "$FORM_save_fxo_dfec" && {
  SAVED=1
  equal "$?" 0 && {
    uci_set asterisk fxo field_dfec_init_control_enable "$FORM_field_dfec_init_control_enable"
    uci_set asterisk fxo field_dfec_nlp_control_enable "$FORM_field_dfec_nlp_control_enable"
    uci_set asterisk fxo field_dfec_tail "$FORM_field_dfec_tail"
    uci_set asterisk fxo field_dfec_master_echo_canceller_enable "$FORM_field_dfec_master_echo_canceller_enable"
    uci_set asterisk fxo field_dfec_transmit_input_dc_filter_disable "$FORM_field_dfec_transmit_input_dc_filter_disable"
    uci_set asterisk fxo field_dfec_tone_transmitter "$FORM_field_dfec_tone_transmitter"
    uci_set asterisk fxo field_dfec_filter_coefficient_freeze "$FORM_field_dfec_filter_coefficient_freeze"
    uci_set asterisk fxo field_dfec_dynamic_attenuation "$FORM_field_dfec_dynamic_attenuation"
    uci_set asterisk fxo field_dfec_background_noise_replacement "$FORM_field_dfec_background_noise_replacement"
    uci_set asterisk fxo field_dfec_sparse_foreground_filter "$FORM_field_dfec_sparse_foreground_filter"
    uci_set asterisk fxo field_dfec_nlp_comfort_noise_generation "$FORM_field_dfec_nlp_comfort_noise_generation"
    uci_set asterisk fxo field_dfec_echo_path_filter_control "$FORM_field_dfec_echo_path_filter_control"
    uci_set asterisk fxo field_dfec_recieve_input_dc_filter_enable "$FORM_field_dfec_recieve_input_dc_filter_enable"
    config_set fxo field_dfec_init_control_enable "$FORM_field_dfec_init_control_enable"
    config_set fxo field_dfec_nlp_control_enable "$FORM_field_dfec_nlp_control_enable"
    config_set fxo field_dfec_tail "$FORM_field_dfec_tail"
    config_set fxo field_dfec_master_echo_canceller_enable "$FORM_field_dfec_master_echo_canceller_enable"
    config_set fxo field_dfec_transmit_input_dc_filter_disable "$FORM_field_dfec_transmit_input_dc_filter_disable"
    config_set fxo field_dfec_tone_transmitter "$FORM_field_dfec_tone_transmitter"
    config_set fxo field_dfec_filter_coefficient_freeze "$FORM_field_dfec_filter_coefficient_freeze"
    config_set fxo field_dfec_dynamic_attenuation "$FORM_field_dfec_dynamic_attenuation"
    config_set fxo field_dfec_background_noise_replacement "$FORM_field_dfec_background_noise_replacement"
    config_set fxo field_dfec_sparse_foreground_filter "$FORM_field_dfec_sparse_foreground_filter"
    config_set fxo field_dfec_nlp_comfort_noise_generation "$FORM_field_dfec_nlp_comfort_noise_generation"
    config_set fxo field_dfec_echo_path_filter_control "$FORM_field_dfec_echo_path_filter_control"
    config_set fxo field_dfec_recieve_input_dc_filter_enable "$FORM_field_dfec_recieve_input_dc_filter_enable"
  }
}

! empty "$FORM_delete_fxo" && {
  uci_set asterisk fxo name ""
  uci_set asterisk fxo number ""
}

! empty "$FORM_display_fxo" && {
  config_get FORM_fxo_name fxo name
  config_get FORM_fxo_number fxo number
}

! empty "$FORM_save_fxo" && {
  SAVED=1
  save_validate_success="n"
validate <<EOF
string|FORM_fxo_name|@TR<<fxo phone name>>|required|$FORM_fxo_name
int|FORM_fxo_number|@TR<<fxo phone number>>|required|$FORM_fxo_number
EOF
  equal "$?" 0 && {
    uci_set asterisk fxo name "$FORM_fxo_name"
    uci_set asterisk fxo number "$FORM_fxo_number"
    config_set fxo name "$FORM_fxo_name"
    config_set fxo number "$FORM_fxo_number"
    save_validate_success="y"
  }
  [ "$save_validate_success" = "n" ] && FORM_display_fxo=1
}

! empty "$FORM_new_voip_phone" && {
  SAVED=1
  add_validate_success="n"
validate <<EOF
string|FORM_voip_name|@TR<<Voip phone name>>|required|$FORM_voip_name
int|FORM_voip_number|@TR<<Voip phone number>>|required|$FORM_voip_number
string|FORM_field_voip_protocol|@TR<<Protocol>>||$FORM_field_voip_protocol
string|FORM_voip_auth_pwd|@TR<<Auth pwd>>||$FORM_voip_auth_pwd
EOF
  equal "$?" 0 && {
    voipid=`uci get asterisk.general.voipphones`
    voipid=`expr $voipid + 1`
    uci_add asterisk voipphone voip$voipid
    uci_set asterisk voip$voipid name "$FORM_voip_name"
    uci_set asterisk voip$voipid number "$FORM_voip_number"
    uci_set asterisk voip$voipid protocol "$FORM_field_voip_protocol"
    uci_set asterisk voip$voipid type "$FORM_field_voip_type"
    uci_set asterisk voip$voipid authpwd "$FORM_voip_auth_pwd"
    uci_set asterisk voip$voipid voicemail "$FORM_field_voip_voicemail"
    uci_set asterisk general voipphones $voipid
    config_set voip$voipid name "$FORM_voip_name"
    config_set voip$voipid number "$FORM_voip_number"
    config_set voip$voipid protocol "$FORM_field_voip_protocol"
    config_set voip$voipid type "$FORM_field_voip_type"
    config_set voip$voipid authpwd "$FORM_voip_auth_pwd"
    config_set voip$voipid voicemail "$FORM_field_voip_voicemail"
    add_validate_success="y"
  }
  [ "$add_validate_success" = "n" ] && FORM_add_new_voip="Add New"
}

! empty "$FORM_display_voip_phone" && {
  voipid=$FORM_display_voip_phone
  config_get FORM_voip_name voip$voipid name
  config_get FORM_voip_number voip$voipid number
  config_get FORM_field_voip_protocol voip$voipid protocol
  config_get FORM_field_voip_type voip$voipid type
  config_get FORM_voip_auth_pwd voip$voipid authpwd
  config_get FORM_field_voip_voicemail voip$voipid voicemail
}

! empty "$FORM_save_voip_phone" && {
  SAVED=1
  save_validate_success="n"
validate <<EOF
string|FORM_voip_name|@TR<<Voip phone name>>|required|$FORM_voip_name
int|FORM_voip_number|@TR<<Voip phone number>>|required|$FORM_voip_number
string|FORM_field_voip_protocol|@TR<<Protocol>>||$FORM_field_voip_protocol
string|FORM_voip_auth_pwd|@TR<<Auth pwd>>||$FORM_voip_auth_pwd
EOF
  equal "$?" 0 && {
    uci_set asterisk voip$FORM_voipid name "$FORM_voip_name"
    uci_set asterisk voip$FORM_voipid number "$FORM_voip_number"
    uci_set asterisk voip$FORM_voipid protocol "$FORM_field_voip_protocol"
    uci_set asterisk voip$FORM_voipid type "$FORM_field_voip_type"
    uci_set asterisk voip$FORM_voipid authpwd "$FORM_voip_auth_pwd"
    uci_set asterisk voip$FORM_voipid voicemail "$FORM_field_voip_voicemail"
    config_set voip$FORM_voipid name "$FORM_voip_name"
    config_set voip$FORM_voipid number "$FORM_voip_number"
    config_set voip$FORM_voipid protocol "$FORM_field_voip_protocol"
    config_set voip$FORM_voipid type "$FORM_field_voip_type"
    config_set voip$FORM_voipid authpwd "$FORM_voip_auth_pwd"
    config_set voip$FORM_voipid voicemail "$FORM_field_voip_voicemail"
    save_validate_success="y"
  }
  [ "$save_validate_success" = "n" ] && FORM_display_voip_phone=$FORM_voipid
}

! empty "$FORM_delete_voip_phone" && {
  number=`uci get asterisk.general.voipphones`
  voipid=$FORM_delete_voip_phone
  uci_remove asterisk voip$voipid
  while [ $voipid -lt $number ]
  do
    uci_rename asterisk voip`expr $voipid + 1` voip$voipid
    voipid=`expr $voipid + 1`
  done
  uci_set asterisk general voipphones `expr $number - 1`
}

#####################################################################
header "Telephony" "Extensions" "@TR<<Dial Plan>>" 
#####################################################################
cat <<EOF
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">

<!--
function modechange()
{
 /* alert('$FORM_echo_cancel_type');
  if ( '$FORM_echo_cancel_type' == "EC" )
  {
    set_visible('field_ec_help', 1);
    set_visible('field_dfec_help', 0);
  }
  else
  {
    set_visible('field_ec_help', 0);
    set_visible('field_dfec_help', 1);
  }*/
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

function setdfecdefaultvalues()
{
  //  var item = document.getElementById('field_dfec_master_echo_canceller_enable');
    document.forms[0].field_dfec_init_control_enable.value  = "default" ;
    document.forms[0].field_dfec_nlp_control_enable.value   = "default"  ;
    document.forms[0].field_dfec_tail.value           = "default"     ;
    document.forms[0].field_dfec_master_echo_canceller_enable.value     = "default"  ;
    document.forms[0].field_dfec_transmit_input_dc_filter_disable.value = "default"  ;
    document.forms[0].field_dfec_tone_transmitter.value                 = "default" ;
    document.forms[0].field_dfec_filter_coefficient_freeze.value        = "default"  ;
    document.forms[0].field_dfec_dynamic_attenuation.value              = "default" ;
    document.forms[0].field_dfec_background_noise_replacement.value     = "default" ;
    document.forms[0].field_dfec_sparse_foreground_filter.value         = "default" ;
    document.forms[0].field_dfec_nlp_comfort_noise_generation.value     = "default"  ;
    document.forms[0].field_dfec_echo_path_filter_control.value         = "default"  ;
    document.forms[0].field_dfec_recieve_input_dc_filter_enable.value   = "default" ;
}




function setecdefaultvalues()
{
    //alert(document.forms[0].field_ec_enable.selectedIndex);
    document.forms[0].field_ec_enable.value          = "default"  ;
    document.forms[0].field_dc_filter_enable.value   = "default"  ;
    document.forms[0].field_hec_filter_enable.value  = "default" ;
    document.forms[0].field_nlp_control_enable.value = "default"  ;
    document.forms[0].field_comfort_noise.value      = "default"  ;
    document.forms[0].field_nlp_tune.value           = "default"     ;
    document.forms[0].field_ec_tail.value      = "default"     ;

}

function setdectecdefaultvalues()
{
    document.forms[0].field_ec_enable.checked          = true  ;
    document.forms[0].field_dc_filter_enable.checked   = true  ;
    document.forms[0].field_hec_filter_enable.checked  = false ;
    document.forms[0].field_nlp_control_enable.checked = true  ;
    document.forms[0].field_comfort_noise.checked      = true  ;
    document.forms[0].field_nlp_tune.selectedIndex           = 0     ;
    document.forms[0].field_ec_tail.selectedIndex      = 0     ;
}

function setfxoecdefaultvalues()
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
    document.forms[0].field_full_filter.value              = "default"  ;
    document.forms[0].field_fast_convergence_control.value = "default" ;
}

function setdectenhecdefaultvalues()
{
    document.forms[0].field_full_filter.checked              = true  ;
    document.forms[0].field_fast_convergence_control.checked = false ;
}

function setfxoenhecdefaultvalues()
{
    document.forms[0].field_full_filter.checked              = true  ;
    document.forms[0].field_fast_convergence_control.checked = false ;
}
-->
</script>
EOF

count=`uci get asterisk.general.analogphones`
echo "<th colspan=\"11\"><h3>" Analog Extensions: "</h3></th>"
echo "<div class=\"settings\">"
echo "<table style=\"width: 96%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><tbody>"
echo "<tr class=\"odd\"><th>Phone ID</th><th>Phone Number</th><th>Display Name</th><th style=\"text-align: center;\">Actions</th></tr>"
i=1
while [ $i -le $count ]
do
config_get analog_name analog$i name
config_get analog_number analog$i number
echo "<tr class=\"tr_bg\"><td>$i</td><td>$analog_number</td><td>$analog_name</td><td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?display_analog_phone=$i\"><img alt=\"@TR<<edit>>\" src=\"/images/edit.gif\" title=\"@TR<<edit>>\" /></a>  </td></tr>"
i=`expr $i + 1`
done
echo "</tbody></table><div class=\"clearfix\">&nbsp;</div></div>"
ectype=`uci get asterisk.general.echo_cancel_type`
equal "$ectype" "EC" &&
{
  echelplink1="<a href=\"$SCRIPT_NAME?display_analog_advance=$FORM_display_analog_phone\">Echo-Canceller</a>"
  echelplink2="<a href=\"$SCRIPT_NAME?display_analog_advance_ec=$FORM_display_analog_phone\">Enhanced Echo-Canceller</a>"
}
equal "$ectype" "DFEC" &&
{
  echelplink1="<a href=\"$SCRIPT_NAME?display_dfec=$FORM_display_analog_phone\">Dual Filter Echo Canceller</a>"
  echelplink2=""
}

! empty "$FORM_display_analog_phone" && {
config_get global_bwe_high_band general bwe_high_band
config_get global_bwe_low_band general bwe_low_band
display_form <<EOF
onchange|modechange
start_form|@TR<<Edit Analog Phone $FORM_display_analog_phone>>
formtag_begin|save_analog_phone|$SCRIPT_NAME
field|@TR<<Analog Phone ID>>
text|analogid|$FORM_display_analog_phone|||readonly
field|@TR<<Name>>|field_analog_name
text|analog_name|$FORM_analog_name
field|@TR<<Number>>|field_analog_number
text|analog_number|$FORM_analog_number
field|@TR<<Voicemail>>|field_analog_voicemail
select|field_analog_voicemail|$FORM_field_analog_voicemail|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<DSP on ACP>>|field_dsp_acp
select|field_dsp_acp|$FORM_field_dsp_acp|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<VAD>>|field_vad
select|field_vad|$FORM_field_vad|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Phone band>>|phone_band
select|phone_band|$FORM_phone_band|narrow
option|default|default
option|narrow|narrow
option|wide|wide
field|@TR<<BWE Master>>|bwe_master
select|bwe_master|$FORM_bwe_master|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<BWE High band>>|bwe_high_band
text|bwe_high_band|$FORM_bwe_high_band| (Default $global_bwe_high_band)
field|@TR<<BWE Low band>>|bwe_low_band
text|bwe_low_band|$FORM_bwe_low_band| (Default $global_bwe_low_band)
field||spacer1
string|<br />
submit|save_analog_phone|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
field||spacer1
string|<br />
string|<tr><td><font color="black" size="2" style="BACKGROUND-COLOR: #ff9900"><b>Advanced: </b></font></td></tr>
field||spacer1
string|$echelplink1
field||spacer1
string|$echelplink2
formtag_end
end_form
EOF
}

! empty "$FORM_display_analog_advance" && {

display_form <<EOF
start_form|@TR<<Edit Echo Canceller for Analog Phone $FORM_display_analog_advance>>
formtag_begin|save_analog_advance|$SCRIPT_NAME
field|@TR<<Analog Phone ID>>
text|analogid|$FORM_display_analog_advance|||readonly
field|@TR<<Name>>|field_analog_name
string|$FORM_analog_name
field|@TR<<Number>>|field_analog_number
string|$FORM_analog_number

field|@TR<<Enable Echo Canceller>>|field_ec_enable
select|field_ec_enable|$FORM_field_ec_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable DC Removal Filter>>|field_dc_filter_enable
select|field_dc_filter_enable|$FORM_field_dc_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Freeze HEC Filter Coefficient>>|field_hec_filter_enable
select|field_hec_filter_enable|$FORM_field_hec_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable NLP Control>>|field_nlp_control_enable
select|field_nlp_control_enable|$FORM_field_nlp_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<NLP Tune>>
select|field_nlp_tune|$FORM_field_nlp_tune
option|default|default
option|00|00
option|01|01
option|10|10
field|@TR<<Comfort Noise Generation>>|field_comfort_noise
select|field_comfort_noise|$FORM_field_comfort_noise|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Network Echo Canceller Tail Length>>|field_ec_tail
select|field_ec_tail|$FORM_field_ec_tail
option|default|default
option|0001|16 ms
option|0011|32 ms
option|0101|48 ms
option|0111|64 ms
field|@TR<<>>
string|<a href="javascript:setecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_analog_advance|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_dfec" && {

display_form <<EOF
start_form|@TR<<Edit Dual Filter Echo Canceller for Analog Phone $FORM_display_dfec>>
formtag_begin|save_dfec|$SCRIPT_NAME
field|@TR<<Analog Phone ID>>||hidden
text|analogid|$FORM_display_dfec|||readonly
field|@TR<<Name>>|field_analog_name
string|$FORM_analog_name
field|@TR<<Number>>|field_analog_number
string|$FORM_analog_number

field|@TR<<Initialization Control>>|field_dfec_init_control_enable
select|field_dfec_init_control_enable|$FORM_field_dfec_init_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable NLP Control>>|field_dfec_nlp_control_enable
select|field_dfec_nlp_control_enable|$FORM_field_dfec_nlp_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Echo Path Filter Length>>|field_dfec_tail
select|field_dfec_tail|$FORM_field_dfec_tail
option|default|default
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
field|@TR<<>>|field_show_yes_enable
string|<a href="javascript:advance(1)">Advance Parameters &gt;&gt;</a>
field|@TR<<>>|field_show_no_enable|hidden
string|<a href="javascript:advance(1)">&lt;&lt;Advance Parameters</a>
field|@TR<<Enable Master Echo Canceller>>|field_dfec_master_echo_canceller_enable|hidden
select|field_dfec_master_echo_canceller_enable|$FORM_field_dfec_master_echo_canceller_enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Transmit Input DC Filter Disable>>|field_dfec_transmit_input_dc_filter_disable|hidden
select|field_dfec_transmit_input_dc_filter_disable|$FORM_field_dfec_transmit_input_dc_filter_disable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Tone Transmitter>>|field_dfec_tone_transmitter|hidden
select|field_dfec_tone_transmitter|$FORM_field_dfec_tone_transmitter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Filter Coefficient Freeze>>|field_dfec_filter_coefficient_freeze|hidden
select|field_dfec_filter_coefficient_freeze|$FORM_field_dfec_filter_coefficient_freeze|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Dynamic Attentuation>>|field_dfec_dynamic_attenuation|hidden
select|field_dfec_dynamic_attenuation|$FORM_field_dfec_dynamic_attenuation|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Background Noise Replacement>>|field_dfec_background_noise_replacement|hidden
select|field_dfec_background_noise_replacement|$FORM_field_dfec_background_noise_replacement|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Sparse Foreground Filter>>|field_dfec_sparse_foreground_filter|hidden
select|field_dfec_sparse_foreground_filter|$FORM_field_dfec_sparse_foreground_filter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<NLP Comfort Noise Generation>>|field_dfec_nlp_comfort_noise_generation|hidden
select|field_dfec_nlp_comfort_noise_generation|$FORM_field_dfec_nlp_comfort_noise_generation|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Echo Path Filter Control>>|field_dfec_echo_path_filter_control|hidden
select|field_dfec_echo_path_filter_control|$FORM_field_dfec_echo_path_filter_control|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Recieve Input DC Filter Enable>>|field_dfec_recieve_input_dc_filter_enable|hidden
select|field_dfec_recieve_input_dc_filter_enable|$FORM_field_dfec_recieve_input_dc_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<>>
string|<a href="javascript:setdfecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_dfec|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}


! empty "$FORM_display_analog_advance_ec" && {

display_form <<EOF
start_form|@TR<<Edit Enhanced Echo Canceller for Analog Phone $FORM_display_analog_advance_ec>>
formtag_begin|save_analog_advance_ec|$SCRIPT_NAME
field|@TR<<Analog Phone ID>>
text|analogid|$FORM_display_analog_advance_ec|||readonly
field|@TR<<Name>>|field_analog_name
string|$FORM_analog_name
field|@TR<<Number>>|field_analog_number
string|$FORM_analog_number

field|@TR<<Full-Filter Echo Path Change Detection>>|field_full_filter
select|field_full_filter|$FORM_field_full_filter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Fast Convergence Control>>|field_fast_convergence_control
select|field_fast_convergence_control|$FORM_field_fast_convergence_control|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<>>
string|<a href="#" onclick="setenhecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_analog_advance_ec|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

if [ -f /usr/lib/libdspg_dect.so ] ; then
#BEGIN DECT
count=`uci get asterisk.general.dectphones`
echo "<th colspan=\"11\"><h3>" DECT Extensions: "</h3></th>"
echo "<div class=\"settings\">"
echo "<table style=\"width: 96%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><tbody>"
echo "<tr class=\"odd\"><th>Phone ID</th><th>Phone Number</th><th>Display Name</th><th style=\"text-align: center;\">Action</th></tr>"
i=1
while [ $i -le $count ]
do
  config_get dect_name dect$i name
  config_get dect_number dect$i number
  echo "<tr><td>$i</td><td>$dect_number</td><td>$dect_name</td><td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?display_dect_phone=$i\"><img alt=\"@TR<<edit>>\" src=\"/images/edit.gif\" title=\"@TR<<edit>>\" /></a></td></tr>"
  i=`expr $i + 1`
done
ectype=`uci get asterisk.general.echo_cancel_type`
equal "$ectype" "EC" &&
{
  echelplink1="<a href=\"$SCRIPT_NAME?display_dect_advance=$FORM_display_dect_phone\">Echo-Canceller</a>"
  echelplink2="<a href=\"$SCRIPT_NAME?display_dect_advance_ec=$FORM_display_dect_phone\">Enhanced Echo-Canceller</a>"
}
equal "$ectype" "DFEC" &&
{
  echelplink1="<a href=\"$SCRIPT_NAME?display_dect_dfec=$FORM_display_dect_phone\">Dual Filter Echo Canceller</a>"
  echelplink2=""
}
echo "</tbody></table><div class=\"clearfix\">&nbsp;</div></div>"

! empty "$FORM_display_dect_phone" && {
config_get global_bwe_high_band general bwe_high_band
config_get global_bwe_low_band general bwe_low_band
display_form <<EOF
onchange|modechange
start_form|@TR<<Edit DECT Phone $FORM_display_dect_phone>>
formtag_begin|save_dect_phone|$SCRIPT_NAME
field|@TR<<DECT Phone ID>>
text|dectid|$FORM_display_dect_phone|||readonly
field|@TR<<Name>>|field_dect_name
text|dect_name|$FORM_dect_name
field|@TR<<Number>>|field_dect_number
text|dect_number|$FORM_dect_number
field|@TR<<Voicemail>>|field_dect_voicemail
select|field_dect_voicemail|$FORM_field_dect_voicemail|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<DSP on ACP>>|field_dsp_acp
select|field_dsp_acp|$FORM_field_dsp_acp|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<VAD>>|field_vad
select|field_vad|$FORM_field_vad|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<BWE Master>>|bwe_master
select|bwe_master|$FORM_bwe_master|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<BWE High band>>|bwe_high_band
text|bwe_high_band|$FORM_bwe_high_band| (Default $global_bwe_high_band)
field|@TR<<BWE Low band>>|bwe_low_band
text|bwe_low_band|$FORM_bwe_low_band|  (Default $global_bwe_low_band)
field||spacer1
string|<br />
submit|save_dect_phone|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
field||spacer1
string|<br />
string|<tr><td><font color="black" size="2" style="BACKGROUND-COLOR: #ff9900"><b>Advanced: </b></font></td></tr>
field||spacer1
string|$echelplink1
field||spacer1
string|$echelplink2
formtag_end
end_form
EOF
}

! empty "$FORM_display_dect_advance" && {

display_form <<EOF
start_form|@TR<<Edit Echo Canceller for DECT Phone $FORM_display_dect_advance>>
formtag_begin|save_dect_advance|$SCRIPT_NAME
field|@TR<<DECT Phone ID>>
text|dectid|$FORM_display_dect_advance|||readonly
field|@TR<<Name>>|field_dect_name
string|$FORM_dect_name
field|@TR<<Number>>|field_dect_number
string|$FORM_dect_number

field|@TR<<Enable Echo Canceller>>|field_ec_enable
select|field_ec_enable|$FORM_field_ec_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable DC Removal Filter>>|field_dc_filter_enable
select|field_dc_filter_enable|$FORM_field_dc_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Freeze HEC Filter Coefficient>>|field_hec_filter_enable
select|field_hec_filter_enable|$FORM_field_hec_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable NLP Control>>|field_nlp_control_enable
select|field_nlp_control_enable|$FORM_field_nlp_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<NLP Tune>>
select|field_nlp_tune|$FORM_field_nlp_tune
option|default|default
option|00|00
option|01|01
option|10|10
field|@TR<<Comfort Noise Generation>>|field_comfort_noise
select|field_comfort_noise|$FORM_field_comfort_noise|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Network Echo Canceller Tail Length>>|field_ec_tail
select|field_ec_tail|$FORM_field_ec_tail
option|default|default
option|0001|16 ms
option|0011|32 ms
option|0101|48 ms
option|0111|64 ms
field|@TR<<>>
string|<a href="javascript:setecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_dect_advance|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_dect_advance_ec" && {

display_form <<EOF
start_form|@TR<<Edit Enhanced Echo Canceller for DECT Phone $FORM_display_dect_advance_ec>>
formtag_begin|save_dect_advance_ec|$SCRIPT_NAME
field|@TR<<DECT Phone ID>>
text|dectid|$FORM_display_dect_advance_ec|||readonly
field|@TR<<Name>>|field_dect_name
string|$FORM_dect_name
field|@TR<<Number>>|field_dect_number
string|$FORM_dect_number

field|@TR<<Full-Filter Echo Path Change Detection>>|field_full_filter
select|field_full_filter|$FORM_field_full_filter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Fast Convergence Control>>|field_fast_convergence_control
select|field_fast_convergence_control|$FORM_field_fast_convergence_control|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<>>
string|<a href="#" onclick="setenhecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_dect_advance_ec|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_dect_dfec" && {

display_form <<EOF
start_form|@TR<<Edit Dual Filter Echo Canceller for DECT Phone $FORM_display_dect_dfec>>
formtag_begin|save_dect_dfec|$SCRIPT_NAME
field|@TR<<DECT Phone ID>>
text|phoneid|$FORM_display_dect_dfec|||readonly
field|@TR<<Name>>|field_dect_name
string|$FORM_dect_name
field|@TR<<Number>>|field_dect_number
string|$FORM_dect_number

field|@TR<<Initialization Control>>|field_dfec_init_control_enable
select|field_dfec_init_control_enable|$FORM_field_dfec_init_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable NLP Control>>|field_dfec_nlp_control_enable
select|field_dfec_nlp_control_enable|$FORM_field_dfec_nlp_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Echo Path Filter Length>>|field_dfec_tail
select|field_dfec_tail|$FORM_field_dfec_tail
option|default|default
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
field|@TR<<>>|field_show_yes_enable
string|<a href="javascript:advance(1)">Advance Parameters &gt;&gt;</a>
field|@TR<<>>|field_show_no_enable|hidden
string|<a href="javascript:advance(1)">&lt;&lt;Advance Parameters</a>
field|@TR<<Enable Master Echo Canceller>>|field_dfec_master_echo_canceller_enable|hidden
select|field_dfec_master_echo_canceller_enable|$FORM_field_dfec_master_echo_canceller_enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Transmit Input DC Filter Disable>>|field_dfec_transmit_input_dc_filter_disable|hidden
select|field_dfec_transmit_input_dc_filter_disable|$FORM_field_dfec_transmit_input_dc_filter_disable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Tone Transmitter>>|field_dfec_tone_transmitter|hidden
select|field_dfec_tone_transmitter|$FORM_field_dfec_tone_transmitter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Filter Coefficient Freeze>>|field_dfec_filter_coefficient_freeze|hidden
select|field_dfec_filter_coefficient_freeze|$FORM_field_dfec_filter_coefficient_freeze|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Dynamic Attentuation>>|field_dfec_dynamic_attenuation|hidden
select|field_dfec_dynamic_attenuation|$FORM_field_dfec_dynamic_attenuation|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Background Noise Replacement>>|field_dfec_background_noise_replacement|hidden
select|field_dfec_background_noise_replacement|$FORM_field_dfec_background_noise_replacement|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Sparse Foreground Filter>>|field_dfec_sparse_foreground_filter|hidden
select|field_dfec_sparse_foreground_filter|$FORM_field_dfec_sparse_foreground_filter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<NLP Comfort Noise Generation>>|field_dfec_nlp_comfort_noise_generation|hidden
select|field_dfec_nlp_comfort_noise_generation|$FORM_field_dfec_nlp_comfort_noise_generation|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Echo Path Filter Control>>|field_dfec_echo_path_filter_control|hidden
select|field_dfec_echo_path_filter_control|$FORM_field_dfec_echo_path_filter_control|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Recieve Input DC Filter Enable>>|field_dfec_recieve_input_dc_filter_enable|hidden
select|field_dfec_recieve_input_dc_filter_enable|$FORM_field_dfec_recieve_input_dc_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<>>
string|<a href="javascript:setdfecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_dect_dfec|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}
# END DECT 
fi

config_get fxo_extensions general fxo
[ -n "$fxo_extensions" -a $fxo_extensions -gt 0 ] && {
echo "<th colspan=\"11\"><h3>" FXO Extensions: "</h3></th>"
echo "<div class=\"settings\">"
echo "<table style=\"width: 96%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><tbody>"
echo "<tr class=\"odd\"><th>Phone ID</th><th>Extension Number</th><th>Display Name</th><th style=\"text-align: center;\">Action</th></tr>"
i=1
config_get name fxo name
config_get number fxo number
echo "<tr class=\"tr_bg\"><td>$i</td><td>$number</td><td>$name</td><td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?display_fxo=$i\"><img alt=\"@TR<<edit>>\" src=\"/images/edit.gif\" title=\"@TR<<edit>>\" /></a> </td></tr>"
echo "</tbody></table><div class=\"clearfix\">&nbsp;</div></div>"

ectype=`uci get asterisk.general.echo_cancel_type`
equal "$ectype" "EC" &&
{
  echelplink1="<a href=\"$SCRIPT_NAME?display_fxo_advance=$FORM_display_fxo\">Echo-Canceller</a>"
  echelplink2="<a href=\"$SCRIPT_NAME?display_fxo_advance_ec=$FORM_display_fxo\">Enhanced Echo-Canceller</a>"
}
equal "$ectype" "DFEC" &&
{
  echelplink1="<a href=\"$SCRIPT_NAME?display_fxo_dfec=$FORM_display_fxo\">Dual Filter Echo Canceller</a>"
  echelplink2=""
}
}

! empty "$FORM_display_fxo" && {

display_form <<EOF
onchange|modechange
start_form|@TR<<Edit FXO Extension>>
formtag_begin|save_fxo_phone|$SCRIPT_NAME
field|@TR<<Name>>|field_fxo_name
text|fxo_name|$FORM_fxo_name
field|@TR<<Number>>|field_fxo_number
text|fxo_number|$FORM_fxo_number
field||spacer1
#helpitem|Advance configuration
#helptext|<a href="$SCRIPT_NAME?display_fxo_advance=$FORM_display_fxo">Echo-Canceller</a>
#helptext|<a href="$SCRIPT_NAME?display_fxo_advance_ec=$FORM_display_fxo">Enhanced Echo-Canceller</a>
string|<br />
submit|save_fxo|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
field||spacer1
string|<br />
string|<tr><td><font color="black" size="2" style="BACKGROUND-COLOR: #ff9900"><b>Advanced: </b></font></td></tr>
field||spacer1
string|$echelplink1
field||spacer1
string|$echelplink2
formtag_end
end_form
EOF
}

! empty "$FORM_display_fxo_advance" && {

display_form <<EOF
start_form|@TR<<Edit Echo Canceller for FXO Phone>>
formtag_begin|save_fxo_advance|$SCRIPT_NAME
field|@TR<<Name>>|field_fxo_name
string|$FORM_fxo_name
field|@TR<<Number>>|field_fxo_number
string|$FORM_fxo_number

field|@TR<<Enable Echo Canceller>>|field_ec_enable
select|field_ec_enable|$FORM_field_ec_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable DC Removal Filter>>|field_dc_filter_enable
select|field_dc_filter_enable|$FORM_field_dc_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Freeze HEC Filter Coefficient>>|field_hec_filter_enable
select|field_hec_filter_enable|$FORM_field_hec_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable NLP Control>>|field_nlp_control_enable
select|field_nlp_control_enable|$FORM_field_nlp_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<NLP Tune>>
select|field_nlp_tune|$FORM_field_nlp_tune
option|default|default
option|00|00
option|01|01
option|10|10
field|@TR<<Comfort Noise Generation>>|field_comfort_noise
select|field_comfort_noise|$FORM_field_comfort_noise|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Network Echo Canceller Tail Length>>|field_ec_tail
select|field_ec_tail|$FORM_field_ec_tail
option|default|default
option|0001|16 ms
option|0011|32 ms
option|0101|48 ms
option|0111|64 ms
field|@TR<<>>
string|<a href="#" onclick="setecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_fxo_advance|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_fxo_advance_ec" && {

display_form <<EOF
start_form|@TR<<Edit Enhanced Echo Canceller for FXO Phone>>
formtag_begin|save_fxo_advance_ec|$SCRIPT_NAME
field|@TR<<Name>>|field_fxo_name
string|$FORM_fxo_name
field|@TR<<Number>>|field_fxo_number
string|$FORM_fxo_number

field|@TR<<Full-Filter Echo Path Change Detection>>|field_full_filter
select|field_full_filter|$FORM_field_full_filter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Fast Convergence Control>>|field_fast_convergence_control
select|field_fast_convergence_control|$FORM_field_fast_convergence_control|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<>>
string|<a href="#" onclick="setenhecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_fxo_advance_ec|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_fxo_dfec" && {

display_form <<EOF
start_form|@TR<<Edit Dual Filter Echo Canceller for FXO Phone>>
formtag_begin|save_fxo_dfec|$SCRIPT_NAME
field|@TR<<DECT Phone ID>>
text|fxoid|$FORM_display_fxo_dfec|||readonly
field|@TR<<Name>>|field_fxo_name
string|$FORM_fxo_name
field|@TR<<Number>>|field_fxo_number
string|$FORM_fxo_number

field|@TR<<Initialization Control>>|field_dfec_init_control_enable
select|field_dfec_init_control_enable|$FORM_field_dfec_init_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Enable NLP Control>>|field_dfec_nlp_control_enable
select|field_dfec_nlp_control_enable|$FORM_field_dfec_nlp_control_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Echo Path Filter Length>>|field_dfec_tail
select|field_dfec_tail|$FORM_field_dfec_tail
option|default|default
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
field|@TR<<>>|field_show_yes_enable
string|<a href="javascript:advance(1)">Advance Parameters &gt;&gt;</a>
field|@TR<<>>|field_show_no_enable|hidden
string|<a href="javascript:advance(1)">&lt;&lt;Advance Parameters</a>
field|@TR<<Enable Master Echo Canceller>>|field_dfec_master_echo_canceller_enable|hidden
select|field_dfec_master_echo_canceller_enable|$FORM_field_dfec_master_echo_canceller_enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Transmit Input DC Filter Disable>>|field_dfec_transmit_input_dc_filter_disable|hidden
select|field_dfec_transmit_input_dc_filter_disable|$FORM_field_dfec_transmit_input_dc_filter_disable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Tone Transmitter>>|field_dfec_tone_transmitter|hidden
select|field_dfec_tone_transmitter|$FORM_field_dfec_tone_transmitter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Filter Coefficient Freeze>>|field_dfec_filter_coefficient_freeze|hidden
select|field_dfec_filter_coefficient_freeze|$FORM_field_dfec_filter_coefficient_freeze|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Dynamic Attentuation>>|field_dfec_dynamic_attenuation|hidden
select|field_dfec_dynamic_attenuation|$FORM_field_dfec_dynamic_attenuation|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Background Noise Replacement>>|field_dfec_background_noise_replacement|hidden
select|field_dfec_background_noise_replacement|$FORM_field_dfec_background_noise_replacement|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Sparse Foreground Filter>>|field_dfec_sparse_foreground_filter|hidden
select|field_dfec_sparse_foreground_filter|$FORM_field_dfec_sparse_foreground_filter|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<NLP Comfort Noise Generation>>|field_dfec_nlp_comfort_noise_generation|hidden
select|field_dfec_nlp_comfort_noise_generation|$FORM_field_dfec_nlp_comfort_noise_generation|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Echo Path Filter Control>>|field_dfec_echo_path_filter_control|hidden
select|field_dfec_echo_path_filter_control|$FORM_field_dfec_echo_path_filter_control|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<Recieve Input DC Filter Enable>>|field_dfec_recieve_input_dc_filter_enable|hidden
select|field_dfec_recieve_input_dc_filter_enable|$FORM_field_dfec_recieve_input_dc_filter_enable|enable
option|default|default
option|enable|enable
option|disable|disable
field|@TR<<>>
string|<a href="javascript:setdfecdefaultvalues()" >Set Default Values</a>

field||spacer1
string|<br />
submit|save_fxo_dfec|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}
#end of FXO

count=`uci get asterisk.general.voipphones`
echo "<th colspan=\"11\"><h3>" VoIP Extensions: "</h3></th>"
echo "<div class=\"settings\">"
echo "<table style=\"width: 96%; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"3\" cellspacing=\"3\" align=\"center\"><tbody>"
echo "<tr class=\"odd\"><th>Phone ID</th><th>Phone Number</th><th>Display Name</th><th style=\"text-align: center;\">Actions</th></tr>"
i=1
while [ $i -le $count ]
do
config_get voip_name voip$i name
config_get voip_number voip$i number
echo "<tr class=\"tr_bg\"><td>$i</td><td>$voip_number</td><td>$voip_name</td><td style=\"text-align: center;\"><a href=\"$SCRIPT_NAME?display_voip_phone=$i\"><img alt=\"@TR<<edit>>\" src=\"/images/edit.gif\" title=\"@TR<<edit>>\" /></a>  <a href=\"$SCRIPT_NAME?delete_voip_phone=$i\"><img alt=\"@TR<<delete>>\" src=\"/images/x.gif\" title=\"@TR<<delete>>\" /></a></td></tr>"
i=`expr $i + 1`
done
echo "</tbody></table><div class=\"clearfix\">&nbsp;</div></div>"

display_form <<EOF
start_form
field||spacer1
string|<br />
formtag_begin|add_new_voip|$SCRIPT_NAME
submit|add_new_voip|@TR<< Add New >>
formtag_end
end_form
EOF

! empty "$FORM_add_new_voip" && {

display_form <<EOF
start_form|@TR<<New VoIP Extension>>
formtag_begin|new_voip_phone|$SCRIPT_NAME
field|@TR<<Name>>|field_voip_name
text|voip_name|$FORM_voip_name
field|@TR<<Number/Auth Name>>|field_voip_number
text|voip_number|$FORM_voip_number
field|@TR<<Protocol>>|field_voip_protocol
select|field_voip_protocol|$FORM_field_voip_protocol
option|sip|@TR<<SIP>>
#option|H.323|@TR<<H.323>>
field|@TR<<Type>>|field_voip_type
select|field_voip_type|$FORM_field_voip_type
option|friend|@TR<<friend>>
option|peer|@TR<<peer>>
field|@TR<<Authentication Password>>|field_voip_auth_pwd
password|voip_auth_pwd|$FORM_voip_auth_pwd
field|@TR<<Voicemail>>|field_voip_voicemail
checkbox|field_voip_voicemail|$FORM_field_voip_voicemail|enable
field||spacer1
string|<br />
submit|new_voip_phone|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

! empty "$FORM_display_voip_phone" && {

display_form <<EOF
onchange|modechange
start_form|@TR<<Edit Voip Phone $FORM_display_voip_phone>>
formtag_begin|save_voip_phone|$SCRIPT_NAME
field|@TR<<Voip Phone ID>>
text|voipid|$FORM_display_voip_phone|||readonly
field|@TR<<Name>>|field_voip_name
text|voip_name|$FORM_voip_name
field|@TR<<Number/Auth Name>>|field_voip_number
text|voip_number|$FORM_voip_number
field|@TR<<Protocol>>|field_voip_protocol
select|field_voip_protocol|$FORM_field_voip_protocol
option|sip|@TR<<SIP>>
#option|H.323|@TR<<H.323>>
field|@TR<<Type>>|field_voip_type
select|field_voip_type|$FORM_field_voip_type
option|friend|@TR<<friend>>
option|peer|@TR<<peer>>
field|@TR<<Authentication Password>>|field_voip_auth_pwd
password|voip_auth_pwd|$FORM_voip_auth_pwd
field|@TR<<Voicemail>>|field_voip_voicemail
checkbox|field_voip_voicemail|$FORM_field_voip_voicemail|enable
field||spacer1>
string|<br />
submit|save_voip_phone|@TR<<Save>>
reset||@TR<<Reset>>
submit||@TR<<Cancel>>
formtag_end
end_form
EOF
}

footer ?>

<!--
##WEBIF:name:Telephony:100:Extensions
-->
