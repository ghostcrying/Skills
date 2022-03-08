## Swift脚本



#### Xcode步骤

1. Menu->File > New > File, 选择osx -> Shell Script, 默认创建Script.sh脚本文件
2. 打开Script.sh, 移除该代码

```
#!/bin/sh

# 这被称为hash bang语法，指定了要用来运行后续代码行的shell在文件系统中的完整路径。这里指定的是/bin/sh（Bash shell）。进行Swift脚本编程时，需要移除这行代码
```

3. 导入Swift代码

```
#!/usr/bin/env xcrun swift
import Foundation
print("Hello World!")
```

4. 运行脚本

```
# 设置脚本文件的权限，使其能够被shell执行
chmod +x Script.sh 
# 运行, ./告诉shell，该脚本位于当前目录中。必须显式地指出这一点，否则shell会找不到脚本
./Script.sh
```



[**参考**](https://www.cnblogs.com/hd1992/articles/5150556.html)

