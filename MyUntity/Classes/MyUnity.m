//
//  MyUnity.m
//  LYRPJ
//
//  Created by icl-network on 14-4-15.
//
//

#import "MyUnity.h"
#import "MBProgressHUD.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "AppDelegate.h"
#import "NSData+Base64.h"
#import "NSString+SBJSON.h"
#import "AFURLSessionManager.h"

//客户测试站
//#define WBB_APPKEY @"appKey=key;appSc=9ca6aa5c70dd72de;"

#define WBB_APPKEY @"appKey=key;appSc=sc;"
//icl测试站
//#define WBB_APPKEY @"appKey=key;appSc=sc;"

//季帆本地
//#define WBB_APPKEY @"appKey=key20171211110730;"

@implementation MyUnity

static MBProgressHUD *HUD = nil;

static SGInfoAlert *SGAlert = nil;

//根据指定字符串获取其位置
+(int)IndexOfContainingString:(NSString *)findment FromString:(NSString *)scrString

{
    
    int index = 0;
    int j=0;
    for(int i=1;i<=[scrString length];i++)
        
    {
        
        NSString *tempString =[scrString substringWithRange:NSMakeRange(j, 1)];
        
        if([tempString isEqualToString:findment])
            
        {
            
            index = i;
            
            break;
            
        }
        j++;
        
    }
    
    return index;
    
}

//拨打本地电话
+ (void) showPhone:(NSString *) phoneNum view:(UIWebView*)webview
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"此设备没有打电话功能"
                              message: nil
                              delegate: self
                              cancelButtonTitle: @"关闭"
                              otherButtonTitles: nil];
        
        [alert show];
        
    }
    else
    {
        if(phoneNum.length == 0)
        {
            UIAlertView *tempAlertView = [[UIAlertView alloc]
                                          initWithTitle:@"该联系人号码为空"
                                          message: nil
                                          delegate: nil
                                          cancelButtonTitle: @"关闭"
                                          otherButtonTitles: nil];
            
            [tempAlertView show];
        }
        else
        {
            
            NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]];
            NSLog(@"url is %@",telURL);
            [webview loadRequest:[NSURLRequest requestWithURL:telURL]];
        }
    }
    
}

+(void)showTsView:(id)sender ts:(NSString *)content{
    UIViewController *vv=(UIViewController *)sender;
    if(HUD!=nil){
        [HUD removeFromSuperview];
        HUD=nil;
    }
    if ([sender isKindOfClass:[UIWindow class]]) {
        UIWindow *currentWindow = (UIWindow *)sender;
        HUD = [[MBProgressHUD alloc] initWithWindow:currentWindow];
        [currentWindow addSubview:HUD];
        [currentWindow bringSubviewToFront:HUD];
    }else{
        HUD = [[MBProgressHUD alloc] initWithView:vv.view];
        [vv.view addSubview:HUD];
        [vv.view bringSubviewToFront:HUD];
    }
    HUD.delegate =sender;
    HUD.labelText = content;
    [HUD show:YES];
}

+(void)removeTsView{
    if(HUD!=nil){
        [HUD removeFromSuperview];
    }
}

+ (void) seeFullScreenImage:(NSArray *)picarr atindex:(NSInteger)index
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < [picarr count]; i++) {
        
        if ([[picarr objectAtIndex:i] isKindOfClass:[NSString class]]) {
            NSString *PictureUrl = [picarr objectAtIndex:i];
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:PictureUrl]];
            
            [arr addObject:photo];
        }else if ([[picarr objectAtIndex:i] isKindOfClass:[UIImage class]]) {
            UIImage *PictureImage = [picarr objectAtIndex:i];
            MWPhoto *photo = [MWPhoto photoWithImage:PictureImage];
            
            [arr addObject:photo];
        }
        
    }
    if ([arr count] == 0) {
        return;
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithPhotos:arr];
    [browser setInitialPageIndex:index];
    browser.displayActionButton = YES;
    
    AppDelegate *appUi = [AppDelegate sharedAppDelegate];
    
    UINavigationController *views = (UINavigationController *)appUi.window.rootViewController;
    
    [views presentViewController:browser animated:YES completion:^{
        
    }];
}

