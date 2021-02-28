# Fluid Framework repo pnpm-ify script

This script can be run on Fluid Framework repo to make it pnpm compatible.

## Install

```bash
npm install @tylerbu/bin-install
```

## Usage

Once installed, you can run using the command `binstall`.

```bash
binstall <command>

Commands:
  binstall install  Download and install a binary file

Options:
      --version  Show version number                                   [boolean]
  -h, --help     Show help                                             [boolean]
```

### The **install** command

The install command downloads a platform-specific binary to the destination path you specify.

```bash
binstall install

Download and install a binary file

Options:
  -n, --name         name of binary to download
                                  [string] [required] [choices: "ditaa", "hugo"]
  -d, --destination  Destination folder                [string] [default: "bin"]
  -h, --help         Show help                                         [boolean]
```

### Supported tools

Currently supported tools are [hugo](https://gohugo.io) and [ditaa](https://github.com/akavel/ditaa).

## Adding new tools

Coming soon...
