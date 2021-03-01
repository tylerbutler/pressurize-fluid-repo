# Pressurize: Heat up the Fluid Framework repo

This _experimental_ and _hacky_ script can be run on [Fluid Framework repo](https://github.com/microsoft/FluidFramework)
to make it [pnpm](https://pnpm.js.org/) compatible.

## Dependencies

### A Linux shell

Pressurize is a shell script, and should run in bash, fish and zsh. It's tested primarily in zsh. Pressurize won't run
in PowerShell or CMD.EXE in Windows. Use WSL2 to run it on Windows. Or send me a PR with a cross-plat implementation.
:smile:

### Some awesome terminal tools

There are some truly awesome modern replacements for classic terminal tools like `sd` (replaces `sed`) and `fd`
(replaces `find`). I like them and I think you will too. Pressurize is a way to _pressure_ you (see what I did there?!)
to install them, because it depends on them.

- [sd](https://github.com/chmln/sd)
- [fd](https://github.com/sharkdp/fd)

There are several wasy to get these two tools but the easiest IMO is to use cargo, the rust package manager. This means
you need rust installed. But it's 2021, and you really should have it anyway. So if you don't, run this handy command to
install it:

`curl https://sh.rustup.rs -sSf | sh`

This should take ~90 seconds to install. Once done, use cargo to install `fd` and `sd`.

`cargo install fd-find sd`

- [jq](https://stedolan.github.io/jq)

Oh yeah, you'll need `jq`. If you're using Ubuntu or debian, you can install it using apt:

`sudo apt-get install jq`

## Install

You can either clone the repo and run the `pressurize.sh` script in your FluidFramework repo directory, or you
can download the script like so:

`curl https://raw.githubusercontent.com/tylerbutler/pressurize-fluid-repo/main/pressurize.sh > pressurize.sh`

Then run `pressurize.sh` in your FluidFramework directory.

**You should create a new branch before running the script!** The script will make changes to your repo and commit
results. It will not push anything to a remote.

## What it does

The script will do the following:

- Add pnpm config files
- Deletes existing package-lock.json files
- Updates scripts in package.json to use pnpm
- Applies some "workarounds" by disabling some npm tasks that currently cause issues with pnpm
