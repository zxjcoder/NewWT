//
//  ModelEntity.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ModelEntity.h"
#import "Utils.h"

@implementation ModelEntity

/**
 *  自定义-字典转换成模型
 */
-(id)initWithCustom:(NSDictionary*)dic
{
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) return nil;
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 *  自定-字典转换成模型
 */
-(id)initWithAuto:(NSDictionary*)dic
{
    if (dic == nil) return nil;
    self = [[self class] mj_objectWithKeyValues:dic];
    if (!self) {
        
    }
    return self;
}

/**
 *  当前模型转换成字典
 */
-(NSDictionary*)getDictionary
{
    return [self.mj_keyValues copy];
}

/**
 *  将模型数组转为字典数组
 */
+(NSArray*)getDictionaryArrayWithModelArray:(NSArray*)array
{
    return [[self class] mj_keyValuesArrayWithObjectArray:array];
}

@end

@implementation ModelAppConfig

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            self.platform = [Utils getSNSInt:dic[@"platform"]];
            self.appStatus = [Utils getSNSInt:dic[@"status"]];
            self.rankStatus = [Utils getSNSInt:dic[@"bill"]];
            
            self.appVersion = [Utils getSNSString:dic[@"version_num"]];
            
            self.title = [Utils getSNSString:dic[@"title"]];
            self.content = [Utils getSNSString:dic[@"content"]];
            self.downloadUrl = [Utils getSNSString:dic[@"url"]];
        }
    }
    return self;
}

@end

@implementation ModelNotice

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.ids = [Utils getSNSString:dic[@"typeId"]];
            self.noticeType = [Utils getSNSInt:dic[@"typeId"]];
            self.noticeTitle = [Utils getSNSString:dic[@"type"]];
            self.noticeDesc = [Utils getSNSString:dic[@"content"]];
            self.noticeTime = [Utils getSNSString:dic[@"create_time"]];
            self.noticeCount = [Utils getSNSInt:dic[@"count"]];
        }
    }
    return self;
}

@end

@implementation ModelNoticeDetail

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.ids = [Utils getSNSString:dic[@"id"]];
            self.noticeContent = [Utils getSNSString:dic[@"content"]];
            self.noticeNickName = [Utils getSNSString:dic[@"operson"]];
            self.noticeTime = [Utils getSNSString:dic[@"create_time"]];
            self.isRead = [Utils getSNSInt:dic[@"status"]];
        }
    }
    return self;
}

@end

@implementation ModelUserBase

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.userId = [Utils getSNSString:dic[@"id"]];
            self.account = [Utils getSNSString:dic[@"account"]];
            self.nickname = [Utils getSNSString:dic[@"nickname"]];
            self.head_img = [Utils getSNSString:dic[@"head_img"]];
            self.sign  = [Utils getSNSString:dic[@"sign"]];
        }
    }
    return self;
}

@end

@implementation ModelUserBlack

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.userId = [Utils getSNSString:dic[@"hid"]];
            self.account = [Utils getSNSString:dic[@"account"]];
            self.nickname = [Utils getSNSString:dic[@"hname"]];
            self.head_img = [Utils getSNSString:dic[@"himg"]];
            self.sign  = [Utils getSNSString:dic[@"sign"]];
        }
    }
    return self;
}

@end

