# 公民身份证信息查询awk源程序

程序行为：

- 如果输入号码为真实号码，则尽可能给出详细分析
- 如果输入号码为虚假号码，则对于真实and/or虚假部分分别给出详细分析

程序运行上基本按照标准GB 11643-1999。

写程序的动机：

由于自己的乙方签协议时给出了有问题的身份证号，导致提起诉讼时各种麻烦，
于是想到做一个身份证号真伪判断的程序。

## 依赖
- [One true awk](https://github.com/onetrueawk/awk) 版本 >= 20210215
- [GB/T 2260 codes for the administrative divisions of the People's Republic of China](https://github.com/khaeru/gb2260)
