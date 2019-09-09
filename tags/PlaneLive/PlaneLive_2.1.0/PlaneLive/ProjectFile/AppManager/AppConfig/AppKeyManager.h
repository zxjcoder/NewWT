//
//  AppKeyManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

//随机生成图片地址
#define kRandomImageName [[[NSString stringWithFormat:@"%f%d%d.jpeg",[NSDate timeIntervalSinceReferenceDate],abs((int)arc4random()),abs((int)arc4random())] stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"jpeg" withString:@".jpeg"]

//多行文本默认图片
#define kTextView_FontWithName [ZFont systemFontOfSize:kFont_Default_Size]

//AppScheme
#define kMy_AppScheme @"wtq1107825213"
//AppScheme Host
#define kMy_AppScheme_Host @"wtqPlaneCircle"
//AppScheme Desc
#define kMy_AppScheme_Desc @"CDWuTongLive"

#define kPathExtension @"mp3"

//项目APPID
#define kApp_AppId @"1107825213"
//项目APP地址
#define kApp_AppUrl @"https://itunes.apple.com/cn/app/cats-magazine/id1107825213?mt=8"
//@"itms-apps://itunes.apple.com/app/id1107825213"

//使用协议地址
#define kApp_ProtocolUrl @"http://www.wutongsx.com/agreement.html"

//信鸽推送
#define kXGPush_AppId 2200202662
#define kXGPush_AppKey @"IIKX8362R6WU"

//Share分享平台
#define kShare_AppKey @"10d1181b1537e"
#define kShare_AppSecret @"ffb79bed2f2fdd9af497ece81a86f544"

//友盟统计平台
#define kUMeng_Appkey @"5786ed3d67e58e38e80019b0"

/**
 *  腾讯扣扣登录,分享,收藏
 */
#define kTencentQQ_AppId @"1105465380"
#define kTencentQQ_AppKey @"iYqZ9Dio21v1lsfi"
#define kTencentQQ_Auth_URLHost_Key @"response_from_qq"

/**
 *  有道云笔记
 */
#define kYouDaoNote_AppKey @"ac676036cb17302055c3d07b8e5c8fd6"
#define kYouDaoNote_AppSecret @"c98747c53302bf833cca5373684b939d"
#define kYouDaoNote_RedirectUri @"wutongsx.com"

/**
 *  印象笔记
 */
#define kYinXiang_AppKey @"comwutongliveios"
#define kYinXiang_AppSecret @"4f126fcae3bcdf97"

/**
 *  微信登录,分享,收藏,支付
 */
#define kWeChat_AppId @"wxe70381d66cc43c3a"
#define kWeChat_AppSecret @"8c332e0da2da844ad914894a4a583c70"
#define kWeChat_Description kMy_AppScheme_Desc
//商户号，填写商户对应参数
#define kWechat_MCH_ID           @"1393357702"
//商户API密钥，填写相应参数
#define kWechat_PARTNER_ID       @"ddc53450e22e1a3855b0373cfdabc3fb"
//支付结果回调页面
#define kWechat_NOTIFY_URL       @"http://appapi.wutongsx.com/share/userPay/wx_notify_url"
//微信回调
#define kWechat_Auth_URLHost_Key @"platformId=wechat"
//统一下单的接口链接
#define kWechat_PAR_URL          @"https://api.mch.weixin.qq.com/pay/unifiedorder"
/*
 接口1地址: /sns/oauth2/access_token
 接口1说明: 通过code换取access_token、refresh_token和已授权scope
 
 接口2地址: /sns/oauth2/refresh_token
 接口2说明: 刷新或续期access_token使用
 
 接口3地址: /sns/auth
 接口3说明: 检查access_token有效性
 */
#define kWeChat_Scope_Base @"snsapi_base"
/*
 接口地址: /sns/userinfo
 接口说明: 用户登录
 */
#define kWeChat_Scope_UserInfo @"snsapi_userinfo"



/**
 *  支付宝支付
 */
#define kALI_PID @"2088221548071149"
#define kALI_Seller @"2016092201946642"
#define kALI_Key @"20bgdkneqkqtnhjdmqli0grmmugkfm6w"
#define kALI_Algorithm @"RSA"
#define kALI_Private_Key @"MIICXwIBAAKBgQClIuaV2kGXkbEEF7Ft6JYhxfs7a8xGPm7U1m8RX1PlQok2hWGTWQ65Zq7URq+aIScUHG8xKc30VfD38ooMmoXtVg8IxPMIqnk4UaNVU9BB4QKBxNh/jH9lF03mW87cyd46rrMnTBg1Y3ykQHs1AYNW+9T4iheB/8HaWoEXADOhJQIDAQABAoGBAIaXjoaekA1gMn2abgOdqRe3zI9eyeyKoDya1YW8Q529ACbOyXuV/3k+5smfHyqpULeEgV/5qaI2laMRLFEfdH1wEM4N2SKX/21Mpur16/em0N9HAg1XWO2TsW2dCz3XkyhxAVt70yYGSRhICVFwk36ZmnxU+dNvXT+qGKpsUmQBAkEA0GCUqhEoDQOkpKfZtY6KmizlKKUgwvb9YCFWeOefJ+hJkTcv7evfC9A12wV/OsHc3W9+pBXCD78paojxW93eJQJBAMrgcflT+CkpFGur9cnnYFWFe5lQXAFtqFxaZckMLaehY8ADkUdMsXkMkIPAWAmIQHZpx8DG1OPgg7n/YafbxwECQQC587Y3HiBTnNCsb22E67McarwFTXazBZ6OzrFQK8KH5m7gPBN1imv9Ks0kqv8i/CWRJhIpc5E+ZCUdgR+CD7hRAkEAxbj5W4X61iKzRDzTz3Mw8CinzUQEZ1/4NgnkKY008arZDMptTI/yZ4dXURCkvKWOLdnqVHd0BKNLvnqnMnGAAQJBAI2JgiXTGZTGh4LGFv8ek80EZobOLXDxPSFGxZPn/VmEk6Ezf1Bxz/m+axW+05COlOogiaP4AZeeO44LhL8/4pk="
#define kALI_Auth_URLHost_Key @"safepay"
//应用注册scheme,在SosoBand-Info.plist定义URL types
#define kALI_AppScheme kMy_AppScheme
//支付结果回调页面
#define kALI_Notify_URL @"http://appapi.wutongsx.com/share/userPay/zfb_notify_url"




