#!/bin/bash
CODE_DIR=$(cd $(dirname $0)/..;pwd)
release_dir=${CODE_DIR}/build/release
ls -lh ${release_dir}

if [ -n "$1" ]; then
    osName=$1
else
    osName=$(sed -nr '1s/^NAME="(.*)"$/\1/gp' /etc/os-release)
fi

if [ "${osName,,}" == "ubuntu" ];then
    rm -f ${release_dir}/*.rpm
    postfix="*.deb"
elif [ "${osName,,}" == "openeuler" ];then
    postfix="*.rpm"
fi

if [ $(ls ${release_dir}|grep "cuda"|wc -l) -eq 2 ];then
    type="cuda"
elif [ $(ls ${release_dir}|grep "ascend"|wc -l) -eq 2 ];then
    type="ascend"
fi

filecount=$(ls ${release_dir} | wc -l)
pkgcount=$(ls ${release_dir} | egrep "${postfix}" | wc -l)
artifacts_file=$(ls ${release_dir} | grep "${type}"| wc -l)

if [ ${filecount} -ge 14 ] && [ ${pkgcount} -ge 12 ] && [ ${artifacts_file} -eq 2 ]; then
    echo "compile success"
else
    echo "compile failed"
    exit 1
fi
