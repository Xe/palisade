{ system ? builtins.currentSystem }:

let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };
  palisade = import ./default.nix { };

  dockerImage = pkg:
    pkgs.dockerTools.buildLayeredImage {
      name = "lightspeedretail/palisade";
      tag = "${palisade.version}";

      contents = [ pkgs.cacert pkg ];

      config = {
        Cmd = [ "/bin/palisade" "cut" ];
        WorkingDir = "/";
      };
    };

in dockerImage palisade
