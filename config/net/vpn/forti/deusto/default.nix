{ self, user, ... }:
let owner = user;
in {
  age = {
    secrets = {
      deustopasswd = {
        inherit owner;
        rekeyFile = "${self}/secrets/deustopasswd.age";
      };

      "dspace.pem" = {
        inherit owner;
        rekeyFile = "${self}/secrets/dspace.pem.age";
      };

      "dspace.host" = {
        inherit owner;
        rekeyFile = "${self}/secrets/dspace.host.age";
      };
    };
  };
}
