#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt install curl -y < "/dev/null"
fi
echo "=================================================="
echo -e 'Installing dependencies...\n' && sleep 1
sudo apt update
sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw -y < "/dev/null"
echo "=================================================="
echo -e 'Installing Rust (stable toolchain)...\n' && sleep 1
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
# sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup default stable
rustup update stable --force
# rustup toolchain install nightly-2021-03-10-x86_64-unknown-linux-gnu
# toolchain=`rustup toolchain list | grep -m 1 nightly`
echo "=================================================="
echo -e 'Cloning snarkOS...\n' && sleep 1
cd $HOME
git clone https://github.com/kingshroud/aleo-prover.git
cd aleo-prover
echo "=================================================="
echo -e 'Installing snarkos v2.0.0 ...\n' && sleep 1
#cargo install --path .
cargo build --release
echo "=================================================="
echo " Attention - Please ensure ports 4132 and 3032"
echo "             are enabled on your local network."
echo ""
echo " Cloud Providers - Enable ports 4132 and 3032"
echo "                   in your network firewall"
echo ""
echo " Home Users - Enable port forwarding or NAT rules"
echo "              for 4132 and 3032 on your router."
echo "=================================================="

# Open ports on system
ufw allow 4132/tcp
ufw allow 3032/tcp
echo "=================================================="
cd target/release
. $HOME/.bashrc
