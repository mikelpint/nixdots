# https://github.com/musnix/musnix/blob/d56a15f30329f304151e4e05fa82264d127da934/pkgs/rtcqs.nix

{
  python3Packages,

  ...
}:
with python3Packages;
buildPythonApplication rec {
  pname = "rtcqs";
  version = "0.6.7";
  format = "pyproject";

  pythonRuntimeDepsCheckHook = "true";

  buildInputs = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "hWGyekVJFWP7R+D80m+7oqXTJB/eElJpICytTJpoC84=";
  };
}
