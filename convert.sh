# The following tools need to be on your path:
# fd
# jq
# sd

echo "Installing pnpm and global deps"
npm i -g pnpm
pnpm i -g rimraf tiged

hr 1

echo "Removing old lockfiles"
rm *package-lock*
cd server/routerlicious
rm *package-lock*
cd ../..

hr 2

echo "Updating packages from lerna.json"
# jq '. + {"packages": [ "examples/**", "experimental/**", "packages/**", "server/routerlicious/packages/gitresources/", "server/routerlicious/packages/local-server/", "server/routerlicious/packages/protocol-base/", "server/routerlicious/packages/protocol-definitions/"]}' lerna.json > lerna2.json
# jq '. + {"packages": []}' lerna.json > lerna2.json
jq 'del(.packages)' lerna.json > lerna2.json
rimraf lerna.json
mv lerna2.json lerna.json

jq 'del(.packages)' server/routerlicious/lerna.json > server/routerlicious/lerna2.json
rimraf server/routerlicious/lerna.json
mv server/routerlicious/lerna2.json server/routerlicious/lerna.json

hr 3

echo "Adding pnpm config files"
echo "packages:
  - 'common/*/*'
  - 'packages/**'
  - 'examples/**'
  - 'experimental/**'
  - 'server/routerlicious/packages/gitresources/'
  - 'server/routerlicious/packages/protocol-base/'
  - 'server/routerlicious/packages/protocol-definitions/'

link-workspace-packages: deep
prefer-workspace-packages: true
save-workspace-protocol: false
shared-workspace-lockfile: true" > pnpm-workspace.yaml

echo "packages:
  - 'packages/**'

link-workspace-packages: deep
prefer-workspace-packages: true
save-workspace-protocol: false
shared-workspace-lockfile: true" > server/routerlicious/pnpm-workspace.yaml

echo "enable-modules-dir = true
shamefully-hoist = true" > .npmrc

echo "enable-modules-dir = true
shamefully-hoist = true" > server/routerlicious/.npmrc

git add .
git commit -m 'pnpm-ify: Add new files'

hr 4

echo "Updating run commands to use pnpm (takes 1-2 mins)"
for file in $(fd package.json --type file); do
    # echo "$file"

    # echo '  npm:      ==> pnpm:'
    sd 'npm:' 'pnpm:' "$file"

    # echo '  npm run   ==> pnpm run'
    sd 'npm run ' 'pnpm run ' "$file"
done

hr 5

echo '  lerna run ==> pnpm -r '
sd 'lerna run ' 'pnpm -r ' "package.json"
sd ' --stream --parallel' ' --workspace-concurrency 8' "package.json"
sd ' --stream' ' --workspace-concurrency 8' "package.json"
sd '"postinstall": ' '"-postinstall": ' "package.json"

# routerlicious
sd 'lerna run ' 'pnpm -r ' "server/routerlicious/package.json"
sd ' --stream --parallel' ' --workspace-concurrency 8' "server/routerlicious/package.json"
sd ' --stream' ' --workspace-concurrency 8' "server/routerlicious/package.json"
sd '"postinstall": ' '"-postinstall": ' "server/routerlicious/package.json"

git add .
git commit -m 'pnpm-ify: Update npm run commands'

hr 6

# misc workarounds
sd '"lint": ' '"-lint": ' "packages/drivers/odsp-driver/package.json"
sd '"build:test": "tsc --project ./src/test/tsconfig.json"' '"build:test": "echo Skipping"' "packages/drivers/odsp-driver/package.json"

git add .
git commit -m 'pnpm-ify: Apply workarounds'

hr 7

# Revert changes to the end-to-end tests
sd 'pnpm:' 'npm:' "packages/test/end-to-end-tests/package.json"
git add .
git commit -m 'pnpm-ify: Revert some changes'

hr 8

echo "Downloading custom fluid-build to ./fluid-build-pnpm..."
rimraf fluid-build-pnpm
degit tylerbutler/FluidFramework/tools/build-tools#pnpm/fluid-build fluid-build-pnpm

cd fluid-build-pnpm
npm install
npm run build
cd ..

hr 9

echo "Add custom build tool as dep"
pnpm add ./fluid-build-pnpm/ --workspace-root
cd server/routerlicious
pnpm add ../../fluid-build-pnpm/ --workspace-root
cd ../..
git add .
git commit -m 'pnpm-ify: Commit custom fluid-build'

echo "We made 5 commits to this branch:"
git log --oneline --decorate --graph -5

echo "Done! Now run 'pnpm install', then 'pnpm run build:fast'"
