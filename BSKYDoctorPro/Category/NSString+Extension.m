//
//  NSString+Extension.m
//  Dingding
//
//  Created by 陈欢 on 14-2-27.
//  Copyright (c) 2014年 陈欢. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import "sys/sysctl.h"
#import "RSA.h"

#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1

#endif

@implementation NSString (Extension)

- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString {
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    
    NSInteger prevLength = 0;
    for (NSInteger i = 0; i < [indexes count]; i++) {
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    
    return raw;
}

- (NSString *)urlencode {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)self,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8));
    if (encodedString) {
        return encodedString;
    }
    return @"";
}

- (NSString *)md5String {
    if (!self) {
        return nil;
    }
    const char *original_str = [self UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (unsigned int)strlen(original_str), digist);
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

+ (NSString *)getCurrentDeviceModel {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (BOOL)isEmptyString:(NSString *)string {
    if (string != nil && (id)string != [NSNull null]) {
        return [string isEmpty];
    }
    return YES;
}

+ (BOOL)isNotEmptyString:(NSString *)string {
    return ![NSString isEmptyString:string];
}

+ (NSString *)fromInt:(int)value {
    return [NSString stringWithFormat:@"%d", value];
}

+ (NSString *)fromLonglongInt:(long long int)value {
    return [NSString stringWithFormat:@"%lld", (long long int)value];
}

+ (NSString *)fromInteger:(NSInteger)value {
    return [NSString stringWithFormat:@"%ld", (long)value];
}

+ (NSString *)fromUInteger:(NSUInteger)value {
    return [NSString stringWithFormat:@"%lu", (unsigned long)value];
}

+ (NSString *)fromFloat:(float)value {
    return [NSString stringWithFormat:@"%f", value];
}

+ (NSString *)fromDouble:(double)value {
    return [NSString stringWithFormat:@"%f", value];
}

+ (NSString *)fromBool:(BOOL)value {
    return [NSString stringWithFormat:@"%d", value];
}

- (CGFloat)getDrawWidthWithFont:(UIFont *)font {
    CGFloat width = 0.f;
    
    CGSize textSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect sizeWithFont = [self boundingRectWithSize:textSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:tdic
                                             context:nil];
    
#if defined(__LP64__) && __LP64__
    width = ceil(CGRectGetWidth(sizeWithFont));
#else
    width = ceilf(CGRectGetWidth(sizeWithFont));
#endif
    
    return width;
}

- (CGFloat)getDrawHeightWithFont:(UIFont *)font Width:(CGFloat)width {
    CGFloat height = 0.f;
    
    CGSize textSize = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    CGRect sizeWithFont = [self boundingRectWithSize:textSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:tdic
                                             context:nil];
    
#if defined(__LP64__) && __LP64__
    height = ceil(CGRectGetHeight(sizeWithFont));
#else
    height = ceilf(CGRectGetHeight(sizeWithFont));
#endif
    
    return height;
}

+ (CGFloat)fontHeight:(UIFont *)font {
    CGFloat height = 0.f;
    
    NSString *fontString = @"臒";
    CGSize textSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect sizeWithFont = [fontString boundingRectWithSize:textSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:tdic
                                                   context:nil];
    
#if defined(__LP64__) && __LP64__
    height = ceil(CGRectGetHeight(sizeWithFont));
#else
    height = ceilf(CGRectGetHeight(sizeWithFont));
#endif
    
    return height;
}

- (BOOL)isEmpty {
    return ![self isNotEmpty];
}

- (BOOL)isNotEmpty {
    if (self != nil
        && ![self isKindOfClass:[NSNull class]]
        && (id)self != [NSNull null]
        && [[self trimWhitespace] length] > 0) {
        return YES;
    }
    return NO;
}

- (NSInteger)actualLength {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:encoding];
    return [data length];
}

- (NSString *)trimWhitespace {
    NSString *string = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimLeftAndRightWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimHTMLTag {
    NSString *html = self;
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return [html trimWhitespace];
}

- (BOOL)isWhitespace {
    return [self isEmpty];
}

- (BOOL)isChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isMatchesRegularExp:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isEmail {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)URLRegularExp {
    static NSString *urlRegEx = @"((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+[\\w\\d:#@%/;$()~_?\\+-=\\\\.&]*)";
    return urlRegEx;
}

- (BOOL)isURL {
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [self URLRegularExp]];
    return [urlTest evaluateWithObject:self];
}

- (NSArray *)URLList {
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:[self URLRegularExp]
                                                                         options:NSRegularExpressionAnchorsMatchLines | NSRegularExpressionDotMatchesLineSeparators
                                                                           error:nil];
    NSArray *matches = [reg matchesInString:self
                                    options:NSMatchingReportCompletion
                                      range:NSMakeRange(0, self.length)];
    
    NSMutableArray *URLs = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *result in matches) {
        [URLs addObject:[self substringWithRange:result.range]];
    }
    return URLs;
}

