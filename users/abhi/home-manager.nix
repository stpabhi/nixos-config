{ inputs, ... }:

{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));
in {
  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "18.09";

  # Disabled for now since we mismatch our versions. See flake.nix for details.
  home.enableNixpkgsReleaseCheck = false;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.asciinema
    pkgs.bat
    pkgs.chezmoi
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.oh-my-zsh

    pkgs.gopls
    pkgs.zigpkgs."0.15.1"

  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.cachix
  ]) ++ (lib.optionals (isLinux) [
    pkgs.starship
  ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";
  };


  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = !isDarwin;

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000000;
      save = 10000000;
      path = "$HOME/.zsh_history";
      extended = true;
      ignoreAllDups = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  programs.starship.enable = true;

  programs.git = {
    enable = true;
    userName = "Abhilash Pallerlamudi";
    userEmail = "stp.abhi@gmail.com";
    signing = {
      signByDefault = true;
    };
    aliases = {
      cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "stpabhi";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPath = "go";
    goPrivate = [ "github.com/stpabhi"];
  };

  services.gpg-agent = {
    enable = isLinux;
    pinentry.package = pkgs.pinentry-tty;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  home.pointerCursor = lib.mkIf (isLinux) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
  };

  programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      ];
      commandLineArgs = [
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
      ];
  };
}
