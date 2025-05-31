{ pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [ bubblewrap ];
  };

  security = {
    wrappers = {
      bwrap = {
        owner = "root";
        group = "root";
        source = builtins.toPath "${pkgs.bubblewrap}/bin/bwrap";
        setuid = lib.mkForce false;
        capabilities = "all+eip";
      };
    };
  };
}
