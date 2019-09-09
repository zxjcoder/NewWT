//
//  ModelEntity.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  strongright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJKeyValue.h"

@interface ModelEntity : NSObject

///自定-字典转换成模型
-(id)initWithAuto:(NSDictionary*)dic;

///自定义-字典转换成模型
-(id)initWithCustom:(NSDictionary*)dic;

///当前模型转换成字典
-(NSDictionary*)getDictionary;

///将模型数组转为字典数组
+(NSArray*)getDictionaryArrayWithModelArray:(NSArray*)array;

@end

///APP配置对象
@interface ModelAppConfig : ModelEntity

///版本号
@property (strong ,nonatomic) NSString *appVersion;
///平台 0 iOS 1 Android
@property (assign ,nonatomic) int platform;
///App状态 0 审核状态 1 上线状态
@property (assign ,nonatomic) int appStatus;
///榜单状态 0 可用状态 1 不可用状态
@property (assign ,nonatomic) int rankStatus;

@end

@interface ModelNotice : ModelEntity

///ID
@property (strong ,nonatomic) NSString *ids;
///标题
@property (strong ,nonatomic) NSString *noticeTitle;
///描述
@property (strong ,nonatomic) NSString *noticeDesc;
///时间
@property (strong ,nonatomic) NSString *noticeTime;

@end

///用户基本对象
@interface ModelUserBase : ModelEntity

///id
@property (strong ,nonatomic) NSString *userId;
///帐号
@property (strong ,nonatomic) NSString *account;
///昵称
@property (strong ,nonatomic) NSString *nickname;
///头像地址
@property (strong ,nonatomic) NSString *head_img;
///个性签名
@property (strong ,nonatomic) NSString *sign;

@end

///黑名单
@interface ModelUserBlack : ModelUserBase

@end

///用户对象
@interface ModelUser : ModelUserBase

///性别
@property (assign ,nonatomic) WTSexType sex;
///手机
@property (strong ,nonatomic) NSString *phone;
///邮箱
@property (strong ,nonatomic) NSString *email;
///类型
@property (assign ,nonatomic) WTAccountType type;
///密码
@property (strong ,nonatomic) NSString *password;
///行业
@property (strong ,nonatomic) NSString *trade;
///标签
@property (strong, nonatomic) NSString *label;
///公司
@property (strong ,nonatomic) NSString *company;
///地址
@property (strong ,nonatomic) NSString *address;

///标示
@property (assign ,nonatomic) int flag;

///QQID
@property (strong ,nonatomic) NSString *qq_id;
///新浪微博ID
@property (strong ,nonatomic) NSString *sina_id;
///微信ID
@property (strong ,nonatomic) NSString *wechat_id;

///我的粉丝数
@property (assign ,nonatomic) int myFunsCount;
///是否有新的等我回答
@property (assign ,nonatomic) int myWaitNewAns;
///等我回答的个数
@property (assign ,nonatomic) int myWaitAnsCount;
///我的问题的个数
@property (assign ,nonatomic) int myQuesCount;
///我的关注的个数
@property (assign ,nonatomic) int myAttAccount;
///我的收藏的个数
@property (assign ,nonatomic) int myCollectAccount;

@end

///他人的用户对象
@interface ModelUserProfile : ModelUser

///他的关注
@property (assign ,nonatomic) int hisAttention;
///他的问题
@property (assign ,nonatomic) int hisQues;
///他的粉丝
@property (assign ,nonatomic) int hisFuns;
///他的答案
@property (assign ,nonatomic) int hisAnswer;
///他的收藏
@property (assign ,nonatomic) int hisCollect;

///是否关注
@property (assign ,nonatomic) BOOL isAtt;
///是否黑名单
@property (assign ,nonatomic) BOOL isBlackList;

@end

///支付宝订单实体类
@interface ModelOrderALI : NSObject

