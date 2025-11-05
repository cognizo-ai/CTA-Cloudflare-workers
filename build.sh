#!/bin/bash
# Cloudflare Build Script for Rust Workers
set -e

echo "Checking Rust installation..."

# Check if Rust is already installed
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
    
    # Source cargo env in the same shell
    export PATH="$HOME/.cargo/bin:$PATH"
    source "$HOME/.cargo/env"
    
    echo "Rust installed: $(rustc --version)"
else
    echo "Rust found: $(rustc --version)"
    export PATH="$HOME/.cargo/bin:$PATH"
fi

echo "Adding wasm32-unknown-unknown target..."
rustup target add wasm32-unknown-unknown

echo "Installing worker-build..."
cargo install -q worker-build 2>/dev/null || echo "worker-build already installed"

echo "Building worker..."
worker-build --release

echo "Build completed successfully!"
echo "Build artifacts:"
ls -lh build/ || echo "Build directory not found"
