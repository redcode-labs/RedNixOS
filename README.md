<h1 align="center"> RedNixOS </h1> <div align="center"> <img src="assets/logoTransparentBg.png" width="333"><br>NixOS 'distro' for security enthusiasts</a><br> <img src="https://builtwithnix.org/badge.svg"> </div>

## What is this project
This aims to be more or less a Kali-like distro, but built around NixOS.
Made for security researchers, pentesters, red teamers and infosec enthusiasts.

## How to use it
Feel free to use this in one of these ways:
1. VM (for example for testing purpouses)
2. Live (sometimes can replace Kali)
3. Baremetal (you must be quite crazy if you do so)

## Features
Basically it's already done NixOS config and all you have to do would be to build the `.iso` file yourself.
That means, there's quite a lot of software which comes preinstalled, as defined in `packages.nix` file.
Feel free to modify this according to your needs.

By default, it will use Zen kernel (better performance in my opinion), as well as have certain networking and security features predefined, which include
* `sudo` only for `wheel` group
* AppArmor enabled
* `lockKernelModules` enabled
* simple firewall config

## How to build it
That's quit easy. Once you have files modified according to your needs or you've decided that `yolo I'm trying the default one`, just use this command:

`nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=rednixos-iso-[stable/unstable].nix` 

(choose stable or unstable according to your needs).

## How often will you update the upstream
I'll try to keep it updated as often as mainstream NixOS, using this as a chance to add some packages and bump the version numbers in here as well.