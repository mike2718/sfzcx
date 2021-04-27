BEGIN {
    FS =","
    print "\n公民身份证号信息查询awk源程序！"
    print "  如果输入真实号码，则给出分析信息"
    print "  如果输入不明号码，则给出诊断信息"
    print "-------------------------------------------------------"
    do {
        printf("请输入要查询的公民身份证号（18位）：")
        getline num < "-"
        if (length(num) > 18) {
            print "输入的公民身份证号长度大于18位，请重新输入"
        }
        if (length(num) < 18) {
            print "输入的公民身份证号长度小于18位，请重新输入"
        }
        if(num !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9xX]$/) {
            print "输入的公民身份证号包含不合法的字符，请重新输入"
        }
    } while (num !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9xX]$/)
    print "查询的身份证号：" num
    printf("\n查询到该公民身份证信息如下：\n")
    # 输出地址错误
    if (substr(num,1,2) == "00") {
        print "[×] 该身份证号有问题！地址区域直辖市/省/自治区两位为零"
    }
    if (substr(num,3,2) == "00") {
        print "[×] 该身份证号有问题！地址区域市辖区/市两位为零"
    }
    if (substr(num,5,2) == "00") {
        print "[×] 该身份证号有问题！无区/县地址"
    }
    sx = substr(num,15,3) # 顺序码3位
    jy = substr(num,18,1) # 校验码
    if (jy == "x") jy = "X" # 校验码为x/X时转换为"10"
    if (jy == "X") jy = "10"
    # 检查出生日期码是否合法
    # https://www.includehelp.com/c-programs/validate-date.aspx
    csrq = substr(num,7,8) # 出生日期码
    yy = substr(csrq,1,4)+0 # 出生年
    mm = substr(csrq,5,2)+0 # 出生月
    dd = substr(csrq,7,2)+0 # 出生日
    ################### 可能要经常更新
    this_y = 2021       # 当前年
    ################### 可能要经常更新
    # ~ 1862 ~ 1899 ~ 2021 (现在)
    # https://en.wikipedia.org/wiki/Oldest_people
    old = 1862 # 1984 - 122 最老者的出生年

    if(yy>=old && yy<=9999)
    {
        printf("[●] 出生日期码的年有效\n");
    }
    if (yy <= old) { # 第一代首次派发年-最长寿者年龄
        printf("[×] 该身份证号有问题！在该年(%s)出生的持有者在第一代身份证开始派发时已经死亡\n", yy);
    }
    if ((yy <= (this_y - 122)) && (yy > old)) {
        printf("[▲] 该身份证可能已经失效！在该年(%s)出生的持有者很可能已经死亡\n", yy);
    }
    if(yy>this_y)
    {
        printf("[×] 该身份证有问题！出生日期码的年(%s)晚于当前年(%s)，该持有者不可能办得身份证\n", yy, this_y);
    }
    if(mm>=1 && mm<=12) {
        mmv = 1
        print "[●] 出生日期码的月有效"
    }
    if (mm<1 || mm>12) {
        printf("[×] 该身份证号有问题！出生日期码的月(%s)超出范围(01~12)\n", mm);
    }
    if(mm)
    {
        #check days
        if ((dd>=1 && dd<=31) && (mm==1 || mm==3 || mm==5 || mm==7 || mm==8 || mm==10 || mm==12)) {
            ddv = 1
            print "[●] 出生日期码的日有效"
        }
        else if ((dd>=1 && dd<=30) && (mm==4 || mm==6 || mm==9 || mm==11)) {
            ddv = 1
            print "[●] 出生日期码的日有效"
        }
        else if ((dd>=1 && dd<=28) && (mm==2)) {
            ddv = 1
            print "[●] 出生日期码的日有效"
        }
        else if (dd==29 && mm==2 && (yy%400==0 ||(yy%4==0 && yy%100!=0))) {
            ddv = 1
            print "[●] 出生日期码的日有效"
        }
        else {
            printf("[×] 该身份证号有问题！出生日期码的日(%s)不符合日期的月日规律\n", dd);
        }
    }
    arr[1] = "虎"
    arr[2] = "兔"
    arr[3] = "龙"
    arr[4] = "蛇"
    arr[5] = "马"
    arr[6] = "羊"
    arr[7] = "猴"
    arr[8] = "鸡"
    arr[9] = "狗"
    arr[10] = "猪"
    arr[11] = "鼠"
    arr[12] = "牛"
    # 计算周岁和生肖
    if (yy && mm && dd) {
        print "[●] 该持有者出生于"yy"年"mm"月"dd"日"
    }
    if((this_y - yy) <= 122) {
        printf("[●] 年龄（周岁）\t%s\n", this_y - yy)
    }
    else {
        printf("[▲] 年龄（周岁）\t%s（可能有问题）\n", this_y - yy)
    }
    printf("[●] 生肖\t%s\n", arr[(12 - (this_y - yy) % 12)])
    # 检查顺序码
    if ((sx + 0) % 2 == 0) {
        print "[●] 性别\t女"
        if ((sx + 0) == 0) {
            print "[●] 该户籍区域内和她同年月日生的女性只有她一个"
        }
        else {
            printf("[●] 该户籍区域内和她同年月日生的女性至少有%s个\n", (sx + 0) / 2)
        }
    }
    else {
        print "[●] 性别\t男"
        if ((sx + 0) == 1) {
            print "[●] 该户籍区域内和他同年月日生的男性只有他一个"
        }
        else {
            printf("[●] 该户籍区域内和他同年月日生的男性至少有%s个\n", int((sx + 0) / 2))
        }
    }
    # 校验码检查 
}

{
    # 找符合的地址
    dz1_6 = substr(num,1,6) # 县级
    dz1_4 = substr(num,1,4)"00" # 直辖市级
    dz1_2 = substr(num,1,2)"0000" # 自治区级

    if ((dz1_2 == $1) && $3 == "1") {
        dzq = $2
    }
    if (dzq && (dz1_4 == $1) && ($3 == "2")) {
        dzs = $2
    }
    if (dzq && dzs && (dz1_6 == $1) && ($3 == "3")) {
        dzx = $2
    }
}

END {
    # 输出找到的地址
    printf("[●] 地址\t%s%s%s\n", dzq, dzs, dzx)
    print ""
}