- (BOOL)isLandlineNumber {
    NSString *regex = @"((^0(10|2[0-9]|\\d{2,3})){0,1}-{0,1}(\\d{6,8}|\\d{6,8})$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    if (self.length < 11 || self.length > 11) {
        return NO;
    }
    NSString *regex = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
- (BOOL)isNumText{
    NSString *inputString = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(inputString.length > 0) {
        return NO;
    } else {
        return YES;
    }
}
- (BOOL)isIdCard
{
    if (self.length != 18) {
        NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:self];
        return isMatch;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:self]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [self substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(self.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[self substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[self substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

- (NSString *)getNumText
{
    NSString *onlyNumStr = [self stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self length])];
    return onlyNumStr;
}
- (NSString *)getNumTextAndDecimalPoint
{
    NSString *onlyNumStr = [self stringByReplacingOccurrencesOfString:@"[^0-9.]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self length])];
    return onlyNumStr;
}

- (BOOL)isZipCode {
    NSString *zipCodeRegEx = @"[1-9]\\d{5}$";
    NSPredicate *zipCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegEx];
    return [zipCodeTest evaluateWithObject:self];
}

- (id)jsonObject:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:error];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxsize {
    NSDictionary *attrs = @{ NSFontAttributeName : font };
    return [self boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (NSString *)stringCoverToTime {
    if (![self isNotEmpty]) {
        return @"";
    }
    
    NSInteger mins = [self integerValue];
    
    NSInteger hours = mins / 3600;
    NSInteger minss = (mins - hours * 3600) / 60;
    NSInteger ss = (mins - hours * 3600 - minss * 60) % 60;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"mm:ss"];
    //NSDate *date = [NSDate dateWithTimeIntervalSinceNow:mins];
    NSMutableString *timeString = [NSMutableString string];
    if (hours <=0) {
        
    }else{
        [timeString appendFormat:@"0%ld:",hours];
    }
    
    if (minss < 10 && minss > 0) {
        [timeString appendFormat:@"0%ld:",minss];
    }else if (minss >= 10){
        [timeString appendFormat:@"%ld:",minss];
    }else{
        [timeString appendString:@"00:"];
    }
    
    if (ss < 10 && ss > 0) {
        [timeString appendFormat:@"0%ld",ss];
    }else if (ss >= 10){
        [timeString appendFormat:@"%ld",ss];
    }else if (ss == 0){
        [timeString appendString:@"00"];
    }
    
    //    NSDate *date = [NSDate dateWithTimeInterval:mins sinceDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //    if (mins / 3600 >= 1) {
    //        [formatter setDateFormat:@"HH:mm:ss"];
    //    }else{
    //        [formatter setDateFormat:@"mm:ss"];
    //    }
    return timeString;
}

- (CGSize)calculateSizeWithText:(CGFloat)font
{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return adjustedSize;
}
- (NSString *)replaceWithKeyWord:(NSString *)regString replace:(NSString *)str {
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:regString options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *resultString =  [regExpression stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:str];
    return resultString;
}

+ (NSString *)convertNewsTime:(NSDate *)date {
    // 根据当地时间把时间戳转为当地时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
    // 实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *today = [[NSDate alloc] init];
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *dateString = [[localeDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]) {
        // 显示小时分钟
        // 设定时间格式
        [dateFormatter setDateFormat:@"HH:mm"];
    } else {
        NSString *todayYearString = [[today description] substringToIndex:4];
        NSString *dateYearString = [[localeDate description] substringToIndex:4];
        
        if ([dateYearString isEqualToString:todayYearString]) {
            // 显示月和日
            // 设定时间格式
            [dateFormatter setDateFormat:@"MM-dd"];
        } else {
            // 显示年月日
            // 设定时间格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
    }
    
    return [dateFormatter stringFromDate:date];
}
- (NSString *)convertDateStringWithTimeStr:(NSString *)formatter
{
    NSTimeInterval time=[self doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
+ (NSString *)toBinary:(NSInteger)input
{
    if (input == 1 || input == 0) {
        return [NSString stringWithFormat:@"%ld", (long)input];
    }
    else {
        return [NSString stringWithFormat:@"%@%ld", [self toBinary:input / 2], input % 2];
    }
}
//传身份证返回生日字符串
-(NSString *)birthdayStrFromIdentityCard{
    
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([self length]<14)
        return result;
    
    if ([self length] == 15) {
        //**截取前12位
        NSString *fontNumer = [self substringWithRange:NSMakeRange(0, 11)];
        
        //**检测前12位否全都是数字;
        const char *str = [fontNumer UTF8String];
        const char *p = str;
        while (*p!='\0') {
            if(!(*p>='0'&&*p<='9'))
                isAllNumber = NO;
            p++;
        }
        
        if(!isAllNumber)
            return result;
        
        year = [self substringWithRange:NSMakeRange(6, 2)];
        month = [self substringWithRange:NSMakeRange(8, 2)];
        day = [self substringWithRange:NSMakeRange(10,2)];
        
        [result appendString:[NSString  stringWithFormat:@"19%@",year]];
        [result appendString:@"-"];
        [result appendString:month];
        [result appendString:@"-"];
        [result appendString:day];
        return result;
    }else if ([self length] == 18){
        //**截取前14位
        NSString *fontNumer = [self substringWithRange:NSMakeRange(0, 13)];
        
        //**检测前14位否全都是数字;
        const char *str = [fontNumer UTF8String];
        const char *p = str;
        while (*p!='\0') {
            if(!(*p>='0'&&*p<='9'))
                isAllNumber = NO;
            p++;
        }
        
        if(!isAllNumber)
            return result;
        
        year = [self substringWithRange:NSMakeRange(6, 4)];
        month = [self substringWithRange:NSMakeRange(10, 2)];
        day = [self substringWithRange:NSMakeRange(12,2)];
        
        [result appendString:year];
        [result appendString:@"-"];
        [result appendString:month];
        [result appendString:@"-"];
        [result appendString:day];
        return result;
    }
    return result;
    
}
//由身份证号返回为性别
-(NSString *)sexStrFromIdentityCard{
    NSString *result = nil;
    
    BOOL isAllNumber = YES;
    
    if(!([self length]==18 || [self length]==15))
        return result;
    
    //**截取第17/14为性别识别符
    NSString *fontNumer = @"";
    if (self.length == 18) {
        fontNumer = [self substringWithRange:NSMakeRange(16, 1)];
    } else {
        fontNumer = [self substringWithRange:NSMakeRange(14, 1)];
    }
    
    //**检测是否是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    
    if(!isAllNumber)
        return result;
    
    int sexNumber = [fontNumer intValue];
    if(sexNumber%2==1)
        result = @"1";
    ///result = @"M";
    else if (sexNumber%2==0)
        result = @"2";
    //result = @"F";
    
    return result;
    
}
-(NSString *)secretStrFromIdentityCard
{
    if (self.length < 15) {
        return self;
    }
    else
    {
        NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(3, 11)];
        NSString *str = [self replaceCharactersAtIndexes:@[rangeValue] withString:@"***********"];
        return str;
    }
}
- (NSString *)secretStrFromPhoneStr
{
    if (self.length < 7) {
        return self;
    }
    NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(3, 4)];
    NSString *str = [self replaceCharactersAtIndexes:@[rangeValue] withString:@"****"];
    return str;
}
+ (NSString *)getMoneyStringWithMoneyNumber:(double)money{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    // 设置格式
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    return formattedNumberString;
}

+ (NSString *)idCardStrByReplacingCharactersWithAsterisk:(NSString *)str {
    NSInteger length = str.length;
    for (int i = 3; i<length-4; i++) {
        str = [str stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return str;
}
- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
//判断字符串是否为浮点数
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
// 去掉括号及包含的字符
- (NSString *)deleteBracketsString{
    NSMutableString * muStr = [NSMutableString stringWithString:self];
    while (1) {
        NSRange range = [muStr rangeOfString:@"("];
        NSRange range1 = [muStr rangeOfString:@")"];
        if (range.location != NSNotFound) {
            NSInteger loc = range.location;
            NSInteger len = range1.location - range.location;
            [muStr deleteCharactersInRange:NSMakeRange(loc, len + 1)];
        }else{
            break;
        }
    }
    return [NSString stringWithString:muStr];
}
- (BOOL )validationEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:self]){
//        NSLog(@"恭喜！您输入的邮箱验证合法");
        return YES;
    }
    return NO;
}
/*
 QQ 第一位1~9 位数4~14位（其他位0~9）
 WX 字母开头  位数5~19位 （其他位数字字母"-"）
 邮编  第一位1~9 位数6位（其他位0~9）
 健康卡 第一位1~9 位数4~14位（其他位0~9）
 */
- (BOOL )validationQQ{
    NSString *emailRegex = @"[1-9][0-9]{4,14}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:self]){
        //        NSLog(@"恭喜！您输入的邮箱验证合法");
        return YES;
    }
    return NO;
}
- (BOOL )validationWX{
    NSString *emailRegex = @"^[a-zA-Z][a-zA-Z0-9_-]{5,19}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:self]){
        //        NSLog(@"恭喜！您输入的邮箱验证合法");
        return YES;
    }
    return NO;
}
- (BOOL )validationPostCode{
    NSString *emailRegex = @"^[1-9][0-9]{5}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:self]){
        //        NSLog(@"恭喜！您输入的邮箱验证合法");
        return YES;
    }
    return NO;
}
- (BOOL )validationHealthCard{
    NSString *emailRegex = @"[1-9][0-9]{4,14}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:self]){
        //        NSLog(@"恭喜！您输入的邮箱验证合法");
        return YES;
    }
    return NO;
}
- (NSString *)upperFirstString{
    NSString *firstStr = [self substringToIndex:1];
    NSString *upperStr = [firstStr uppercaseString];
    NSString *upperFirstStr = [self stringByReplacingOccurrencesOfString:firstStr withString:upperStr];
    return upperFirstStr;
}
/**
根据省份证号获取年龄
**/
-(NSString *)getIdentityCardAge
{
    
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
    [formatterTow setDateFormat:@"yyyy-MM-dd"];
    NSDate *bsyDate = [formatterTow dateFromString:[self birthdayStrFromIdentityCard]];
    
    NSTimeInterval dateDiff = [bsyDate timeIntervalSinceNow];
    
    int age = trunc(dateDiff/(60*60*24))/365;
    
    return [NSString stringWithFormat:@"%d",-age];
}
/**
 aes cbc 解密
 **/
