{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell tools
    fzf
    ripgrep
    tree
    zoxide

    # Git tools
    gh
    ghq
    lazygit

    # Editor
    neovim

    # Infrastructure tools
    argocd
    awscli2
    kubectl
    kubernetes-helm
    terraform
  ];
}
