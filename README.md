<h1 align="center"> RedNixOS </h1> <div align="center"> <img src="assets/logoTransparentBg.png"><br>NixOS 'distro' for security enthusiasts</a><br> 

</div>
<br>

---
<br>

## About 

RedNixOS wraps the [RedNix](https://github.com/redcode-labs/RedNix) tool collection into a NixOS flavor. 

It ships in three shapes:

| Shape | What it is |
| --- | --- |
| **Live ISO** | A bootable live environment with the tools, hardening and theming. **Not an installer for RedNixOS** - see below. |
| **WSL image** | An importable `.wsl` tarball that *is* RedNixOS, and stays RedNixOS across rebuilds. |
| **Drop-in module** | Flake modules you import into an existing NixOS config. This is how you get RedNixOS onto a real machine/existing NixOS installation. |

Every shape is built from the same `modules/` tree, so the tool set and the security posture are identical across them.

### The ISO is a live environment, **NOT** an installer

The ISO boots into a full RedNixOS: all of rednix's tooling, `run0`-based escalation, the datasets, the theme, all the goodies in one place.

If you then run the graphical installer, **what gets installed is ordinary NixOS, not RedNixOS.**.
Calamares writes its own `configuration.nix` from a fixed template whose only import is `./hardware-configuration.nix`; nothing in it refers to this flake (RedNixOS).
You will reboot into stock NixOS with the desktop and user you picked in the installer, and **none** of the tooling.

Treat the ISO as a live/triage environment - boot it, work, shut down - and, if needed, adopt RedNixOS on a persistent machine through the module below. If you *did* install from the ISO, the next section is also how you turn that install into RedNixOS.

### Adding RedNixOS to an existing NixOS install

Add the flake as an input and import the granularity you want:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rednixos = {
      url = "github:redcode-labs/RedNixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, rednixos, ... }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        rednixos.nixosModules.default          # adds the options, enables nothing
        { services.rednixos.tools.enable = true; }
      ];
    };
  };
}
```

Then `sudo nixos-rebuild switch --flake .#my-host`.

Pin a release rather than tracking the branch if you want reproducibility:
`url = "github:redcode-labs/RedNixOS/v1.0.0";`

### Module pre-sets

| Module | Effect |
| --- | --- |
| `nixosModules.default` | Adds every `services.rednixos.*` option and turns **nothing** on. Safe to import blind. |
| `nixosModules.minimal` | Enables `tools`, `hardening`, `nix-config`. |
| `nixosModules.full` | `minimal` plus `networking`, `graphical`, `theme` (GNOME). |

Or cherry-pick a single concern: `tools`, `hardening`, `networking`, `graphical`, `theme`, `datasets`, `compat`, `sysctl`, `nur`, `nixConfig`, `services`, `installerUser`.

Importing a module never changes behaviour on its own, as each one is gated behind its own `enable`, so `nixosModules.default` plus nothing else is a no-op. Presets are the exception: they flip "enable" for you.

### Just the tools, nothing else

```nix
{
  imports = [ rednixos.nixosModules.tools ];
  services.rednixos.tools.enable = true;
}
```

That installs the whole collection (700+ packages). Narrow it by name or by rednix category. Both accept `null` (the default) to mean "everything", and combine as a union when both are set:

```nix
services.rednixos.tools = {
  enable = true;
  packages = [ "nmap" "ffuf" "sqlmap" ];
  categories = [ "web" "passwords" "info-gathering" ];
};
```

Available categories: `RCL`, `archive-tools`, `bluetooth`, `ci`, `cloud`, `containers`, `crypto`, `dns`, `email`, `exploits`, `forensics`, `fuzzers`, `general`, `git`, `hardware`, `ids`, `info-gathering`, `kubernetes`, `ldap`, `load-testing`, `misc`, `mobile`, `network`, `packet-generators`, `passwords`, `port-scanners`, `protocols`, `reporting`, `reverse-engineering`, `services`, `smartcards`, `snmp`, `sql`, `ssh`, `ssl-tls`, `supply-chain`, `terminals`, `terraform`, `traffic`, `tunnels`, `unported-shims`, `voip`, `vuln-analysis`, `web`, `windows`, `wireless`. 

