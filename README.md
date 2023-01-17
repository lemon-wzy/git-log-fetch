## 基于git shell 命令获取git提交日志
#### 主体命令依据git 官网
```shell
git log -a --author='xxx@xxx.com' --no-merges --pretty=format:" %s" --since="2008-10-01"
```
* 详细说明请查阅git[官网历史记录篇](https://git-scm.com/book/zh/v2/Git-%E5%9F%BA%E7%A1%80-%E6%9F%A5%E7%9C%8B%E6%8F%90%E4%BA%A4%E5%8E%86%E5%8F%B2)

*****************************
#### 使用说明（* 需要确认当前目录下存在git仓库）
* 直接使用
```shell
sh ./gitLogFetch.sh
```
* 附加参数
```shell
sh ./gitLogFetch.sh -e "xxx@xx.com" -f "./xxx.log" -d 7 
```
* 参数说明
```shell
Usage:[-f 输出文件目录，默认./2023-01-14log.log] [-d 统计多少天，默认4天] [-e email 默认为git global中设置的email] [-s 存在git仓库的项目目录, 默认脚本存在的目录] [-h help]
```

***********************
#### 依赖系统说明
* 该脚本仅适用于macos之类的unix系统，linux 系统请自行修改脚本中的date命令
```shell
os_name=$(uname -s)
if [[ "$os_name" == "Linux" ]]; then
    #statements
    pre_date=$(date +%Y-%m-%d --date='-1 day')
elif [[ "$os_name" == "Darwin" ]]; then
    pre_date=$(date -v -1d +%Y-%m-%d)
fi
```

****************************************************************
#### Version1.1新功能
* 使用参数`-s` 可以自定义设置项目目录不需要移动脚本
```shell
sh ./gitLogFetch.sh -s xx/xxx/xx
```

******************************************************************
#### Version1.2
* 使用参数`-n` 可以获取脚本执行当天的git提交记录
```shell
sh ./gitLogFetch.sh -n
```
* 新增参数说明
```shell
Usage:[-n 代码执行当天的参数]
```