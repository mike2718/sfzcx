BEGIN {     
    FS =","
    print "\n公民身份证号信息查询awk源程序"
    print "-----------------------------"
    print "查询到该公民身份证信息如下：\n"
}

{
    # ARGV[2]
    num = "11010519491231002X"

    dz = substr(num,1,6) # 地址码
    csrq = substr(num,7,8) # 出生日期码
    csn = substr(csrq,1,4) # 出生年
    csy = substr(csrq,5,2) # 出生月
    csr = substr(csrq,7,2) # 出生日
    sx = substr(num,15,3) # 顺序码
    jy = substr(num,18,1) # 校验码
    #print dz "\t"csrq "\t"sx "\t"jy "\t\t"csn "\t"csy "\t"csr
    # 检查地址码
    if (dz == $1) {
        print "地址："$2
    }
    # 检查出生日期码
    # 检查顺序码
    sx3 = substr(sx,2,1)
    if (sx3 % 2 == 0) {
        print "性别：女"
    }
    else {
        printf "性别：男"
    }
    # 检查校验码
}

END {
}