@implementation ModelUser

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self) {
        self.sex = [Utils getSNSInteger:dic[@"sex"]];
        self.phone = [Utils getSNSString:dic[@"phone"]];
        self.email = [Utils getSNSString:dic[@"email"]];
        
        self.type = [Utils getSNSInteger:dic[@"type"]];
        
        self.password = [Utils getSNSString:dic[@"password"]];
        self.trade = [Utils getSNSString:dic[@"trade"]];
        self.label = [Utils getSNSString:dic[@"label"]];
        self.company  = [Utils getSNSString:dic[@"company"]];
        self.address  = [Utils getSNSString:dic[@"address"]];
        
        self.birthday = [Utils getSNSString:dic[@"date_of_birth"]];
        self.education = [Utils getSNSString:dic[@"education"]];
        self.joinTime = [Utils getSNSString:dic[@"entry_time"]];
        
        self.unReadTotalCount = [Utils getSNSInt:dic[@"unReadTotalCount"]];
        self.shoppingCartCount = [Utils getSNSInt:dic[@"shoppingCartCount"]];
        
        self.flag = [Utils getSNSInt:dic[@"flag"]];
        
        self.qq_id = [Utils getSNSString:dic[@"qq_id"]];
        self.sina_id = [Utils getSNSString:dic[@"sina_id"]];
        self.wechat_id = [Utils getSNSString:dic[@"wechat_id"]];
        
        self.myFunsCount = [Utils getSNSInt:dic[@"myFunsCount"]];
        self.myWaitAnsCount = [Utils getSNSInt:dic[@"myWaitAnsCount"]];
        self.myWaitNewAns = [Utils getSNSInt:dic[@"myWaitAnsCountBy"]];
        self.myQuesCount = [Utils getSNSInt:dic[@"myQuesCount"]];
        self.myAttAccount = [Utils getSNSInt:dic[@"myAttAccount"]];
        self.myCollectAccount = [Utils getSNSInt:dic[@"myCollectAccount"]];
        
        self.myQuesNewCount = [Utils getSNSInt:dic[@"myQuesNewCount"]];
        
        self.myNoticeCenterCount = [Utils getSNSInt:dic[@"notice"]];
        self.myAnswerCommentcount = [Utils getSNSInt:dic[@"ansCount"]];
        self.myAnswerAgreeCount = [Utils getSNSInt:dic[@"answerAgree"]];
        self.myAnswerShareCount = [Utils getSNSInt:dic[@"ansShareCount"]];
        self.myAnswerCollectCount = [Utils getSNSInt:dic[@"ansCollCount"]];
        
        self.myCommentReplyCount = [Utils getSNSInt:dic[@"ansCount"]];
        
        self.balance = [Utils getSNSDouble:dic[@"balance"]];
    }
    return self;
}

@end

@implementation ModelUserProfile

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self) {
        self.hisAttention = [Utils getSNSInt:dic[@"hisAttention"]];
        self.hisQues = [Utils getSNSInt:dic[@"hisQues"]];
        self.hisFuns = [Utils getSNSInt:dic[@"hisFuns"]];
        self.hisAnswer = [Utils getSNSInt:dic[@"hisAnswer"]];
        self.hisCollect = [Utils getSNSInt:dic[@"hisCollect"]];
        
        self.isAtt = [Utils getSNSBool:dic[@"isAtt"]];
        self.isBlackList = [Utils getSNSBool:dic[@"isBlack"]];
    }
    return self;
}

@end

@implementation ModelBizContent

- (NSString *)description {
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary new];
    // NOTE: 增加不变部分数据
    [tmpDict addEntriesFromDictionary:@{@"subject":_subject?:@"",
                                        @"out_trade_no":_out_trade_no?:@"",
                                        @"total_amount":_total_amount?:@"",
                                        @"seller_id":_seller_id?:@"",
                                        @"product_code":_product_code?:@"QUICK_MSECURITY_PAY"}];
    
    // NOTE: 增加可变部分数据
    if (_body.length > 0) {
        [tmpDict setObject:_body forKey:@"body"];
    }
    
    if (_timeout_express.length > 0) {
        [tmpDict setObject:_timeout_express forKey:@"timeout_express"];
    }
    
    // NOTE: 转变得到json string
    NSData* tmpData = [NSJSONSerialization dataWithJSONObject:tmpDict options:0 error:nil];
    NSString* tmpStr = [[NSString alloc]initWithData:tmpData encoding:NSUTF8StringEncoding];
    return tmpStr;
}

@end

@implementation ModelOrderALI

