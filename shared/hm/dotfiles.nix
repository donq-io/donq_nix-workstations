# Org dotfiles shipped verbatim into the home directory.
{ ... }: {
  home.file.".editorconfig".source = ../files/editor_config.ini;
  home.file.".justfile".source = ../files/justfile;
}
