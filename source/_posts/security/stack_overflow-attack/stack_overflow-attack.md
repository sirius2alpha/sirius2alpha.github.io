---
title: 栈溢出攻击
catalog: true
date: 2023-05-05 13:40
subtitle: 使用ollydbg进行反汇编调试
lang: cn
header-img: /img/header_img/lml_bg2.jpg
# sticky: 100  # 置顶功能
tags:
- information security 
- ollydbg
- attack
---
实验程序源代码：

```c
#include <stdio.h>
#include <windows.h>
#include <string.h>
#include <stdlib.h>
#define PASSWORD "1234567"
int verify_password(char *password)
{
    int authenticated;
    char buffer[44];
    authenticated = strcmp(password, PASSWORD);
    strcpy(buffer, password); // over flowed here!
    return authenticated;
}
int main()
{
    int valid_flag = 0;
    char password[1024];l
    FILE *fp;
    LoadLibrary("user32.dll"); // prepare for messagebox
    if (!(fp = fopen("password.txt", "rw+")))
    {
        exit(0);
    }
    fscanf(fp, "%s", password);
    valid_flag = verify_password(password);
    if (valid_flag)
    {
        printf("incorrect password!\n");
    }
    else
    {
        printf("Congratulation! You have passed the verification!\n");
    }
    fclose(fp);
    system("pause");l
    return 0;
}
```

在这个实验中，将buffer数组的大小扩大到了44个字节。

大致步骤：

（1）分析并调试漏洞程序，获得淹没返回地址的偏移。
（2）获得buffer 的起始地址，并将其写入password.txt 的相应偏移处，用来冲刷返回地址。
（3）向password.txt 中写入可执行的机器代码，用来调用API 弹出一个消息框。



#### **第一步：调试栈的布局**

​		调试漏洞程序，在password.txt根据buffer数组的大小编写11个4321，刚好到达buffer数组末尾。

​		第12 个输入单元将authenticated 覆盖；第13 个输入单元将前栈帧EBP 值覆盖；第14 个输入单元将返回地址覆盖。

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682492206.png" alt="image-20230426145646254" style="zoom:67%;" />

​		在ollydbg中调试exe文件之后，在堆栈区中搜索4321相关字符串内容，就能够找到他的地址开始分析。

​		找到buffer数组的地址为**0x0019FB30**，作为之后的覆盖的返回地址，在buffer数组中存入植入代码。在上面的截图可以看到0019FB5C中的内容最后的两位为00，这里其实就是authenticated的内容，00是上面的字符串最后的结束符NULL的ASCII码。本来strcmp()函数在遇到不相等的时候返回到是一个非0的数，只有当匹配成功的时候才返回0，这里就是被溢出修改了。

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682492297.png" alt="image-20230426145816927" style="zoom:50%;" />

按照理论来说，后面三个字节的地址应该为authenticated, EBP, 返回地址的地址。



#### **第二步：查找MessageBoxA的入口地址**

获得user32.dll的加载基址，以此加上MessageBoxA的文件偏移量来计算MessageBoxA的入口地址。



使用Process Explore找到了user32.dll的加载地址：0x00007FF8C0D80000（其实不是这个，往后面看）

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682493891.png" alt="image-20230426152450991" style="zoom:50%;" />



在64位系统中查看MessageBoxA的偏移地址：

1. 在C:\Windows\system32目录下使用dumpbin命令来查看user32.dll文件的导出表：`dumpbin /exports user32.dll`
2. 在导出表中查找`MessageBoxA`函数，RVA为0x00078A40

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682494627.png" alt="image-20230426153707360" style="zoom: 50%;" />

所以MessageBoxA的入口为：0x00007FF8C0D80000 + 0x00078A40 = 0x00007FF8C0DF8A40。这里有些**不太正确**的地方，因为程序本身是32位的程序，所以这个user32.dll的基址不应该是这个。

在64位系统上运行32位程序需要使用**WoW64子系统**，该子系统允许在64位操作系统中运行32位应用程序。要在WoW64中调用user32.dll模块中的MessageBoxA函数，需要使用**32位版本的user32.dll模块**。



然后我又用Process Explore重新查找了`C:\Windows\SysWOW64`下面的user32.dll的基址和RVA

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682495946.png" alt="image-20230426155906250" style="zoom:50%;" />

32-bit的user32.dll加载基址为：0x0000000075230000，偏移地址还是和64-bit版本一样的为：0x00078A40，所以MessageBoxA在这个32位程序中的入口地址为：0x0000000075230000 + 0x00078A40 = 0x00000000**752A8A40**。

0x00000000764C0000

在32位程序中将0x752A8A40作为MessageBoxA函数的入口点地址来调用该函数。



#### 第三步：编写16进制的API函数

16进制可执行代码和对应的汇编码：

![image-20230426165712822](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682499432.png)

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682499368.png" alt="image-20230426165607891" style="zoom:67%;" />img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682518982.png" alt="image-20230426222300604" style="zoom: 67%;" />



<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682501367.png" alt="image-20230426172927315" style="zoom: 50%;" />

这4位是填写MessageBoxA的入口地址

![image-20230426164829928](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682498910.png)

最后4位是buffer数组的入口地址

![image-20230426164633693](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682498793.png)

更改弹出窗口的文字为Cracked!，找到对应的ASCII码，68是PUSH指令

![image-20230426171036378](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682500236.png)

![image-20230426170938050](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682500178.png)



最后完成的截图

![image-20230426171132480](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/04/upgit_20230426_1682500292.png)



注：重启完电脑之后好像user32.dll的基址可能会发生变更，需要使用Process Explore查看，并与偏移量进行计算，重新得到加载地址，password.txt中需要更改的位置为第二行中FF前面四位。

