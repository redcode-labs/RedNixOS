{
  description = "RedNixOS - a NixOS flavor for offensive-security work; drop-in module, ISO, and WSL tarball.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rednix = {
      url = "github:redcode-labs/RedNix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate Nix for the shipped images (see profiles/determinate.nix).
    # Taken from GitHub rather than FlakeHub so the top-level input needs no
    # FlakeHub resolution; its own `nix` input still points at FlakeHub, which
    # is where that source lives
    determinate.url = "github:DeterminateSystems/determinate";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # reference content for the datasets module. `flake = false` so we get
    # the raw repository tree as a store path; the datasets module symlinks
    # it under /usr/share to match Kali's layout
    payloadsallthethings = {
      url = "github:swisskyrepo/PayloadsAllTheThings";
      flake = false;
    };

    webshells = {
      url = "github:Red-Flake/webshells";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    rednix,
    nur,
    nix-alien,
    treefmt-nix,
    payloadsallthethings,
    webshells,
    ...
  }: let
    isoSystems = ["x86_64-linux" "aarch64-linux"];
    wslSystems = ["x86_64-linux" "aarch64-linux"];

    # artifacts are Linux-only, but the formatter has to work wherever
    # development happens
    devSystems = isoSystems ++ ["aarch64-darwin"];

    # rednix exposes two per-system shapes:
    #   - packages.${system}           - flat attrset keyed by pname
    #   - packagesByCategory.${system} - { category = [drv...]; }
    # Modules consume them via `_module.args.{rednix-pkgs,rednix-by-category}`
    # so external drop-in users get the same plumbing for free - no need to
    # forward `inputs.rednix` themselves.
    rednixArgs = _: {
      _module.args = {
        rednix-pkgs = rednix.packages;
        rednix-by-category = rednix.packagesByCategory or {};

        # Source-path inputs the datasets/compat modules consume. We plumb
        # them through `_module.args` so drop-in users importing
        # `nixosModules.datasets` don't have to forward our flake inputs
        # themselves - the lock pin embedded in this flake's flake.lock
        # is what gets used.
        rednixos-sources = {
          inherit payloadsallthethings webshells;
        };
        rednixos-extras = {
          nix-alien = nix-alien.packages;
          nurOverlay = nur.overlays.default;
        };
      };
    };

    wrap = path: {...}: {
      imports = [
        rednixArgs
        path
      ];
    };

    mkSystem = system: extraModules:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs self;};
        modules =
          [
            rednixArgs
            ./modules
          ]
          ++ extraModules;
      };

    forSystems = systems: f: nixpkgs.lib.genAttrs systems f;
  in {
    nixosModules = {
      default = wrap ./modules;
      full = wrap ./modules/presets/full.nix;
      minimal = wrap ./modules/presets/minimal.nix;

      tools = wrap ./modules/tools.nix;
      branding = wrap ./modules/branding.nix;
      hardening = wrap ./modules/hardening.nix;
      networking = wrap ./modules/networking.nix;
      graphical = wrap ./modules/graphical.nix;
      theme = wrap ./modules/theme.nix;
      installerUser = wrap ./modules/installer-user.nix;
      nixConfig = wrap ./modules/nix-config.nix;
      datasets = wrap ./modules/datasets.nix;
      compat = wrap ./modules/compat.nix;
      sysctl = wrap ./modules/sysctl.nix;
      nur = wrap ./modules/nur.nix;
      services = wrap ./modules/services;
    };

    nixosConfigurations = let
      iso = system:
        nixpkgs.lib.nameValuePair "RedNixOS-${system}" (mkSystem system [./profiles/iso.nix]);
      isoLight = system:
        nixpkgs.lib.nameValuePair "RedNixOS-light-${system}" (mkSystem system [./profiles/iso-light.nix]);
      isoHeadless = system:
        nixpkgs.lib.nameValuePair "RedNixOS-headless-${system}" (mkSystem system [./profiles/iso-headless.nix]);
      wsl = system:
        nixpkgs.lib.nameValuePair "RedNixOS-wsl-${system}" (mkSystem system [./profiles/wsl.nix]);
      wslLight = system:
        nixpkgs.lib.nameValuePair "RedNixOS-wsl-light-${system}" (mkSystem system [./profiles/wsl-light.nix]);
      # Eval coverage for the opt-in modules no real profile enables.
      allModules = system:
        nixpkgs.lib.nameValuePair "RedNixOS-all-${system}" (mkSystem system [./profiles/all-modules.nix]);
    in
      builtins.listToAttrs (
        (map iso isoSystems)
        ++ (map isoLight isoSystems)
        ++ (map isoHeadless isoSystems)
        ++ (map wsl wslSystems)
        ++ (map wslLight wslSystems)
        ++ (map allModules isoSystems)
      );

    formatter = forSystems devSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.alejandra.enable = true;
        programs.deadnix.enable = true;
        programs.statix.enable = true;
      };
    in
      treefmtEval.config.build.wrapper);

    checks = forSystems isoSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.alejandra.enable = true;
        programs.deadnix.enable = true;
        programs.statix.enable = true;
      };
    in {
      formatting = treefmtEval.config.build.check self;

      # VM test. `nix flake check --no-build` only evaluates it; building it
      # runs a real guest and needs KVM, so CI builds it in a dedicated job.
      invariants = import ./tests/invariants.nix {inherit self pkgs;};
    });

    # No devShells: `nix fmt` already runs alejandra + deadnix + statix, and
    # the tool environments live in rednix (`nix develop rednix#<category>`),
    # so a shell here would only have duplicated the formatter.

    packages = forSystems isoSystems (system: let
      isoFor = name: self.nixosConfigurations.${name}.config.system.build.isoImage;
      tarballFor = name: self.nixosConfigurations.${name}.config.system.build.tarballBuilder;
    in
      {
        iso = isoFor "RedNixOS-${system}";
        iso-light = isoFor "RedNixOS-light-${system}";
        iso-headless = isoFor "RedNixOS-headless-${system}";

        wsl = tarballFor "RedNixOS-wsl-${system}";
        wsl-light = tarballFor "RedNixOS-wsl-light-${system}";

        default = isoFor "RedNixOS-${system}";
      }
      // {
        # Back-compat aliases for the previous flake output names.
        RedNixOS = isoFor "RedNixOS-${system}";
        RedNixOS-light = isoFor "RedNixOS-light-${system}";
        RedNixOS-headless = isoFor "RedNixOS-headless-${system}";
      });
  };
}