- (NSString *)orderInfoEncoded:(BOOL)bEncoded {
    
    if (_app_id.length <= 0) {
        return nil;
    }
    // NOTE: 增加不变部分数据
    NSMutableDictionary *tmpDict = [NSMutableDictionary new];
    [tmpDict addEntriesFromDictionary:@{@"app_id":_app_id,
                                        @"method":_method?:@"alipay.trade.app.pay",
                                        @"charset":_charset?:@"utf-8",
                                        @"timestamp":_timestamp?:@"",
                                        @"version":_version?:@"1.0",
                                        @"biz_content":_biz_content.description?:@"",
                                        @"sign_type":_sign_type?:@"RSA"}];
    // NOTE: 增加可变部分数据
    if (_format.length > 0) {
        [tmpDict setObject:_format forKey:@"format"];
    }
    if (_return_url.length > 0) {
        [tmpDict setObject:_return_url forKey:@"return_url"];
    }
    if (_notify_url.length > 0) {
        [tmpDict setObject:_notify_url forKey:@"notify_url"];
    }
    if (_app_auth_token.length > 0) {
        [tmpDict setObject:_app_auth_token forKey:@"app_auth_token"];
    }
    // NOTE: 排序，得出最终请求字串
    NSArray* sortedKeyArray = [[tmpDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (NSString* key in sortedKeyArray) {
        NSString* orderItem = [self orderItemWithKey:key andValue:[tmpDict objectForKey:key] encoded:bEncoded];
        if (orderItem.length > 0) {
            [tmpArray addObject:orderItem];
        }
    }
    return [tmpArray componentsJoinedByString:@"&"];
}

- (NSString*)orderItemWithKey:(NSString*)key andValue:(NSString*)value encoded:(BOOL)bEncoded
{
    if (key.length > 0 && value.length > 0) {
        if (bEncoded) {
            value = [self encodeValue:value];
        }
        return [NSString stringWithFormat:@"%@=%@", key, value];
    }
    return nil;
}

- (NSString*)encodeValue:(NSString*)value
{
    NSString* encodedValue = value;
    if (value.length > 0) {
        encodedValue = (__bridge_transfer  NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)value, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    }
    return encodedValue;
}

@end

@implementation ModelOrderALIResult

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self) {
        self.resultStatus = [Utils getSNSInteger:dic[@"resultStatus"]];
        self.memo = [Utils getSNSString:dic[@"memo"]];
        self.result = [Utils getSNSString:dic[@"result"]];
    }
    return self;
}

@end

///支付宝2.0认证实体类
@implementation ModelAPAuthV2InfoALI

- (NSString *)description
{
    if (self.appID.length != 16||self.pid.length != 16) {
        return nil;
    }
    // NOTE: 增加不变部分数据
    NSMutableDictionary *tmpDict = [NSMutableDictionary new];
    [tmpDict addEntriesFromDictionary:@{@"app_id":_appID,
                                        @"pid":_pid,
                                        @"apiname":@"com.alipay.account.auth",
                                        @"method":@"alipay.open.auth.sdk.code.get",
                                        @"app_name":@"mc",
                                        @"biz_type":@"openservice",
                                        @"product_id":@"APP_FAST_LOGIN",
                                        @"scope":@"kuaijie",
                                        @"target_id":(_targetID?:@"20141225xxxx"),
                                        @"auth_type":(_authType?:@"AUTHACCOUNT")}];
    // NOTE: 排序，得出最终请求字串
    NSArray* sortedKeyArray = [[tmpDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (NSString* key in sortedKeyArray) {
        NSString* orderItem = [self itemWithKey:key andValue:[tmpDict objectForKey:key]];
        if (orderItem.length > 0) {
            [tmpArray addObject:orderItem];
        }
    }
    return [tmpArray componentsJoinedByString:@"&"];
}

- (NSString*)itemWithKey:(NSString*)key andValue:(NSString*)value
{
    if (key.length > 0 && value.length > 0) {
        return [NSString stringWithFormat:@"%@=%@", key, value];
    }
    return nil;
}

@end


@implementation ModelWeChat

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.openId = [Utils getSNSString:dic[@"openid"]];
        self.accessToken = [Utils getSNSString:dic[@"access_token"]];
        self.expiresIn = [Utils getSNSString:dic[@"expires_in"]];
        self.refreshToken = [Utils getSNSString:dic[@"refresh_token"]];
        self.scope = [Utils getSNSString:dic[@"scope"]];
        self.unionId = [Utils getSNSString:dic[@"unionid"]];
    }
    return self;
}

@end

@implementation ModelWeChatUser

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.openId = [Utils getSNSString:dic[@"openid"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.sex = [Utils getSNSInteger:dic[@"sex"]]==1 ? kCMale : kCFemale;
        self.province = [Utils getSNSString:dic[@"province"]];
        self.city = [Utils getSNSString:dic[@"city"]];
        self.country = [Utils getSNSString:dic[@"country"]];
        self.language = [Utils getSNSString:dic[@"language"]];
        self.headimgurl = [Utils getSNSString:dic[@"headimgurl"]];
        self.unionid = [Utils getSNSString:dic[@"unionid"]];
    }
    return self;
}

@end

@implementation ModelPushManager

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        
    }
    return self;
}

@end

@implementation ModelDictionary

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        
    }
    return self;
}

@end

@implementation ModelTagType

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.typeId = [Utils getSNSString:dic[@"typeId"]];
        self.typeName = [Utils getSNSString:dic[@"name"]];
        
        NSArray *arr = [dic objectForKey:@"articles"];
        if (arr && arr.count > 0) {
            NSMutableArray *arrResult = [NSMutableArray array];
            for (NSDictionary *dicTag in arr) {
                [arrResult addObject:[[ModelTag alloc] initWithCustom:dicTag]];
            }
            self.tagArray = [NSArray arrayWithArray:arrResult];
        }
    }
    return self;
}

