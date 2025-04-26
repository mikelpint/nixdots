{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ redisinsight ];
  };
}
