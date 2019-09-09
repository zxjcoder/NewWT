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

+ (DataOper*)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataOperInstance = [[DataOper alloc] init];
    });
    return _dataOperInstance;
}

#pragma mark - V1.0.0

/**
 *  提交BUG或ERROR或用户建议
 *
 *  @param crashContent 崩溃内容
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postErrorReportWithContent:(NSString *)crashContent resultBlock:(void(^)(void))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    
    [dicParam setObject:@"0" forKey:@"platform"];
    [dicParam setObject:[[NSDate new] toString] forKey:@"log_time"];
    if (crashContent) {
        NSData *baseData = [crashContent dataUsingEncoding:NSUTF8StringEncoding];
        if (baseData) {
            crashContent = [NSString base64StringFromData:baseData length:baseData.length];
            if (crashContent) {
                [dicParam setObject:crashContent forKey:@"log_content"];
            }
        }
    }
    [self postJsonWithAction:@"share/appLog/saveAppLog" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取设备数量
 *
 *  @param userId       用户ID
 *  @param deviceToken  设备Token
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getDeviceNumberWithUserId:(NSString *)userId deviceToken:(NSString *)deviceToken resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  获取App配置信息
 *
 *  @param  appVersion  App版本号
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getAppConfigWithAppVersion:(NSString *)appVersion resultBlock:(void(^)(ModelAppConfig *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (appVersion) {
        [dicParam setObject:appVersion forKey:@"versionNum"];
    }
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
-(void)postLoginWithOpenid:(NSString *)openid unionid:(NSString *)unionid flag:(WTAccountType)flag nickname:(NSString *)nickname headImg:(NSString *)headImg sex:(WTSexType)sex address:(NSString *)address resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    [self postJsonWithAction:@"share/user/threeLogin" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  帐号登录
 *
 *  @param account      登录账户
 *  @param password     登录密码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postLoginWithAccount:(NSString *)account password:(NSString *)password resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (account) {
        [dicParam setObject:account forKey:@"account"];
    }
    if (password) {
        [dicParam setObject:[Utils stringMD5:password] forKey:@"password"];
    }
    [self postJsonWithAction:@"share/user/login" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取验证码
 *
 *  @param account      登录账户
 *  @param flag         1:注册时获取验证码 2:找回密码获取验证码 3:绑定手机号 4:验证手机号 5:更换手机号 6:解绑手机号
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postGetCodeWithAccount:(NSString *)account flag:(int)flag resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (account) {
        [dicParam setObject:account forKey:@"account"];
    }
    [dicParam setObject:[NSNumber numberWithInt:flag] forKey:@"flag"];
    
    [self postJsonWithAction:@"share/user/beforeReg" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)postRegisterWithAccount:(NSString *)account password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    [self postJsonWithAction:@"share/user/register" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)postForgotPasswordWithAccount:(NSString *)account password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    [self postJsonWithAction:@"share/user/findPass" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)postUpdatePasswordWithAccount:(NSString *)account oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    [self postJsonWithAction:@"share/user/modifyPass" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  修改个人资料接口
 *
 *  @param account      登录账户
 *  @param headImg      图片
 *  @param nickname     昵称
 *  @param signature    个性签名
 *  @param sex          性别
 *  @param trade        行业
 *  @param company      公司
 *  @param address      地址
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postUpdateUserInfoWithAccount:(NSString *)account headImg:(NSString *)headImg nickname:(NSString *)nickname signature:(NSString *)signature sex:(WTSexType)sex trade:(NSString *)trade company:(NSString *)company address:(NSString *)address resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    
    [self postJsonWithAction:@"share/user/updateMyInfo" postParam:dicParam postFile:@[headImgPath] resultBlock:^(Response *result) {
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
-(void)postFeekbackWithUserId:(NSString *)userId question:(NSString *)question type:(NSString *)type objId:(NSString *)objId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    [self postJsonWithAction:@"share/user/feedBack" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取用户基本信息
 *
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postGetUserInfoWithUserId:(NSString *)userId resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [self postJsonWithAction:@"share/user/refresh" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取他人用户基本信息
 *
 *  @param userId       用户ID
 *  @param hisId        他人用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postGetUserInfoWithUserId:(NSString *)userId hisId:(NSString *)hisId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    if (hisId) {
        [dicParam setObject:hisId forKey:@"hisId"];
    }
    [self postJsonWithAction:@"share/search/getInfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取黑名单列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postGetBlackListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/user/getBlackList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  删除黑名单列表
 *
 *  @param userId       用户ID
 *  @param removeUserId 被移除的用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postRemoveBlackListWithUserId:(NSString *)userId removeUserId:(NSString *)removeUserId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    if (removeUserId) {
        [dicParam setObject:removeUserId forKey:@"hisId"];
    }
    [self postJsonWithAction:@"share/user/removeBlackList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  添加黑名单
 *
 *  @param userId       用户ID
 *  @param addUserId    添加用户
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAddBlackListWithUserId:(NSString *)userId addUserId:(NSString *)addUserId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    if (addUserId) {
        [dicParam setObject:addUserId forKey:@"hisId"];
    }
    [self postJsonWithAction:@"share/user/addBlackList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取我的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetQueryQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/question/queryQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取我的问题的更新信息(新答案)
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetUpdQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/question/getUpdQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取我的粉丝
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetFunsWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/user/myFuns" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取我的回答
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetReplyWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/user/myReply" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)postMyGetAttentionWithUserId:(NSString *)userId flag:(int)flag pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:flag] forKey:@"flag"];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/user/myAttention" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取等我回答的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetQueryInviteAnswersWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/question/queryInviteAnswers" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  删除被别人邀请但不想回答的问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyDelInviteAnswersWithUserId:(NSString *)userId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    if (questionId) {
        [dicParam setObject:questionId forKey:@"questionId"];
    }
    [self postJsonWithAction:@"share/question/delInviteAnswers" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)postAddReportWithUserId:(NSString *)userId objId:(NSString *)objId type:(ZReportType)type content:(NSString *)content resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)postDeleteAttentionWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)postAddAttentionWithuserId:(NSString *)userId hisId:(NSString *)hisId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  删除问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteQuestionWithUserId:(NSString *)userId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  删除新回答提示信息
 *
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteQuestionWithQuestionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  删除我的粉丝
 *
 *  @param userId       用户ID
 *  @param hisId        被删除的用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteMyFunsWithUserId:(NSString *)userId hisId:(NSString *)hisId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  删除我的收藏
 *
 *  @param cid          收藏的ID,行业时可不传
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteMyFunsWithCId:(NSString *)cid resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)getSearchUserWithUserId:(NSString *)userId questionId:(NSString *)questionId flag:(NSString *)flag content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)getCircleQueryQuestionAnswerWithQuestion:(NSString *)question pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (question) {
        [dicParam setObject:question forKey:@"question"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/remd/queryQuestionAnswer" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)getCircleQueryQuestionAnswerWithUserId:(NSString *)userId content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    if (content) {
        [dicParam setObject:content forKey:@"content"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/search/searchSubstance" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)getCircleSearchUserWithUserId:(NSString *)userId content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  搜索话题
 *
 *  @param artName      关键字
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleQueryArticleWithArtName:(NSString *)artName pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  添加话题
 *
 *  @param userId       用户ID
 *  @param artName      关键字
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleSaveArticleWithUserId:(NSString *)userId artName:(NSString *)artName resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  圈子推荐
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleRemdListWithPageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/remd/getQuestionAnswer" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  圈子最新
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleLatestListWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[AppSetting getUserDetauleId] forKey:@"userId"];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/latest/latestList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

/**
 *  圈子动态
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleTrendListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/latest/trend" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
                resultBlock(arrR, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

/**
 *  圈子关注
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleAttentionListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/latest/myAttentionList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)postCirclePublishQuestionWithUserId:(NSString *)userId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)postCircleUpdateQuestionWithUserId:(NSString *)userId questionId:(NSString *)questionId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)getQuestionDetailWithQuestionId:(NSString *)questionId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)getAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  关注问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAttentionQuestionWithQuestionId:(NSString *)questionId userId:(NSString *)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)postClickLikeWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)postClickUnLikeWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  删除答案
 *
 *  @param userId       用户ID
 *  @param answerId     答案ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteAnswerWithAnswerId:(NSString *)answerId userId:(NSString *)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)postInviteUserWithUserId:(NSString *)userId hisId:(NSString *)hisId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)getRecommendUserWithUserId:(NSString *)userId questionId:(NSString *)questionId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)postAddAnswerWithQuestionId:(NSString *)questionId content:(NSString *)content userId:(NSString *)userId answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    NSArray *arrImage = [NSArray array];
    if (answerImg && [answerImg isKindOfClass:[NSArray class]]) {
        arrImage = [NSArray arrayWithArray:answerImg];
    }
    [dicParam setObject:[NSNumber numberWithInteger:arrImage.count] forKey:@"imgCount"];
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
-(void)postUpdAnswerWithQuestionId:(NSString *)questionId answerId:(NSString *)answerId content:(NSString *)content userId:(NSString *)userId answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    NSArray *arrImage = [NSArray array];
    if (answerImg && [answerImg isKindOfClass:[NSArray class]]) {
        arrImage = [NSArray arrayWithArray:answerImg];
    }
    [dicParam setObject:[NSNumber numberWithInteger:arrImage.count] forKey:@"imgCount"];
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
}

/**
 *  获取要编辑的答案
 *
 *  @param answerId     回答ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getAnswerDetailWithAnswerId:(NSString *)answerId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)postUpdAnswerDetailWithAnswerId:(NSString *)answerId content:(NSString *)content answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  评论
 *
 *  @param userId       用户ID
 *  @param content      评论内容
 *  @param objId        评论对象ID
 *  @param type         类型(问题：0,实务：1)
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postSaveCommentWithUserId:(NSString *)userId content:(NSString *)content objId:(NSString *)objId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
-(void)getAddCollectionWithUserId:(NSString *)userId cid:(NSString *)cid flag:(int)flag type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    [dicParam setObject:[NSNumber numberWithInt:flag] forKey:@"flag"];
    
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
-(void)getDelCollectionWithUserId:(NSString *)userId cid:(NSString *)cid type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}


#pragma mark - V1.0.0 - 实务


/**
 *  获取实务[语音]列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getSpeechArrayWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/speech/getSpeechList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSMutableArray *arrResult = [NSMutableArray array];
                NSArray *arrR = [result.body objectForKey:kResultKey];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                    }
                }
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

/**
 *  获取实务[语音]详情
 *
 *  @param speechId     实务ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getQuerySpeechDetailWithSpeechId:(NSString *)speechId userId:(NSString*)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}



#pragma mark - V1.1.0

/**
 *  获取我的收藏->回答
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getMyCollectionAnswerWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/collect/getCollectAnswer" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
-(void)getMyCollectionWithUserId:(NSString *)userId type:(int)type pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/collect/getCollect1_1" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  获取我的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getMyQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/question/queryQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSMutableArray *arrResult = [NSMutableArray array];
                NSArray *arrR = [result.body objectForKey:kResultKey];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelQuestionDetail alloc] initWithCustom:dic]];
                    }
                }
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

/**
 *  圈子话题分类集合
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleTopicListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/article/queryArticle" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSMutableArray *arrResult = [NSMutableArray array];
                NSArray *arrR = [result.body objectForKey:kResultKey];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelTagType alloc] initWithCustom:dic]];
                    }
                }
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
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
-(void)getTopicListWithUserId:(NSString *)userId typeId:(NSString *)typeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrReulst,NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
                NSMutableArray *arrResult = [NSMutableArray array];
                NSArray *arrR = [result.body objectForKey:kResultKey];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelTag alloc] initWithCustom:dic]];
                    }
                }
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

/**
 *  删除我的答案->收到的评论
 *
 *  @param comment      评论ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteAnswerCommentWithCommentId:(NSString *)comment resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
}

/**
 *  消息中心->列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getUserNoticeListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/user/getNotice" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSMutableArray *arrResult = [NSMutableArray array];
                NSArray *arrR = [result.body objectForKey:kResultKey];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelNotice alloc] initWithCustom:dic]];
                    }
                }
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
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
-(void)getUserNoticeListWithNoticeId:(NSString *)noticeId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
                NSMutableArray *arrResult = [NSMutableArray array];
                NSArray *arrR = [result.body objectForKey:kResultKey];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelNoticeDetail alloc] initWithCustom:dic]];
                    }
                }
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}


#pragma mark - V1.2.0

/**
 *  分享答案时调用
 *
 *  @param share_id     答案ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAddShareInfoWithShareId:(NSString *)share_id userId:(NSString *)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
                resultBlock(result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}


#pragma mark - V1.3.0

/**
 *  获取实务[语音]详情
 *
 *  @param practiceId   实务ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getPracticeDetailWithPracticeId:(NSString *)practiceId userId:(NSString*)userId resultBlock:(void(^)(ModelPractice *resultModel))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (practiceId) {
        [dicParam setObject:practiceId forKey:@"id"];
    }
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/speech/querySpeechInfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSDictionary *dic = [result.body objectForKey:kResultKey];
                if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dic];
                    
                    NSString *resultCollect = [result.body objectForKey:@"resultCollect"];
                    if (resultCollect && ![resultCollect isKindOfClass:[NSNull class]]) {
                        [dicResult setObject:resultCollect forKey:@"resultCollect"];
                    }
                    NSString *resultApplaud = [result.body objectForKey:@"resultApplaud"];
                    if (resultApplaud && ![resultApplaud isKindOfClass:[NSNull class]]) {
                        [dicResult setObject:resultApplaud forKey:@"resultApplaud"];
                    }
                    ModelPractice *model = [[ModelPractice alloc] initWithCustom:dicResult];
                    resultBlock(model);
                } else {
                    resultBlock(nil);
                }
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

/**
 *  实务详情获取问题列表接口
 *
 *  @param practiceId   实务ID
 *  @param type         问题分类
 *  @param pageNum      当前第几页
 *  @param pageSize     每页多少条
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getPracticeQuestionArrayWithPracticeId:(NSString *)practiceId type:(ZPracticeQuestionType)type pageNum:(int)pageNum pageSize:(int)pageSize resultBlock:(void(^)(NSArray *arrResult, int pageSizeHot, NSInteger questionCount))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (practiceId) {
        [dicParam setObject:practiceId forKey:@"speechId"];
    }
    [dicParam setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [dicParam setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    
    [self postJsonWithAction:@"share/speech/querySpeechQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPracticeQuestion alloc] initWithCustom:dic]];
                    }
                }
                NSString *resultSize = [result.body objectForKey:@"resultSize"];
                NSString *resultQuestionCount = [result.body objectForKey:@"resultQuestionCount"];
                resultBlock(arrResult, [resultSize intValue], [resultQuestionCount integerValue]);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

/**
 *  获取我的评论列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getMyCommentArrayWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/user/myAnswerComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSMutableArray *arrResult = [NSMutableArray array];
                NSArray *arrR = [result.body objectForKey:kResultKey];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelQuestionMyAnswerComment alloc] initWithCustom:dic]];
                    }
                }
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

/**
 *  对评论进行回复
 *
 *  @param userId       用户ID
 *  @param content      回复内容
 *  @param replyUserId  回复的那个用户id
 *  @param commentId    评论id
 *  @param parent_id    一级为0下面的所有未一级的id
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postCommentReplyWithUserId:(NSString *)userId content:(NSString*)content replyUserId:(NSString*)replyUserId commentId:(NSString*)commentId parent_id:(NSString*)parent_id resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    if (content) {
        [dicParam setObject:content forKey:@"content"];
    }
    if (replyUserId) {
        [dicParam setObject:replyUserId forKey:@"replyUserId"];
    }
    if (commentId) {
        [dicParam setObject:commentId forKey:@"commentId"];
    }
    if (parent_id) {
        [dicParam setObject:parent_id forKey:@"parent_id"];
    }
    [self postJsonWithAction:@"share/commentReply/saveCommentReply" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  删除评论和回复
 *
 *  @param userId       用户ID
 *  @param ids          评论ID或回复id
 *  @param type         0：评论 1：回复
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postCommentReplyWithUserId:(NSString *)userId ids:(NSString*)ids type:(int)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    if (ids) {
        [dicParam setObject:ids forKey:@"id"];
    }
    [dicParam setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    [self postJsonWithAction:@"share/commentReply/delComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  实务-发布问题
 *
 *  @param userId       用户ID
 *  @param question     问题标题
 *  @param quizDetail   问题描述
 *  @param articles     话题列表
 *  @param speechId     实务ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postCirclePublishQuestionWithUserId:(NSString *)userId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles speechId:(NSString*)speechId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
    if (speechId) {
        [dicParam setObject:speechId forKey:@"speechId"];
    }
    [self postJsonWithAction:@"share/speech/saveQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
}

/**
 *  答案详情
 *
 *  @param userId       用户ID
 *  @param answerId     回答ID
 *  @param commentId    默认查询的评论ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId commentId:(NSString *)commentId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrComment, ModelAnswerBase *modelAnswer, ModelAnswerComment *modelDefaultComment, NSDictionary *dicResult))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    if (answerId) {
        [dicParam setObject:answerId forKey:@"answerId"];
    }
    if (commentId) {
        [dicParam setObject:commentId forKey:@"commentId"];
    } else {
        [dicParam setObject:@"0" forKey:@"commentId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/question/getComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                //问题对象
                ModelAnswerBase *resultAnswer = nil;
                NSDictionary *dicAnswer = [result.body objectForKey:@"resultAnswer"];
                if (dicAnswer && [dicAnswer isKindOfClass:[NSDictionary class]]) {
                    resultAnswer = [[ModelAnswerBase alloc] initWithCustom:dicAnswer];
                    //评论数
                    NSString *resultComCount = [result.body objectForKey:@"resultComCount"];
                    if (resultComCount && ![resultComCount isKindOfClass:[NSNull class]]) {
                        [resultAnswer setCommentCount:[resultComCount intValue]];
                    }
                    //是否被点赞 1:是 0：否
                    NSString *resultAld = [result.body objectForKey:@"resultAld"];
                    if (resultAld && ![resultAld isKindOfClass:[NSNull class]]) {
                        [resultAnswer setIsAgree:[resultAld intValue]];
                    }
                    //是否被举报 1:是0否
                    NSString *resultRpt = [result.body objectForKey:@"resultRpt"];
                    if (resultRpt && ![resultRpt isKindOfClass:[NSNull class]]) {
                        [resultAnswer setIsRept:[resultRpt intValue]];
                    }
                }
                //评论列表
                NSArray *arrResult = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResultComment = [NSMutableArray array];
                if (arrResult && [arrResult isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrResult) {
                        [arrResultComment addObject:[[ModelAnswerComment alloc] initWithCustom:dic]];
                    }
                }
                //默认选中评论对象
                ModelAnswerComment *resultDefaultComment = nil;
                NSDictionary *dicDefaultComment = [result.body objectForKey:@"resultComment"];
                if (dicDefaultComment && [dicDefaultComment isKindOfClass:[NSDictionary class]]) {
                    resultDefaultComment = [[ModelAnswerComment alloc] initWithCustom:dicDefaultComment];
                }
                ///组装答案详情数据
                if (resultAnswer) {
                    if (arrResultComment) {
                        resultAnswer.commentArray = [NSArray arrayWithArray:arrResultComment];
                    }
                    resultAnswer.modelDefaultComment = resultDefaultComment;
                }
                resultBlock(arrResultComment, resultAnswer, resultDefaultComment, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

#pragma mark - V1.4.0

/**
 *  获取话题语音
 *
 *  @param topicId      话题ID
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getTopicPracticeArrayWithTopicId:(NSString *)topicId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (topicId) {
        [dicParam setObject:topicId forKey:@"id"];
    }
    if (userId) {
        [dicParam setObject:userId forKey:@"userId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/article/getArticleSpeech" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                    }
                }
                resultBlock(arrResult, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
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
-(void)getTopicDetailWithTopicId:(NSString *)aid userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, ModelTag *modelTag, NSDictionary *dicResult))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
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
                NSArray *arrList = [result.body objectForKey:kQuestionAllKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrList && [arrList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in arrList) {
                        ModelQuestionTopic *model = [[ModelQuestionTopic alloc] initWithCustom:dic];
                        [arrResult addObject:model];
                    }
                }
                ModelTag *modelTag = nil;
                NSDictionary *dicTopic = [result.body objectForKey:kTagKey];
                if (dicTopic && [dicTopic isKindOfClass:[NSDictionary class]]) {
                    modelTag = [[ModelTag alloc] initWithCustom:dicTopic];
                    NSString *strAtt = [result.body objectForKey:@"flag"];
                    if (strAtt && ![strAtt isKindOfClass:[NSNull class]]) {
                        [modelTag setIsAtt:[strAtt boolValue]];
                    }
                }
                resultBlock(arrResult, modelTag, result.body);
            }
        } else {
            if (errorBlock) {
                errorBlock(result.msg);
            }
        }
    }];
}

@end