Unknown names and categories are dropped silently.

### The full list of options

```nix
services.rednixos = {
  tools = { enable = false; packages = null; categories = null; };

  # sshd posture + run0-instead-of-sudo + auditd
  hardening = { enable = false; auditExecve = false; };

  networking = {
    enable = false;
    firewall.allowedTCPPorts = [ ];
  };

  graphical.enable = false;   # plymouth, pipewire, xserver baseline
  theme.enable = false;       # dark + red GNOME theming and wallpaper
  nix-config.enable = false;  # flakes, allowUnfree, allowInsecure

  # Kali-convention paths under /usr/share
  datasets = {
    wordlists.enable = false;   # SecLists        -> /usr/share/wordlists
    payloads.enable = false;    # PayloadsAllTheThings + ExploitDB
    webshells.enable = false;   # Red-Flake/webshells
  };

  # running foreign, non-Nix binaries
  compat = {
    fhs.enable = false;         # `rednixos-fhs` shim environment
    appimage.enable = false;    # AppImage execution via binfmt
    nix-alien.enable = false;   # resolve ELF deps on the fly
  };

  # pentest-friendly kernel knobs (unprivileged low ports, wider
  # ephemeral range, raised backlogs and inotify limits)
  sysctl = { enable = false; ipForward = false; looseRpFilter = false; };

  nur.enable = false;           # pkgs.nur.repos.<user>.<pkg>

  services = {
    neo4j.enable = false;
    bloodhound = { enable = false; autostartNeo4j = true; };
  };

  # the live `red` account - never enable this on a real install
  installerUser = {
    enable = false;
    name = "red";
    initialPassword = "rednixos";
    extraGroups = [ ];
  };
};
```

### Important to know:

- **`hardening.enable` removes `sudo`.** Escalation goes through `run0` (systemd 256+): no setuid binary, no shell-parser surface, polkit authenticates the invoker. A `sudo` command still exists and still works, as a shim backed by `run0`, so scripts and copy-pasted writeups are fine. If you want the real setuid sudo back, `security.run0.sudo-shim.enable = false;` and `security.sudo.enable = true;`
- **`hardening.enable` also enables `sshd`** with publickey-only authentication and no password auth. If you rely on password logins, set `services.openssh.settings.PasswordAuthentication = true;`
- **`theme.enable` turns on GNOME** and sets a dark-with-red look through the system dconf database. It sets defaults, not locks, so Settings can still change them
- **`installerUser` must stay off.** The password is published in this README
- **Determinate Nix and the RedNixOS hostname/branding are image-only.** They live in `profiles/`, not `modules/`, so importing these modules will never swap your Nix or rename your distro. If you want Determinate Nix (recommended) on your own machine, add [its own flake](https://github.com/DeterminateSystems/determinate) directly.

---

## Building the artifacts yourself

```sh
nix build .#iso                                 # graphical live ISO + tools
nix build .#iso-light                           # graphical, no tools
nix build .#iso-headless                        # tty, + tools

# the WSL targets are builder scripts, not derivations. They must run as
# root, the output path is positional, and its parent must exist
mkdir -p out
sudo nix run .#wsl       -- out/rednixos.wsl        # WSL image + tools
sudo nix run .#wsl-light -- out/rednixos-light.wsl  # WSL image, no tools
```

`.wsl` and `.tar.gz` are the same bytes; the extension only picks
`wsl --install --from-file` over `wsl --import <name> <dir> <file>`.

Importing a `.wsl` gives you a system where `/etc/nixos/flake.nix` already refers back to this flake, so `nixos-rebuild switch` keeps it RedNixOS instead of reverting to stock NixOS-WSL.

---

## Checks

```sh
nix flake check --no-build --all-systems        # evaluates every variant
nix fmt                                         # alejandra + deadnix + statix
nix build .#checks.x86_64-linux.invariants      # VM test; needs /dev/kvm
```

## License
Licensed under the [ISC License](./LICENSE), © 2022 Red Code Labs.