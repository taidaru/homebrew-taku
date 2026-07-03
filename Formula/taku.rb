class Taku < Formula
  desc "A task runner powered by Rust and scripted in Lua."
  homepage "https://taidaru.github.io/taku/"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/taidaru/taku/releases/download/v0.1.4/taku-aarch64-apple-darwin.tar.xz"
      sha256 "5fa43e0ad81a8bb2d7462203b8f6cebaa06760f188f618a08da424b57aaf0353"
    end
    if Hardware::CPU.intel?
      url "https://github.com/taidaru/taku/releases/download/v0.1.4/taku-x86_64-apple-darwin.tar.xz"
      sha256 "3d3809b5b886b7b4ec6dc0175e0772dccddfedfde167e3cd0d41254c1e3fd1ac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/taidaru/taku/releases/download/v0.1.4/taku-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a21b47012f348bad408de53d502fc4402d6e928929e9b257a9e0dd52105f26a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/taidaru/taku/releases/download/v0.1.4/taku-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2fab7a00b1bc442953aa11bfff24043f53e194feb9d1ae4a300ae7049ea1565"
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
