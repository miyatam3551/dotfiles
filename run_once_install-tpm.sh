#!/bin/bash
# TPM (Tmux Plugin Manager) の自動インストール

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "TPM installed. Run 'prefix + I' in tmux to install plugins."
else
    echo "TPM already installed."
fi
