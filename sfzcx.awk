BEGIN {     
    FS =","
    print "\n公民身份证号信息查询awk源程序"
    print "-----------------------------"
    print "查询到该公民身份证信息如下：\n"
    num = ARGV[2]
    print "身份证号\t"num
    csrq = substr(num,7,8) # 出生日期码
    csn = substr(csrq,1,4) # 出生年
    csy = substr(csrq,5,2) # 出生月
    csr = substr(csrq,7,2) # 出生日
    sx = substr(num,15,3) # 顺序码
    sxl = substr(num,17,1) # 顺序码
    jy = substr(num,18,1) # 校验码
    if (jy == "x") jy = "X" # 校验码为x/X时转换为10
    if (jy == "X") jy = "10"
    # 检查出生日期码
    # 检查顺序码，顺序码最后一位为奇数/偶数时判断男女
    if (sxl % 2 == 0) {
        print "性别\t女"
    }
    else {
        print "性别\t男"
    }
}

{
    num = ARGV[2]
    dz = substr(num,1,6) # 地址码
    if (dz == $1) {
        print "地址\t"$2
    }
    # 检查出生日期码
    # 检查校验码
    #print dz "\t"csrq "\t"sx "\t"jy "\t\t"csn "\t"csy "\t"csr"\t"sxl
}

END {
}