@end

@implementation ModelTag

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.tagId = [Utils getSNSString:dic[@"id"]];
        self.tagName = [Utils getSNSString:dic[@"art_name"]];
        self.tagLogo = [Utils getSNSString:dic[@"art_img"]];
        self.question_id = [Utils getSNSString:dic[@"question_id"]];
        self.userId = [Utils getSNSString:dic[@"pusher"]];
        self.attCount = [Utils getSNSInt:dic[@"count"]];
        self.status = [Utils getSNSInt:dic[@"status"]];
        self.isCollection = [Utils getSNSInt:dic[@"attent"]];
    }
    return self;
}

@end

@implementation ModelBanner

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.imageUrl = [Utils getSNSString:dic[@"rmd_img"]];
        self.title = [Utils getSNSString:dic[@"title"]];
        self.url = [Utils getSNSString:dic[@"url"]];
        self.code = [Utils getSNSString:dic[@"code"]];
        self.type = [Utils getSNSInt:dic[@"type"]];
        self.sorce = [Utils getSNSString:dic[@"sorce"]];
        self.look_num = [Utils getSNSString:dic[@"look_num"]];
        self.create_time = [Utils getSNSString:dic[@"create_time"]];
    }
    return self;
}

@end

@implementation ModelHotArticle

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.imageUrl = [Utils getSNSString:dic[@"news_img"]];
        self.title = [Utils getSNSString:dic[@"title"]];
        self.desc = [Utils getSNSString:dic[@"content"]];
        self.source = [Utils getSNSString:dic[@"source"]];
        self.look_num = [Utils getSNSLong:dic[@"look_num"]];
    }
    return self;
}

@end

@implementation ModelCircleHot

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"question_id"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.userId = [Utils getSNSString:dic[@"quserId"]];
        self.head_img = [Utils getSNSString:dic[@"qhead_img"]];
        self.nickname = [Utils getSNSString:dic[@"qnickname"]];
        self.sign = [Utils getSNSString:dic[@"qsign"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.contentNoImage = self.content.imgReplacing;
    }
    return self;
}

@end

@implementation ModelCircleDynamic

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.contentNoImage = self.content.imgReplacing;
        
        self.userId = [Utils getSNSString:dic[@"hid"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        
        self.wid = [Utils getSNSString:dic[@"wid"]];
        self.flag = [Utils getSNSString:dic[@"flag"]];
    }
    return self;
}

@end

@implementation ModelCircleNew

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        
        self.userIdQ = [Utils getSNSString:dic[@"fid"]];
        self.head_imgQ = [Utils getSNSString:dic[@"fimg"]];
        self.nicknameQ = [Utils getSNSString:dic[@"fname"]];
        
        self.userIdA = [Utils getSNSString:dic[@"hid"]];
        self.head_imgA = [Utils getSNSString:dic[@"himg"]];
        self.nicknameA = [Utils getSNSString:dic[@"hname"]];
        self.signA = [Utils getSNSString:dic[@"hsign"]];
        
        self.count = [Utils getSNSString:dic[@"count"]];
        self.time = [Utils getSNSString:dic[@"ago"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.contentNoImage = self.content.imgReplacing;
    }
    return self;
}

@end

@implementation ModelCircleAtt

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        self.content = [Utils getSNSString:dic[@"describ"]];
        
        self.userIdQ = [Utils getSNSString:dic[@"fid"]];
        self.head_imgQ = [Utils getSNSString:dic[@"fimg"]];
        self.nicknameQ = [Utils getSNSString:dic[@"fname"]];
        
        self.userIdA = [Utils getSNSString:dic[@"hid"]];
        self.head_imgA = [Utils getSNSString:dic[@"himg"]];
        self.nicknameA = [Utils getSNSString:dic[@"hname"]];
        self.signA = [Utils getSNSString:dic[@"hsign"]];
        
        self.count = [Utils getSNSString:dic[@"count"]];
        self.time = [Utils getSNSString:dic[@"ago"]];
        self.answerContent = [Utils getSNSString:dic[@"content"]];
    }
    return self;
}

@end

