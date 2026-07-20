class Taku < Formula
  desc "A task runner powered by Rust and scripted in Lua."
  homepage "https://taidaru.github.io/taku/"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/taidaru/taku/releases/download/v0.1.5/taku-aarch64-apple-darwin.tar.xz"
      sha256 "b0c3f66d5a3448b8a4b172196673f27ea4c14529b0711d369df031467502ad77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/taidaru/taku/releases/download/v0.1.5/taku-x86_64-apple-darwin.tar.xz"
      sha256 "e835905bc071182527bd06e64358e493377b439aa4cbc71cb1e0c06e3ced2c75"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/taidaru/taku/releases/download/v0.1.5/taku-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2fe5211c03ab9c18853962c924687916c301fab1665a3e91ee6f98449327629"
    end
    if Hardware::CPU.intel?
      url "https://github.com/taidaru/taku/releases/download/v0.1.5/taku-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "99b2d1b5ba98a16fdffa33b8809d38fc7483077d6d28ac5403a5138a27ba33cb"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "taku" if OS.mac? && Hardware::CPU.arm?
    bin.install "taku" if OS.mac? && Hardware::CPU.intel?
    bin.install "taku" if OS.linux? && Hardware::CPU.arm?
    bin.install "taku" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
