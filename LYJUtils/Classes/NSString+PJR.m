//
//  NSString+PJR.m
//  xyx-zhihu-ios-framework
//
//  Created by loirou on 2018/5/11.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import "NSString+PJR.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (PJR)



- (NSDictionary*)toJSONObject
{
    NSDictionary *jsonObject = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    return jsonObject;
}


- (NSString *)removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

- (NSString *)md5String
{
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;

}





+ (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
    
}



@end