@implementation ModelCircleSearchContent

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        
        id answer = [dic objectForKey:@"answers"];
        if (answer && [answer isKindOfClass:[NSArray class]] && [(NSArray*)answer count] > 0) {
            NSDictionary *dicAnswer = [(NSArray*)answer firstObject];
            if (dicAnswer && [dicAnswer isKindOfClass:[NSDictionary class]]) {
                self.aid = [Utils getSNSString:dicAnswer[@"id"]];
                self.content = [Utils getSNSString:dicAnswer[@"content"]];
                self.count = [Utils getSNSLong:dicAnswer[@"agree"]];
            }
        } else if (answer && [answer isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dicAnswer = (NSDictionary*)answer;
            if (dicAnswer && [dicAnswer isKindOfClass:[NSDictionary class]]) {
                self.aid = [Utils getSNSString:dicAnswer[@"id"]];
                self.content = [Utils getSNSString:dicAnswer[@"content"]];
                self.count = [Utils getSNSLong:dicAnswer[@"agree"]];
            }
        }
        self.flag = [Utils getSNSInt:dic[@"flag"]];
    }
    return self;
}

@end

@implementation ModelQuestion

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        
    }
    return self;
}

@end

@implementation ModelQuestionBase

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        if (self.ids == nil || self.ids.length == 0) {
            self.ids = [Utils getSNSString:dic[@"question_id"]];
        }
        self.title = [Utils getSNSString:dic[@"questions"]];
    }
    return self;
}

@end

@implementation ModelQuestionDetail

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.sign = [Utils getSNSString:dic[@"sign"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.qContent = [Utils getSNSString:dic[@"describ"]];
        
        NSArray *arr = [dic objectForKey:@"resultArt"];
        if ([arr isKindOfClass:[NSArray class]]) {
            self.arrTopic = [NSArray arrayWithArray:arr];
        }
        self.answerCount = [Utils getSNSLong:dic[@"reusltAncount"]];
        self.attCount = [Utils getSNSLong:dic[@"resultAttention"]];
        
        self.isAtt = [Utils getSNSBool:dic[@"resultAtten"]];
        self.answerQuestion = [Utils getSNSString:dic[@"answer"]];
        self.status = [Utils getSNSInt:dic[@"status"]];
        self.isInvitation = [Utils getSNSInt:dic[@"reusltInvite"]];
    }
    return self;
}

@end

@implementation ModelMyAllQuestion

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.qContent = [Utils getSNSString:dic[@"describ"]];
        
        self.aContent = [Utils getSNSString:dic[@"content"]];
        self.aid = [Utils getSNSString:dic[@"aid"]];
        
        self.status = [Utils getSNSInt:dic[@"status"]];
    }
    return self;
}

@end

@implementation ModelMyNewQuestion

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        
    }
    return self;
}

@end

@implementation ModelAnswerBase

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"content"]];
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.sign = [Utils getSNSString:dic[@"sign"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        
        self.question_id = [Utils getSNSString:dic[@"question_id"]];
        self.question_title = [Utils getSNSString:dic[@"questions"]];
        
        self.discuss_time = [Utils getSNSString:dic[@"discuss_time"]];
        
        self.isAgree = [Utils getSNSInt:dic[@"resultAld"]];
        
        self.resultRpt = [Utils getSNSLong:dic[@"resultRpt"]];
        self.disagree = [Utils getSNSLong:dic[@"disagree"]];
        self.agree = [Utils getSNSLong:dic[@"agree"]];
        self.commentCount = [Utils getSNSLong:dic[@"resultComCount"]];
        self.isCollection = [Utils getSNSInt:dic[@"resultAns"]];
    }
    return self;
}

@end

@implementation ModelQuestionTopic

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        
        self.userIdA = [Utils getSNSString:dic[@"hid"]];
        self.head_imgA = [Utils getSNSString:dic[@"himg"]];
        self.nicknameA = [Utils getSNSString:dic[@"hname"]];
        self.signA = [Utils getSNSString:dic[@"hsign"]];
        
        self.userIdQ = [Utils getSNSString:dic[@"quserId"]];
        self.head_imgQ = [Utils getSNSString:dic[@"qhead_img"]];
        self.nicknameQ = [Utils getSNSString:dic[@"qnickname"]];
        self.signQ = [Utils getSNSString:dic[@"qsign"]];
        
        self.content = [Utils getSNSString:dic[@"content"]];
    }
    return self;
}

@end

@implementation ModelUserInvitation

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.isInvitation = [Utils getSNSInt:dic[@"flag"]];
    }
    return self;
}

@end

@implementation ModelComment

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.createTime = [Utils getSNSString:dic[@"create_time"]];
        self.type = [Utils getSNSString:dic[@"type"]];
        self.obj_id = [Utils getSNSString:dic[@"obj_id"]];
    }
    return self;
}

