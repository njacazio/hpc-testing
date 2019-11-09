#!/bin/bash -e

LOAD_PACKAGES="O2/nightly-$(TZ=Europe/Zurich date +%Y%m%d)-1"   # CVMFS packages, comma-separated
CVMFS_NAMESPACE='/cvmfs/alice-nightlies.cern.ch'                # CVMFS namespace

# Trick to bypass slow CVMFS modulecmd follows
: ${ARCH_DIR_CVMFS='el7-x86_64/Packages'}
: ${ARCH_DIR_ALIBUILD='slc7_x86-64'}
echo "Using CVMFS namespace ${CVMFS_NAMESPACE}"

# Creates a fake temporary work directory to load packages
PACKAGES_PREFIX="$CVMFS_NAMESPACE/$ARCH_DIR_CVMFS"
WORK_DIR="$(mktemp -d)"
ln -nfs "$PACKAGES_PREFIX" "$WORK_DIR/slc7_x86-64"

for PKG in $(echo "$LOAD_PACKAGES" | sed -e 's/,/ /g'); do
  # Loading the environment is non-fatal
  source "$PACKAGES_PREFIX/$PKG/etc/profile.d/init.sh" > /dev/null 2>&1 || true
done

# Cleanup of package loading
rm -rf "$WORK_DIR"
unset PKG PACKAGES_PREFIX WORK_DIR

### From this point on: we should be in the proper ALICE environment ###

# Check if environment is OK (die if not found!)
type o2-sim
o2-sim -j 12 -n 1 --skipModules ZDC CPV MID -g pythia8hi
