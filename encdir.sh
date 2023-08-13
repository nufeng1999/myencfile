#!/bin/bash

# encdir srcdir desdir netdir

func (){
    local sdir="$1"      #local局部变量标识符
    local ddir="$2"      #local局部变量标识符   
    local ndir="$3"      #local局部变量标识符   
    #for f in `ls "$1"` 
    for f in $(ls "$1")
    do
        if [ -f "$sdir/$f" ]
        then

            if [ ! -f "$ddir/$f.rar" ];then
                echo "-------<开始处理文件 $sdir/$f>-------"
                ./encfile.sh \
                -d "$ddir/$f.rar" \
                -s "$sdir/$f" \
                -n "$ndir"
                echo "------->处理文件 $sdir/$f 结束<-------"

                #if [ $? != 0 ]
                #then
                    #echo "encfile terminating....." >&2
                    #exit 1
                #fi

            #else
                #rm -f /data/filename
            fi
        elif [ -d "$sdir/$f" ]
        then
              mkdir -p "$ddir/$f"
              func "$sdir/$f"  "$ddir/$f"  "$ndir/$f"            #如果是目录再次进行遍历
        else
              echo "$f未知"
        fi
    done
}
func "$1" "$2" "$3"
