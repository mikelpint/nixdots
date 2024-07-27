{
  imports = [ ./selinux ];

  boot = {
    kernelParams = [
      "lsm=landlock,lockdown,yama,integrity,bpf,tomoyo,selinux"
      "security=selinux"
    ];
  };
}
