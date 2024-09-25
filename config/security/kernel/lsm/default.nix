_: {
  imports = [
    ./apparmor
    # ./selinux
  ];

  boot = {
    kernelParams = [
      "lsm=landlock,lockdown,yama,integrity,safesetid,apparmor,bpf"
    ];
  };
}
