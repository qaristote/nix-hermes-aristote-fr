{ pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "academic-webpage";
  version = "2021-08-14";

  buildInputs = with pkgs; [ hugo ];

  src = pkgs.fetchFromGitHub {
    owner = "qaristote";
    repo = "academic-webpage";
    rev = "1ee3b3878082a0c8fc5c72641d20ead89b01e8f3";
    sha256 = "PDliiJNLnauVyEdssnhYReXZTunlmv6KNCgVNf6U+os=";
    fetchSubmodules = true;
  };

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    hugo --destination $out
  '';
}
