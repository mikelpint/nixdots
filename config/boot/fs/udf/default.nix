{ pkgs, lib, ... }:
{
  boot = {
    supportedFilesystems = {
      udf = lib.mkDefault true;
    };
  };

  environment = {
    systemPackages = with pkgs; [ udftools ];
  };
}
