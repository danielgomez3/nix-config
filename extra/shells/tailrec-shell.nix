let
  pkgs = import <nixpkgs> {};
	tail_recursive = with pkgs.python3Packages; buildPythonPackage rec {
		pname = "tail-recursive";
		version = "2.1.0";
		src = fetchPypi {
			inherit pname version;
			sha256 = "b2cba5019202154d5d4a9b1afb0f7317e760052750c30de0289cc0bea104daa6";
		};
		doCheck = false;
	};
in pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    pkgs.python3.pkgs.requests
    pkgs.python3.pkgs.flask
    pkgs.python3.pkgs.nltk
    pkgs.python3.pkgs.transformers
    pkgs.python3.pkgs.werkzeug
    pkgs.python3.pkgs.python-docx
    pkgs.python3.pkgs.openai-whisper
    pkgs.python3.pkgs.librosa
    tail_recursive
  ];
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
    ]}
  '';
}
