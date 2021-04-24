BEGIN {
    FS =","
    print "\n公民身份证号信息查询awk源程序！"
    print "如果号码真实，则尽量给出可靠信息"
    print "如果号码虚假，则尽量给出诊断信息"
    print "--------------------------------"
    print "查询到该公民身份证信息如下：\n"
    num = ARGV[2]
    print "身份证号\t"num
    # 输出地址错误
    if (substr(num,1,2) == "00") {
        print "该身份证号有问题！地址区域直辖市/省/自治区两位为零"
    }
    if (substr(num,3,2) == "00") {
        print "该身份证号有问题！地址区域市辖区/市两位为零"
    }
    if (substr(num,5,2) == "00") {
        print "该身份证号有问题！无区/县地址"
    }
    #校验码检查 
    sx = substr(num,15,3) # 顺序码3位
    sxl = substr(sx,3,1) # 顺序码最后一位
    jy = substr(num,18,1) # 校验码
    if (jy == "x") jy = "X" # 校验码为x/X时转换为10
    if (jy == "X") jy = "10"
    # 检查出生日期码是否合法
    # https://www.includehelp.com/c-programs/validate-date.aspx
    csrq = substr(num,7,8) # 出生日期码
    yy = substr(csrq,1,4)+0 # 出生年
    mm = substr(csrq,5,2)+0 # 出生月
    dd = substr(csrq,7,2)+0 # 出生日

    if(yy>=1900 && yy<=9999)
    {
        #check month
        if(mm>=1 && mm<=12)
        {
            #check days
            if ((dd>=1 && dd<=31) && (mm==1 || mm==3 || mm==5 || mm==7 || mm==8 || mm==10 || mm==12)) ;
            else if ((dd>=1 && dd<=30) && (mm==4 || mm==6 || mm==9 || mm==11)) ;
            else if ((dd>=1 && dd<=28) && (mm==2)) ;
            else if (dd==29 && mm==2 && (yy%400==0 ||(yy%4==0 && yy%100!=0))) ;
            else {
                printf("该身份证号有问题！日不对\n");
            }
        }
        else
        {
            printf("该身份证号有问题！月份不对\n");
        }
    }
    else
    {
        printf("该身份证号有问题！年不对\n");
    }
    # 检查顺序码，顺序码最后一位为奇数/偶数时判断男女
    if (sxl % 2 == 0) {
        print "性别\t女"
    }
    else {
        print "性别\t男"
    }
}

{
    # 输出地址
    num = ARGV[2]
    dz1_6 = substr(num,1,6) # 县级
    dz1_4 = substr(num,1,4)"00" # 直辖市级
    dz1_2 = substr(num,1,2)"0000" # 自治区级


    if (dz1_2 == $1 && $3 == "1") {
        dzq = $2
        printf "地址\t%s", dzq
    }
    if (dz1_4 == $1 && $3 == "2") {
        dzs = $2
        printf "%s", dzs
    }
    if (dz1_6 == $1 && $3 == "3") {
        dzx = $2
        printf "%s\n", dzx
    }
}

END {
}
