//
//  ClassCategory.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice (ClassCategory)

-(NSString*)getMacAddress;
-(NSString*)getIPAddress;
-(NSString*)getResolution;
-(NSString*)getLanguage;
-(NSString*)uniqueDeviceIdentifier;
-(NSString*)getDeviceName;

@end

@interface NSDate (ClassCategory)

-(NSString*)toString;
-(NSString*)toStringWithFormat:(NSString*)format;
///获取农历日期
-(NSString*)toChineseCalendar;
///获取星期几
-(NSString*)toWeekDay;
//考虑时区，获取准备的系统时间方法
-(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
//获取时间段
-(NSString *)toTimeSlot;

@end

@interface NSString (ClassCategory)

///URL地址
-(BOOL)isUrl;
///身份证
-(BOOL)isIdentityCard;
///验证码或邮政编码
-(BOOL)isCode;
///电子邮件
-(BOOL)isEmail;
///手机号码
-(BOOL)isMobile;
///座机号码
-(BOOL)isPhone;
///车牌号验证
-(BOOL)isCarNo;
///登录密码-只能包含数字或字母
-(BOOL)isPassword;
///判断昵称 只能是中文,字母或数字组成
-(BOOL)isNickName;
///判断姓名 只能是中文
-(BOOL)isRealName;
///资格号码 只能是字母和数字
-(BOOL)isQualifications;
///银行名称 2-10中文
-(BOOL)isBankName;
///银行卡号
-(BOOL)isBankNumber;
///判断中文
-(BOOL)isChinese;
///QQ号码
-(BOOL)isQQ;
///是否是中文
-(BOOL)existChinese;
///是否为空
-(BOOL)isEmpty;
///是否包涵某个字符串
-(BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0);
///判断是非包含表情
- (BOOL)isIncludingEmoji;
///移除表情
- (instancetype)removedEmojiString;

///去掉图片标签
-(NSString*)imgReplacing;

-(NSString*)encodingUTF8;
-(NSDate*)toDate;
-(NSDate*)toDateWithFormat:(NSString*)format;
-(NSString*)toTrim;
-(NSArray*)toArray;
-(NSString*)toString;
-(NSString*)toURLEncode;

-(NSString*)formatWithAppendString:(NSString*)str, ... NS_FORMAT_FUNCTION(1,2);

+(NSString*)stringFormatWithTimeStamp:(NSTimeInterval)timeStamp;

+(NSString*)stringWithTimeStamp:(NSTimeInterval)timeStamp;
+(NSString*)stringWithTimeStamp:(NSTimeInterval)timeStamp format:(NSString*)format;
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end

@interface NSNumber (ClassCategory)

-(NSString*)toString;

@end

@interface UIView (ClassCategory)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

@property (nonatomic,assign) CGFloat ttx;
@property (nonatomic,assign) CGFloat tty;

- (void)setViewRound;
- (void)setViewRoundNoBorder;
- (void)setViewRoundWithRound;
- (void)setViewRoundWithNoBorder;
- (void)setViewRoundWithButton;
- (void)setViewRound:(float)radius borderWidth:(float)width borderColor:(UIColor*)color;

///隐藏View上的键盘
- (void)hideKeyboard;

@end

@interface UILabel (ClassCategory)

- (CGFloat)getLabelHeightWithMinHeight:(CGFloat)minheight;
- (CGFloat)getLabelWidthWithMinWidth:(CGFloat)minwidth;

- (void)setLabelColorWithRange:(NSRange)range color:(UIColor*)color;

- (void)setLabelFontWithRange:(NSRange)range font:(UIFont*)font;

@end

@interface NSArray (ClassCategory)

-(NSString*)toString;

@end

@interface UIImage (ClassCategory)

/**
 *  返回能够自由拉伸不变形的图片
 *
 *  @param name 文件名
 *
 *  @return 能够自由拉伸不变形的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *   返回能够自由拉伸不变形的图片
 *
 *  @param name      文件名
 *  @param leftScale 左边需要保护的比例（0~1）
 */
+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;

/**
 *  截取头像图片
 *
 *  @param oldImage    原图片对象
 *  @param borderWidth 圆环宽度
 *  @param borderColor 圆环颜色
 *
 *  @return 截取成功后的图片
 */
+ (instancetype)circleImageWithUIImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  用颜色返回一张图片
 */
+ (UIImage *)createImageWithColor:(UIColor*) color;

@end

@interface UIImageView (ClassCategory)

- (void)setImageViewRound;
- (void)setImageViewRoundWithBorderZero;
- (void)setImageViewRoundWithBorderDefault;
- (void)setImageViewRound:(float)radius borderWidth:(float)width borderColor:(UIColor*)color;

///获取1个点高度的实线分割线
+(UIImageView *)getDLineView;
///获取5个点高度的实线分割线
+(UIImageView *)getSLineView;
///获取1个点高度的虚线分割线
+(UIImageView *)getTLineView;

@end


@interface UITextField (ClassCategory)

- (void)setReplaceRange;

@end
