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


//校验密码
+(NSString *)validatePassword:(NSString *)pwd{
    NSString * str1 = [NSString stringWithFormat:@"^[a-zA-Z]{0,%d}$",(int)pwd.length];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str1];
    if ([predicate2 evaluateWithObject:pwd] == YES) {
        return @"密码格式错误，密码需由字母与数字混合组成";
    }
    if ([self validateIsNumber:pwd]) {
        return @"密码格式错误，密码需由字母与数字混合组成";
    }
    NSString *regx=[NSString stringWithFormat:@"^[a-zA-Z0-9\u4e00-\u9fa5]{0,%d}$",(int)pwd.length];
    NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    if([predicate4 evaluateWithObject:pwd]==NO){
        return @"密码不能包含特殊符号，请使用字母与数字组合的密码";
    }
    return nil;
}


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
+ (BOOL)validateNumber:(NSString *)num
{
    NSString *userNameRegex = @"^\\d+(\\.\\d+)?$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:num];
    return B;
}

//校验字符串是否为纯数字
+(BOOL)validateIsNumber:(NSString *)string{
    NSString * numberString=[NSString stringWithFormat:@"^[0-9]{0,%d}$",(int)string.length];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberString];
    return [predicate evaluateWithObject:string];
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
