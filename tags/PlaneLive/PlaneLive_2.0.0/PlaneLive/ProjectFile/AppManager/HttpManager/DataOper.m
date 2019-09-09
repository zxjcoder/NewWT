//
//  DataOper.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataOper.h"
#import "DataOperManager.h"
#import "RequestManager.h"
#import "AppSetting.h"
#import "ClassCategory.h"
#import "AESCrypt.h"
#import "NSString+Base64.h"

@implementation DataOper

static DataOper *_dataOperInstance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataOperInstance = [super allocWithZone:zone];
    });
    return _dataOperInstance;
}

+ (DataOper*)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataOperInstance = [[self alloc] init];
    });
    return _dataOperInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _dataOperInstance;
}

/**
 *  提交BUG或ERROR或用户建议
 *
 *  @param crashContent 崩溃内容
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postErrorReportWithContent:(NSString *)crashContent resultBlock:(void(^)(void))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        
        [dicParam setObject:@"0" forKey:@"platform"];
        [dicParam setObject:[[NSDate new] toString] forKey:@"log_time"];

        NSData *baseData = [crashContent dataUsingEncoding:NSUTF8StringEncoding];
        crashContent = [NSString base64StringFromData:baseData length:baseData.length];
        [dicParam setObject:crashContent forKey:@"log_content"];
        
        [self postJsonWithAction:kJson_PostErrorReport_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock();
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取设备数量
 *
 *  @param userId       用户ID
 *  @param deviceToken  设备Token
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getDeviceNumberWithUserId:(NSString *)userId deviceToken:(NSString *)deviceToken resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (deviceToken) {
            [dicParam setObject:deviceToken forKey:@"deviceToken"];
        }
        
        [self postJsonWithAction:@"share/app/getDeviceNumber" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取App配置信息
 *
 *  @param  appVersion  App版本号
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getAppConfigWithAppVersion:(NSString *)appVersion resultBlock:(void(^)(ModelAppConfig *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        [dicParam setObject:appVersion forKey:@"versionNum"];
        [dicParam setObject:@"0" forKey:@"platform"];
        
        [self postJsonWithAction:@"share/appversion/queryAppVersion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                NSDictionary *dicResult = [result.body objectForKey:kResultKey];
                if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
                    if (resultBlock) {
                        resultBlock([[ModelAppConfig alloc] initWithCustom:dicResult]);
                    }
                } else {
                    if (errorBlock) {
                        errorBlock(result.msg);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  第三方登录
 *
 *  @param openid       openid
 *  @param unionid      unionid
 *  @param flag         1:微信  2:新浪  3:QQ
 *  @param nickname     昵称
 *  @param headImg      头像
 *  @param sex          性别 0默认 1男 2女
 *  @param address      地址
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postLoginWithOpenid:(NSString *)openid unionid:(NSString *)unionid flag:(WTAccountType)flag nickname:(NSString *)nickname headImg:(NSString *)headImg sex:(WTSexType)sex address:(NSString *)address resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (openid) {
            [dicParam setObject:openid forKey:@"openid"];
        }
        if (unionid) {
            [dicParam setObject:unionid forKey:@"uuid"];
        }
        [dicParam setObject:[NSNumber numberWithInteger:flag] forKey:@"flag"];
        if (nickname) {
            [dicParam setObject:nickname forKey:@"nickname"];
        }
        if (headImg) {
            [dicParam setObject:headImg forKey:@"head_img"];
        }
        [dicParam setObject:[NSNumber numberWithInteger:sex] forKey:@"sex"];
        if (address) {
            [dicParam setObject:address forKey:@"address"];
        }
        
        [self postJsonWithAction:kJson_ThirdLogin_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:[result.body objectForKey:kResultKey]];
                    if (dicUser && [dicUser isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *myWaitAnsCount = [result.body objectForKey:@"myWaitAnsCount"];
                        NSString *myQuesCount = [result.body objectForKey:@"myQuesCount"];
                        NSString *myFunsCount = [result.body objectForKey:@"myFunsCount"];
                        NSString *myWaitAnsCountBy = [result.body objectForKey:@"myWaitAnsCountBy"];
                        
                        if (myWaitAnsCount && ![myWaitAnsCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myWaitAnsCount forKey:@"myWaitAnsCount"];
                        }
                        if (myQuesCount && ![myQuesCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myQuesCount forKey:@"myQuesCount"];
                        }
                        if (myFunsCount && ![myFunsCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myFunsCount forKey:@"myFunsCount"];
                        }
                        if (myWaitAnsCountBy && ![myWaitAnsCountBy isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myWaitAnsCountBy forKey:@"myWaitAnsCountBy"];
                        }
                        
                        ModelUser *modelUser = [[ModelUser alloc] initWithCustom:dicUser];
                        resultBlock(modelUser, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  帐号登录
 *
 *  @param account      登录账户
 *  @param password     登录密码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postLoginWithAccount:(NSString *)account password:(NSString *)password resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (account) {
            [dicParam setObject:account forKey:@"account"];
        }
        if (password) {
            [dicParam setObject:[Utils stringMD5:password] forKey:@"password"];
        }
        
        [self postJsonWithAction:kJson_Login_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:[result.body objectForKey:kResultKey]];
                    if (dicUser && [dicUser isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *myWaitAnsCount = [result.body objectForKey:@"myWaitAnsCount"];
                        NSString *myQuesCount = [result.body objectForKey:@"myQuesCount"];
                        NSString *myFunsCount = [result.body objectForKey:@"myFunsCount"];
                        NSString *myWaitAnsCountBy = [result.body objectForKey:@"myWaitAnsCountBy"];
                        
                        if (myWaitAnsCount && ![myWaitAnsCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myWaitAnsCount forKey:@"myWaitAnsCount"];
                        }
                        if (myQuesCount && ![myQuesCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myQuesCount forKey:@"myQuesCount"];
                        }
                        if (myFunsCount && ![myFunsCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myFunsCount forKey:@"myFunsCount"];
                        }
                        if (myWaitAnsCountBy && ![myWaitAnsCountBy isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myWaitAnsCountBy forKey:@"myWaitAnsCountBy"];
                        }
                        
                        ModelUser *modelUser = [[ModelUser alloc] initWithCustom:dicUser];
                        resultBlock(modelUser, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取验证码
 *
 *  @param account      登录账户
 *  @param flag         1:注册时获取验证码 2:找回密码获取验证码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postGetCodeWithAccount:(NSString *)account flag:(int)flag resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (account) {
            [dicParam setObject:account forKey:@"account"];
        }
        [dicParam setObject:[NSNumber numberWithInt:flag] forKey:@"flag"];
        
        [self postJsonWithAction:kJson_GetCode_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  注册
 *
 *  @param account      登录账户
 *  @param password     登录密码
 *  @param valiCode     验证码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postRegisterWithAccount:(NSString *)account password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (account) {
            [dicParam setObject:account forKey:@"account"];
        }
        if (password) {
            [dicParam setObject:[Utils stringMD5:password] forKey:@"password"];
        }
        if (valiCode) {
            [dicParam setObject:valiCode forKey:@"valiCode"];
        }
        
        [self postJsonWithAction:kJson_Register_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:[result.body objectForKey:kResultKey]];
                    if (dicUser && [dicUser isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *myWaitAnsCount = [result.body objectForKey:@"myWaitAnsCount"];
                        NSString *myQuesCount = [result.body objectForKey:@"myQuesCount"];
                        NSString *myFunsCount = [result.body objectForKey:@"myFunsCount"];
                        NSString *myWaitAnsCountBy = [result.body objectForKey:@"myWaitAnsCountBy"];
                        
                        if (myWaitAnsCount && ![myWaitAnsCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myWaitAnsCount forKey:@"myWaitAnsCount"];
                        }
                        if (myQuesCount && ![myQuesCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myQuesCount forKey:@"myQuesCount"];
                        }
                        if (myFunsCount && ![myFunsCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myFunsCount forKey:@"myFunsCount"];
                        }
                        if (myWaitAnsCountBy && ![myWaitAnsCountBy isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myWaitAnsCountBy forKey:@"myWaitAnsCountBy"];
                        }
                        
                        ModelUser *modelUser = [[ModelUser alloc] initWithCustom:dicUser];
                        resultBlock(modelUser, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  找回密码
 *
 *  @param account      登录账户
 *  @param password     新密码
 *  @param valiCode     验证码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postForgotPasswordWithAccount:(NSString *)account password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (account) {
            [dicParam setObject:account forKey:@"account"];
        }
        if (password) {
            [dicParam setObject:[Utils stringMD5:password] forKey:@"newPass"];
        }
        if (valiCode) {
            [dicParam setObject:valiCode forKey:@"valiCode"];
        }
        
        [self postJsonWithAction:kJson_ForgotPassword_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  修改密码
 *
 *  @param account      登录账户
 *  @param oldPwd       旧密码
 *  @param newPwd       新密码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postUpdatePasswordWithAccount:(NSString *)account oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (account) {
            [dicParam setObject:account forKey:@"userId"];
        }
        if (oldPwd) {
            [dicParam setObject:[Utils stringMD5:oldPwd] forKey:@"oldPass"];
        }
        if (newPwd) {
            [dicParam setObject:[Utils stringMD5:newPwd] forKey:@"newPass"];
        }
        
        [self postJsonWithAction:kJson_UpdatePassword_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  修改个人资料接口
 *
 *  @param account      登录账户
 *  @param password     登录密码
 *  @param valiCode     验证码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postUpdateUserInfoWithAccount:(NSString *)account headImg:(NSString *)headImg nickname:(NSString *)nickname signature:(NSString *)signature sex:(WTSexType)sex trade:(NSString *)trade company:(NSString *)company address:(NSString *)address resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (account) {
            [dicParam setObject:account forKey:@"userId"];
        }
        if (nickname) {
            [dicParam setObject:nickname forKey:@"nickname"];
        }
        if (signature) {
            [dicParam setObject:signature forKey:@"signature"];
        }
        [dicParam setObject:[NSNumber numberWithInteger:sex] forKey:@"sex"];
        if (trade) {
            [dicParam setObject:trade forKey:@"trade"];
        }
        if (company) {
            [dicParam setObject:company forKey:@"company"];
        }
        if (address) {
            [dicParam setObject:address forKey:@"address"];
        }
        NSString *headImgPath = headImg.length == 0 ? kEmpty : headImg;
        
        [self postJsonWithAction:kJson_UpdateUser_CMD postParam:dicParam postFile:@[headImgPath] resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  意见反馈
 *
 *  @param userId       用户ID
 *  @param question     反馈的问题
 *  @param type         0:问题 1:人员 2:机构
 *  @param objId        反馈的对象ID type为0可不传
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postFeekbackWithUserId:(NSString *)userId question:(NSString *)question type:(NSString *)type objId:(NSString *)objId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (question) {
            [dicParam setObject:question forKey:@"question"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        if (objId) {
            [dicParam setObject:objId forKey:@"objId"];
        }
        
        [self postJsonWithAction:kJson_Feekback_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取用户基本信息
 *
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postGetUserInfoWithUserId:(NSString *)userId resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        
        [self postJsonWithAction:kJson_GetUserInfo_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:[result.body objectForKey:kResultKey]];
                    if (dicUser && [dicUser isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *myWaitAnsCount = [result.body objectForKey:@"myWaitAnsCount"];
                        NSString *myQuesCount = [result.body objectForKey:@"myQuesCount"];
                        NSString *myFunsCount = [result.body objectForKey:@"myFunsCount"];
                        NSString *myWaitAnsCountBy = [result.body objectForKey:@"myWaitAnsCountBy"];
                        
                        if (myWaitAnsCount && ![myWaitAnsCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myWaitAnsCount forKey:@"myWaitAnsCount"];
                        }
                        if (myQuesCount && ![myQuesCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myQuesCount forKey:@"myQuesCount"];
                        }
                        if (myFunsCount && ![myFunsCount isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myFunsCount forKey:@"myFunsCount"];
                        }
                        if (myWaitAnsCountBy && ![myWaitAnsCountBy isKindOfClass:[NSNull class]]) {
                            [dicUser setObject:myWaitAnsCountBy forKey:@"myWaitAnsCountBy"];
                        }
                        
                        ModelUser *modelUser = [[ModelUser alloc] initWithCustom:dicUser];
                        resultBlock(modelUser, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取他人用户基本信息
 *
 *  @param userId       用户ID
 *  @param hisId        他人用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postGetUserInfoWithUserId:(NSString *)userId hisId:(NSString *)hisId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (hisId) {
            [dicParam setObject:hisId forKey:@"hisId"];
        }
        
        [self postJsonWithAction:kJson_GetOtherUserInfo_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取黑名单列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postGetBlackListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_GetBlackList_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除黑名单列表
 *
 *  @param userId       用户ID
 *  @param removeUserId 被移除的用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postRemoveBlackListWithUserId:(NSString *)userId removeUserId:(NSString *)removeUserId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (removeUserId) {
            [dicParam setObject:removeUserId forKey:@"hisId"];
        }
        
        [self postJsonWithAction:kJson_RemoveBlackList_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  添加黑名单
 *
 *  @param userId       用户ID
 *  @param addUserId    添加用户
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postAddBlackListWithUserId:(NSString *)userId addUserId:(NSString *)addUserId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (addUserId) {
            [dicParam setObject:addUserId forKey:@"hisId"];
        }
        
        [self postJsonWithAction:kJson_AddBlackList_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取我的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postMyGetQueryQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_MyGetQueryQuestion_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取我的问题的更新信息(新答案)
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postMyGetUpdQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_MyGetUpdQuestion_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取我的粉丝
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postMyGetFunsWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_MyGetFuns_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取我的回答
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postMyGetReplyWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_MyGetReply_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取我的关注
 *
 *  @param userId       用户ID
 *  @param flag         1.用户    2.话题
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postMyGetAttentionWithUserId:(NSString *)userId flag:(int)flag pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:flag] forKey:@"flag"];
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_MyGetAttention_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取等我回答的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postMyGetQueryInviteAnswersWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_MyGetQueryInviteAnswers_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除被别人邀请但不想回答的问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postMyDelInviteAnswersWithUserId:(NSString *)userId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        
        [self postJsonWithAction:kJson_MyDelInviteAnswers_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  举报
 *
 *  @param userId       用户ID
 *  @param objId        举报对象ID
 *  @param type         举报类型
 *  @param content      举报内容
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postAddReportWithUserId:(NSString *)userId objId:(NSString *)objId type:(ZReportType)type content:(NSString *)content resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (objId) {
            [dicParam setObject:objId forKey:@"objId"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"content"];
        }
        [dicParam setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
        
        [self postJsonWithAction:@"share/question/addReport" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  取消话题、问题、用户的关注
 *
 *  @param aid          关注对象的ID
 *  @param userId       用户ID
 *  @param type         类型 0问题1人2答案3话题4语音
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postDeleteAttentionWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (aid) {
            [dicParam setObject:aid forKey:@"aid"];
        }
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        
        [self postJsonWithAction:@"share/user/cancelAtt" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  添加话题、问题、用户的关注
 *
 *  @param userId       用户ID
 *  @param hisId        关注对象的ID
 *  @param type         类型 0问题1人2答案3话题4语音
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postAddAttentionWithuserId:(NSString *)userId hisId:(NSString *)hisId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (hisId) {
            [dicParam setObject:hisId forKey:@"hisId"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        
        [self postJsonWithAction:@"share/search/attentOther" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postDeleteQuestionWithUserId:(NSString *)userId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        
        [self postJsonWithAction:@"share/question/delQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除新回答提示信息
 *
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postDeleteQuestionWithQuestionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        
        [self postJsonWithAction:@"share/question/delUpdQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除我的粉丝
 *
 *  @param userId       用户ID
 *  @param hisId        被删除的用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postDeleteMyFunsWithUserId:(NSString *)userId hisId:(NSString *)hisId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (hisId) {
            [dicParam setObject:hisId forKey:@"hisId"];
        }
        
        [self postJsonWithAction:@"share/user/delMyFuns" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除我的收藏
 *
 *  @param cid          收藏的ID,行业时可不传
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postDeleteMyFunsWithCId:(NSString *)cid resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (cid) {
            [dicParam setObject:cid forKey:@"cid"];
        }
        
        [self postJsonWithAction:@"share/collect/delCollect" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  搜索用户
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param flag         搜索用户位置 0表示只是单纯的搜用户  1表示搜用户进行邀请回答
 *  @param content      搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getSearchUserWithUserId:(NSString *)userId questionId:(NSString *)questionId flag:(NSString *)flag content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        if (flag) {
            [dicParam setObject:flag forKey:@"flag"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"content"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/search/searchUser" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/****************************圈子模块****************************/