+ (int)calc_charsetNum:(NSString*)_str{
    int strlength = 0;
    char* p = (char*)[_str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[_str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

//设置边框
+(void)setBordor:(id)sender color:(UIColor *)bordor{
    if([sender isKindOfClass:[UIView class]]){
        UIView *tview=(UIView *)sender;
        tview.layer.borderColor=bordor.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIButton class]]){
        UIButton *tview=(UIButton *)sender;
        tview.layer.borderColor=bordor.CGColor;
        tview.layer.borderWidth =  1.0f;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UILabel class]]){
        UILabel *tview=(UILabel *)sender;
        tview.layer.borderColor=bordor.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIImageView class]]){
        UIImageView *tview=(UIImageView *)sender;
        tview.layer.borderColor=bordor.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.masksToBounds=YES;
    }
}

//设置圆角
+(void)setYuanJiao:(id)sender{
    if([sender isKindOfClass:[UIView class]]){
        UIView *tview=(UIView *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = 5.0f;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIButton class]]){
        UIButton *tview=(UIButton *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = 5.0f;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UILabel class]]){
        UILabel *tview=(UILabel *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = 5.0f;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIImageView class]]){
        UIImageView *tview=(UIImageView *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = 5.0f;
        tview.layer.masksToBounds=YES;
    }
    
}

//设置圆角及圆角弧度
+(void)setYuanJiao:(id)sender cornerRadius:(CGFloat)cornerRadius{
    if(cornerRadius<=0.0f){
        cornerRadius=5.0f;
    }
    if([sender isKindOfClass:[UIView class]]){
        UIView *tview=(UIView *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = cornerRadius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIButton class]]){
        UIButton *tview=(UIButton *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius =cornerRadius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UILabel class]]){
        UILabel *tview=(UILabel *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = cornerRadius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIImageView class]]){
        UIImageView *tview=(UIImageView *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = cornerRadius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIScrollView class]]){
        UIScrollView *tview=(UIScrollView *)sender;
        tview.layer.borderColor=[UIColor clearColor].CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = cornerRadius;
        tview.layer.masksToBounds=YES;
    }
}

//设置圆角及边框颜色、弧度
+(void)setYuanJiao:(id)sender color:(UIColor *)color radius:(CGFloat)radius{
    if ([sender isKindOfClass:[UIButton class]]){
        UIButton *tview=(UIButton *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = radius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UILabel class]]){
        UILabel *tview=(UILabel *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = radius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIImageView class]]){
        UIImageView *tview=(UIImageView *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = radius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIView class]]){
        UIView *tview=(UIView *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = radius;
        tview.layer.masksToBounds=YES;
    }
}

//设置圆角及边框颜色、边框宽度、弧度
+(void)setYuanJiao:(id)sender color:(UIColor *)color bordorWidth:(CGFloat)borderWidth radius:(CGFloat)radius{
    if ([sender isKindOfClass:[UIButton class]]){
        UIButton *tview=(UIButton *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = borderWidth;
        tview.layer.cornerRadius = radius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UILabel class]]){
        UILabel *tview=(UILabel *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = borderWidth;
        tview.layer.cornerRadius = radius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIImageView class]]){
        UIImageView *tview=(UIImageView *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = borderWidth;
        tview.layer.cornerRadius = radius;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIView class]]){
        UIView *tview=(UIView *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = borderWidth;
        tview.layer.cornerRadius = radius;
        tview.layer.masksToBounds=YES;
    }
}

//设置椭圆角
+(void)setTuoYuanJiao:(id)sender color:(UIColor *)color{
    if([sender isKindOfClass:[UIView class]]){
        UIView *tview=(UIView *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = tview.frame.size.height/2;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIButton class]]){
        UIButton *tview=(UIButton *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = tview.frame.size.height/2;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UILabel class]]){
        UILabel *tview=(UILabel *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = tview.frame.size.height/2;
        tview.layer.masksToBounds=YES;
    }else if ([sender isKindOfClass:[UIImageView class]]){
        UIImageView *tview=(UIImageView *)sender;
        tview.layer.borderColor=color.CGColor;
        tview.layer.borderWidth = 1.0f;
        tview.layer.cornerRadius = tview.frame.size.height/2;
        tview.layer.masksToBounds=YES;
    }
}

