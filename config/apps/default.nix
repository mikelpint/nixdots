{ lib, config, ... }:
{
  nixpkgs = {
    overlays = [
      (
        _final: prev:
        let
          ipv6 = config.networking.enableIPv6 or true;

          pyOverrides = _python-final: python-prev: {
            mss = python-prev.mss.overrideAttrs (_oldAttrs: {
              doCheck = false;
              doInstallCheck = false;
              dontUsePytestCheck = "please dont";
            });

            twisted = python-prev.twisted.overrideAttrs (_oldAttrs: {
              doCheck = ipv6;
              doInstallCheck = ipv6;
              dontUsePytestCheck = lib.optionalString (!ipv6) "please dont";
            });

            aiohttp = python-prev.aiohttp.overrideAttrs (oldAttrs: {
              disabledTests =
                (oldAttrs.disabledTests or [ ])
                ++ (lib.optionals (true || ipv6) [
                  "test_tcp_connector_happy_eyeballs"
                  "test_tcp_connector_happy_eyeballs[pyloop-0.1]"
                  "test_tcp_connector_happy_eyeballs[pyloop-0.25]"
                  "test_tcp_connector_happy_eyeballs[pyloop-None]"

                  "test_tcp_connector_interleave"
                  "test_tcp_connector_interleave[pyloop]"

                  "test_test_server_hostnames"
                  "test_test_server_hostnames[::1-::1]"
                ]);
            });

            urwid = python-prev.urwid.overrideAttrs (oldAttrs: {
              disabledTests = (oldAttrs.disabledTests or [ ]) ++ [
                "TornadoEventLoopTest"
              ];
            });
          };
        in
        {
          pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [ pyOverrides ];
          python313 = prev.python313.override { packageOverrides = pyOverrides; };

          thrift = prev.thrift.overrideAttrs (oldAttrs: {
            prePatch =
              (oldAttrs.prePatch or "")
              + (lib.optionalString (!ipv6) ''
                rm test/py/RunClientServer.py
              '');

            preCheck =
              (oldAttrs.preCheck or "")
              + (lib.optionalString (!ipv6) ''
                rm test/py/RunClientServer.py
              '');
          });
        }
      )
    ];
  };
}
