class DirenvKeepassxc < Formula
  desc "Load secrets from KeePassXC into direnv environments"
  homepage "https://github.com/gregorgebhardt/direnv-keepassxc"
  url "https://github.com/gregorgebhardt/direnv-keepassxc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "97d448276d1075e2d5693660a193f071287519d8d32866e0e7586eefcfed9e4d"
  license "MIT"

  depends_on :macos

  def install
    pkgshare.install "keepass.sh"
    bin.install "bin/keepass-forget"
  end

  def caveats
    <<~EOS
      To let direnv load use_keepass, link it into direnv's lib folder:
        mkdir -p ~/.config/direnv/lib
        ln -s #{opt_pkgshare}/keepass.sh ~/.config/direnv/lib/keepass.sh

      Then set your database in ~/.config/direnv/direnvrc, e.g.:
        KEEPASS_DATABASE="$HOME/Documents/Passwords.kdbx"

      use_keepass also needs direnv and KeePassXC.
    EOS
  end

  test do
    system "bash", "-n", pkgshare/"keepass.sh"
    system "bash", "-n", bin/"keepass-forget"
  end
end
