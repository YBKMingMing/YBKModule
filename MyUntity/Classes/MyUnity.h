//
//  MyUnity.h
//  LYRPJ
//
//  Created by icl-network on 14-4-15.
//
//

#import <Foundation/Foundation.h>

@interface MyUnity : NSObject


+(NSString *)validatePassword:(NSString *)pwd;
+(BOOL)theStringIsNull:(NSString *)string;
+ (void)setSpecifiedViewHeight:(id)sender withHeight:(CGFloat)height;
+ (BOOL) validateNumber:(NSString *)num;
+(NSString *)jsonToString:(id)json options:(NSJSONWritingOptions)options;



@end
