let
  pkgs = import <nixpkgs> {};
	spleeter = with pkgs.python3Packages; buildPythonPackage rec {
		pname = "spleeter";
		version = "2.4.0";
    format = "wheel";
		src = fetchPypi {
			inherit pname version format;
			sha256 = "3647c71783d2dfe64430544498a854b8b6348e7054d353cb03a583c0d8b718a8";
      dist = python;
      python = "py3";
		};
	};
in pkgs.mkShell {
  
  buildInputs = [
    pkgs.python3
    pkgs.poetry
    spleeter
  ];
  shellHook = ''
  '';
}