@property (nonatomic, strong) NSString * partner;
@property (nonatomic, strong) NSString * seller;
@property (nonatomic, strong) NSString * orderId;
///订单ID(由商家自行制定)
@property (nonatomic, strong) NSString * tradeNO;
///商品标题
@property (nonatomic, strong) NSString * productName;
///商品描述
@property (nonatomic, strong) NSString * productDescription;
///商品价格
@property (nonatomic, strong) NSString * amount;
///回调URL
@property (nonatomic, strong) NSString * notifyURL;

@property (nonatomic, strong) NSString * service;
@property (nonatomic, strong) NSString * paymentType;
@property (nonatomic, strong) NSString * inputCharset;
@property (nonatomic, strong) NSString * itBPay;
@property (nonatomic, strong) NSString * showUrl;

///可选
@property (nonatomic, strong) NSString * rsaDate;
///可选
@property (nonatomic, strong) NSString * appID;

@property (assign, nonatomic) NSInteger ptype;

@property (nonatomic, readonly) NSMutableDictionary * extraParams;

-(NSDictionary*)getDictionary;

@end


///支付宝订单返回对象
@interface ModelOrderALIResult : ModelEntity

@property (nonatomic, assign) NSInteger resultStatus;
@property (nonatomic, retain) NSString *memo;
@property (nonatomic, retain) NSString *result;

@end


///支付宝2.0认证实体类
@interface ModelAPAuthV2InfoALI : NSObject

@property (retain ,nonatomic) NSString *apiName;
@property (retain ,nonatomic) NSString *appName;
@property (retain ,nonatomic) NSString *appID;
@property (retain ,nonatomic) NSString *bizType;
@property (retain ,nonatomic) NSString *pid;
@property (retain ,nonatomic) NSString *productID;
@property (retain ,nonatomic) NSString *scope;
@property (retain ,nonatomic) NSString *targetID;
@property (retain ,nonatomic) NSString *authType;
@property (retain ,nonatomic) NSString *signDate;
@property (retain ,nonatomic) NSString *service;

- (NSString *)description;

@end


@interface ModelWeChat : NSObject

@property (strong ,nonatomic) NSString *openId;
@property (strong ,nonatomic) NSString *accessToken;
@property (strong ,nonatomic) NSString *expiresIn;
@property (strong ,nonatomic) NSString *refreshToken;
@property (strong ,nonatomic) NSString *scope;
@property (strong ,nonatomic) NSString *unionId;

-(id)initWithDictionary:(NSDictionary*)dic;

@end

@interface ModelWeChatUser : ModelEntity

@property (strong ,nonatomic) NSString *openId;
@property (strong ,nonatomic) NSString *nickname;
@property (strong ,nonatomic) NSString *sex;
@property (strong ,nonatomic) NSString *province;
@property (strong ,nonatomic) NSString *city;
@property (strong ,nonatomic) NSString *country;
@property (strong ,nonatomic) NSString *language;
@property (strong ,nonatomic) NSString *headimgurl;
@property (strong ,nonatomic) NSString *unionid;

-(id)initWithDictionary:(NSDictionary*)dic;

@end


///推送对象
@interface ModelPushManager : ModelEntity

@property (retain ,nonatomic) NSDictionary *dicCustomJson;

@property (retain ,nonatomic) NSDictionary *aps;

@property (retain ,nonatomic) NSString *alert;
@property (retain ,nonatomic) NSString *city;

@end

///数据字典
@interface ModelDictionary : ModelEntity

///代码
@property (retain ,nonatomic) NSString *dicCode;
///字典名称
@property (retain ,nonatomic) NSString *dicName;

@end

///标签&话题分类
@interface ModelTagType : ModelEntity

///ID
@property (retain ,nonatomic) NSString *typeId;
///分类
@property (retain ,nonatomic) NSString *typeName;
///标签&话题集合
@property (retain, nonatomic) NSArray *tagArray;

@end

///标签&话题
@interface ModelTag : ModelEntity

