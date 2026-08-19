{ pkgs, llm-agents, ... }:
let
  llmPackages = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    # Shell tools
    bat
    bottom
    eza
    fd
    hyperfine
    jq
    pngpaste
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
    llmPackages.claude-code
    llmPackages.codex

    # Infrastructure tools
    argocd
    awscli2
    go
    kubectl
    kubernetes-helm
    mise
    tfenv
  ];
}
