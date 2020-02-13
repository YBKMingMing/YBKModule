//
//  MyUnity.h
//  LYRPJ
//
//  Created by icl-network on 14-4-15.
//
//

#import <Foundation/Foundation.h>

@interface MyUnity : NSObject

//加载框
+(void)showTsView:(id)sender ts:(NSString *)content;

//去除加载框
+(void)removeTsView;

//根据指定字符串获取其位置
+(int)IndexOfContainingString:(NSString *)findment FromString:(NSString *)scrString;

//拨打本地电话
+ (void) showPhone:(NSString *) phoneNum view:(UIWebView*)webview;

//查看图片
+ (void) seeFullScreenImage:(NSArray *)picarr atindex:(NSInteger)index;

//计算字符长度
+ (int)calc_charsetNum:(NSString*)_str;

//设置边框
+(void)setBordor:(id)sender color:(UIColor *)bordor;

//设置圆角
+(void)setYuanJiao:(id)sender;

//设置圆角及圆角弧度
+(void)setYuanJiao:(id)sender cornerRadius:(CGFloat)cornerRadius;

//设置圆角及边框颜色、弧度
+(void)setYuanJiao:(id)sender color:(UIColor *)color radius:(CGFloat)radius;

//设置圆角及边框颜色、边框宽度、弧度
+(void)setYuanJiao:(id)sender color:(UIColor *)color bordorWidth:(CGFloat)borderWidth radius:(CGFloat)radiu;

//设置椭圆角
+(void)setTuoYuanJiao:(id)sender color:(UIColor *)color;

//字符串非空验证
+(BOOL)theStringIsNull:(NSString *)string;

//long转data
+(NSData *) LongToNSData:(long long)data;

//根据Date得到星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

//校验登录密码
+(NSString *)validatePassword:(NSString *)pwd;

//校验字符串是否为纯数字
+(BOOL)validateIsNumber:(NSString *)string;

//校验手机号
+ (BOOL)validateMobile:(NSString *)mobileNum;

//校验统一社会信用代码
+(BOOL)validateUniformSocialCreditCode:(NSString *)uniformSocialCreditCode;

//校验营业执照
+(BOOL)validateBusinessLicense:(NSString *)businessLicense;

//校验组织机构代码
+(BOOL)validateOrganizationalCertificate:(NSString *)organizationalCertificate;

//校验税务登记证
+(BOOL)validateTaxRegistrationCertificate:(NSString *)taxRegistrationCertificate;

//校验身份证号码
+(BOOL)validateIdCardNumber:(NSString *)idCardNumber;

//View动画
+ (void) transitionAnimation:(UIView*)view animationType:(NSInteger)type;

// 返回虚线image的方法
+ (UIImage *)drawLineByImageView:(UIImageView *)imageView lineColor:(UIColor *)lineColor;

//设置视图内线的位置(通过相对按钮)
+ (void)setLineByBtnAndConstant:(UIButton *)btn Constant:(CGFloat)constant;

//设置指定视图的高度
+ (void)setSpecifiedViewHeight:(id)sender withHeight:(CGFloat)height;

//设置指定视图的宽度
+ (void)setSpecifiedViewWidth:(id)sender withWidth:(CGFloat)width;

//设置指定视图的Y轴
+ (void)setSpecifiedViewY:(id)sender withY:(CGFloat)y;

//设置指定视图的bottom
+ (void)setSpecifiedViewBottom:(id)sender withBottom:(CGFloat)bottom;

//设置图片到指定的大小
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

//弹出错误信息
+ (void)alertMessageContent:(NSString *)content;

//移除错误信息提示框
+ (void)removeAlertMessageView;

//根据公钥字符加密
+(NSString *)RSAEncrypotoTheData:(NSString *)plainText key:(NSString *)key;

//格式化GETUrl
+(NSString *)urlGetFormat:(NSString *)url params:(NSMutableDictionary *)dic;

//格式化手机号码
+(NSString *)formatMobile:(NSString *)mobile;

//格式化银行卡号
+(NSString *)formatBankCardNumber:(NSString *)bankCardNumber;

//格式化金额
+(NSString *)formatAmount:(NSString *)amount;

//清除缓存数据
+(void)clearLocalData:(NSArray *)filterArr;

//清空网络缓存
+(void)clearcookie:(BOOL)isLoginInfo;

//计算收益
+(double)calculatorInterestWithAmount:(NSString *)amount withPeriodUnit:(NSString *)periodUnit withPeriod:(NSString *)period withLilv:(NSString *)lilv withRepaymentWay:(NSString *)repaymentWay;

//日期字符串转NSDate
+(NSDate *)dateStringTransformationDate:(NSString *)dateString format:(NSString *)format;

//NSDate转日期字符串
+(NSString *)dateTransformationDateString:(NSDate *)date format:(NSString *)format;

//添加必要Cookie
+(void)addCookies:(NSMutableDictionary *)dic;

/**
 *  下载新图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName;
/**
 *  删除旧图片
 */
+ (void)deleteOldImage;

//获取图片路径
+ (NSString *)getFilePathWithImageName:(NSString *)imageName;

//文件是否存在（根据文件路径）
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath;

//下载文件
+(void)downloadFile:(NSString *)pdfUrl;

//获取文字 size
+(CGSize )getStringSizeBy:(CGSize )size ByTittleFont:(CGFloat )font withTittle:(NSString *)text;

//验证数字
+ (BOOL) validateNumber:(NSString *)num;

//json 转字符串
+(NSString *)jsonToString:(id)json options:(NSJSONWritingOptions)options;

@end
