# adambware does dotfiles

macOS development environment setup. No frameworks, no dependencies beyond Homebrew — just shell scripts and config files.

## Quick Start

```Shell
git clone https://github.com/adambware/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup
```

## Selective Setup

```Shell
./setup homebrew     # Install Homebrew and packages
./setup shell        # Set up ZSH, Oh My Zsh, and dotfiles
./setup git          # Set up git config and global gitignore
./setup macos        # Apply macOS system preferences
./setup languages    # Install Python, Ruby, Node via asdf
./setup private      # Symlink private configs
```

Combine commands: `./setup homebrew shell git`

## Structure

```text
setup                   # Main runner script
config/
  Brewfile              # Homebrew packages and casks
  macos.sh              # macOS system preferences (defaults write)
  languages.sh          # Python, Ruby, Node setup via asdf
shell/
  zshrc                 # Minimal ~/.zshrc (bootstraps Oh My Zsh)
git/
  gitconfig             # Git config (symlinked to ~/.gitconfig)
  gitignore_global      # Global gitignore
private/                # .gitignored — your personal configs
private.example/        # Templates for private/ setup
```

## Private Configs

The `private/` directory is gitignored for secrets and personal settings. See `private.example/` for templates.

Supported private files:

* `private/gitconfig.local` — Git name, email, signing key (included via `[include]` in gitconfig)
* `private/env.local.zsh` — Private env vars, tokens, aliases (auto-sourced via Oh My Zsh custom/)
* `private/Brewfile.private` — Extra Homebrew packages for work tools
* `private/ssh_config` — SSH config (symlinked to `~/.ssh/config`)

## Customization

* **Add/remove packages**: Edit `config/Brewfile`
* **Change macOS settings**: Edit `config/macos.sh`
* **Update language versions**: Edit the variables at the top of `config/languages.sh`
* **Shell config (aliases, env, theme, plugins)**: Managed in [omz](https://github.com/adambware/omz) (cloned automatically by `./setup shell`)

## License

MIT
