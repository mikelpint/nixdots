{ pkgs, ... }:
{
  imports = [ ./dspace ];

  services = {
    mongodb = {
      enable = true;
      package = pkgs.mongodb-ce;

      dbpath = "/var/db/mongodb";

      user = "mongodb";
    };
  };
}
