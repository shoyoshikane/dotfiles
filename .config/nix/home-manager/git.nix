{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sho Yoshikane";
        email = "118446211+shoyoshikane@users.noreply.github.com";
      };
      core.editor = "vim";
    };
    ignores = [ "**/.claude/settings.local.json" ];
  };

  programs.delta.enable = true;
}
