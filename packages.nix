{ pkgs, fetchFromGitHub, ... }:

{
  environment.systemPackages = with pkgs; [

    # sorry if anything's duplicated
    # feel free to PR to make this file less 'messy'
    # as well as add other packages

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
    xh

    # Host
    checksec
    chkrootkit
    lynis
    safety-cli
    tracee
    vulnix

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

    # Mobile
    abootimg
    androguard
    apkeep
    apkleaks
    apktool
    dex2jar
    genymotion
    ghost
    simg2img
    trueseeing

    # Hardware
    arduino
    cantoolz
    chipsec
    esptool
    extrude
    hachoir
    # nrfutil
    tytools
    python3Packages.angr
    python3Packages.angrop
    python3Packages.can
    python3Packages.pyi2cflash
    python3Packages.pyspiflash
    routersploit

    # Protocols
    cifs-utils
    freerdp
    net-snmp
    nfs-utils
    ntp
    openssh
    openvpn
    samba
    step-cli
    tightvnc
    wireguard-go
    wireguard-tools
    xrdp

    # load testing
    drill
    cassowary
    ddosify
    siege
    tsung
    vegeta

    # Network
    arping
    atftp
    bandwhich
    crackmapexec
    evillimiter
    iperf2
    lftp
    mtr
    ncftp
    netcat-gnu
    netdiscover
    nload
    # nuttcp
    p0f
    putty
    pwnat
    rustcat
    sshping
    sslh
    wbox
    whois
    yersinia
    ipcalc
    netmask

    # Port scanners
    arp-scan
    ipscan
    masscan
    naabu
    nmap
    sx-go
    rustscan
    zmap

    # Packet generators
    boofuzz
    gping
    fping
    hping
    ostinato
    pktgen
    python3Packages.scapy

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
    secrets-extractor
    sniffglue
    tcpdump
    tcpflow
    tcpreplay
    termshark
    wireshark
    wireshark-cli
    zeek

    # Tunnels
    bore-cli
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
    sngrep

    # Wireless
    aircrack-ng
    airgeddon
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
    # maigret
    metabigor
    sn0int
    p0f
    theharvester
    urlhunter
    cloudbrute
    ntopng
    urlhunter

    # Reverse engineering
    bingrep
    cutter
    # flare-floss
    gdb
    ghidra-bin
    mono
    pev
    pwndbg
    python3Packages.binwalk
    python3Packages.binwalk-full
    python3Packages.malduck
    python3Packages.karton-core
    python3Packages.unicorn
    python3Packages.r2pipe
    radare2
    radare2-cutter
    rizin
    stacks
    unicorn
    unicorn-emu
    volatility3
    xortool
    yara
    zkar
    zydis
    jd-gui
    valgrind

    # Fuzzers
    afl
    aflplusplus
    feroxbuster
    ffuf
    honggfuzz
    radamsa
    regexploit
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
    gef
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
    dnsmon-go
    dnsmonster
    dnsrecon
    dnstake
    dnstracer
    dnstwist
    dnsx
    fierce
    findomain
    knockpy
    subfinder
    subzerod

    # Smartcards
    cardpeek
    libfreefare
    mfcuk
    mfoc
    python3Packages.emv

    # Bluetooth
    bluez
    python39Packages.bleak
    bluewalker
    # pc-ble-driver
    # python39Packages.pc-ble-driver-py
    redfang
    ubertooth

    # Passwords
    badtouch
    authoscope
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
    nth
    phrasendrescher
    # python3Packages.patator
    thc-hydra
    truecrack
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
    ldeep
    nikto
    onesixtyone
    checkip
    ike-scan
    metasploit
    nuclei
    traitor

    # E-Mail
    swaks

    # Databases
    mongoaudit
    sqlmap

    # SNMP
    onesixtyone
    snmpcheck

    # SSH
    sshchecker
    ssh-audit
    ssh-mitm
    ssb

    # IDS/IPS/WAF
    teler
    waf-tester
    # wafw00f

    # CI
    oshka

    # Terraform
    terrascan
    tfsec

    # Kubernetes
    cfripper
    checkov
    kdigger
    kube-score
    kubeaudit
    kubescape

    # Supply chain
    chain-bench
    witness

    # ldap
    python39Packages.ldapdomaindump
    adenum
    ldapmonitor
    ldeep

    # Git & code
    gitjacker
    trufflehog
    gitleaks
    shhgit
    git-secret
    gitleaks
    gitls
    secretscanner
    cargo-audit
    credential-detector
    detect-secrets
    gokart
    osv-detector
    pip-audit
    python310Packages.safety
    skjold
    whispers

    # *SQL
    sqlmap

    # Web, HTTP, proxies
    brakeman
    cameradar
    cariddi
    chopchop
    commix
    corsair
    python3Packages.corsair-scan
    crlfsuite
    dalfox
    dismap
    dontgo403
    galer
    gau
    gospider
    gotestwaf
    gowitness
    graphqlmap
    graphw00f
    hakrawler
    hey
    httpx
    # nodePackages_latest.hyperpotamus
    jaeles
    jsubfinder
    jwt-hack
    kiterunner
    mitmproxy2swagger
    monsoon
    nikto
    ntlmrecon
    photon
    slowlorust
    snallygaster
    subjs
    swaggerhole
    uddup
    wad
    webanalyze
    whatweb
    wprecon
    wpscan
    wuzz
    bettercap
    burpsuite
    ettercap
    mitmproxy
    mubeng
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
    cdk-go
    clair
    cliam
    cloudlist
    dive
    dockle
    grype
    trivy
    fwanalyzer

    # Windows
    adreaper
    certipy
    enum4linux
    enum4linux-ng
    erosmb
    evil-winrm
    go365
    gomapenum
    kerbrute
    nbtscanner
    offensive-azure
    python3Packages.pypykatz
    smbscan

    # Misc
    badchars
    changetower
    deepsea
    doona
    honeytrap
    jwt-cli
    nmap-formatter
    pwntools
    python3Packages.pytenable
  ];
}
