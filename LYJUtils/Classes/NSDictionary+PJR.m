//
//  NSDictionary+PJR.m
//  WebWiew
//
//  Created by loirou on 2018/5/11.
//  Copyright © 2018年 loirou. All rights reserved.
//

#import "NSDictionary+PJR.h"

@implementation NSDictionary (PJR)


-(NSString *)toJsonString{
    
    NSString *jsonString = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    if(data){
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
