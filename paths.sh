if cmdExists go; then
  export GOPATH="${HOME}/.local/go"
  export GOBIN="${GOPATH}/bin"
  export PATH="${PATH}:${GOBIN}"
  if [[ ! -d "${GOBIN}" ]]; then
    mkdir -p "${GOBIN}" 
  fi

  # TODO: Make an associative array and test if all the binaries exist
  # Install go plugins
  # for MOD in 'antonmedv/fx@24.0.0' 'andreazorzetto/yh@v0.4.0' 'cpuguy83/go-md2man/v2@v2.0.2'
  # do
    # go install "github.com/${MOD}"
  # done;
fi

if cmdExists fzf; then
  # eval <(fzf --zsh) # There are some issues with this, which are not related to
  #   upstream so we're going to use a cache
  if [[ -f "${XDG_CONFIG_HOME}/fzf.zsh" ]]; then
    source "${XDG_CONFIG_HOME}/fzf.zsh"
  else
    echo "Warning: fzf.zsh not found in ${XDG_CONFIG_HOME}. Please run 'fzf --zsh' to generate it."
  fi
fi

# Export luarocks vars for lua
if cmdExists luarocks; then
  eval $(luarocks path --bin)
fi

if cmdExists java; then
  # Get the symlink target from java executable in PATH, then calculate JAVA_HOME
  # by removing '/bin/java' from the end of the path which readlink gives
  export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"
fi

# Setup perl5 paths
if [[ -d "${HOME}/perl5" ]]; then
  export PATH="${PATH}:/home/revan/perl5/bin"
  export PERL5LIB="/home/revan/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
  export PERL_LOCAL_LIB_ROOT="/home/revan/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
  export PERL_MB_OPT="--install_base \"/home/revan/perl5\""
  export PERL_MM_OPT="INSTALL_BASE=/home/revan/perl5"
fi

# Set up fnm
if [[ -d "${XDG_DATA_HOME}/fnm" ]]; then
  export PATH="${XDG_DATA_HOME}/fnm:$PATH"
  eval $(fnm env)
fi
