{ user, ... }:
{
  boot = {
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1 report_ignored_msrs=0
    '';
  };

  users = {
    users = {
      "${user}" = {
        extraGroups = [ "kvm" ];
      };
    };
  };

  virtualisation = {
    virtualbox = {
      host = {
        enableKvm = true;
      };
    };
  };
}
