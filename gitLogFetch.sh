#!/bin/bash
#################################################################
# Function  导出项目git日志 方便撰写周报                            #
# Auhtor    wangzy                                              #    
# Date      2023-01-14 11:29                                    #
# Version   1.1                                                 #   
#################################################################

#默认参数设置
#获取前几天的提交记录
day=4
#git提交记录的邮箱
email=`git config user.email`
#输出文件名
outFile=""$(date +%Y-%m-%d)"log.log"
#默认输出文件名
defaultOutFile=$outFile
#项目目录
sourcePath="$(pwd)"
#是否获取当天的提交记录
isToday=false
#脚本所在目录记录
scriptPath="$(pwd)"
#日志文件输出路径
outPath=$scriptPath"/"$outFile


#读取命令行参数
while getopts "s:f:d:e:nh" arg
do
    case "$arg" in
        n)
        isToday=true
        ;;
        f)
        outFile=$OPTARG
        ;;
        d)
        day=$OPTARG
        ;;
        e)
        email=$OPTARG
        ;;
        s)
        sourcePath=$OPTARG
        ;;
        h)
        echo "Usage:[-f 输出文件目录，默认脚本存在目录] [-d 统计多少天，默认"$day"天] [-e email 默认为git global中设置的email]
           [-s 存在git仓库的项目目录, 默认脚本存在的目录] [-h help]"
        exit
        ;;
        ?)
        echo "Unknown option"
        exit
        ;;
    esac
done

#设置日志文件输出路径
if [ $defaultOutFile != $outFile ]; then
    outPath=$outFile
fi

#计算从什么时候开始获取提交记录
since=`date -v -$day"d" +%Y-%m-%d`


#判断文件类型
function isLogFileFunc() {
    if [ ! -n "$1" ]; then
        echo "日志文件参数不存在！"
        exit 0
    fi
    if [ "${1##*.}" = "log" ]; then
        return 0
    fi
    return 1
}

#定义获取文件名函数
function getFileNameFunc() {
    if [ ! -d ${1%/*} ]; then
        echo "请输入正确的日志文件路径"
        exit 0
    fi
    fileName=${1##*/}
}
#获取文件名
getFileNameFunc $outPath

#判断输出文件是否为log文件
if ! isLogFileFunc $outPath; then
    echo "请输入正确的日志文件"
    exit 0
elif [ ${#fileName} -le 4 ]; then
    echo "请输入设置正确的的日志文件名"
    exit 0
fi

#查看源文件目录下是是否存在git仓库
if [ ! -d $sourcePath"/.git" ]; then 
    echo "项目目录下不存在git仓库，请检查源文件目录配置是否正确！"
    exit 0
fi

#项目目录与脚本目录不一致时，切换到项目目录
if [ $sourcePath != "./" ] && [ $sourcePath != $scriptPath ]; then
    echo "切换到项目目录："$sourcePath""
    cd $sourcePath
fi

#提示说明
tips="获取前："$day"天，邮箱为："$email"的git提交记录，输出到文件："$outPath""

#判断是否获取当天的提交记录
if [ $isToday = true ]; then
    since=`date -v -1d +%Y-%m-%d`
    tips="获取当天，邮箱为："$email"的git提交记录，输出到文件："$outPath""
fi

#输出提示说明
echo $tips

#获取提交记录并输出到文件
echo "开始提取git提交记录..."


#参数测试退出点
# exit 0

#执行git log命令
`git log -a --author="$email" --no-merges --pretty=format:"%s" --since="$since" > $outPath`