@end

@implementation ModelCollectionAnswer

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.questions = [Utils getSNSString:dic[@"questions"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.question_id = [Utils getSNSString:dic[@"question_id"]];
        self.answer_id = [Utils getSNSString:dic[@"answer_id"]];
    }
    return self;
}

@end

@implementation ModelCollection

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"title"]];
        self.img = [Utils getSNSString:dic[@"img"]];
        self.hotspot_id = [Utils getSNSString:dic[@"hotspot_id"]];
        self.user_id = [Utils getSNSString:dic[@"user_id"]];
        self.collect_title = [Utils getSNSString:dic[@"collect_title"]];
        self.type = [Utils getSNSString:dic[@"type"]];
    }
    return self;
}

@end

@implementation ModelQuestionMyAnswer

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.count = [Utils getSNSString:dic[@"agree"]];
        self.userId = [Utils getSNSString:dic[@"userId"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.sgin = [Utils getSNSString:dic[@"sgin"]];
    }
    return self;
}

@end

@implementation ModelQuestionMyAnswerComment

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.qid = [Utils getSNSString:dic[@"question_id"]];
        self.acontent = [Utils getSNSString:dic[@"acontent"]];
        
        self.create_time = [Utils getSNSString:dic[@"create_time"]];
        self.com_time = [Utils getSNSString:dic[@"com_time"]];
        
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.userid = [Utils getSNSString:dic[@"user_id"]];
        
        self.status = [Utils getSNSInt:dic[@"status"]];
        self.type = [Utils getSNSInt:dic[@"type"]];
    }
    return self;
}

@end

@implementation ModelWaitAnswer

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.status = [Utils getSNSInt:dic[@"status"]];
    }
    return self;
}

@end

@implementation ModelAttentionQuestion

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
 
    }
    return self;
}

@end

@implementation ModelRankCompany

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.company_name = [Utils getSNSString:dic[@"company_name"]];
        self.address = [Utils getSNSString:dic[@"address"]];
        self.company_img = [Utils getSNSString:dic[@"company_img"]];
        self.cpy_name = [Utils getSNSString:dic[@"cpy_name"]];
        self.synopsis = [Utils getSNSString:dic[@"synopsis"]];
        self.create_time = [Utils getSNSString:dic[@"create_time"]];
        self.type = [Utils getSNSInt:dic[@"type"]];
        self.code = [Utils getSNSString:dic[@"code"]];
        self.count = [Utils getSNSString:dic[@"count"]];
        
        self.isAtt = [Utils getSNSBool:dic[@"resultColl"]];
    }
    return self;
}

@end

@implementation ModelRankUser

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.nickname = [Utils getSNSString:dic[@"operator"]];
        self.company_id = [Utils getSNSString:dic[@"company_id"]];
        self.company_name = [Utils getSNSString:dic[@"company_name"]];
        self.operator_img = [Utils getSNSString:dic[@"operator_img"]];
        self.create_time = [Utils getSNSString:dic[@"create_time"]];
        self.type = [Utils getSNSInt:dic[@"type"]];
        
        self.isAtt = [Utils getSNSBool:dic[@"resultColl"]];
    }
    return self;
}

@end

@class ModelTask;

@implementation ModelPractice

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"title"]];
        self.time = [Utils getSNSString:dic[@"speech_time"]];
        
        self.speech_img = [Utils getSNSString:dic[@"speech_img"]];
        
        self.bkimg = [Utils getSNSString:dic[@"bkimg"]];
        self.speech_url = [Utils getSNSString:dic[@"speech_url"]];
        self.share_content = [Utils getSNSString:dic[@"content"]];
        
        self.nickname = [Utils getSNSString:dic[@"operator"]];
        self.person_synopsis = [Utils getSNSString:dic[@"person_synopsis"]];
        self.person_title = [Utils getSNSString:dic[@"person_title"]];
        
        self.create_time = [Utils getSNSString:dic[@"create_time"]];
        self.speech_content = [Utils getSNSString:dic[@"speech_content"]];
        
        self.unlock = [Utils getSNSInt:dic[@"unlock"]];
        
        self.joinCart = [Utils getSNSInt:dic[@"joinCart"]];
        self.price = [Utils getSNSString:dic[@"price"]];
        self.buyStatus = [Utils getSNSInt:dic[@"buyStatus"]];
        
        self.price = [Utils getSNSString:dic[@"price"]];
        
        NSArray *arr = [dic objectForKey:@"speech_images"];
        if (arr && [arr isKindOfClass:[NSArray class]] && arr.count > 0) {
            self.arrImage = [NSArray arrayWithArray:arr];
        }
        self.showText = [Utils getSNSInt:dic[@"show_text"]];
        
        self.applauds = [Utils getSNSLong:dic[@"applauds"]];
        self.mcount = [Utils getSNSLong:dic[@"mcount"]];
        self.ccount = [Utils getSNSLong:dic[@"count"]];
        
        self.qcount = [Utils getSNSLong:dic[@"qcount"]];
        
        self.isCollection = [Utils getSNSBool:dic[@"resultCollect"]];
        self.isPraise = [Utils getSNSBool:dic[@"resultApplaud"]];
        
        self.type = [Utils getSNSInt:dic[@"type"]];
    }
    return self;
}

