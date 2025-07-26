{
  pkgs,
  osConfig,
  lib,
  config,
  ...
}:

{
  home = lib.mkIf (config.services.ssh.enable or false) {
    packages = with pkgs; [
      openfortivpn
      (writeShellScriptBin "deustovpn" ''
        #!bash

        SUDO=""

        if [ "$EUID" -ne 0 ]
        then
          if command -v "sudo" &> /dev/null
          then
            SUDO='sudo'
          elif command -v "doas" &> /dev/null
          then
            SUDO='doas'
          else
            echo "Please run as root"
            exit 1
          fi
        fi

        if [[ $1 == "kill" ]]
        then
          $SUDO pkill openfortivpn
          $SUDO pkill ppp

          exit
        fi

        PASSWD=$(< ${osConfig.age.secrets.deustopasswd.path})

        OTP=$1
        if [[ -z $OTP ]]
        then
            read -s -p "Enter the FortiToken OTP code: " OTP
        fi

        $SUDO pkill openfortivpn
        $SUDO pkill ppp

        $SUDO ${openfortivpn}/bin/openfortivpn \
          conecta.deusto.es:443 \
          -u mikel.p@opendeusto.es \
          -p $PASSWD \
          --otp $OTP \
          --set-dns=1 \
          --pppd-use-peerdns=1 \
          & disown
      '')
      (writeShellScriptBin "dspace" ''
        if [[ -z $1 ]]
        then
          echo "The OTP code is needed"
          exit 1
        fi

        deustovpn $1 &> /dev/null & disown
        if [ $? -ne 0 ]
        then
          exit $?
        fi

        HOST=$(< ${osConfig.age.secrets."dspace.host".path})
        ssh $HOST -i ${osConfig.age.secrets."dspace.pem".path}
      '')
    ];
  };
}