///ID
@property (retain ,nonatomic) NSString *tagId;
///名称
@property (retain ,nonatomic) NSString *tagName;
///图片地址
@property (retain ,nonatomic) NSString *tagLogo;
///问题ID
@property (retain ,nonatomic) NSString *question_id;
///发布者用户ID
@property (retain ,nonatomic) NSString *userId;
///关注数
@property (assign ,nonatomic) long attCount;
///状态
@property (assign ,nonatomic) int status;
///是否选中
@property (assign ,nonatomic) BOOL isCheck;
///是否关注
@property (assign ,nonatomic) BOOL isAtt;

@end

///广告
@interface ModelBanner : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///图片地址
@property (retain ,nonatomic) NSString *imageUrl;
///链接地址
@property (retain ,nonatomic) NSString *url;
///实务ID
@property (retain, nonatomic) NSString *code;
///来源
@property (retain, nonatomic) NSString *sorce;
///浏览量
@property (retain, nonatomic) NSString *look_num;
///创建时间
@property (retain, nonatomic) NSString *create_time;

@end

///新闻文章
@interface ModelHotArticle : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///图片地址
@property (retain ,nonatomic) NSString *imageUrl;
///标题
@property (retain ,nonatomic) NSString *title;
///描述
@property (retain ,nonatomic) NSString *desc;
///来源
@property (retain ,nonatomic) NSString *source;
///查看数量
@property (assign ,nonatomic) long look_num;

@end

///圈子推荐
@interface ModelCircleHot : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///标签集合
@property (retain ,nonatomic) NSArray *tags;
///标题
@property (retain ,nonatomic) NSString *title;
///id
@property (strong ,nonatomic) NSString *userId;
///昵称
@property (strong ,nonatomic) NSString *nickname;
///头像地址
@property (strong ,nonatomic) NSString *head_img;
///个性签名
@property (strong ,nonatomic) NSString *sign;
///回答内容
@property (retain ,nonatomic) NSString *answerContent;

@end

///圈子动态
@interface ModelCircleDynamic : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///标题
@property (retain ,nonatomic) NSString *title;
///回答内容
@property (retain ,nonatomic) NSString *content;
///用户ID
@property (strong ,nonatomic) NSString *userId;
///昵称
@property (strong ,nonatomic) NSString *nickname;
///头像地址
@property (strong ,nonatomic) NSString *head_img;
///wid-回答ID
@property (retain ,nonatomic) NSString *wid;
///描述
@property (retain ,nonatomic) NSString *flag;
///当前内容类型 0提问,1回答
@property (assign ,nonatomic) int type;

@end

///圈子最新
@interface ModelCircleNew : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///标题
@property (retain ,nonatomic) NSString *title;

///发布问题的用户ID
@property (strong ,nonatomic) NSString *userIdQ;
///发布问题的头像地址
@property (strong ,nonatomic) NSString *head_imgQ;
///发布问题的昵称
@property (strong ,nonatomic) NSString *nicknameQ;

///回答问题的用户ID
@property (strong ,nonatomic) NSString *userIdA;
///回答问题的昵称
@property (strong ,nonatomic) NSString *nicknameA;
///回答问题的头像地址
@property (strong ,nonatomic) NSString *head_imgA;
///回答问题的个性签名
@property (strong ,nonatomic) NSString *signA;

///回答内容
@property (retain ,nonatomic) NSString *answerContent;
///时间
@property (retain ,nonatomic) NSString *time;
///数量
@property (retain ,nonatomic) NSString *count;

@end

///圈子关注
@interface ModelCircleAtt : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///问题标题
@property (retain ,nonatomic) NSString *title;
///问题描述
@property (retain ,nonatomic) NSString *content;

///发布问题的用户ID
@property (strong ,nonatomic) NSString *userIdQ;
///发布问题的头像地址
@property (strong ,nonatomic) NSString *head_imgQ;
///发布问题的昵称
@property (strong ,nonatomic) NSString *nicknameQ;

///回答问题的用户ID
@property (strong ,nonatomic) NSString *userIdA;
///回答问题的昵称
@property (strong ,nonatomic) NSString *nicknameA;
///回答问题的头像地址
@property (strong ,nonatomic) NSString *head_imgA;
///回答问题的个性签名
@property (strong ,nonatomic) NSString *signA;

