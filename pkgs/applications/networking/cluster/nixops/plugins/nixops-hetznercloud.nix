{ lib
, buildPythonPackage
, fetchFromGitHub
, unstableGitUpdater
, poetry-core
, hcloud
, nixops
, typing-extensions
}:

buildPythonPackage {
  pname = "nixops-hetznercloud";
  version = "unstable-2023-02-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shyblower";
    repo = "nixops-hetznercloud";
    rev = "2cbdd7234d40e1f937b264ed053a4f9df06963c";
    hash = "sha256-rH1icbjvDGtQkbrcfepstyvUhFEMtxqjSNJKQH8RUl8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    nixops
  ];

  propagatedBuildInputs = [
    hcloud
    typing-extensions
  ];

  pythonImportsCheck = [ "nixops_hetznercloud" ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "A NixOps plugin supporting Hetzner Cloud deployments";
    homepage = "https://github.com/lukebfox/nixops-hetznercloud";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ lukebfox ];
  };
}
