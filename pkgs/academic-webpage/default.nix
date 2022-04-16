{ pkgs, stdenvNoCC, fetchFromGitHub, ... }:

let wowchemy-module = name: stdenvNoCC.mkDerivation {
      inherit name;
      version = "v5.5.0";
      src = fetchFromGitHub {
        owner = "wowchemy";
        repo = "wowchemy-hugo-themes";
        rev = "3f178a06f49582758671432d3ff8298f5d65244f";
        sha256 = "2+Pf8cBS/QEbsIjbk1VSG+OUqxHYKK7/kLajNoHvN1k=";
      };
      installPhase = ''
        cp -r $src/"${name}" $out
      '';
      preferLocalBuild = true;
    };
    wowchemy = wowchemy-module "wowchemy";
    wowchemy-cms = wowchemy-module "wowchemy-cms";

in stdenvNoCC.mkDerivation rec {
  pname = "academic-webpage";
  version = "latest";

  buildInputs = with pkgs; [ hugo wowchemy wowchemy-cms ];

  src = fetchFromGitHub {
    owner = "qaristote";
    repo = "academic-webpage";
    rev = "bc012418ac3621a7292bce834d2efb837281bb15";
    sha256 = "dCfTxHz98V7QOnYCP2f1QT/4UDgnUq4HnShY+q6eYxY=";
  };

  patchPhase = ''
    sed -i -e "s/github.com\/wowchemy\/wowchemy-hugo-modules\/\(wowchemy[-a-z]*\)\/v5/\1/g" config/_default/config.yaml
    mkdir -p themes
    ln -sf "${wowchemy}" themes/wowchemy
    ln -sf "${wowchemy-cms}" themes/wowchemy-cms
  '';

  installPhase = ''
    hugo --destination $out
  '';
}
