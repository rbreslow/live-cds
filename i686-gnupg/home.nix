{ pkgs, ... }:

{
  programs = {
    gpg = {
      enable = true;

      # It's worth surfacing that Riseup has deprecated their entire
      # OpenPGP Best Practices guide.
      # > [...] you only need to use the defaults because GnuPG is doing
      # sane things. Just keep your software up-to-date. That is it, you
      # are done!
      # https://riseup.net/en/security/message-security/openpgp/best-practices
      settings = {
        # GPG Configuration Options
        # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
        # http://web.archive.org/web/20191119005638/http://gwolf.org/node/4070
        keyid-format = "0xlong";
        list-options = "show-uid-validity show-unusable-uids show-unusable-subkeys show-sig-expire";
        verify-options = "show-uid-validity show-unusable-uids";

        # GPG Input and Output
        # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Input-and-Output.html
        with-fingerprint = true;

        # OpenPGP Options
        # https://www.gnupg.org/documentation/manuals/gnupg/OpenPGP-Options.html
        personal-cipher-preferences = "AES256";
        personal-digest-preferences = "SHA512";
        # https://crypto.stackexchange.com/questions/48906/what-exactly-does-s2k-do-in-gpg
        s2k-cipher-algo = "AES256";
        s2k-digest-algo = "SHA512";
        # The GPG agent will calibrate this value based on "a count
        # which requires by default 100ms to mangle a given passphrase."
        # Although you can change the default calibration time, it seems
        # to make more sense to set this value to the max.
        s2k-count = "65011712";
      };
    };

    home-manager = {
      enable = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    # The description of this option says that it's useful for GPG agent
    # forwarding.
    enableExtraSocket = true;
    # Enables the smartcard daemon (for working with YubiKeys, etc.).
    enableScDaemon = true;
    pinentryFlavor = "curses";
  };
}
