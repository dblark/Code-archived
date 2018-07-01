# 加密算法的Pascal实现

## DES库

> 到了暑假，总算有时间重构代码了……

将DES的代码改了改，修复了一些陈年漏洞（奇怪的是以前竟没出问题）。

另外，根据hash计算的补位，更加合理的设计了文本和密钥的补位。

函数：

`text`表示要加/解密的文本，`key`表示密钥，`encryption`为`true`是加密、为`false`是解密。

```pas
function DES_64bit(text,key:string;encryption:boolean):string;
```

64位的二进制加密，最原始的DES加密。

```pas
function DES(text,key:ansistring;encryption:boolean):ansistring;
```

DES文本加密。

```pas
function DES_hex(text,key:ansistring;encryption:boolean):ansistring;
```

DES十六进制加密。加密后的文本以十六进制形式显示。