///回答内容
@property (retain ,nonatomic) NSString *answerContent;
///时间
@property (retain ,nonatomic) NSString *time;
///数量
@property (retain ,nonatomic) NSString *count;

@end

///圈子搜索内容
@interface ModelCircleSearchContent : ModelEntity

///提问或回答ID
@property (retain ,nonatomic) NSString *ids;
///标题
@property (retain ,nonatomic) NSString *title;
///回答内容
@property (retain ,nonatomic) NSString *content;
///问题描述
//@property (retain ,nonatomic) NSString *describ;
///数量
@property (retain ,nonatomic) NSString *count;
///用户ID
@property (retain ,nonatomic) NSString *userId;
///当前内容类型 0提问,1回答
@property (assign ,nonatomic) int type;
@property (assign ,nonatomic) int status;
@property (assign ,nonatomic) int flag;

@end

///发布&编辑问题
@interface ModelQuestion : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///问题标题
@property (retain ,nonatomic) NSString *title;
///问题内容
@property (retain ,nonatomic) NSString *content;
///选中话题
@property (retain, nonatomic) NSArray *arrSelTag;

@end

///问题基类
@interface ModelQuestionBase : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///问题标题
@property (retain ,nonatomic) NSString *title;

@end

///问题详情
@interface ModelQuestionDetail : ModelQuestionBase

///问题创建者ID
@property (retain ,nonatomic) NSString *userId;
///问题创建者昵称
@property (retain ,nonatomic) NSString *nickname;
///问题创建者签名
@property (retain ,nonatomic) NSString *sign;
///头像
@property (retain ,nonatomic) NSString *head_img;
///问题内容
@property (retain ,nonatomic) NSString *qContent;
///话题
@property (retain, nonatomic) NSArray *arrTopic;

///答案数量
@property (assign, nonatomic) long answerCount;
///关注数量
@property (assign, nonatomic) long attCount;
///是否关注
@property (assign, nonatomic) BOOL isAtt;
///回答ID
@property (retain, nonatomic) NSString *answerQuestion;
///是否能邀请
@property (assign, nonatomic) int isInvitation;

@end

///回答基类
@interface ModelAnswerBase : ModelEntity

///回答ID
@property (retain ,nonatomic) NSString *ids;
///回答内容
@property (retain ,nonatomic) NSString *title;
///回答者ID
@property (retain ,nonatomic) NSString *userId;
///回答者昵称
@property (retain ,nonatomic) NSString *nickname;
///问题者签名
@property (retain ,nonatomic) NSString *sign;
///头像
@property (retain ,nonatomic) NSString *head_img;
///回答时间
@property (retain ,nonatomic) NSString *discuss_time;
///问题ID
@property (retain ,nonatomic) NSString *question_id;
///举报数
@property (assign ,nonatomic) long resultRpt;
///同意数
@property (assign ,nonatomic) long agree;
///不同意数
@property (assign ,nonatomic) long disagree;
///是否已同意 0 未同意 1 已同意   ||  是否被点赞 1:是 0：否
@property (assign ,nonatomic) int isAgree;
///评论数量
@property (assign, nonatomic) long commentCount;

@end

///话题->问题对象
@interface ModelQuestionTopic : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///标题
@property (retain ,nonatomic) NSString *title;

///回答问题的用户ID
@property (strong ,nonatomic) NSString *userIdA;
///回答问题的昵称
@property (strong ,nonatomic) NSString *nicknameA;
///回答问题的头像地址
@property (strong ,nonatomic) NSString *head_imgA;
///回答问题的个性签名
@property (strong ,nonatomic) NSString *signA;

///回答内容
@property (retain ,nonatomic) NSString *answerContent;

@end

///邀请用户
@interface ModelUserInvitation : ModelUserBase

///是否已经邀请 1--已邀请   0:--未邀请
@property (assign, nonatomic) int isInvitation;

@end

///评论
@interface ModelComment : ModelEntity

