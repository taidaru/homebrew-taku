class Taku < Formula
  desc "A task runner powered by Rust and scripted in Lua."
  homepage "https://taidaru.github.io/taku/"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/taidaru/taku/releases/download/v0.1.4/taku-aarch64-apple-darwin.tar.xz"
      sha256 "b742125da1def4a40db61dde1ae4fab7a673f56d89267e88c633780bf9c690ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/taidaru/taku/releases/download/v0.1.4/taku-x86_64-apple-darwin.tar.xz"
      sha256 "92b6f5366fa092f6e906ddcbc3046b6c3fe5c033a5d8e8e3fba3fa967b996172"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/taidaru/taku/releases/download/v0.1.4/taku-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6161b85282bb3f1ac32f3a10f2fbba272019af6eb4e0cbc02f78de48a5827e6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/taidaru/taku/releases/download/v0.1.4/taku-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c06a628730da231411325e4721b5ddd1e464cd96c06f931b290a49b8558c834f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "taku"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "taku"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "taku"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "taku"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
