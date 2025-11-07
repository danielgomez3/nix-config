# hapless.nix
{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "hapless";
  version = "0.14.0"; # Use the actual version from the GitHub repo

  src = fetchFromGitHub {
    owner = "bmwant"; # Replace with actual GitHub owner/organization
    repo = "hapless"; # Replace with actual repository name
    rev = "v${version}"; # or "main", "master", or a specific commit hash
    hash = "sha256-ivTW9epMHMpS41LWE+hsAF/m3OC+oIXKuFhkJki4EAg="; # You'll need to update this
  };

  # Common Python packaging formats - choose based on the project:
  format = "pyproject"; # if it has pyproject.toml
  # format = "setuptools";  # if it has setup.py
  # format = "flit";        # if it uses flit
  # format = "poetry";      # if it uses poetry

  # If the project uses pyproject.toml with setuptools:
  nativeBuildInputs = with python3.pkgs; [
    setuptools
    poetry-core
    # pip
    # wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    # Add dependencies from the project's:
    # - setup.py
    # - requirements.txt
    # - pyproject.toml

    # Example common dependencies:
    click
    django-environ
    humanize
    psutil
    rich
    structlog
    typing-extensions
    psutil
    # requests
    # typer
    # rich
  ];

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace 'psutil = "^6.1.0"' 'psutil = ">=6.1.0"' \
      --replace 'rich = "^13.5.2"' 'rich = ">=13.5.2"' \
      --replace 'typing-extensions = "4.0.0"' 'typing-extensions = ">=4.0.0"'
  '';

  # Optional: If the project has tests you want to run
  # nativeCheckInputs = with python3.pkgs; [
  #   pytest
  # ];

  # Optional: Run tests during build
  # doCheck = true;

  pythonImportsCheck = ["hapless"];

  meta = with lib; {
    description = "A Linux CLI tool called hapless";
    homepage = "https://github.com/hapless/hapless"; # Update with actual URL
    license = licenses.mit; # Adjust based on actual license
    maintainers = with maintainers; [];
    mainProgram = "hapless";
  };
}
