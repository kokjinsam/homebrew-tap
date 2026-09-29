class Oafmt < Formula
  desc "Command-line interface for deterministic, syntax-preserving OpenAPI formatting"
  homepage "https://github.com/kokjinsam/oafmt"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kokjinsam/oafmt/releases/download/v0.2.0/oafmt-aarch64-apple-darwin.tar.xz"
      sha256 "624a780602cf6de8941a9f1981522dd9fe556ab75d937ee40cf0c4f7b61e2cfa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kokjinsam/oafmt/releases/download/v0.2.0/oafmt-x86_64-apple-darwin.tar.xz"
      sha256 "da369481f31af21e7db2e03946ac79258eba8e6db0f98f3f6a5e38f589a6c684"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kokjinsam/oafmt/releases/download/v0.2.0/oafmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f3b01d11d6c4c59b21c0e60830db09b9a832337c850ff5805eebaa358b5e06e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kokjinsam/oafmt/releases/download/v0.2.0/oafmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13cf4ef3ad7aee95ef933dd6b8db088869e2cf920d06a18840d614cfcaf998c4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "oafmt"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "oafmt"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "oafmt"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "oafmt"
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
