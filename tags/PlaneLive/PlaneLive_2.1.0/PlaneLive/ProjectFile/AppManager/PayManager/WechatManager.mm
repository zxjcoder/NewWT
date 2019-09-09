//
//  WechatManager.m
//  SosoBand
//
//  Created by Daniel on 15/7/6.
//  Copyright (c) 2015年 SSB. All rights reserved.
//

#import "WechatManager.h"
#import "Utils.h"
#import "ClassCategory.h"
/*
 // 签名实例
 // 更新时间：2015年3月3日
 // 负责人：李启波（marcyli）
 // 该Demo用于ios sdk 1.4
 
 //微信支付服务器签名支付请求请求类
 //============================================================================
 //api说明：
 //初始化商户参数，默认给一些参数赋值，如cmdno,date等。
 -(BOOL) init:(NSString *)app_id (NSString *)mch_id;
 
 //设置商户API密钥
 -(void) setKey:(NSString *)key;
 
 //生成签名
 -(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
 
 //获取XML格式的数据
 -(NSString *) genPackage:(NSMutableDictionary*)packageParams;
 
 //提交预支付交易，获取预支付交易会话标识
 -(NSString *) sendPrepay:(NSMutableDictionary *);
 
 //签名实例测试
 - ( NSMutableDictionary *)sendPay_demo;
 
 //获取debug信息日志
 -(NSString *) getDebugifo;
 
 //获取最后返回的错误代码
 -(long) getLasterrCode;
 //============================================================================
 */

// 账号帐户资料
//更改商户把相关参数后可测试


@interface WechatManager()

@end

@implementation WechatManager

/*
 *  创建package签名
 */
+(NSString *)createMd5Sign:(NSDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        NSString *categoryValue = [dict objectForKey:categoryId];
        if (categoryValue != nil
            && ![categoryValue isEqualToString:kEmpty]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            ) {
            [contentString appendFormat:@"%@=%@&", categoryId, categoryValue];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", kWechat_PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign = [WXUtil md5:contentString];
    
    return md5Sign;
}

/*
 *  获取package带参数的签名包
 */
+(NSString *)genPackage:(NSDictionary*)packageParams
{
    NSMutableString *reqPars=[NSMutableString string];
    //生成签名
    NSString *sign = [self createMd5Sign:packageParams];
    //生成xml的package
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>\n"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    
    return [NSString stringWithString:reqPars];
}

/*
 *  提交预支付
 */
+(void)sendPayWithParams:(NSDictionary *)prePayParams successBlock:(void(^)(NSString *result))successBlock resultErrorBlock:(void(^)(NSString *code))resultErrorBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSData *res = [WXUtil httpSend:kWechat_PAR_URL method:@"POST" data:[self genPackage:prePayParams]];
    
    XMLHelper *xml  = [[XMLHelper alloc] init];
    [xml startParse:res];
    
    NSMutableDictionary *resParams = [xml getDict];
    //NSLog(@"%@", resParams);
    NSString *return_code = [resParams objectForKey:@"return_code"];
    if ([return_code isEqualToString:@"SUCCESS"])
    {
        //生成返回数据的签名
        NSString *sign      = [self createMd5Sign:resParams];
        NSString *send_sign = [resParams objectForKey:@"sign"];
        //验证签名正确性
        if( [sign isEqualToString:send_sign]){
            NSString *result_code = [resParams objectForKey:@"result_code"];
            if( [result_code isEqualToString:@"SUCCESS"]) {
                //验证业务处理状态
                successBlock([resParams objectForKey:@"prepay_id"]);
            } else {
                resultErrorBlock([Utils getSNSString:[resParams objectForKey:@"err_code"]]);
            }
        }else{
            errorBlock(@"微信生成签名错误");
        }
    }else{
        NSString *errMsg = [resParams objectForKey:@"return_msg"];
        errMsg = errMsg==nil?@"微信生成订单失败":errMsg;
        errorBlock(errMsg);
    }
}

+(NSString*)getMessageWithCode:(NSString*)code
{
    if ([[code uppercaseString] isEqualToString:@"NOAUTH"]) return @"商户无此接口权限";
    if ([[code uppercaseString] isEqualToString:@"NOTENOUGH"]) return @"余额不足";
    if ([[code uppercaseString] isEqualToString:@"ORDERPAID"]) return @"商户订单已支付";
    if ([[code uppercaseString] isEqualToString:@"ORDERCLOSED"]) return @"订单已关闭";
    if ([[code uppercaseString] isEqualToString:@"SYSTEMERROR"]) return @"系统错误";
    if ([[code uppercaseString] isEqualToString:@"APPID_NOT_EXIST"]) return @"APPID不存在";
    if ([[code uppercaseString] isEqualToString:@"MCHID_NOT_EXIST"]) return @"MCHID不存在";
    if ([[code uppercaseString] isEqualToString:@"APPID_MCHID_NOT_MATCH"]) return @"APPID和MCHID不匹配";
    if ([[code uppercaseString] isEqualToString:@"LACK_PARAMS"]) return @"缺少参数";
    if ([[code uppercaseString] isEqualToString:@"OUT_TRADE_NO_USED"]) return @"商户订单号重复";
    if ([[code uppercaseString] isEqualToString:@"SIGNERROR"]) return @"签名错误";
    if ([[code uppercaseString] isEqualToString:@"XML_FORMAT_ERROR"]) return @"XML格式错误";
    if ([[code uppercaseString] isEqualToString:@"REQUIRE_POST_METHOD"]) return @"请使用POST方法";
    if ([[code uppercaseString] isEqualToString:@"POST_DATA_EMPTY"]) return @"POST数据为空";
    if ([[code uppercaseString] isEqualToString:@"NOT_UTF8"]) return @"编码格式错误";
    return @"微信生成订单失败";
}

