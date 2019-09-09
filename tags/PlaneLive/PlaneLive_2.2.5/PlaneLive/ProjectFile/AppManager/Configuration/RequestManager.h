//
//  RequestManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "HostManager.h"

//异常提交接口
#define kJson_PostErrorReport_CMD @"share/appLog/saveAppLog"

//微信第三方AccessToken接口
#define kJson_Wechat_AccessToken_CMD @"https:#pragma mark - api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"
//微信第三方用户接口
#define kJson_Wechat_UserInfor_CMD @"https:#pragma mark - api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@"


