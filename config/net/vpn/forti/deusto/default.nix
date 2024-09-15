{ self, ... }:
{
  age = {
    secrets = {
      deustopasswd = {
        owner = "mikel";
        rekeyFile = "${self}/secrets/deustopasswd.age";
      };

      "dspace.pem" = {
        owner = "mikel";
        rekeyFile = "${self}/secrets/dspace.pem.age";
      };

      "dspace.host" = {
        owner = "mikel";
        rekeyFile = "${self}/secrets/dspace.host.age";
      };
    };
  };
}
