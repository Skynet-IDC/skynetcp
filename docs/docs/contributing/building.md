# Building packages

::: info
For building `skynet-nginx` or `skynet-php`, at least 2 GB of memory is required!
:::

Here is more detailed information about the build scripts that are run from `src`:

## Installing skynet from a branch

The following is useful for testing a Pull Request or a branch on a fork.

1. Install Node.js [Download](https://nodejs.org/en/download) or use [Node Source APT](https://github.com/nodesource/distributions)

```bash
# Replace with https://github.com/username/skynetcp.git if you want to test a branch that you created yourself
git clone https://github.com/skynetcp/skynetcp.git
cd ./skynetcp/

# Replace main with the branch you want to test
git checkout main

cd ./src/

# Compile packages
./hst_autocompile.sh --all --noinstall --keepbuild '~localsrc'

cd ../install

bash hst-install-{os}.sh --with-debs /tmp/skynetcp-src/deb/
```

Any option can be appended to the installer command. [See the complete list](../introduction/getting-started#list-of-installation-options).

## Build packages only

```bash
# Only skynet
./hst_autocompile.sh --skynet --noinstall --keepbuild '~localsrc'
```

```bash
# skynet + skynet-nginx and skynet-php
./hst_autocompile.sh --all --noinstall --keepbuild '~localsrc'
```

## Build and install packages

::: info
Use if you have skynet already installed, for your changes to take effect.
:::

```bash
# Only skynet
./hst_autocompile.sh --skynet --install '~localsrc'
```

```bash
# skynet + skynet-nginx and skynet-php
./hst_autocompile.sh --all --install '~localsrc'
```

## Updating skynet from GitHub

The following is useful for pulling the latest staging/beta changes from GitHub and compiling the changes.

::: info
The following method only supports building the `skynet` package. If you need to build `skynet-nginx` or `skynet-php`, use one of the previous commands.
:::

1. Install Node.js [Download](https://nodejs.org/en/download) or use [Node Source APT](https://github.com/nodesource/distributions)

```bash
v-update-sys-skynet-git [USERNAME] [BRANCH]
```

**Note:** Sometimes dependencies will get added or removed when the packages are installed with `dpkg`. It is not possible to preload the dependencies. If this happens, you will see an error like this:

```bash
dpkg: error processing package skynet (–install):
dependency problems - leaving unconfigured
```

To solve this issue, run:

```bash
apt install -f
```
