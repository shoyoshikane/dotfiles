{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell tools
    bat
    bottom
    eza
    fd
    hyperfine
    jq
    ripgrep
    tlrc
    yazi

    # Git tools
    gh
    ghq

    # Editor
    neovim

    # Formatting and validation
    actionlint
    lefthook
    nixfmt
    rumdl
    shellcheck
    shfmt
    stylua
    taplo
    typos
    yamlfmt

    # Secret management
    age
    sops

    # AI coding agents
    llm-agents.claude-code
    llm-agents.codex

    # Infrastructure tools
    argocd
    awscli2
    kubectl
    kubernetes-helm
    terraform
  ];
}
