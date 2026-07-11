{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sho Yoshikane";
        email = "118446211+shoyoshikane@users.noreply.github.com";
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      diff.algorithm = "histogram";
      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      push.autoSetupRemote = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
    ignores = [ "**/.claude/settings.local.json" ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
