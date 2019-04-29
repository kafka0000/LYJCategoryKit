//
//  NSString+PJR.h
//  xyx-zhihu-ios-framework
//
//  Created by loirou on 2018/5/11.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PJR)


/**
 *  json串转为字典
 **/
- (NSDictionary*)toJSONObject;//字符串转换成字典

/**
 * 移除空格
 **/
- (NSString *)removeWhiteSpacesFromString;



- (NSString *)md5String;




/**
 *  修改行间距
 **/
+ (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;
@end