/**
 *  圈子模糊查询问题及话题
 *
 *  @param question     搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleQueryQuestionAnswerWithQuestion:(NSString *)question pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (question) {
            [dicParam setObject:question forKey:@"question"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_GetCircleQueryQuestionAnswer_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  搜索内容
 *
 *  @param userId       用户ID
 *  @param content      搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleQueryQuestionAnswerWithUserId:(NSString *)userId content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"content"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_GetCircleSearchContent_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  搜索用户
 *
 *  @param userId       用户ID
 *  @param content      搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleSearchUserWithUserId:(NSString *)userId content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"content"];
        }
        [dicParam setObject:@"0" forKey:@"flag"];
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_GetCircleSearchUser_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  搜索话题
 *
 *  @param artName      关键字
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleQueryArticleWithArtName:(NSString *)artName pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (artName) {
            [dicParam setObject:artName forKey:@"artName"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/remd/queryArticles" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  添加话题
 *
 *  @param userId       用户ID
 *  @param artName      关键字
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleSaveArticleWithUserId:(NSString *)userId artName:(NSString *)artName resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (artName) {
            [dicParam setObject:artName forKey:@"artName"];
        }
        
        [self postJsonWithAction:@"share/remd/saveArticle" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  圈子推荐
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleRemdListWithPageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_GetCircleRemdList_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  圈子最新
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleLatestListWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        [dicParam setObject:[AppSetting getUserDetauleId] forKey:@"userId"];
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_GetCircleLatestList_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrList = [result.body objectForKey:kResultKey];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in arrList) {
                            ModelCircleNew *model = [[ModelCircleNew alloc] initWithCustom:dic];
                            [arrResult addObject:model];
                        }
                    }
                    GCDMainBlock(^{
                        resultBlock(arrResult, result.body);
                    });
                }
            } else {
                if (errorBlock) {
                    GCDMainBlock(^{
                        errorBlock(result.msg);
                    });
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            GCDMainBlock(^{
                errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
            });
        }
    }
}

/**
 *  圈子动态
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleTrendListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_GetCircleTrendList_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSMutableArray *arrR = [NSMutableArray array];
                    NSArray *arrList = [result.body objectForKey:@"trends"];
                    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in arrList) {
                            ModelCircleDynamic *model = [[ModelCircleDynamic alloc] initWithCustom:dic];
                            [arrR addObject:model];
                        }
                    }
                    GCDMainBlock(^{
                        resultBlock(arrR, result.body);
                    });
                }
            } else {
                if (errorBlock) {
                    GCDMainBlock(^{
                        errorBlock(result.msg);
                    });
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            GCDMainBlock(^{
                errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
            });
        }
    }
}

/**
 *  圈子关注
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleAttentionListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_GetCircleAttentionList_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  发布问题
 *
 *  @param userId       用户ID
 *  @param question     问题标题
 *  @param quizDetail   问题描述
 *  @param articles     话题列表
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postCirclePublishQuestionWithUserId:(NSString *)userId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (question) {
            [dicParam setObject:question forKey:@"question"];
        }
        if (quizDetail) {
            [dicParam setObject:quizDetail forKey:@"quizDetail"];
        }
        if (articles) {
            [dicParam setObject:articles forKey:@"articles"];
        }
        
        [self postJsonWithAction:@"share/remd/savaQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  修改问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param question     问题标题
 *  @param quizDetail   问题描述
 *  @param articles     话题列表
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postCircleUpdateQuestionWithUserId:(NSString *)userId questionId:(NSString *)questionId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (question) {
            [dicParam setObject:question forKey:@"question"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        if (quizDetail) {
            [dicParam setObject:quizDetail forKey:@"quizDetail"];
        }
        if (articles) {
            [dicParam setObject:articles forKey:@"articles"];
        }
        
        [self postJsonWithAction:@"share/remd/savaUpdQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  问题详情接口
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getQuestionDetailWithQuestionId:(NSString *)questionId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/question/answerQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  回答问题的详情接口
 *
 *  @param userId       用户ID
 *  @param answerId     回答ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (answerId) {
            [dicParam setObject:answerId forKey:@"answerId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/question/getComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  话题详情
 *
 *  @param userId       用户ID
 *  @param aid          话题ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getTopicDetailWithTopicId:(NSString *)aid userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (aid) {
            [dicParam setObject:aid forKey:@"aid"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/search/getArtDetails" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  关注问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postAttentionQuestionWithQuestionId:(NSString *)questionId userId:(NSString *)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        
        [self postJsonWithAction:@"share/question/attention" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  点赞
 *
 *  @param userId       用户ID
 *  @param aid          点赞对象ID
 *  @param type         类型0问题1人2答案3话题4语音
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postClickLikeWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (aid) {
            [dicParam setObject:aid forKey:@"answerId"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        
        [self postJsonWithAction:@"share/question/applaud" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  取消点赞
 *
 *  @param userId       用户ID
 *  @param aid          点赞对象ID
 *  @param type         类型0问题1人2答案3话题4语音
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postClickUnLikeWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (aid) {
            [dicParam setObject:aid forKey:@"id"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        
        [self postJsonWithAction:@"share/question/cancelAgree" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除答案
 *
 *  @param userId       用户ID
 *  @param answerId     答案ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postDeleteAnswerWithAnswerId:(NSString *)answerId userId:(NSString *)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (answerId) {
            [dicParam setObject:answerId forKey:@"answerId"];
        }
        
        [self postJsonWithAction:@"share/question/delAnswer" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  用户点击邀请回答问题
 *
 *  @param userId       用户ID
 *  @param hisId        被邀请用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postInviteUserWithUserId:(NSString *)userId hisId:(NSString *)hisId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (hisId) {
            [dicParam setObject:hisId forKey:@"hisId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        
        [self postJsonWithAction:@"share/search/inviteAnswer" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  用户点击邀请回答后显示的推荐用户
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getRecommendUserWithUserId:(NSString *)userId questionId:(NSString *)questionId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/search/recommendUser" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  添加回答问题
 *
 *  @param content      回答内容
 *  @param questionId   问题ID
 *  @param userId       用户ID
 *  @param answerImg    图片集合
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postAddAnswerWithQuestionId:(NSString *)questionId content:(NSString *)content userId:(NSString *)userId answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"content"];
        }
        [dicParam setObject:[NSNumber numberWithInteger:answerImg.count] forKey:@"imgCount"];
        NSArray *arrImage = [NSArray arrayWithArray:answerImg];
        if (arrImage.count == 0) {
            arrImage = @[kEmpty];
        }
        
        [self postJsonWithAction:@"share/question/addAnswer" postParam:dicParam postFile:arrImage resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  修改回答问题
 *
 *  @param content      回答内容
 *  @param questionId   问题ID
 *  @param answerId     回答ID
 *  @param userId       用户ID
 *  @param answerImg    图片集合
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postUpdAnswerWithQuestionId:(NSString *)questionId answerId:(NSString *)answerId content:(NSString *)content userId:(NSString *)userId answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (questionId) {
            [dicParam setObject:questionId forKey:@"questionId"];
        }
        if (answerId) {
            [dicParam setObject:answerId forKey:@"answerId"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"content"];
        }
        [dicParam setObject:[NSNumber numberWithInteger:answerImg.count] forKey:@"imgCount"];
        NSArray *arrImage = [NSArray arrayWithArray:answerImg];
        if (arrImage.count == 0) {
            arrImage = @[kEmpty];
        }
        
        [self postJsonWithAction:@"share/question/updAnswer" postParam:dicParam postFile:arrImage resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取要编辑的答案
 *
 *  @param answerId     回答ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getAnswerDetailWithAnswerId:(NSString *)answerId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (answerId) {
            [dicParam setObject:answerId forKey:@"answerId"];
        }
        
        [self postJsonWithAction:@"share/question/getAnswer" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  保存修改后的答案
 *
 *  @param answerId     回答ID
 *  @param content      回答内容
 *  @param answerImg    图片集合
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postUpdAnswerDetailWithAnswerId:(NSString *)answerId content:(NSString *)content answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (answerId) {
            [dicParam setObject:answerId forKey:@"answerId"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"content"];
        }
        if (answerImg) {
            [dicParam setObject:answerImg forKey:@"answerImg"];
        }
        
        [self postJsonWithAction:@"share/question/updAnswer" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  评论
 *
 *  @param answerId     回答ID
 *  @param content      评论内容
 *  @param objId        评论对象ID
 *  @param type         类型(问题：0,实务：1)
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postSaveCommentWithUserId:(NSString *)userId content:(NSString *)content objId:(NSString *)objId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"commentInfo"];
        }
        if (objId) {
            [dicParam setObject:objId forKey:@"objId"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        
        [self postJsonWithAction:@"share/question/saveComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}



/*************************************榜单*****************************************/


