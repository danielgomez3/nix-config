final: prev: {
  # Create hapless with patched dependencies
  hapless = prev.python3.pkgs.buildPythonPackage rec {
    pname = "hapless";
    version = "0.14.0";

    src = prev.fetchFromGitHub {
      owner = "bmwant";
      repo = "hapless";
      rev = "v${version}";
      hash = "sha256-ivTW9epMHMpS41LWE+hsAF/m3OC+oIXKuFhkJki4EAg=";
    };

    format = "pyproject";

    nativeBuildInputs = with prev.python3.pkgs; [
      setuptools
      poetry-core
    ];

    propagatedBuildInputs = with prev.python3.pkgs; [
      click
      django-environ
      humanize
      psutil
      rich
      structlog
      typing-extensions
    ];

    # Patch the version requirements in pyproject.toml
    prePatch = ''
      substituteInPlace pyproject.toml \
        --replace 'psutil = "^6.1.0"' 'psutil = ">=6.1.0"' \
        --replace 'rich = "^13.5.2"' 'rich = ">=13.5.2"' \
        --replace 'typing-extensions = "4.0.0"' 'typing-extensions = ">=4.0.0"'
    '';

    # Skip the runtime dependency check that's failing
    # pythonRuntimeDepsCheck = false;

    pythonImportsCheck = ["hapless"];

    meta = with prev.lib; {
      description = "A Linux CLI tool called hapless";
      homepage = "https://github.com/hapless/hapless";
      license = licenses.mit;
      maintainers = with maintainers; [];
      mainProgram = "hapless";
    };
  };
}
