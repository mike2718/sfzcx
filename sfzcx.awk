BEGIN {
    FS =","
    print "\n公民身份证号信息查询awk源程序！"
    print "  如果输入真实号码，则给出分析信息"
    print "  如果输入不明号码，则给出诊断信息"
    print "-------------------------------------------------------"
    do {
        printf "请输入要查询的公民身份证号（18位）："
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
    } while (length(num) != 18 || num !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9xX]$/)
    print "查询的身份证号："num
    print "\n查询到该公民身份证信息如下：\n"
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
    #校验码检查 
    sx = substr(num,15,3) # 顺序码3位
    jy = substr(num,18,1) # 校验码
    if (jy == "x") jy = "X" # 校验码为x/X时转换为10
    if (jy == "X") jy = "10"
    # 检查出生日期码是否合法
    # https://www.includehelp.com/c-programs/validate-date.aspx
    csrq = substr(num,7,8) # 出生日期码
    yy = substr(csrq,1,4)+0 # 出生年
    mm = substr(csrq,5,2)+0 # 出生月
    dd = substr(csrq,7,2)+0 # 出生日
    ################### 可能要经常更新
    date = 2021 # 当前年
    ################### 可能要经常更新
    # https://en.wikipedia.org/wiki/Oldest_people
    old = date - 118 # 最老者的出生年

    if(yy>=old && yy<=date)
    {
        printf("[●] 出生日期码的年部分有效\n");
    }
    if(yy<old)
    {
        printf("[○] 该身份证号有问题！该年份(%s)出生的持有者很可能已经死亡\n", yy);
    }
    if(yy>date)
    {
        printf("[×] 该身份证号有问题！出生日期码的年(%s)晚于当前年(%s)，该持有者不可能办得身份证\n", yy, date);
    }
    if(mm>=1 && mm<=12) {
        printf("[●] 出生日期码的月部分有效\n");
    }
    if (mm<1 || mm>12) {
        printf("[×] 该身份证号有问题！出生日期码的月(%s)超出范围(01~12)\n", mm);
    }
    if(mm)
    {
        #check days
        if ((dd>=1 && dd<=31) && (mm==1 || mm==3 || mm==5 || mm==7 || mm==8 || mm==10 || mm==12))
            printf("[●] 出生日期码的日部分有效\n");
        else if ((dd>=1 && dd<=30) && (mm==4 || mm==6 || mm==9 || mm==11))
            printf("[●] 出生日期码的日部分有效\n");
        else if ((dd>=1 && dd<=28) && (mm==2))
            printf("[●] 出生日期码的日部分有效\n");
        else if (dd==29 && mm==2 && (yy%400==0 ||(yy%4==0 && yy%100!=0)))
            printf("[●] 出生日期码的日部分有效\n");
        else
            printf("[×] 该身份证号有问题！出生日期码的日(%s)不符合日期的月日规律\n", dd);
    }
    # 检查顺序码，顺序码最后一位，判断男女
    sx = sx + 0
    if (sx % 2 == 0) {
        print "[●] 性别\t女"
    }
    else {
        print "[●] 性别\t男"
    }
}

{
    # 输出地址
    dz1_6 = substr(num,1,6) # 县级
    dz1_4 = substr(num,1,4)"00" # 直辖市级
    dz1_2 = substr(num,1,2)"0000" # 自治区级

    if (dz1_2 == $1 && $3 == "1") {
        dzq = $2
        fq = 1
        printf "[●] 地址\t%s", dzq
    }
    if (dz1_4 == $1 && $3 == "2" && fq) {
        dzs = $2
        fs = 1
        printf "%s", dzs
    }
    if (dz1_6 == $1 && $3 == "3" && fq && fs) {
        dzx = $2
        fx = 1
        printf "%s\n", dzx
    }
}

END {
    print ""
}

