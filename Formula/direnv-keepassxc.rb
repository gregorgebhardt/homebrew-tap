class DirenvKeepassxc < Formula
  desc "Load secrets from KeePassXC into direnv environments"
  homepage "https://github.com/gregorgebhardt/direnv-keepassxc"
  url "https://github.com/gregorgebhardt/direnv-keepassxc/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "6227bbbe1ca682ec1509b39fcb82f1ce368567a6ac2fa9d4b65185c69b6b4470"
  license "MIT"

  depends_on :macos

  def install
    pkgshare.install "keepass.sh"
    libexec.install "install.sh"
    bin.install "bin/keepass-forget"
    (bin/"direnv-keepassxc-setup").write_env_script libexec/"install.sh", DIRENV_KEEPASSXC_FROM: opt_pkgshare
  end

  def caveats
    <<~EOS
      Run this once, so direnv loads use_keepass and knows your database:
        direnv-keepassxc-setup

      Before brew uninstall, remove the link again:
        direnv-keepassxc-setup --uninstall

      use_keepass also needs direnv and KeePassXC.
    EOS
  end

  test do
    ENV["XDG_CONFIG_HOME"] = (testpath/".config").to_s
    ENV.delete "DIRENV_CONFIG"
    system bin/"direnv-keepassxc-setup", "--database", testpath/"Passwords.kdbx"
    assert_equal opt_pkgshare/"keepass.sh", (testpath/".config/direnv/lib/keepass.sh").readlink
    assert_match "KEEPASS_DATABASE=", (testpath/".config/direnv/direnvrc").read
    system "bash", "-n", pkgshare/"keepass.sh"
    system "bash", "-n", bin/"keepass-forget"
  end
end
