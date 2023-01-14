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
sh ./weeklyReportGene.sh
```
* 附加参数
```shell
sh ./weeklyReportGene.sh -e "xxx@xx.com" -f "./xxx.log" -d 7 
```
* 参数说明
```shell
Usage:[-f 输出文件目录，默认./2023-01-14log.log] [-d 统计多少天，默认4天] [-e email 默认为git global中设置的email][-h help]
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