/**
 *  获取榜单热门标签
 *
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getHotBillBoardArrayWithResultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        [self postJsonWithAction:@"share/billBoard/getHotLabel" postParam:nil postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  搜索榜单
 *
 *  @param param        搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getSearchBillBoardArrayWithParam:(NSString *)param pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (param) {
            [dicParam setObject:param forKey:@"param"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/billBoard/queryBillboard" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  查看榜单详情
 *
 *  @param userId       用户ID
 *  @param flag         1：查看人2：查看机构3:行业
 *  @param cpysfId      当flag为1时必填(人id)
 *  @param companyId    当flag为2是必填(机构id)
 *  @param qrtype       当flag为2是必填(0机构下的人，1查询机构业绩清单)
 *  @param type         当flag为3是必填(0:律所2:证券 1:会计)
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getBillBoardDetailWithUserId:(NSString *)userId flag:(int)flag cpysfId:(NSString *)cpysfId companyId:(NSString *)companyId qrtype:(NSString *)qrtype type:(NSString *)type pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (cpysfId) {
            [dicParam setObject:cpysfId forKey:@"cpysfId"];
        }
        if (companyId) {
            [dicParam setObject:companyId forKey:@"companyId"];
        }
        if (qrtype) {
            [dicParam setObject:qrtype forKey:@"qrtype"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        [dicParam setObject:[NSNumber numberWithInt:flag] forKey:@"flag"];
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT*2] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/billBoard/getResultList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}


/**
 *  机构导出
 *
 *  @param organizationId   机构ID
 *  @param pageNum          当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getExportOrganizationWithOrganizationId:(NSString *)organizationId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (organizationId) {
            [dicParam setObject:organizationId forKey:@"id"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/export/exportOrganization" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  人员导出
 *
 *  @param userId       人员ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getExportPeopleWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"id"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/export/exportPeople" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  新三板业绩清单导出
 *
 *  @param type         2:律师事务所 4:证券公司 3:会计事务所
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getExportNEEQWithType:(NSString *)type pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/export/exportNEEQ" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  收藏
 *
 *  @param userId       用户iD
 *  @param cid          收藏的ID,行业时可不传
 *  @param flag         1：实务 2：机构或人员 3:行业 4:答案
 *  @param type         0律所 1 会计 2证券 3语音 4人 5机构 6答案
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getAddCollectionWithUserId:(NSString *)userId cid:(NSString *)cid flag:(int)flag type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (cid) {
            [dicParam setObject:cid forKey:@"cid"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        if (flag>0) {
            [dicParam setObject:[NSNumber numberWithInt:flag] forKey:@"flag"];
        }
        
        [self postJsonWithAction:@"share/collect/collect" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  取消收藏
 *
 *  @param userId       用户iD
 *  @param cid          收藏的ID,行业时可不传
 *  @param type         0律所 1 会计 2证券 3语音 4人 5机构 6答案
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getDelCollectionWithUserId:(NSString *)userId cid:(NSString *)cid type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (cid) {
            [dicParam setObject:cid forKey:@"cid"];
        }
        if (type) {
            [dicParam setObject:type forKey:@"type"];
        }
        
        [self postJsonWithAction:@"share/collect/delCollect" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}


/*************************************实务[语音]*****************************************/


