{ config, ... }:
{
  imports = [
    ./apparmor
    ./selinux
  ];

  boot = {
    kernelParams = [
      "lsm=landlock,lockdown,yama,integrity,safesetid,${
        if config.security.apparmor.enable then "apparmor" else "selinux"
      },bpf"
    ];
    kernel = {
      sysctl = {
        "kernel.yama.ptrace_scope" = "1";
        "kernel.unprivileged_bpf_disabled" = "1";
        "net.core.bpf_jit_harden" = "2";
      };
    };
  };
}
