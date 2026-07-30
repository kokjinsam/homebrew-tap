class Oafmt < Formula
  desc "Command-line interface for deterministic, syntax-preserving OpenAPI formatting"
  homepage "https://github.com/kokjinsam/oafmt"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kokjinsam/oafmt/releases/download/v0.1.0/oafmt-aarch64-apple-darwin.tar.xz"
      sha256 "3176c1da6901ef074b30d1e08fe4f4dc323113e50afb9da7625c8651e3a490f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kokjinsam/oafmt/releases/download/v0.1.0/oafmt-x86_64-apple-darwin.tar.xz"
      sha256 "1ae3dad178afc3e31b360c2777ab12b639e961b5085f06f7f7e08e9eb9c064ea"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kokjinsam/oafmt/releases/download/v0.1.0/oafmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13575a2693ecd5f1513c6e75f15d6fe9b3213cc7f6b8d197ab1ae3ec55019831"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kokjinsam/oafmt/releases/download/v0.1.0/oafmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "72e68b36c5bd5e1b595e472e092fa02cf288f6ce9305b9b5cbe6f9436b3fb6a2"
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
    bin.install "oafmt" if OS.mac? && Hardware::CPU.arm?
    bin.install "oafmt" if OS.mac? && Hardware::CPU.intel?
    bin.install "oafmt" if OS.linux? && Hardware::CPU.arm?
    bin.install "oafmt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