/**
 *  获取实务[语音]列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getSpeechArrayWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/speech/getSpeechList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    if (arrR.count > 0) {
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic in arrR) {
                            [arr addObject:[[ModelPractice alloc] initWithCustom:dic]];
                        }
                        resultBlock(arr, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取实务[语音]详情
 *
 *  @param speechId     实务ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getQuerySpeechDetailWithSpeechId:(NSString *)speechId userId:(NSString*)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (speechId) {
            [dicParam setObject:speechId forKey:@"id"];
        }
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        
        [self postJsonWithAction:@"share/speech/querySpeech" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取实务[语音]详情-带有一页评论
 *
 *  @param speechId     实务ID
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getSpeechDetailWithSpeechId:(NSString *)speechId userId:(NSString*)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (speechId) {
            [dicParam setObject:speechId forKey:@"id"];
        }
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/speech/querySpeechInfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}


/*************************************新闻*****************************************/


/**
 *  获取新闻详情
 *
 *  @param newsId       新闻详情
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getNewsDetailWithNewsId:(NSString *)newsId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (newsId) {
            [dicParam setObject:newsId forKey:@"id"];
        }
        [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/remd/queryNewinfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取新闻详情
 *
 *  @param  newsId      新闻ID
 *  @param errorBlock  新闻URL地址
 */
