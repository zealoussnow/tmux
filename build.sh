#!/usr/bin/env bash
set -x
set -e

name="tmux"
VERSION=$(git describe --tags)

if expr index $VERSION '-' > /dev/null; then
    rpm_version=$(echo $VERSION | sed 's/^v//;s/-.*//')
    rpm_release=$(echo $VERSION | cut -d - -f 2- | sed 's/-/./g')
else
    rpm_version=$(echo $VERSION | sed 's/^v//;s/-.*//')
    rpm_release=0
fi

echo $rpm_version
echo $rpm_release

bash autogen.sh

sed "s/@REPO_VERSION@/${rpm_version}/g;s/@REPO_RELEASE@/${rpm_release}/g;s/@NAME@/${name}/g" ${name}.spec.in > ${name}.spec
rpmbuild -bb ${name}.spec