@end

@class ModelCommentReply;

@implementation ModelAnswerComment

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.createTime = [Utils getSNSString:dic[@"create_time"]];
        self.type = [Utils getSNSInt:dic[@"type"]];
        self.obj_id = [Utils getSNSString:dic[@"obj_id"]];
        
        NSArray *arr = [dic objectForKey:@"commentReply"];
        if (arr && [arr isKindOfClass:[NSArray class]] && arr.count > 0) {
            NSMutableArray *arrReply = [NSMutableArray array];
            for (NSDictionary *dicReply in arr) {
                ModelCommentReply *modelCR = [[ModelCommentReply alloc] initWithCustom:dicReply];
                [modelCR setCommentId:self.ids];
                [arrReply addObject:modelCR];
            }
            self.arrReply = [NSArray arrayWithArray:arrReply];
        }
    }
    return self;
}

@end

@implementation ModelCommentReply

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.user_id = [Utils getSNSString:dic[@"user_id"]];
        self.hnickname = [Utils getSNSString:dic[@"hnickname"]];
        self.reply_user_id = [Utils getSNSString:dic[@"reply_user_id"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.parent_id = [Utils getSNSString:dic[@"parent_id"]];
        
    }
    return self;
}

@end

@implementation ModelPracticeQuestion

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"question_id"]];
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.userId = [Utils getSNSString:dic[@"quser_id"]];
        self.head_img = [Utils getSNSString:dic[@"qhead_img"]];
        self.nickname = [Utils getSNSString:dic[@"qnickname"]];
        self.sign = [Utils getSNSString:dic[@"qsign"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        self.content = [Utils getSNSString:dic[@"content"]];
    }
    return self;
}

@end

@implementation ModelTask

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.speech_id = [Utils getSNSString:dic[@"speech_id"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        self.status = [Utils getSNSInt:dic[@"status"]];
        self.rule = [Utils getSNSInteger:dic[@"rule"]];
    }
    return self;
}

@end

@implementation ModelSubscribe

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"title"]];
        self.team_name = [Utils getSNSString:dic[@"team_name"]];
        self.team_info = [Utils getSNSString:dic[@"team_intro"]];
        
        self.theme_intro = [Utils getSNSString:dic[@"theme_intro"]];
        self.illustration = [Utils getSNSString:dic[@"illustration"]];
        self.course_picture = [Utils getSNSString:dic[@"course_picture"]];
        
        self.price = [Utils getSNSString:dic[@"price"]];
        self.units = [Utils getSNSString:dic[@"units"]];
        
        self.type = [Utils getSNSInt:dic[@"type"]];
        self.count = [Utils getSNSInt:dic[@"count"]];
        self.status = [Utils getSNSInt:dic[@"status"]];
        self.unReadCount = [Utils getSNSInt:dic[@"unReadCount"]];
    }
    return self;
}

@end

@implementation ModelSubscribeDetail

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.isSubscribe = [Utils getSNSInt:dic[@"isSubscribe"]]==0?NO:YES;
        self.fit_people = [Utils getSNSString:dic[@"fit_people"]];
        self.must_know = [Utils getSNSString:dic[@"must_know"]];
        self.need_help = [Utils getSNSString:dic[@"need_help"]];
        self.latest_push = [Utils getSNSString:dic[@"latest_push"]];
    }
    return self;
}

@end

@implementation ModelSubscribePlay

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"title"]];
        self.price = [Utils getSNSString:dic[@"price"]];
        self.units = [Utils getSNSString:dic[@"units"]];
        self.pay_time = [Utils getSNSString:dic[@"pay_time"]];
        self.type = [Utils getSNSInt:dic[@"type"]];
    }
    return self;
}

