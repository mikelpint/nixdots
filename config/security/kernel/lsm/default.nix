{ config, ... }:
{
  imports = [
    ./apparmor
    ./selinux
  ];

  boot = {
    kernelParams = [
      "lsm=landlock,lockdown,yama,integrity,safesetid,${
        if config.security.apparmor.enable or false then "apparmor" else "selinux"
      },bpf"
      "lockdown=confidentiality"
    ];

    kernel = {
      sysctl = {
        "kernel.yama.ptrace_scope" = "2";
        "kernel.unprivileged_bpf_disabled" = true;
        "net.core.bpf_jit_harden" = "2";
        "net.core.bpf_jit_enable" = false;
      };
    };
  };
}
