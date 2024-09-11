# `TimonLukas/dotfiles`

My personal dotfiles repository, managed through the wonderful [`chezmoi`](https://www.chezmoi.io/)

## Install

**Simple (but unsafe)**: `sh -c "$(curl -fsLS dotfiles.timon.sh)"`
- Doesn't require `chezmoi` to be installed
- Not a good idea
- URL redirects to [`https://timonlukas.github.io/dotfiles/index.txt`](https://timonlukas.github.io/dotfiles/index.txt)

**Simple (a bit safer)**: `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply TimonLukas`
- Doesn't require `chezmoi` to be installed
- - Same command as in script above

**Safest**: `chezmoi init --apply TimonLukas`
- `chezmoi` must be installed


## Scripts

### `build-github-pages.sh`

Usage: `./build-github-pages.sh $GITHUB_USERNAME [$URL_INDEX_TXT]`