@end

@implementation ModelCurriculum

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"cid"]];
        
        self.subscribeId = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"title"]];
        
        self.speaker_name = [Utils getSNSString:dic[@"operator"]];
        
        self.team_name = [Utils getSNSString:dic[@"team_name"]];
        self.team_intro = [Utils getSNSString:dic[@"team_intro"]];
        
        self.create_time = [Utils getSNSString:dic[@"create_time"]];
        self.illustration = [Utils getSNSString:dic[@"illustration"]];
        self.course_picture = [Utils getSNSString:dic[@"course_picture"]];
        
        id courseImges = [dic objectForKey:@"course_imges"];
        if (courseImges && [courseImges isKindOfClass:[NSArray class]]) {
            self.course_imges = [NSArray arrayWithArray:courseImges];
        } else if (courseImges && [courseImges isKindOfClass:[NSString class]]) {
            NSArray *arrCourseImges = [courseImges componentsSeparatedByString:@"@"];
            if (arrCourseImges && [arrCourseImges isKindOfClass:[NSArray class]] && arrCourseImges.count > 0) {
                self.course_imges = [NSArray arrayWithArray:arrCourseImges];
            }
        }
        self.ctitle = [Utils getSNSString:dic[@"ctitle"]];
        self.content = [Utils getSNSString:dic[@"speech_content"]];
        
        self.audio_picture = [Utils getSNSString:dic[@"audio_picture"]];
        self.audio_time = [Utils getSNSString:dic[@"audio_time"]];
        self.audio_url = [Utils getSNSString:dic[@"audio_url"]];
        
        self.free_read = [Utils getSNSInt:dic[@"free_read"]];
        self.unReadCount = [Utils getSNSInt:dic[@"unReadCount"]];
    }
    return self;
}

@end

@implementation ModelPracticeType

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.type = [Utils getSNSString:dic[@"type"]];
        
        NSArray *array = [dic objectForKey:@"speechs"];
        if (array && [array isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrayP = [NSMutableArray array];
            for (NSDictionary *dicP in array) {
                [arrayP addObject:[[ModelPractice alloc] initWithCustom:dicP]];
            }
            self.arrPractice = [NSArray arrayWithArray:arrayP];
        }
    }
    return self;
}

@end

@implementation ModelQuestionBoutique

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"question_id"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        
        self.userId = [Utils getSNSString:dic[@"quser_id"]];
        self.nickname = [Utils getSNSString:dic[@"qnickname"]];
        self.head_img = [Utils getSNSString:dic[@"qhead_img"]];
        self.sign = [Utils getSNSString:dic[@"qsign"]];
    }
    return self;
}

@end

@implementation ModelQuestionItem

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.sign = [Utils getSNSString:dic[@"sign"]];
    }
    return self;
}

@end

@implementation ModelOrderWT

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        
        self.type = [Utils getSNSInt:dic[@"type"]];
        
        self.title = [Utils getSNSString:dic[@"title"]];
        self.order_no = [Utils getSNSString:dic[@"order_no"]];
        self.price = [Utils getSNSString:dic[@"price"]];
        
        self.pay_type = [Utils getSNSInteger:dic[@"pay_type"]];
        self.status = [Utils getSNSInt:dic[@"status"]];
        
        self.create_time = [Utils getSNSString:dic[@"create_time"]];
        self.pay_time = [Utils getSNSString:dic[@"pay_time"]];
    }
    return self;
}

@end

@implementation ModelRechargeRecord

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.title = [Utils getSNSString:dic[@"title"]];
        self.price = [Utils getSNSString:dic[@"price"]];
        self.pay_time = [Utils getSNSString:dic[@"create_time"]];
    }
    return self;
}

@end

@implementation ModelQuestionRecommend

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.aid = [Utils getSNSString:dic[@"aid"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        
        self.userId = [Utils getSNSString:dic[@"userId"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.sign = [Utils getSNSString:dic[@"sign"]];
    }
    return self;
}

@end

@implementation ModelPayCart

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        
    }
    return self;
}

@end

@implementation ModelMessage

-(id)initWithCustom:(NSDictionary*)dic
{
    self = [super initWithCustom:dic];
    if (self&&dic) {
        self.ids = [Utils getSNSString:dic[@"id"]];
        self.content = [Utils getSNSString:dic[@"content"]];
        
        self.userId = [Utils getSNSString:dic[@"userId"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.sign = [Utils getSNSString:dic[@"sign"]];
    }
    return self;
}

@end