///评论ID
@property (retain ,nonatomic) NSString *ids;
///评论内容
@property (retain ,nonatomic) NSString *content;
///评论的用户ID
@property (strong ,nonatomic) NSString *userId;
///评论的昵称
@property (strong ,nonatomic) NSString *nickname;
///评论的头像地址
@property (strong ,nonatomic) NSString *head_img;
///评论时间
@property (strong ,nonatomic) NSString *createTime;
///类型
@property (strong ,nonatomic) NSString *type;
///对象ID
@property (strong ,nonatomic) NSString *obj_id;

@end

///收藏
@interface ModelCollection : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///名称
@property (retain ,nonatomic) NSString *title;
///收藏的标题	--不取这个
@property (retain ,nonatomic) NSString *collect_title;
///类型  0:律所 1:会计 2证券 3:语音 4:人 5 机构
@property (retain ,nonatomic) NSString *type;
///图片
@property (retain ,nonatomic) NSString *img;
///收藏者ID，
@property (retain ,nonatomic) NSString *user_id;
///收藏的对象ID
@property (retain ,nonatomic) NSString *hotspot_id;

@end

///我的回答
@interface ModelQuestionMyAnswer : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///标题
@property (retain ,nonatomic) NSString *title;
///回答内容
@property (retain ,nonatomic) NSString *content;
///回答数量
@property (retain ,nonatomic) NSString *count;
///用户ID
@property (retain ,nonatomic) NSString *userId;

@end

///榜单公司对象
@interface ModelRankCompany : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///公司名称
@property (retain ,nonatomic) NSString *company_name;
///公司地址
@property (retain ,nonatomic) NSString *address;
///类型(0:律所, 1:会计, 2:卷商)
@property (assign ,nonatomic) int type;
///公司图片
@property (retain ,nonatomic) NSString *company_img;
///公司简称
@property (retain ,nonatomic) NSString *cpy_name;
///公司简介
@property (retain ,nonatomic) NSString *synopsis;
///创建时间
@property (retain ,nonatomic) NSString *create_time;
///公司代码
@property (retain ,nonatomic) NSString *code;
///公司排名
@property (retain ,nonatomic) NSString *count;

///是否收藏
@property (assign ,nonatomic) BOOL isAtt;

@end

///榜单用户对象
@interface ModelRankUser : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///人员名称
@property (retain ,nonatomic) NSString *nickname;
///公司id
@property (retain ,nonatomic) NSString *company_id;
///公司名称
@property (retain ,nonatomic) NSString *company_name;
///人员图片
@property (retain ,nonatomic) NSString *operator_img;
///创建时间
@property (retain ,nonatomic) NSString *create_time;
///类型(0:律所, 1:会计, 2:卷商)
@property (assign ,nonatomic) int type;

///是否收藏
@property (assign ,nonatomic) BOOL isAtt;

@end

///实务[语音]对象
@interface ModelPractice : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///标题
@property (retain ,nonatomic) NSString *title;
///时长->秒
@property (retain ,nonatomic) NSString *time;
///上次播放时长->秒
@property (assign ,nonatomic) long play_time;
///语音图片
@property (retain ,nonatomic) NSString *speech_img;
///背景图片
@property (retain ,nonatomic) NSString *bkimg;
///获取语音地址
@property (retain ,nonatomic) NSString *speech_url;
///分享内容&&实务简介
@property (retain ,nonatomic) NSString *share_content;

///主讲人
@property (retain ,nonatomic) NSString *nickname;
///主讲人描述
@property (retain ,nonatomic) NSString *person_synopsis;
///创建时间
@property (retain ,nonatomic) NSString *create_time;
///语音内容
@property (retain ,nonatomic) NSString *speech_content;

///收藏数
@property (assign ,nonatomic) long ccount;
///评论数
@property (assign ,nonatomic) long mcount;
///点赞数
@property (assign ,nonatomic) long applauds;

///是否收藏
@property (assign ,nonatomic) BOOL isCollection;
///是否点赞
@property (assign ,nonatomic) BOOL isPraise;

@property (assign ,nonatomic) NSInteger rowIndex;

@end


