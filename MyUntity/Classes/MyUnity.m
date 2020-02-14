//
//  MyUnity.m
//  LYRPJ
//
//  Created by icl-network on 14-4-15.
//
//

#import "MyUnity.h"


//客户测试站
//#define WBB_APPKEY @"appKey=key;appSc=9ca6aa5c70dd72de;"

#define WBB_APPKEY @"appKey=key;appSc=sc;"
//icl测试站
//#define WBB_APPKEY @"appKey=key;appSc=sc;"

//季帆本地
//#define WBB_APPKEY @"appKey=key20171211110730;"

@implementation MyUnity


//字符串非空验证
+(BOOL)theStringIsNull:(NSString *)string{
    if(string == nil || (NSNull *)string == [NSNull null] || [string isEqualToString:@""] || [string isEqualToString:@"null"]){
        return true;
    }
    return false;
}


//设置指定视图的高度
+ (void)setSpecifiedViewHeight:(id)sender withHeight:(CGFloat)height{
    for (NSLayoutConstraint *constraint in [sender constraints]) {
        if ([constraint class] == [NSLayoutConstraint class] && constraint.firstItem == sender && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
            break;
        }
    }
}

///验证数字
+ (BOOL) validateNumber:(NSString *)num
{
    NSString *userNameRegex = @"^\\d+(\\.\\d+)?$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:num];
    return B;
}


//json 转字符串
+(NSString *)jsonToString:(id)json options:(NSJSONWritingOptions)options
{
    NSError *error;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    } else {
        jsonData = [NSJSONSerialization dataWithJSONObject:json options:options error:&error];
    }
    if (error) {
        NSLog(@"%@", error);
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}






@end
