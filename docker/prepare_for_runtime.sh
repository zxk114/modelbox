#!/bin/bash
CUR_DIR=$(cd $(dirname "${BASH_SOURCE[0]}");pwd)
PLATFROM=$(arch)

if [ $# -eq 2 ]; then
    OS_NAME=$1
    OS_VER=$2
    if [ "${OS_NAME,,}" == "ubuntu" ];then
        if [ "${OS_VER}" == "18.04" ];then
            OS_VER=18.04
        else
            OS_VER=20.04
        fi
    elif [ "${OS_NAME,,}" == "openeuler" ];then
        if [ "${OS_VER}" == "18.04" ];then
            OS_VER=20.03
        else
            OS_VER=22.03
        fi
    fi
elif [ $# -eq 1 ]; then
    OS_NAME=$1
    if [ "${OS_NAME,,}" == "ubuntu" ];then
        OS_VER=20.04
    elif [ "${OS_NAME,,}" == "openeuler" ];then
        OS_VER=20.03
    fi
else
    OS_NAME=$(sed -nr '/NAME/s/^NAME="(.*)"$/\1/gp' /etc/os-release)
    OS_VER=$(sed -nr '/VERSION_ID/s/^VERSION_ID="(.*)"$/\1/gp' /etc/os-release)
fi

download() {
    url="$1"
    softName=${url##*/}
    echo -e "\n\nBegin to download ${softName}"

    times=0
    while true
    do
        curl -k -L -O ${url}
        if [ $(ls -l ${softName}|awk '{print $5}') -ge 10000 ]; then
            echo "${softName} download complete"
            break
        else
            times=$[${times}+1]
            if [ ${times} -gt 3 ]; then
                echo "package ${softName} download failed,pls check"
                exit 1
            fi
            echo "package ${softName} download failed, retry $times in 3 seconds......"
            sleep 3
        fi
    done
}

if [ "${OS_NAME,,}" == "ubuntu" ];then
    download https://github.com/modelbox-ai/modelbox-binary/releases/download/BinaryArchive/opencv_4.5.5-ubuntu${OS_VER}-${PLATFROM}.tar.gz
    download https://github.com/modelbox-ai/modelbox-binary/releases/download/BinaryArchive/obssdk_3.23.3-ubuntu-${PLATFROM}.tar.gz
elif [ "${OS_NAME,,}" == "openeuler" ];then
    download https://github.com/modelbox-ai/modelbox-binary/releases/download/BinaryArchive/obssdk_3.23.3-openeuler-${PLATFROM}.tar.gz
    download https://github.com/modelbox-ai/modelbox-binary/releases/download/BinaryArchive/cpprestsdk_2.10.18-openeuler${OS_VER}-${PLATFROM}.tar.gz
    download https://github.com/modelbox-ai/modelbox-binary/releases/download/BinaryArchive/duktape_2.6.0-openeuler${OS_VER}-${PLATFROM}.tar.gz
    download https://github.com/modelbox-ai/modelbox-binary/releases/download/BinaryArchive/ffmpeg_4.4.3-openeuler${OS_VER}-${PLATFROM}.tar.gz
    download https://github.com/modelbox-ai/modelbox-binary/releases/download/BinaryArchive/opencv_4.5.5-openeuler${OS_VER}-${PLATFROM}.tar.gz
fi

if [ "${PLATFROM}" == "x86_64" ];then
    download https://github.com/modelbox-ai/modelbox-binary/releases/download/BinaryArchive/Video_Codec_SDK_9.1.23.tar.gz
fi
ls -lh *.tar.gz

#ls release|egrep 'devel|document|solution|demo'|xargs -i rm -f release/{}
#ls -lh release
