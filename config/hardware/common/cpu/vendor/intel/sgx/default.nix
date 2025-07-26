{ lib, ... }:
{
  hardware = {
    cpu = {
      intel = {
        sgx = {
          enableDcapCompat = lib.mkDefault true;

          provision = {
            enable = lib.mkDefault true;

            user = "root";
            group = "sgx";
            mode = "0660";
          };
        };
      };
    };
  };
}
