#Linux Shell参数替换
#Bash中的$符号的作用是参数替换，将参数名替换为参数所代表的值。对于$来说，大括号是可选的，即$A和${A}代表同一个参数。

#${}带冒号的有下面几种表达式：
${parameter:-word}
#如果parameter为null或者未设置，整个参数替换表达式值为word
${parameter:=word}
#如果parameter为null或者未设置，整个参数替换表达式值为word，并且parameter参数值设置为word
${parameter:?word}
#如果parameter为null或者未设置，则打印出错误信息。否则，整个参数替换表达式值为$parameter
${parameter:+word}
#如果parameter不为null或者未设置，则整个参数替换表达式值为word
${parameter:offset}
${parameter:offset:length}
#parameter的值的子字符串。

#${}带！有下面几种表达式：
${!prefix*}
${!prefix@}
#将带有前缀为prefix的参数名打印出来
${!name[@]}
${!name[*]}
#这个是针对name数组的，打印出来name数组有哪些下标

#${}带正则匹配的几种表达式：
${parameter#word}
${parameter##word}
#从头开始扫描word，将匹配word正则表达的字符过滤掉, #为最短匹配, ##为最长匹配
${parameter%word}
${parameter%%word}
#从尾开始扫描word，将匹配word正则表达式的字符过滤掉, %为最短匹配，%%为最长匹配
${parameter/pattern/string}
${parameter//pattern/string}
将parameter对应值的pattern字符串替换成为string字符串, /表示只替换一次, //表示全部替换
