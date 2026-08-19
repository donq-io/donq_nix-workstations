# Org git configuration: git + delta, and lazygit.
{ ... }: {
  programs.lazygit = {
    enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
      navigate = true;
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.useConfigOnly = true;
      # Automatically handle !fixup and !squash commits -- see https://thoughtbot.com/blog/autosquashing-git-commits
      rebase.autosquash = "true";
      # Improve merge conflicts style showing base -- see https://ductile.systems/zdiff3/
      merge.conflictstyle = "zdiff3";
      # Different color for moves in diffs.
      diff.colorMoved = "default";
      # Default branch name.
      init.defaultBranch = "main";
      # Help with autocorrect but ask for permission.
      help.autocorrect = "prompt";
      # Use ISO dates.
      log.date = "iso";
      # Probably easier diffs when permuting functions.
      diff.algorithm = "histogram";
      # Sort branches by last commit.
      branch.sort = "-committerdate";
    };
  };
}