//字符串非空验证
+(BOOL)theStringIsNull:(NSString *)string{
    if(string == nil || (NSNull *)string == [NSNull null] || [string isEqualToString:@""] || [string isEqualToString:@"null"]){
        return true;
    }
    return false;
}

//long转data
+(NSData *) LongToNSData:(long long)data
{
    Byte *buf = (Byte*)malloc(8);
    for (int i=7; i>=0; i--) {
        buf[i] = data & 0x00000000000000ff;
        data = data >> 8;
    }
    NSData *result =[NSData dataWithBytes:buf length:8];
    return result;
}

//根据Date得到星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

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

//校验字符串是否为纯数字
+(BOOL)validateIsNumber:(NSString *)string{
    NSString * numberString=[NSString stringWithFormat:@"^[0-9]{0,%d}$",(int)string.length];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberString];
    return [predicate evaluateWithObject:string];
}

//校验手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum

{
    NSString *validateRule = @"^1[3|4|5|7|8]\\d{9}$";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",validateRule];
    return [regexMobile evaluateWithObject:mobileNum];
}

//校验统一社会信用代码
+(BOOL)validateUniformSocialCreditCode:(NSString *)uniformSocialCreditCode{
    NSString *validateRule = @"^[^_IOZSVa-z\\W]{2}\\d{6}[^_IOZSVa-z\\W]{10}$";
    NSPredicate *regexCreditCode = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",validateRule];
    return [regexCreditCode evaluateWithObject:uniformSocialCreditCode];
}

//校验营业执照
+(BOOL)validateBusinessLicense:(NSString *)businessLicense{
    NSString *validateRule = @"^\\d{15}$";
    NSPredicate *regexBusinessLicense = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",validateRule];
    return [regexBusinessLicense evaluateWithObject:businessLicense];
}

//校验组织机构代码
+(BOOL)validateOrganizationalCertificate:(NSString *)organizationalCertificate{
    NSString *validateRule = @"^\\d{9}$";
    NSString *validateRule2 = @"^\\d{8}-[\\d{1}|X]$";
    NSPredicate *regexOrganizationalCertificate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",validateRule];
    NSPredicate *regexOrganizationalCertificate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",validateRule2];
    return [regexOrganizationalCertificate evaluateWithObject:organizationalCertificate] ||
            [regexOrganizationalCertificate2 evaluateWithObject:organizationalCertificate];
}

//校验税务登记证
+(BOOL)validateTaxRegistrationCertificate:(NSString *)taxRegistrationCertificate{
    NSString *validateRule = @"^\\d{14}[\\d{1}|X]$";
    NSPredicate *regexTaxRegistrationCertificate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",validateRule];
    return [regexTaxRegistrationCertificate evaluateWithObject:taxRegistrationCertificate];
}

//校验身份证号码
+(BOOL)validateIdCardNumber:(NSString *)idCardNumber{
    NSString *validateRule = @"^([1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3})|([1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}(x|X)))$";
    NSPredicate *regexIdCardNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",validateRule];
    return [regexIdCardNumber evaluateWithObject:idCardNumber];
}

+ (void) transitionAnimation:(UIView*)view animationType:(NSInteger)type{
    
    if (view == nil) {
        
        return;
    }
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.25;
    
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    switch (type){
            
        case 0:
            transition.subtype = kCATransitionFromLeft;
            break;
        case 1:
            transition.subtype = kCATransitionFromRight;
            break;
        case 2:
            transition.subtype = kCATransitionFromTop;
            break;
            break;
        case 3:
            transition.subtype = kCATransitionFromBottom;
            break;
        default:
            transition.subtype = kCATransitionFromLeft;
            break;
    }
    
    
    [view.layer addAnimation:transition forKey:nil];
}