+(NSString *)getNewsUrlWithNewsId:(NSString *)newsId
{
    return [NSString stringWithFormat:@"%@share/remd/queryNewinfo?id=%@",kWebServerUrl,newsId];
}


/*************************************1.1.0版本新增接口*****************************************/

/**
 *  获取我的收藏->回答
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getMyCollectionAnswerWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/collect/getCollectAnswer" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
//                    NSArray *arrR = [result.body objectForKey:kResultKey];
//                    if (arrR.count > 0) {
//                        NSMutableArray *arr = [NSMutableArray array];
//                        for (NSDictionary *dic in arrR) {
//                            [arr addObject:[[ModelCollectionAnswer alloc] initWithCustom:dic]];
//                        }
//                        resultBlock(arr, result.body);
//                    } else {
                        resultBlock(nil, result.body);
//                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取我的收藏->榜单||实务
 *
 *  @param userId       用户ID
 *  @param type         类型 1榜单 2实务
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getMyCollectionWithUserId:(NSString *)userId type:(int)type pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:type] forKey:@"type"];
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:kJson_MyGetCollection_CMD postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(nil, result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取我的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getMyQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/question/queryQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    if (arrR.count > 0) {
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic in arrR) {
                            [arr addObject:[[ModelQuestionDetail alloc] initWithCustom:dic]];
                        }
                        resultBlock(arr, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  圈子话题分类集合
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleTopicListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/article/queryArticle" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrList = [result.body objectForKey:kResultKey];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in arrList) {
                            ModelTagType *model = [[ModelTagType alloc] initWithCustom:dic];
                            [arrResult addObject:model];
                        }
                    }
                    GCDMainBlock(^{
                        resultBlock(arrResult, result.body);
                    });
                }
            } else {
                if (errorBlock) {
                    GCDMainBlock(^{
                        errorBlock(result.msg);
                    });
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            GCDMainBlock(^{
                errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
            });
        }
    }
}

/**
 *  根据话题类型查询话题集合
 *
 *  @param userId       用户ID
 *  @param typeId       话题分类ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getTopicListWithUserId:(NSString *)userId typeId:(NSString *)typeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrReulst,NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (typeId) {
            [dicParam setObject:typeId forKey:@"type"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/article/queryArticleAll" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    if (arrR && [arrR isKindOfClass:[NSArray class]] && arrR.count > 0) {
                        NSMutableArray *arr = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in arrR) {
                            [arr addObject:[[ModelTag alloc] initWithCustom:dic]];
                        }
                        resultBlock(arr, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除我的答案->收到的评论
 *
 *  @param comment      评论ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postDeleteAnswerCommentWithCommentId:(NSString *)comment resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (comment) {
            [dicParam setObject:comment forKey:@"id"];
        }
        
        [self postJsonWithAction:@"share/user/delAnswerComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  消息中心->列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getUserNoticeListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/user/getNotice" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    if (arrR.count > 0) {
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic in arrR) {
                            [arr addObject:[[ModelNotice alloc] initWithCustom:dic]];
                        }
                        resultBlock(arr, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  消息中心->列表->详情列表
 *
 *  @param noticeId     消息ID
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getUserNoticeListWithNoticeId:(NSString *)noticeId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (noticeId) {
            [dicParam setObject:noticeId forKey:@"type"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/user/getNoticeTypeInfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    if (arrR.count > 0) {
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic in arrR) {
                            [arr addObject:[[ModelNoticeDetail alloc] initWithCustom:dic]];
                        }
                        resultBlock(arr, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}


/*************************************1.2.0版本新增接口*****************************************/

/**
 *  分享答案时调用
 *
 *  @param share_id     答案ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)postAddShareInfoWithShareId:(NSString *)share_id userId:(NSString *)userId resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"share_operson"];
        }
        if (share_id) {
            [dicParam setObject:share_id forKey:@"share_id"];
        }
        [dicParam setObject:@"0" forKey:@"type"];
        
        [self postJsonWithAction:@"share/question/addShareInfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(nil, result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

@end
