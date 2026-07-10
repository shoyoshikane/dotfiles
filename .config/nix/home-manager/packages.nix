{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell tools
    ripgrep
    tree

    # Git tools
    gh
    ghq

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
