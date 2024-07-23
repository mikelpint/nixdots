{ inputs, ... }:
{
  environment = {
    systemPackages = [ inputs.manix ];
  };
}
