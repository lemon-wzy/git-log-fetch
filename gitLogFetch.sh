#!/bin/bash
#################################################################
# Function  导出项目git日志 方便撰写周报                            #
# Auhtor    wangzy                                              #    
# Date      2023-01-14 11:29                                    #
# Version   1.0                                                 #   
#################################################################

#默认参数设置
day=4
email=`git config user.email`
outFile="./"$(date +%Y-%m-%d)"log.log"

#读取命令行参数
while getopts "f:d:e:h" arg
do
    case "$arg" in
        f)
        outFile=$OPTARG
        ;;
        d)
        day=$OPTARG
        ;;
        e)
        email=$OPTARG
        ;;
        h)
        echo "Usage:[-f 输出文件目录，默认"$outFile"] [-d 统计多少天，默认"$day"天] [-e email 默认为git global中设置的email]
           [-h help]"
        exit
        ;;
        ?)
        echo "Unknown option"
        exit
        ;;
    esac
done

#提示说明
echo "获取前："$day"天，邮箱为："$email"的git提交记录，输出到文件："$outFile""

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

#判断输出文件是否为log文件
if ! isLogFileFunc $outFile; then
    echo "请输入正确的日志文件"
    exit 0
fi

#查看当前目录下是是否存在git仓库
if [ ! -e ".git" ]; then 
    echo "当前目录下不存在git仓库"
    exit 0
fi

#获取提交记录并输出到文件
`git log -a --author="$email" --no-merges --pretty=format:"%s" --since="$since" > $outFile`
