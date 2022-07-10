{ pkgs, fetchFromGitHub, ... }:

{
  environment.systemPackages = with pkgs; [

    # General
    chrony
    clamav
    curl
    flashrom
    htop
    httpie
    i2pd
    inetutils
    inxi
    iproute
    iproute2
    iw
    lynx
    macchanger
    ngrok
    vim
    parted
    pwgen
    utillinux
    wget
    coreutils
    killall
    usbutils
    ntfs3g
    ripgrep
    ripgrep-all
    ranger
    file
    tor
    torsocks

    # Misc
    badchars
    deepsea
    honeytrap
    pwntools

    # Mobile
    abootimg
    apktool
    dex2jar
    genymotion
    python39Packages.androguard
    simg2img

    # Hardware
    arduino
    cantoolz
    chipsec
    esptool
    hachoir
    python3Packages.angr
    python3Packages.angrop
    python3Packages.can
    python3Packages.pyi2cflash
    python3Packages.pyspiflash

    # Protocols
    cifs-utils
    freerdp
    mosh
    net-snmp
    nfs-utils
    ntp
    openssh
    openvpn
    samba
    # tightvnc
    wireguard-go
    wireguard-tools
    xrdp

    # Network
    netkittftp
    atftp
    evillimiter
    iperf2
    lftp
    mtr
    # ncat
    ncftp
    netcat-gnu
    nload
    # nuttcp `error: The store path /nix/store/y5cd1rxjjz8z0c5gjjwijcbqn9yrd6ql-nuttcp.8 is a file and can't be merged into an environment using pkgs.buildEnv! at /nix/store/87sn6m7rzz9y3z64j8bbbkfzkabm4774-builder.pl line 122.`
    putty
    pwnat
    sshping
    sslh
    wbox
    whois
    ipcalc
    netmask

    # Port scanners
    arp-scan
    ipscan
    masscan
    naabu
    nmap
    # nmap-graphical `error: nmap graphical support has been removed due to its python2 dependency`
    rustscan
    zmap

    # Packet generators
    gping
    fping
    hping
    ostinato
    pktgen
    python39Packages.scapy

    # Vul. analysis
    checksec
    chkrootkit
    lynis
    vulnix

    # SSL-TLS
    # cipherscan `error: cipherscan was removed from nixpkgs, as it was unmaintained`
    ssldump
    sslsplit
    # sslyze - was on 21.11, but no more since 22.05 :')
    testssl

    # Traffic
    anevicon
    dhcpdump
    dnstop
    driftnet
    dsniff
    goreplay
    httpdump
    junkie
    netsniff-ng
    ngrep
    sniffglue
    tcpdump
    tcpflow
    tcpreplay
    termshark
    tshark
    wireshark
    wireshark-cli
    zeek

    # Tunnels
    corkscrew
    hans
    chisel
    httptunnel
    iodine
    # proxytunnel `error: proxytunnel has been removed from nixpkgs, because it has not been update upstream since it was added to nixpkgs in 2008 and has therefore bitrotted.`
    sish
    stunnel
    udptunnel
    wstunnel

    # VOIP
    sipp
    sipsak
    sipvicious

    # Wireless
    aircrack-ng
    bully
    cowpatty
    horst
    kismet
    pixiewps
    # pyrit `error: pyrit has been removed from nixpkgs as the project is still stuck on python2`
    reaverwps
    reaverwps-t6x
    wavemon
    wifite2
    util-linux
    gqrx
    kalibrate-hackrf
    kalibrate-rtl
    multimon-ng

    # Information gathering
    sn0int
    p0f
    theharvester
    urlhunter
    cloudbrute
    ntopng

    # Reverse engineering
    bingrep
    gdb
    ghidra-bin
    mono
    pev
    pwndbg
    python39Packages.binwalk
    python39Packages.binwalk-full
    python39Packages.unicorn
    python310Packages.r2pipe
    radare2
    radare2-cutter
    unicorn
    unicorn-emu
    volatility3
    xortool
    yara
    zydis
    jd-gui
    valgrind

    # Terminals
    cutecom
    minicom
    picocom
    socat
    x3270
    tmate

    # Terminal multiplexer
    screen
    tmux

    # Archive tools
    cabextract
    p7zip
    unrar
    unzip

    # Fuzzers
    afl
    aflplusplus
    ffuf
    honggfuzz
    radamsa
    ssdeep
    wfuzz
    zzuf
    spike

    # Forensics
    afflib
    dcfldd
    ddrescue
    ddrescueview
    dislocker
    python310Packages.distorm3
    exiv2
    ext4magic
    extundelete
    foremost
    gzrt
    hivex
    ntfs3g
    ntfsprogs
    nwipe
    recoverjpeg
    safecopy
    sleuthkit
    srm
    stegseek
    testdisk
    wipe
    xorex
    capstone
    pdf-parser

    # DNS
    aiodnsbrute
    amass
    bind
    dnsenum
    dnsrecon
    dnstracer
    dnstwist
    dnsx
    fierce
    findomain
    knockpy
    subfinder

    # Smartcards
    cardpeek
    libfreefare
    mfcuk
    mfoc

    # Bluetooth
    bluez
    python39Packages.bleak

    # Passwords
    badtouch
    bruteforce-luks
    brutespray
    crunch
    hashcat
    hashcat-utils
    hashdeep
    john
    medusa
    nasty
    ncrack
    phrasendrescher
    python38Packages.patator
    thc-hydra
    chntpw
    crowbar
    hcxtools

    # Reporting
    cherrytree
    dos2unix

    # Services
    enum4linux
    enum4linux-ng
    ike-scan
    python39Packages.ldapdomaindump
    ldeep
    metasploit
    nikto
    nuclei
    onesixtyone
    siege
    swaks
    traitor
    # wafw00f

    # Git
    gitjacker
    trufflehog
    gitleaks
    shhgit
    secretscanner

    # *SQL
    sqlmap

    # Web, HTTP, proxies
    monsoon
    galer
    gau
    # corsmisc `error: corsmisc has been removed (upstream is gone)`
    # bypass403 `error: bypass403 has been removed: deleted by upstream`
    subjs
    photon
    ntlmrecon
    wad
    httpx
    snallygaster
    hakrawler
    wuzz
    uddup
    # sigurlx `error: sigurlx has been removed (upstream is gone)`
    gospider
    wprecon
    wpscan
    bettercap
    burpsuite
    ettercap
    mitmproxy
    proxify
    proxychains
    redsocks
    rshijack
    zap
    dirb
    gobuster

    # SNMP
    onesixtyone

    # SSH
    sshchecker
    ssh-audit
    ssb

    # IDS
    teler

    # Container, images
    clair
    dockle
    grype
    trivy
    fwanalyzer

    # Terraform
    terrascan
    tfsec

    # Kubernetes
    checkov
    kube-score

    # Windows
    python39Packages.pypykatz
    nbtscanner
  ];
}