/**
 *  生成微信支付认证
 *  @param orderNo 订单编号
 *  @param outTradeNo 商户订单号
 *  @param orderName 订单名称
 *  @param orderDesc 订单描述
 *  @param orderPrice 订单价格
 *  @param successBlock 成功回调函数
 *  @param resultBlock 订单重复回调函数
 *  @param errorBlock 失败回调函数
 */
+(void)sendPayWithOrderNo:(NSString*)orderNo outTradeNo:(NSString*)outTradeNo OrderName:(NSString*)orderName orderDesc:(NSString*)orderDesc orderPrice:(NSString*)orderPrice successBlock:(void(^)(NSDictionary *result))successBlock resultBlock:(void(^)(NSString *msg))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    srand( (unsigned)time(0) );
    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
    noncestr = [WXUtil md5:noncestr];
    NSString *ipAddress = [[UIDevice currentDevice] getIPAddress];
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    
    [packageParams setObject: kWeChat_AppId         forKey:@"appid"];       //开放平台appid
    [packageParams setObject: kWechat_MCH_ID        forKey:@"mch_id"];      //商户号
    [packageParams setObject: @"APP"                forKey:@"device_info"]; //支付设备号或门店号
    [packageParams setObject: noncestr              forKey:@"nonce_str"];   //随机串
    [packageParams setObject: @"APP"                forKey:@"trade_type"];  //支付类型，固定为APP
    [packageParams setObject: orderName             forKey:@"body"];        //订单描述，展示给用户
    [packageParams setObject: kWechat_NOTIFY_URL    forKey:@"notify_url"];  //支付结果异步通知
    [packageParams setObject: orderNo               forKey:@"out_trade_no"];//商户订单号
    [packageParams setObject: ipAddress             forKey:@"spbill_create_ip"];//发器支付的机器ip
    [packageParams setObject: orderPrice            forKey:@"total_fee"];       //订单金额，单位为分
    [packageParams setObject: outTradeNo            forKey:@"attach"];          //附加数据
    
    [WechatManager sendPayWithParams:packageParams successBlock:^(NSString *result) {
        //获取到prepayid后进行第二次签名
        NSString *package, *time_stamp, *nonce_str;
        //设置支付参数
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        ///随机字符串
        nonce_str	= [WXUtil md5:time_stamp];
        //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
        //package       = [NSString stringWithFormat:@"Sign=%@",package];
        package         = @"Sign=WXPay";
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: kWeChat_AppId        forKey:@"appid"];
        [signParams setObject: nonce_str            forKey:@"noncestr"];
        [signParams setObject: package              forKey:@"package"];
        [signParams setObject: kWechat_MCH_ID       forKey:@"partnerid"];
        [signParams setObject: time_stamp           forKey:@"timestamp"];
        [signParams setObject: result               forKey:@"prepayid"];
        //生成签名
        NSString *sign  = [WechatManager createMd5Sign:signParams];
        //添加签名
        [signParams setObject:sign forKey:@"sign"];
        
        [signParams setObject: orderNo              forKey:@"orderId"];
        [signParams setObject: outTradeNo           forKey:@"orderNumber"];
        [signParams setObject: orderPrice           forKey:@"orderPrice"];
        [signParams setObject: orderName        forKey:@"orderName"];
        [signParams setObject: orderDesc        forKey:@"orderDesc"];
        [signParams setObject: @"MD5"               forKey:@"signType"];
        [signParams setObject: [NSNumber numberWithInt:WTPayWayTypeWechat] forKey:@"ptype"];
        
        successBlock(signParams);
    } resultErrorBlock:^(NSString* code) {
        if ([code isEqualToString:@"OUT_TRADE_NO_USED"]) {
            resultBlock([WechatManager getMessageWithCode:code]);
        } else {
            errorBlock([WechatManager getMessageWithCode:code]);
        }
    } errorBlock:^(NSString *msg) {
        errorBlock(msg);
    }];
}
/**
 *  发起微信支付
 *  @param signParams 生成证书之后的参数对象
 */
+(void)sendPayWithDictionary:(NSDictionary*)signParams resultBlock:(void(^)(bool isSuccess))resultBlock;
{
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [signParams objectForKey:@"appid"];
    req.partnerId           = [signParams objectForKey:@"partnerid"];
    req.prepayId            = [signParams objectForKey:@"prepayid"];
    req.nonceStr            = [signParams objectForKey:@"noncestr"];
    req.timeStamp           = [[signParams objectForKey:@"timestamp"] intValue];
    req.package             = [signParams objectForKey:@"package"];
    req.sign                = [signParams objectForKey:@"sign"];
    BOOL isSuccess = [WXApi sendReq:req];
    if (resultBlock) {
        resultBlock(isSuccess);
    }
}

@end
