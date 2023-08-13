#!/bin/bash
 
#定义选项， -o 表示短选项 -a 表示支持长选项的简单模式(以 - 开头) -l 表示长选项 
# a 后没有冒号，表示没有参数
# b 后跟一个冒号，表示有一个必要参数
# c 后跟两个冒号，表示有一个可选参数(可选参数必须紧贴选项)
# -n 出错时的信息
# -- 也是一个选项，比如 要创建一个名字为 -f 的目录，会使用 mkdir -- -f ,
#    在这里用做表示最后一个选项(用以判定 while 的结束)
# $@ 从命令行取出参数列表(不能用用 $* 代替，因为 $* 将所有的参数解释成一个字符串
#                         而 $@ 是一个参数数组)
TEMP=`getopt -o ad:s:n:c:: -a -l apple,desfile:,srcfile:,netdir:,cherry:: -n "test.sh" -- "$@"`
 
# 判定 getopt 的执行时候有错，错误信息输出到 STDERR
if [ $? != 0 ]
then
	echo "encfile terminating....." >&2
	exit 1
fi
 
# 重新排列参数的顺序
# 使用eval 的目的是为了防止参数中有shell命令，被错误的扩展。
eval set -- "$TEMP"
 
# 处理具体的选项
while true
do
	case "$1" in
		-a | --apple | -apple)
			#echo "option a"
			shift
			;;
		-d | --desfile | -desfile)
			#echo "option s, argument $2"
            desfile=$2
			shift 2
			;;
		-s | --srcfile | -srcfile)
			#echo "option s, argument $2"
            srcfile=$2
			shift 2
			;;
		-n | --netdir | -netdir)
			#echo "option s, argument $2"
            netdir=$2
			shift 2
			;;
		-c | --cherry | -cherry)
			case "$2" in
				"") # 选项 c 带一个可选参数，如果没有指定就为空
					#echo "option c, no argument"
					shift 2
					;;
				*)
					#echo "option c, argument $2"
					shift 2
			esac
			;;
		--)
			shift
			break
			;;
		*) 
			echo "Internal error!"
			exit 1
			;;
		esac
 
done
 
#显示除选项外的参数(不包含选项的参数都会排到最后)
# arg 是 getopt 内置的变量 , 里面的值，就是处理过之后的 $@(命令行传入的参数)
#for arg do
#   echo '--> '"$arg" ;
#done
#echo "srcfile=$srcfile";
#echo  "$1";

cd ./libshell
. shell-ini-config
cd ..

inifile="./app.ini"

encno=`expr $RANDOM % 10`;
desdir=$(ini_config_get "$inifile" "des" "dir")
pw=$(ini_config_get "$inifile" "$encno" "pw")
comment=$(ini_config_get "$inifile" "$encno" "comment")
url=$(ini_config_get "$inifile" "$encno" "url")
surl=$(ini_config_get "$inifile" "$encno" "surl")

echo "-------add file------"
rar a -ep "$desfile" -p$pw "$srcfile"
echo "-------add comment------"
rar c -z/mnt/n/PWD/$encno/readme.txt "$desfile"
echo "-------upload file------"
bypy upload "$desfile" "$netdir/${desfile##*/}"

exit 0


#