// 返回虚线image的方法
+ (UIImage *)drawLineByImageView:(UIImageView *)imageView lineColor:(UIColor *)lineColor{
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距  
    CGFloat lengths[] = {2,2};
    
    CGContextSetStrokeColorWithColor(line, lineColor.CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, imageView.frame.size.width, 2.0);
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

//设置视图内线的位置(通过相对按钮)
+ (void)setLineByBtnAndConstant:(UIButton *)btn Constant:(CGFloat)constant{
    UIView *parentView = [btn superview];
    //获取视图中的线label
    UILabel *lineLab = [parentView viewWithTag:30010];
    //重设视图中线的位置
    for (NSLayoutConstraint *constraint in [parentView constraints]) {
        if (constraint.firstItem == lineLab && constraint.firstAttribute == NSLayoutAttributeLeading) {
            [parentView removeConstraint:constraint];
            //添加相对于选中btn的约束
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:lineLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeLeading multiplier:1.0 constant:constant];
            [parentView addConstraint:constraint];
            [parentView updateConstraints];
            break;
        }
    }
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

//设置指定视图的宽度
+ (void)setSpecifiedViewWidth:(id)sender withWidth:(CGFloat)width{
    for (NSLayoutConstraint *constraint in [sender constraints]) {
        if ([constraint class] == [NSLayoutConstraint class] && constraint.firstItem == sender && constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = width;
            break;
        }
    }
}

//设置指定视图的Y轴
+ (void)setSpecifiedViewY:(id)sender withY:(CGFloat)y{
    for (NSLayoutConstraint *constraint in [[sender superview] constraints]) {
        if ([constraint class] == [NSLayoutConstraint class] && constraint.firstItem == sender && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = y;
            break;
        }
    }
}

//设置指定视图的bottom
+ (void)setSpecifiedViewBottom:(id)sender withBottom:(CGFloat)bottom{
    for (NSLayoutConstraint *constraint in [[sender superview] constraints]) {
        if ([constraint class] == [NSLayoutConstraint class] && constraint.secondItem == sender && constraint.secondAttribute == NSLayoutAttributeBottom) {
            constraint.constant = bottom;
            break;
        }
    }
}

//设置图片到指定的大小
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

//弹出错误信息
+ (void)alertMessageContent:(NSString *)content{
    if ([MyUnity theStringIsNull:content]) {
        return;
    }
    if (SGAlert) {
        [SGAlert removeFromSuperview];
        SGAlert = nil;
    }
    SGAlert = [SGInfoAlert showInfo:content
                  bgColor:[UIColor blackColor].CGColor
                   inView:[AppDelegate sharedAppDelegate].window
                 vertical:0.5];
}

//移除错误信息提示框
+ (void)removeAlertMessageView{
    if (SGAlert) {
        [SGAlert removeFromSuperview];
        SGAlert = nil;
    }
}

//添加公钥头
+ (NSData *)stripPublicKeyHeader:(NSData *)d_key
{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned int len = (int)[d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx    = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

//根据公钥字符串生成公钥
+(SecKeyRef)getPublicKey:(NSString *)key{
    NSData *d_key = [NSData dataFromBase64String:key];
    d_key = [self stripPublicKeyHeader:d_key];
    if (d_key == nil) return(FALSE);
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *identi=[NSString stringWithFormat:@"%@.publickey",[infoDict objectForKey:@"CFBundleIdentifier"]];
    NSData *d_tag = [NSData dataWithBytes:[identi UTF8String] length:[identi length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    CFTypeRef persistKey = nil;
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:d_key forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    OSStatus secStatus = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil) CFRelease(persistKey);
    
    if ((secStatus != noErr) && (secStatus != errSecDuplicateItem)) {
        return(FALSE);
    }
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    secStatus = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey,
                                    (CFTypeRef *)&keyRef);
    
    if (keyRef == nil)
        return(FALSE);
    else
        return keyRef;
}

//根据公钥字符加密
+(NSString *)RSAEncrypotoTheData:(NSString *)plainText key:(NSString *)key
{
    
    SecKeyRef publicKey=nil;
    publicKey=[self getPublicKey:key];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = NULL;
    
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = (int)cipherBufferSize-11;
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length]-i*blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                      initWithBytes:(const void *)cipherBuffer
                                      length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            if (cipherBuffer)
            {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    NSString *encrypotoResult=[NSString stringWithFormat:@"%@",[encryptedData base64EncodedString]];
    return encrypotoResult;
}

//格式化GETUrl
+(NSString *)urlGetFormat:(NSString *)url params:(NSMutableDictionary *)dic{
    if ([MyUnity theStringIsNull:url]) {
        return nil;
    }
    if (!dic) {
        return url;
    }
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:url];
    for (NSString * key in [dic allKeys]) {
        NSString *param = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        if ([urlString rangeOfString:@"?"].location==NSNotFound) {
            [urlString appendString:@"?"];
        }else{
            [urlString appendString:@"&"];
        }
        [urlString appendString:param];
    }
    return urlString;
}

//格式化手机号码
+(NSString *)formatMobile:(NSString *)mobile{
    if (![MyUnity theStringIsNull:mobile]) {
        if (mobile.length==11) {
            NSString *start = [mobile substringToIndex:3];
            NSString *end = [mobile substringFromIndex:mobile.length-4];
            mobile = [start stringByAppendingString:@"****"];
            mobile = [mobile stringByAppendingString:end];
        }
    }
    return mobile;
}

//格式化银行卡号
+(NSString *)formatBankCardNumber:(NSString *)bankCardNumber{
    if (![MyUnity theStringIsNull:bankCardNumber]) {
        if (bankCardNumber.length>10) {
            NSString *start = [bankCardNumber substringToIndex:6];
            NSString *end = [bankCardNumber substringFromIndex:bankCardNumber.length-4];
            bankCardNumber = start;
            for (int x = 0; x < bankCardNumber.length-10; x++) {
                bankCardNumber = [bankCardNumber stringByAppendingString:@"*"];
            }
            bankCardNumber = [bankCardNumber stringByAppendingString:end];
        }
    }
    return bankCardNumber;
}

//格式化金额
+(NSString *)formatAmount:(NSString *)amount{
    if (![MyUnity theStringIsNull:amount]) {
        NSArray *amounts = [amount componentsSeparatedByString:@"."];
        amount = amounts[0];
        NSMutableString *formatAmount = [[NSMutableString alloc] init];
        int x = 0;
        if (amount.length%3 != 0) {
            x = amount.length%3;
            [formatAmount appendString:[amount substringToIndex:x]];
        }
        for (int i = 0; i < amount.length/3; i++) {
            if (x != 0 || i != 0) {
                [formatAmount appendString:@","];
            }
            [formatAmount appendString:[amount substringWithRange:NSMakeRange((x+i*3), 3)]];
        }
        if ([amounts count] > 1) {
            [formatAmount appendString:@"."];
            [formatAmount appendString:amounts[1]];
        }
        return formatAmount;
    }
    return amount;
}

//清除缓存数据
+(void)clearLocalData:(NSArray *)filterArr{
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        //过滤不清除的数据
        if (filterArr && [filterArr containsObject:key]) {
            continue;
        }
        //手势密码设置是否已提示
        if ([key isEqualToString:@"isPrompt"]) {
            continue;
        }
        //启动广告图
        if ([key isEqualToString:adImageName]) {
            continue;
        }
        //是否已显示过第一次安装介绍导航图
        if ([key isEqualToString:@"isFirstShowed"]) {
            continue;
        }
        //过滤用户登录名
        if ([key isEqualToString:@"username"]) {
            continue;
        }
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
    
}

//清除缓存（是否清除登录信息）
+(void)clearcookie:(BOOL)isLoginInfo{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        if (!isLoginInfo) {
            if([[cookie name] isEqualToString:@"Username"]||[[cookie name] isEqualToString:@"LENDINGID"]){
                continue;
            }
        }
        [storage deleteCookie:cookie];
    }
    
    //缓存  清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

//计算收益
+(double)calculatorInterestWithAmount:(NSString *)amount withPeriodUnit:(NSString *)periodUnit withPeriod:(NSString *)period withLilv:(NSString *)lilv withRepaymentWay:(NSString *)repaymentWay{
    if ([MyUnity theStringIsNull:amount]||[MyUnity theStringIsNull:periodUnit]||[MyUnity theStringIsNull:period]||[MyUnity theStringIsNull:lilv]||[MyUnity theStringIsNull:repaymentWay]) {
        return 0.0f;
    }
    double interest = [amount doubleValue]*[period doubleValue]*[lilv doubleValue]/100;
    //天标计算
    if ([repaymentWay isEqualToString:@"ldcpi"]) {
        interest = interest/360.0f;
    }else{
        //月标计算
        interest = interest/12.0f;
    }
    return interest;
}

//日期字符串转NSDate
+(NSDate *)dateStringTransformationDate:(NSString *)dateString format:(NSString *)format{
    if ([MyUnity theStringIsNull:dateString] || [MyUnity theStringIsNull:format]) {
        return nil;
    }
    NSDate *date = nil;
    @try {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:format];
        date = [dateformatter dateFromString:dateString];
    }
    @catch (NSException *exception) {
        
    }
    return date;
}

//NSDate转日期字符串
+(NSString *)dateTransformationDateString:(NSDate *)date format:(NSString *)format{
    if (!date || [MyUnity theStringIsNull:format]) {
        return nil;
    }
    NSString *dateString = nil;
    @try {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:format];
        dateString = [dateformatter stringFromDate:date];
    }
    @catch (NSException *exception) {
        
    }
    return dateString;
}

