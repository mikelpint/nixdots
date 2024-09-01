# ASUS ROG Strix G15 G513IH-HN008

{ lib, ... }:
{
  imports = [
    ../common
    ./bluetooth
    ./cpu
    ./display
    ./gpu
    ./input
    ./net
    ./power
    ./storage
  ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  age = {
    rekey = {
      hostPubkey = lib.mkForce "ssh-ed25519 AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICZHA48GprSaBWkG9YZ5Iq6cdA/hJouD5XLzM14y9tx+AAAABHNzaDo=";
    };
  };
}
