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
    self = [[self class] objectWithKeyValues:dic];
    if (!self) {
        
    }
    return self;
}

/**
 *  当前模型转换成字典
 */
-(NSDictionary*)getDictionary
{
    return [self.keyValues copy];
}

/**
 *  将模型数组转为字典数组
 */
+(NSArray*)getDictionaryArrayWithModelArray:(NSArray*)array
{
    return [[self class] keyValuesArrayWithObjectArray:array];
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

@implementation ModelOrderALI

-(id)init
{
    self = [super init];
    if (self) {
        self.partner = kALI_PID;
        self.seller = kALI_Seller;
        
        self.service = @"mobile.securitypay.pay";
        self.paymentType = @"1";
        self.inputCharset = @"utf-8";
        self.itBPay = @"30m";
        self.showUrl = @"m.alipay.com";
    }
    return self;
}

-(NSDictionary*)getDictionary
{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    NSString *package, *time_stamp, *nonce_str;
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [Utils stringMD5:time_stamp];
    package     = @"Sign=RSA";
    
    [signParams setObject: kALI_AppScheme   forKey:@"appid"];
    [signParams setObject: nonce_str        forKey:@"noncestr"];
    [signParams setObject: package          forKey:@"package"];
    [signParams setObject: kALI_PID         forKey:@"partnerid"];
    [signParams setObject: time_stamp       forKey:@"timestamp"];
    [signParams setObject: self.partner     forKey:@"prepayid"];
    [signParams setObject: @"MD5"           forKey:@"signType"];
    [signParams setObject: self.tradeNO     forKey:@"orderId"];
    [signParams setObject: self.productName forKey:@"orderName"];
    [signParams setObject: self.productDescription     forKey:@"orderDesc"];
    [signParams setObject: self.amount     forKey:@"orderPrice"];
    [signParams setObject: self.orderId     forKey:@"orderNumber"];
    [signParams setObject: kALI_Algorithm   forKey:@"sign"];
    [signParams setObject: [NSNumber numberWithInt:2] forKey:@"ptype"];
    return signParams;
}

- (NSString *)description
{
    NSMutableString * discription = [NSMutableString string];
    if (self.partner.length > 0) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller.length > 0) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.tradeNO.length > 0) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
    if (self.productName.length > 0) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
    
    if (self.productDescription.length > 0) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
    if (self.amount.length > 0) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    if (self.notifyURL.length > 0) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    
    if (self.service.length > 0) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType.length > 0) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset.length > 0) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay.length > 0) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl.length > 0) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.rsaDate.length > 0) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
    }
    if (self.appID.length > 0) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
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
    if (self.appID.length != 16||self.pid.length != 16) return nil;
    
    NSArray *decriptionArray = @[[NSString stringWithFormat:@"app_id=\"%@\"", self.appID],
                                 [NSString stringWithFormat:@"pid=\"%@\"", self.pid],
                                 [NSString stringWithFormat:@"apiname=\"%@\"", self.apiName?self.apiName:@"com.alipay.account.auth"],
                                 [NSString stringWithFormat:@"app_name=\"%@\"", self.appName?self.appName:@"mc"],
                                 [NSString stringWithFormat:@"biz_type=\"%@\"", self.bizType?self.bizType:@"openservice"],
                                 [NSString stringWithFormat:@"product_id=\"%@\"", self.productID?self.productID:@"WAP_FAST_LOGIN"],
                                 [NSString stringWithFormat:@"scope=\"%@\"", self.scope?self.scope:@"kuaijie"],
                                 [NSString stringWithFormat:@"target_id=\"%@\"", self.targetID?self.targetID:@"20141225xxxx"],
                                 [NSString stringWithFormat:@"auth_type=\"%@\"", self.authType?self.authType:@"AUTHACCOUNT"],
                                 [NSString stringWithFormat:@"sign_date=\"%@\"", self.signDate?self.signDate:@"2014-12-25 00:00:00"]];
    
    return [decriptionArray componentsJoinedByString:@"&"];
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
        NSArray *arrTags = [dic objectForKey:@"articles"];
        if (arrTags.count > 0) {
            self.tags = [NSArray arrayWithArray:arrTags];
        }
        NSDictionary *dicQuestion = [dic objectForKey:@"question"];
        self.ids = [Utils getSNSString:dicQuestion[@"question_id"]];
        self.aid = [Utils getSNSString:dicQuestion[@"aid"]];
        self.userId = [Utils getSNSString:dicQuestion[@"userid"]];
        self.head_img = [Utils getSNSString:dicQuestion[@"head_img"]];
        self.nickname = [Utils getSNSString:dicQuestion[@"nickname"]];
        self.sign = [Utils getSNSString:dicQuestion[@"sign"]];
        self.title = [Utils getSNSString:dicQuestion[@"questions"]];
        self.answerContent = [Utils getSNSString:dicQuestion[@"content"]];
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
        self.answerContent = [Utils getSNSString:dic[@"content"]];
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
        self.content = [Utils getSNSString:dic[@"content"]];
        self.userId = [Utils getSNSString:dic[@"user_id"]];
        self.count = [Utils getSNSString:dic[@"agree"]];
        self.status = [Utils getSNSInt:dic[@"status"]];
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
        
        self.answerContent = [Utils getSNSString:dic[@"content"]];
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
        self.arrTasks = [dic objectForKey:@"tasks"];
        
        NSArray *arr = [dic objectForKey:@"speech_images"];
        if (arr && arr.count > 0) {
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
        self.userId = [Utils getSNSString:dic[@"userid"]];
        self.head_img = [Utils getSNSString:dic[@"head_img"]];
        self.nickname = [Utils getSNSString:dic[@"nickname"]];
        self.sign = [Utils getSNSString:dic[@"sign"]];
        self.title = [Utils getSNSString:dic[@"questions"]];
        self.answerContent = [Utils getSNSString:dic[@"content"]];
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

