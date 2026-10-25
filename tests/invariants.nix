#  asserts run0-instead-of-sudo, dataset placement,
#  tool filtering, and the installer user staying off
#  for drop-in users
#
#  imports `self.nixosModules.default`
{
  self,
  pkgs,
}:
pkgs.testers.runNixOSTest {
  name = "rednixos-invariants";

  nodes.machine = {
    imports = [self.nixosModules.default];

    services.rednixos = {
      hardening.enable = true;

      # webshells is the smallest dataset
      datasets.webshells.enable = true;

      tools = {
        enable = true;
        packages = ["nmap"];
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("escalation is run0-backed, with no setuid sudo on disk"):
        machine.succeed("command -v run0")
        machine.wait_for_unit("polkit.service")

        # `sudo` must exist, because tooling and writeups invoke it...
        machine.succeed("command -v sudo")
        # ...but as the run0 shim, not NixOS's setuid sudo wrapper.
        machine.fail("test -e /run/wrappers/bin/sudo")
        machine.fail("test -u $(readlink -f $(command -v sudo))")

    with subtest("sshd starts and refuses password authentication"):
        # The unit reaching active proves sshd parsed and accepted the
        # generated config - a stronger signal than inspecting it. Don't use
        # `sshd -T | grep -q`: grep is last in the pipe, so a failing sshd is
        # indistinguishable from a non-matching pattern, and it exits 1 either
        # way. Assert on the config text and echo it on failure instead.
        machine.wait_for_unit("sshd.service")

        sshd_config = machine.succeed("cat /etc/ssh/sshd_config")
        for expected in [
            "PasswordAuthentication no",
            "KbdInteractiveAuthentication no",
            "AuthenticationMethods publickey",
            "X11Forwarding yes",
        ]:
            assert expected in sshd_config, (
                f"missing {expected!r} in sshd_config:\n{sshd_config}"
            )

    with subtest("datasets land under the Kali-convention path"):
        machine.succeed("test -L /usr/share/webshells")
        machine.succeed("readlink /usr/share/webshells | grep -q '^/nix/store/'")

    with subtest("tools.packages selects rather than installing all of rednix"):
        machine.succeed("command -v nmap")
        machine.fail("command -v amass")

    with subtest("the installer user never exists on a drop-in install"):
        machine.fail("id red")
  '';
}
