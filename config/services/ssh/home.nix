{ lib, ... }:
{
  programs = {
    ssh = {
      enable = true;

      forwardAgent = true;
      hashKnownHosts = true;

      extraConfig = ''
        Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
        AddKeysToAgent yes
      '';

      matchBlocks = {
        GitHub = {
          host = "github.com";
          extraOptions = {
            KexAlgorithms = lib.strings.concatStringsSep "," [
              "curve25519-sha256@libssh.org"
              "ecdh-sha2-nistp256"
              "ecdh-sha2-nistp384"
              "ecdh-sha2-nistp521"
            ];

            Ciphers = lib.strings.concatStringsSep "," [
              "chacha20-poly1305@openssh.com"
              "aes256-ctr"
              "aes192-ctr"
              "aes128-ctr"
              "aes256-cbc"
              "aes192-cbc"
              "aes128-cbc"
            ];

            MACs = lib.strings.concatStringsSep "," [
              "hmac-sha2-256"
              "hmac-sha2-512"
              "hmac-sha1"
            ];
          };
        };
      };
    };
  };

  home = {
    sessionVariables = {
      SSH_ASKPASS_REQUIRE = "never";
    };
  };
}
