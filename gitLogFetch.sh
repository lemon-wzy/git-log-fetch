#!/bin/bash
#################################################################
# Function  导出项目git日志 方便撰写周报                            #
# Auhtor    wangzy                                              #    
# Date      2023-01-14 11:29                                    #
# Version   1.3                                                 #   
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
#日期区间
between=
#其余参数
shellParam=

#读取命令行参数
while getopts "b:s:f:d:e:nh" arg
do
    case "$arg" in
        b)
        between=$OPTARG
        ;;
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
        echo "Usage:[-f 输出文件目录，默认脚本存在目录] 
                    [-d 统计多少天，默认"$day"天] 
                    [-e email 默认为git global中设置的email]
                    [-s 存在git仓库的项目目录, 默认脚本存在的目录] 
                    [-n 获取脚本执行当天的git提交记录] 
                    [ -b 添加时间区间 导出给定时间段之间的git提交记录 ] [-h help]"
        exit 0
        ;;
        ?)
        echo "Unknown option"
        exit 0
        ;;
    esac
done

#定义拉取git提交记录函数
function gitLogFetchFunc() {
    if [ -n "$1" ]; then
        echo "$1"
    fi
    echo "开始提取git提交记录..."
    `git log -a --author="$email" --no-merges --pretty=format:"%s" --since="$since" $2 > $outPath` 
    exit 0
}


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
    gitLogFetchFunc $tips
fi

#判断字符串包含
function containStr() {
    if [ -z "$1" ]; then
        return 1
    fi
    result=$(echo "$1" | grep "$2")
    if [ -z "$result" ]; then
        return 1
    else
        return 0
    fi
}

#校验时间格式(只校验格式，不校验时间是否合法)
function checkDateFormt() {
    result=$(echo "$1" | egrep "([0-9][0-9][0-9][0-9])-(0[1-9]|[1][0-2])-(0[1-9]|[1-2][0-9]|3[0-1])")
    if test -z $result; then
        return 1
    fi
    return 0
}

#校验时间区间
if containStr "$between" ","; then
    array=(${between//,/ })
    if [ ${#array[@]} -ne 2 ]; then
        echo "时间区间格式错误，请检查！"
        exit 0
    fi
    for item in ${array[@]}
    do 
        if ! checkDateFormt $item; then
            echo "时间区间格式错误，请检查！"
            exit 0
        fi
    done
    since=${array[0]}
    until=${array[1]}
    shellParam="$shellParam""--until=$until"
    tips="获取从："$since"到"$until"，邮箱为："$email"的git提交记录，输出到文件："$outPath""
fi

#参数测试退出点
# exit 0

gitLogFetchFunc $tips $shellParam
