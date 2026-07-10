{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell tools
    fzf
    tree
    zoxide

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
