<h1 align="center"> RedNixOS </h1> <div align="center"> <img src="assets/screenshot.png"><br>NixOS 'distro' for security enthusiasts</a><br> 

<img src="https://builtwithnix.org/badge.svg"> </div>

## What is this project
This aims to be more or less a Kali-like distro, but built around NixOS.
Made for security researchers, pentesters, red teamers and infosec enthusiasts.

## How to use it
Feel free to use this in one of these ways:
1. VM (for example for testing purpouses or as a playground)
2. Live (sometimes can replace Kali, but it's way cooler)
3. Baremetal (you must be quite crazy if you do so, but it works)

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

`nix build` 

> Note: by default it will build RedNixOS unstable with KDE

## FAQ

### 'Distro'?
Well, it's not literally distro as often defined in Linux world.
Consider this project rather a modification of existing NixOS (it literally is pre-configured NixOS).
Also can be considered as a better version of existing [RedNix](https://github.com/redcode-labs/RedNix) - NixOS container and nix-shells.
RedNix was used as a base idea-wise for RedNixOS, all the packages are the same.

Note that it was heavily influenced by other projects besides **RedNix**. One of the major contributors behind this idea was [nix-security-box](https://github.com/fabaff/nix-security-box) by [fabaff](https://github.com/fabaff/). Check it out as well.

Besides from that, 

### How often will you update the upstream?
I'll try to keep it updated as often as mainstream NixOS, using this as a chance to add some packages and bump the version numbers in here as well.

Currently available Kali packages for nixpkgs are constantly listed by the [nix-security-box website](https://fabaff.github.io/nix-security-box/), as well as [this issue](https://github.com/NixOS/nixpkgs/issues/81418) and [this website](https://jjjollyjim.github.io/arewehackersyet/index.html).

### Contributing

Feel free to add anything. From different packages, through cosmetic tweaks to usability features.