//添加必要Cookie
+(void)addCookies:(NSMutableDictionary *)dic{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSString *cookieStr = nil;
    for (cookie in [storage cookies])
    {
        if([[cookie name] isEqualToString:@"Username"]||[[cookie name] isEqualToString:@"LENDINGID"]){
            if (cookieStr) {
                NSString *nowCookie = [NSString stringWithFormat:@"%@=%@;",[cookie name],[cookie value]];
                cookieStr = [NSString stringWithFormat:@"%@%@",cookieStr,nowCookie];
            }else{
                cookieStr = [NSString stringWithFormat:@"%@=%@;",[cookie name],[cookie value]];
            }
        }
    }
    if (cookieStr) {
        NSString *nowCookie = WBB_APPKEY;
        cookieStr = [NSString stringWithFormat:@"%@%@",cookieStr,nowCookie];
    }else{
        cookieStr = WBB_APPKEY;
    }
    if (cookieStr) {
        [dic setObject:cookieStr forKey:@"cookie"];
    }
}

/**
 *  下载新图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];// 保存成功后删除旧图片
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，需要将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
    });
}
/**
 *  删除旧图片
 */
+ (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

//获取图片路径
+ (NSString *)getFilePathWithImageName:(NSString *)imageName{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    NSString *filePath = [path stringByAppendingPathComponent:imageName];
    return filePath;
}

//文件是否存在（根据文件路径）
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath{
    NSData *data= [NSData dataWithContentsOfFile:filePath options:0 error:NULL];
    return data != nil;
}

//下载PDF
+(void)downloadFile:(NSString *)pdfUrl{
    /* 创建网络下载对象 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:pdfUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    [self showTsView:[AppDelegate sharedAppDelegate].window ts:@"请稍等..."];
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
//        [_progress setProgress:downloadProgress.fractionCompleted * 100];
//        _progressLab.text = [NSString stringWithFormat:@"下载进度：%.1f",downloadProgress.fractionCompleted * 100];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self removeTsView];
        NSLog(@"下载完成");
//        [_downloadView removeFromSuperview];
//        [_progress setProgress:0.0f];
//        _progressLab.text = @"下载进度：0.0%";
        [MyUnity alertMessageContent:@"下载完成"];
    }];
    [downloadTask resume];
}

///验证数字
+ (BOOL) validateNumber:(NSString *)num
{
    NSString *userNameRegex = @"^\\d+(\\.\\d+)?$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:num];
    return B;
}

#pragma mark - 获取字符串 size
+(CGSize)getStringSizeBy:(CGSize)size ByTittleFont:(CGFloat)font withTittle:(NSString *)text
{
    CGSize type = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    
    return type;
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