- (NSString *)decryptCBCStr{
    
    NSString *key = [BSAppManager sharedInstance].cbcKey;
    if (self.length && key.length && [BSAppManager sharedInstance].needEncryption.boolValue) {
        NSString *value = [AES128Helper AES128DecryptCBC:self key:key gIv:[BSClientManager sharedInstance].gIv];
        if (value.length) {
            return value;
        }else{
            return self;
        }
    }else{
        return self;
    }
    
}
/**
 aes cbc 加密
 **/
- (NSString *)encryptCBCStr{
    NSString *key = [BSAppManager sharedInstance].cbcKey;
    if (self.length && key.length && [BSAppManager sharedInstance].needEncryption.boolValue) {
        NSString *value = [AES128Helper AES128EncryptCBC:self key:key gIv:[BSClientManager sharedInstance].gIv];
        if (value.length) {
            return value;
        }else{
            return self;
        }
    }else{
        return self;
    }
    
}
/**
 随机生成字符串
 **/
+ (NSString *)randomStringWithLength:(NSInteger)len String:(NSString *)letters{
    if (!letters.length) {
        letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    }
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    return randomString;
}
/**
 rsa 加密
 **/
- (NSString *)enctryptRSAStr{
    NSString *key = [BSAppManager sharedInstance].publicKey;
    if (key.length) {
        return  [RSA encryptString:self publicKey:[BSAppManager sharedInstance].publicKey];
    }else{
        return self;
    }
}
/**
 rsa 加密 cbc 密钥
 **/
+ (NSString *)enctryptCBCKeyWithRSA{
    NSString *key = [BSAppManager sharedInstance].publicKey;
    if (key.length) {
        return  [RSA encryptString:[BSAppManager sharedInstance].cbcKey publicKey:[BSAppManager sharedInstance].publicKey];
    }else{
        return [BSAppManager sharedInstance].cbcKey;
    }
}
@end
