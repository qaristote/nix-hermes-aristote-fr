{ pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "academic-webpage";
  version = "2021-08-14";

  buildInputs = with pkgs; [ hugo ];

  src = pkgs.fetchFromGitHub {
    owner = "qaristote";
    repo = "academic-webpage";
    rev = "e7854e58aada223bdf5e01acb23e2b015abd2149";
    sha256 = "nd8CgcY7f7kJD2txFSum7W2/qxamEO6nZ5f8SS5U10E=";
  };

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    hugo --destination $out
  '';
}
