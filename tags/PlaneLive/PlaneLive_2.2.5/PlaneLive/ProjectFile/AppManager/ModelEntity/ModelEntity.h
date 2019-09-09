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

///更新标题
@property (strong ,nonatomic) NSString *title;
///更新内容
@property (strong ,nonatomic) NSString *content;
///下载版本
@property (strong ,nonatomic) NSString *downloadUrl;

@end

///通知列表对象
@interface ModelNotice : ModelEntity

///ID
@property (strong ,nonatomic) NSString *ids;
///标题
@property (strong ,nonatomic) NSString *noticeTitle;
///描述
@property (strong ,nonatomic) NSString *noticeDesc;
///通知类型 1梧桐管理员 2更新提示
@property (assign ,nonatomic) int noticeType;
///通知图片
@property (strong ,nonatomic) NSString *noticeLogo;
///未读数量
@property (assign ,nonatomic) int noticeCount;
///时间
@property (strong ,nonatomic) NSString *noticeTime;

@end

///通知详情对象
@interface ModelNoticeDetail : ModelEntity

///ID
@property (strong ,nonatomic) NSString *ids;
///内容
@property (strong ,nonatomic) NSString *noticeContent;
///描述
@property (strong ,nonatomic) NSString *noticeDesc;
///通知者
@property (strong ,nonatomic) NSString *noticeNickName;
///时间
@property (strong ,nonatomic) NSString *noticeTime;
///是否已读 状态 0未读1已读
@property (assign ,nonatomic) int isRead;

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
///入行时间
@property (strong ,nonatomic) NSString *joinTime;
///学历
@property (strong ,nonatomic) NSString *education;
///生日
@property (strong ,nonatomic) NSString *birthday;
///登录Token
@property (strong ,nonatomic) NSString *loginToken;
///登录时间
@property (strong ,nonatomic) NSString *loginTime;
///登录类型
@property (assign ,nonatomic) WTAccountType loginType;
///登录成功提示语句
@property (assign ,nonatomic) BOOL isShowAlert;
///登录成功提示标题
@property (strong ,nonatomic) NSString *alertTitle;
///登录成功提示内容
@property (strong ,nonatomic) NSString *alertContent;
///标示
@property (assign ,nonatomic) int flag;

///意见反馈手机号
@property (strong ,nonatomic) NSString *feekbackPhone;

///QQID
@property (strong ,nonatomic) NSString *qq_id;
///新浪微博ID
@property (strong ,nonatomic) NSString *sina_id;
///微信ID
@property (strong ,nonatomic) NSString *wechat_id;

///订阅未读数量
@property (assign ,nonatomic) int unReadTotalCount;
///购物车数量
@property (assign ,nonatomic) int shoppingCartCount;

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

///问题有新回答未读数
@property (assign ,nonatomic) int myQuesNewCount;

///我的消息有未读数量
@property (assign ,nonatomic) int myNoticeCenterCount;

///我的回答收到评论的个数
@property (assign ,nonatomic) int myAnswerCommentcount;
///我的回答数量
@property (assign ,nonatomic) int myReplyCount;
///我的评论数
@property (assign ,nonatomic) int myCommentCount;
///我的留言数
@property (assign ,nonatomic) int myMessageCount;

///我的答案被同意的个数
@property (assign ,nonatomic) int myAnswerAgreeCount;
///我的答案被分享的个数
@property (assign ,nonatomic) int myAnswerShareCount;
///我的答案被收藏的个数
@property (assign ,nonatomic) int myAnswerCollectCount;

///我的评论未读回复消息数量
@property (assign, nonatomic) int myCommentReplyCount;

///是否有意见反馈的回复数据
@property (assign, nonatomic) int myFeedbackReplyCount;

///我的余额
@property (assign ,nonatomic) double balance;

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

///支付宝订单内容实体类
@interface ModelBizContent : NSObject

// NOTE: (非必填项)商品描述
@property (nonatomic, copy) NSString *body;
// NOTE: 商品的标题/交易标题/订单标题/订单关键字等。
@property (nonatomic, copy) NSString *subject;
// NOTE: 商户网站唯一订单号
@property (nonatomic, copy) NSString *out_trade_no;
// NOTE: 该笔订单允许的最晚付款时间，逾期将关闭交易。
//       取值范围：1m～15d m-分钟，h-小时，d-天，1c-当天(1c-当天的情况下，无论交易何时创建，都在0点关闭)
//       该参数数值不接受小数点， 如1.5h，可转换为90m。
@property (nonatomic, copy) NSString *timeout_express;
// NOTE: 订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]
@property (nonatomic, copy) NSString *total_amount;
// NOTE: 收款支付宝用户ID。 如果该值为空，则默认为商户签约账号对应的支付宝用户ID (如 2088102147948060)
@property (nonatomic, copy) NSString *seller_id;
// NOTE: 销售产品码，商家和支付宝签约的产品码 (如 QUICK_MSECURITY_PAY)
@property (nonatomic, copy) NSString *product_code;

@end

///支付宝订单实体类
@interface ModelOrderALI : NSObject

// NOTE: 支付宝分配给开发者的应用ID(如2014072300007148)
@property (nonatomic, copy) NSString *app_id;
// NOTE: 支付接口名称
@property (nonatomic, copy) NSString *method;
// NOTE: (非必填项)仅支持JSON
@property (nonatomic, copy) NSString *format;
// NOTE: (非必填项)HTTP/HTTPS开头字符串
@property (nonatomic, copy) NSString *return_url;
// NOTE: 参数编码格式，如utf-8,gbk,gb2312等
@property (nonatomic, copy) NSString *charset;
// NOTE: 请求发送的时间，格式"yyyy-MM-dd HH:mm:ss"
@property (nonatomic, copy) NSString *timestamp;
// NOTE: 请求调用的接口版本，固定为：1.0
@property (nonatomic, copy) NSString *version;
// NOTE: (非必填项)支付宝服务器主动通知商户服务器里指定的页面http路径
@property (nonatomic, copy) NSString *notify_url;
// NOTE: (非必填项)商户授权令牌，通过该令牌来帮助商户发起请求，完成业务(如201510BBaabdb44d8fd04607abf8d5931ec75D84)
@property (nonatomic, copy) NSString *app_auth_token;
// NOTE: 具体业务请求数据
@property (nonatomic, strong) ModelBizContent *biz_content;
// NOTE: 签名类型
@property (nonatomic, copy) NSString *sign_type;
/**
 *  获取订单信息串
 *
 *  @param bEncoded       订单信息串中的各个value是否encode
 *                        非encode订单信息串，用于生成签名
 *                        encode订单信息串 + 签名，用于最终的支付请求订单信息串
 */
- (NSString *)orderInfoEncoded:(BOOL)bEncoded;

@end


///支付宝订单返回对象
@interface ModelOrderALIResult : ModelEntity

@property (nonatomic, assign) NSInteger resultStatus;
@property (nonatomic, retain) NSString *memo;
@property (nonatomic, retain) NSString *result;

@end


///支付宝2.0认证实体类
@interface ModelAPAuthV2InfoALI : NSObject

/*********************************授权必传参数*********************************/
//服务接口名称，常量com.alipay.account.auth。
@property (nonatomic, copy) NSString *apiName;
//调用方app标识 ，mc代表外部商户。
@property (nonatomic, copy) NSString *appName;
//调用业务类型，openservice代表开放基础服务
@property (nonatomic, copy) NSString *bizType;
//产品码，目前只有WAP_FAST_LOGIN
@property (nonatomic, copy) NSString *productID;
//签约平台内的appid
@property (nonatomic, copy) NSString *appID;
//商户签约id
@property (nonatomic, copy) NSString *pid;
//授权类型,AUTHACCOUNT:授权;LOGIN:登录
@property (nonatomic, copy) NSString *authType;
//商户请求id需要为unique,回调使用
@property (nonatomic, copy) NSString *targetID;
/*********************************授权可选参数*********************************/
//oauth里的授权范围，PD配置,默认为kuaijie
@property (nonatomic, copy) NSString *scope;
//固定值，alipay.open.auth.sdk.code.get
@property (nonatomic, copy) NSString *method;

- (NSString *)description;

@end

///微信对象
@interface ModelWeChat : NSObject

@property (strong ,nonatomic) NSString *openId;
@property (strong ,nonatomic) NSString *accessToken;
@property (strong ,nonatomic) NSString *expiresIn;
@property (strong ,nonatomic) NSString *refreshToken;
@property (strong ,nonatomic) NSString *scope;
@property (strong ,nonatomic) NSString *unionId;

-(id)initWithDictionary:(NSDictionary*)dic;

@end

///微信用户对象
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
@property (assign ,nonatomic) int attCount;
///状态
@property (assign ,nonatomic) int status;
///是否选中
@property (assign ,nonatomic) BOOL isCheck;
///是否关注
@property (assign ,nonatomic) BOOL isAtt;
///是否已经收藏 1收藏0未收藏
@property (assign ,nonatomic) int isCollection;

@end

///广告
@interface ModelBanner : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///图片地址
@property (retain ,nonatomic) NSString *imageUrl;
///标题名称
@property (retain ,nonatomic) NSString *title;
///分享标题
@property (retain ,nonatomic) NSString *share_title;
///分享描述
@property (retain ,nonatomic) NSString *share_desc;
///链接地址
@property (retain ,nonatomic) NSString *url;
///微课ID||问题ID
@property (retain, nonatomic) NSString *code;
///广告类型 语音为1 分享预告为2 问题详情3 订阅4
@property (assign, nonatomic) ZBannerType type;
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
@property (retain ,nonatomic) NSString *content;
///回答内容
@property (retain ,nonatomic) NSString *contentNoImage;

@end

///圈子动态
@interface ModelCircleDynamic : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///标题
@property (retain ,nonatomic) NSString *title;
///回答内容
@property (retain ,nonatomic) NSString *content;
///回答内容
@property (retain ,nonatomic) NSString *contentNoImage;
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
@property (retain ,nonatomic) NSString *content;
///回答内容
@property (retain ,nonatomic) NSString *contentNoImage;
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

///提问ID
@property (retain ,nonatomic) NSString *ids;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///标题
@property (retain ,nonatomic) NSString *title;
///回答内容
@property (retain ,nonatomic) NSString *content;
///同意数量
@property (assign ,nonatomic) long count;

///1问题 2答案
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
///关联微课ID
@property (retain, nonatomic) NSString *bePracticeId;

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
///是否已读0未读1已读
@property (assign ,nonatomic) int status;
///回答ID
@property (retain, nonatomic) NSString *answerQuestion;
///是否能邀请
@property (assign, nonatomic) int isInvitation;

@end

///我的问题->所有问题
@interface ModelMyAllQuestion : ModelQuestionBase

///问题描述
@property (retain ,nonatomic) NSString *qContent;
///是否已读0未读1已读
@property (assign ,nonatomic) int status;
///回答内容
@property (retain, nonatomic) NSString *aContent;
///回答ID
@property (retain, nonatomic) NSString *aid;
///回答者ID
@property (retain ,nonatomic) NSString *userId;
///回答者昵称
@property (retain ,nonatomic) NSString *nickname;
///回答者头像
@property (retain ,nonatomic) NSString *head_img;

@end

///我的问题->新答案问题
@interface ModelMyNewQuestion : ModelMyAllQuestion

@end

@class ModelAnswerComment;
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
///问题发布者ID
@property (retain ,nonatomic) NSString *userIdQ;
///问题标题
@property (retain ,nonatomic) NSString *question_title;
///评论列表
@property (retain, nonatomic) NSArray *commentArray;
///默认选中评论
@property (retain, nonatomic) ModelAnswerComment *modelDefaultComment;
///举报数
@property (assign ,nonatomic) long resultRpt;
///同意数
@property (assign ,nonatomic) long agree;
///不同意数
@property (assign ,nonatomic) long disagree;
///是否被举报 1:是0否
@property (assign ,nonatomic) int isRept;
///是否已同意 0 未同意 1 已同意   ||  是否被点赞 1:是 0：否
@property (assign ,nonatomic) int isAgree;
///评论数量
@property (assign, nonatomic) long commentCount;
///是否已经收藏 1收藏0未收藏
@property (assign, nonatomic) int isCollection;

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

///问题的用户ID
@property (strong ,nonatomic) NSString *userIdQ;
///问题的昵称
@property (strong ,nonatomic) NSString *nicknameQ;
///问题的头像地址
@property (strong ,nonatomic) NSString *head_imgQ;
///问题的个性签名
@property (strong ,nonatomic) NSString *signQ;

///回答内容
@property (retain ,nonatomic) NSString *content;

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

///收藏->回答
@interface ModelCollectionAnswer : ModelEntity

///收藏ID
@property (retain ,nonatomic) NSString *ids;
///问题
@property (retain ,nonatomic) NSString *questions;
///回答内容
@property (retain ,nonatomic) NSString *content;
///问题id
@property (retain ,nonatomic) NSString *question_id;
///答案id
@property (retain ,nonatomic) NSString *answer_id;

@end

///收藏->微课|订阅
@interface ModelCollection : ModelEntity

///收藏ID
@property (retain ,nonatomic) NSString *ids;
///名称
@property (retain ,nonatomic) NSString *title;
///收藏的标题	--不取这个
@property (retain ,nonatomic) NSString *collect_title;
///类型  0:律所 1:会计 2证券 3:语音 4:人 5 机构 6回答 7 课程内容
@property (retain ,nonatomic) NSString *type;
///图片
@property (retain ,nonatomic) NSString *img;
///每期看图片
@property (retain ,nonatomic) NSString *audio_picture;
///收藏者ID，
@property (retain ,nonatomic) NSString *user_id;
///收藏的对象ID
@property (retain ,nonatomic) NSString *hotspot_id;
///订阅对象ID
@property (retain ,nonatomic) NSString *subscribe_id;
///订阅对象内容是否试读 0不是试读 1是试读
@property (assign ,nonatomic) int free_read;
///订阅对象时间
@property (retain ,nonatomic) NSString *create_time;
///订阅价格
@property (retain ,nonatomic) NSString *price;
///订阅单位
@property (retain ,nonatomic) NSString *units;

@end

///我的回答
@interface ModelQuestionMyAnswer : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///问题标题
@property (retain ,nonatomic) NSString *title;
///回答内容
@property (retain ,nonatomic) NSString *content;
///回答数量
@property (retain ,nonatomic) NSString *count;

///提问者用户ID
@property (strong ,nonatomic) NSString *userId;
///提问者用户昵称
@property (strong ,nonatomic) NSString *nickname;
///提问者用户头像
@property (strong ,nonatomic) NSString *head_img;
///提问者用户个性签名
@property (retain ,nonatomic) NSString *sgin;

@end

///我的回答->收到的评论
@interface ModelQuestionMyAnswerComment : ModelEntity

///评论id
@property (retain ,nonatomic) NSString *ids;
///评论内容  type为0时为评论内容,type为1时为被回复
@property (retain ,nonatomic) NSString *content;
///答案id
@property (retain ,nonatomic) NSString *aid;
///问题id
@property (retain ,nonatomic) NSString *qid;
///答案内容  type为0答案内容 ,type为1评论内容
@property (retain ,nonatomic) NSString *acontent;

///评论时间
@property (retain ,nonatomic) NSString *create_time;
///评论距离现在多久
@property (retain ,nonatomic) NSString *com_time;

///评论者id
@property (retain ,nonatomic) NSString *userid;
///评论者头像
@property (retain ,nonatomic) NSString *head_img;
///评论者昵称
@property (retain ,nonatomic) NSString *nickname;

///是否已读0未读1已读
@property (assign ,nonatomic) int status;
///0：答案 1：回复
@property (assign, nonatomic) int type;

@end

///等我回答
@interface ModelWaitAnswer : ModelEntity

///问题ID
@property (retain ,nonatomic) NSString *ids;
///问题标题
@property (retain ,nonatomic) NSString *title;
///邀请的用户ID
@property (strong ,nonatomic) NSString *userId;
///邀请的昵称
@property (strong ,nonatomic) NSString *nickname;
///邀请的头像地址
@property (strong ,nonatomic) NSString *head_img;
///是否已读0未读1已读
@property (assign ,nonatomic) int status;

@end

///我的关注->问题
@interface ModelAttentionQuestion : ModelCircleAtt

@end

///榜单公司对象
@interface ModelRankCompany : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///公司名称
@property (retain ,nonatomic) NSString *company_name;
///公司地址
@property (retain ,nonatomic) NSString *address;
///类型(0:律所, 1:会计, 2:券商)
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
///类型(0:律所, 1:会计, 2:券商)
///类型  0:律所 1:会计 2证券 3:语音 4:人 5 机构 6回答
@property (assign ,nonatomic) int type;

///是否收藏
@property (assign ,nonatomic) BOOL isAtt;

@end

///微课[语音]对象
@interface ModelPractice : ModelEntity

///微课ID
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
///分享内容&&微课简介
@property (retain ,nonatomic) NSString *share_content;
///取消关注
@property (retain ,nonatomic) NSString *hotspot_id;
///是否需要付费 0不需要，1需要
@property (assign ,nonatomic) int unlock;

///是否显示文本  0显示  1不显示
@property (assign ,nonatomic) int showText;
///是否加入购物车  0未加入  1加入
@property (assign ,nonatomic) int joinCart;
///是否已购买  0未购买  1购买
@property (assign ,nonatomic) int buyStatus;
///价格
@property (retain ,nonatomic) NSString *price;
///图片数据集合
@property (retain ,nonatomic) NSArray *arrImage;

///主讲人
@property (retain ,nonatomic) NSString *nickname;
///主讲人描述
@property (retain ,nonatomic) NSString *person_synopsis;
///主讲人机构
@property (retain ,nonatomic) NSString *person_title;
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
///收听数
@property (assign, nonatomic) long hits;

///热门问题数量
@property (assign ,nonatomic) long question_hot;
///最新问题数量
@property (assign ,nonatomic) long question_new;
///总问题数量,列表使用
@property (assign ,nonatomic) long qcount;

///是否收藏
@property (assign ,nonatomic) BOOL isCollection;
///是否点赞
@property (assign ,nonatomic) BOOL isPraise;

///语音类型
@property (assign ,nonatomic) int type;
///当前在数据集合索引位置
@property (assign ,nonatomic) NSInteger rowIndex;

@end

///回答评论
@interface ModelAnswerComment : ModelEntity

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
@property (assign ,nonatomic) int type;
///对象ID
@property (strong ,nonatomic) NSString *obj_id;

///状态 0 不显示背景  1显示背景
@property (assign ,nonatomic) int status;

///回复数据集合
@property (strong, nonatomic) NSArray *arrReply;

@end

///我的评论回复
@interface ModelCommentReply : ModelEntity

///回复ID
@property (retain ,nonatomic) NSString *ids;
///评论ID
@property (retain ,nonatomic) NSString *commentId;
///回复的父级ID
@property (retain ,nonatomic) NSString *parent_id;
///回复内容
@property (retain ,nonatomic) NSString *content;
///回复者id
@property (retain ,nonatomic) NSString *user_id;
///回复者昵称
@property (retain ,nonatomic) NSString *hnickname;
///被回复者id
@property (retain ,nonatomic) NSString *reply_user_id;
///被回复者昵称
@property (retain ,nonatomic) NSString *nickname;

@end

///微课问题对象
@interface ModelPracticeQuestion : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///微课ID
@property (retain ,nonatomic) NSString *pid;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///问题标题
@property (retain ,nonatomic) NSString *title;
///id
@property (retain ,nonatomic) NSString *userId;
///昵称
@property (retain ,nonatomic) NSString *nickname;
///头像地址
@property (retain ,nonatomic) NSString *head_img;
///个性签名
@property (retain ,nonatomic) NSString *sign;
///回答内容
@property (retain ,nonatomic) NSString *content;

@end

///任务对象
@interface ModelTask : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///微课ID
@property (retain, nonatomic) NSString *speech_id;
///任务内容
@property (retain ,nonatomic) NSString *content;
///状态 0 未完成  1已完成
@property (assign ,nonatomic) int status;
///跳转规则
@property (assign ,nonatomic) ZTaskType rule;

@end

///订阅对象
@interface ModelSubscribe : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///订阅标题
@property (retain ,nonatomic) NSString *title;
///订阅团队名称
@property (retain ,nonatomic) NSString *team_name;
///订阅团队描述
@property (retain ,nonatomic) NSString *team_info;
///订阅描述
@property (retain ,nonatomic) NSString *theme_intro;
///课程图片-ICON
@property (retain ,nonatomic) NSString *illustration;
///课程图片-详情顶部背景
@property (retain ,nonatomic) NSString *course_picture;
///订阅发布时间
@property (retain ,nonatomic) NSString *time;
///订阅价格
@property (retain ,nonatomic) NSString *price;
///订阅单位
@property (retain ,nonatomic) NSString *units;
///收听数
@property (assign ,nonatomic) long hits;
///订阅调转类型 0 原生详情 1 弹窗或者网页
@property (assign ,nonatomic) int type;
///订阅人数
@property (assign ,nonatomic) int count;
///订阅状态 0买过 1 没有
@property (assign ,nonatomic) int status;
///课程内容更新未读数
@property (assign ,nonatomic) int unReadCount;
///判断是否订阅
@property (assign, nonatomic) BOOL isSubscribe;
///0不是系列课程 1是系列课程
@property (assign ,nonatomic) int is_series_course;
///是否有试读内容(true表示有试读内容，false表示没有试读内容)
@property (assign ,nonatomic) BOOL isExistFreeRead;
///试读数量
@property (assign ,nonatomic) int freeReadCount;
///新增课程数
@property (assign ,nonatomic) int increasedCourseCount;

@end

///订阅详情对象
@interface ModelSubscribeDetail : ModelSubscribe

///适合人群
@property (retain ,nonatomic) NSString *fit_people;
///订阅须知
@property (retain ,nonatomic) NSString *must_know;
///需要帮助
@property (retain ,nonatomic) NSString *need_help;
///近期推送
@property (retain ,nonatomic) NSString *latest_push;

@end

///订阅购买记录
@interface ModelSubscribePlay : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///订单标题
@property (retain ,nonatomic) NSString *title;
///价格
@property (retain ,nonatomic) NSString *price;
///价格
@property (retain ,nonatomic) NSString *units;
///完成订单时间
@property (retain ,nonatomic) NSString *pay_time;
///支付方式
@property (retain ,nonatomic) NSString *pay_type;
///0：订阅  1：微课
@property (assign, nonatomic) int type;

@end

///订阅课程每节课内容对象
@interface ModelCurriculum : ModelEntity

///内容ID
@property (retain ,nonatomic) NSString *ids;

///课程ID
@property (retain ,nonatomic) NSString *subscribeId;
///课程标题
@property (retain ,nonatomic) NSString *title;

///订阅主讲人名称
@property (retain ,nonatomic) NSString *speaker_name;

///订阅团队名称
@property (retain ,nonatomic) NSString *team_name;
///订阅团队描述
@property (retain ,nonatomic) NSString *team_intro;

///课程配图
@property (retain ,nonatomic) NSString *illustration;
///课程顶部图片
@property (retain ,nonatomic) NSString *course_picture;
///课程内容PPT图片集合
@property (retain ,nonatomic) NSArray *course_imges;

///课程内容标题
@property (retain ,nonatomic) NSString *ctitle;
///课程内容
@property (retain ,nonatomic) NSString *content;
///创建时间
@property (retain ,nonatomic) NSString *create_time;
///年月日时间
@property (retain ,nonatomic) NSString *createTimeFormat;
///音频图片
@property (retain ,nonatomic) NSString *audio_picture;
///音频时长
@property (retain ,nonatomic) NSString *audio_time;
///音频地址
@property (retain ,nonatomic) NSString *audio_url;

///0不是系列课程 1是系列课程
@property (assign ,nonatomic) int is_series_course;
///收听数
@property (assign ,nonatomic) long hits;
///订阅价格
@property (retain ,nonatomic) NSString *price;
///订阅单位
@property (retain ,nonatomic) NSString *units;
///0：非试读  1：试读
@property (assign, nonatomic) int free_read;
///当前播放时间
@property (assign, nonatomic) long play_time;
///课程内容更新未读数
@property (assign, nonatomic) int unReadCount;
///当前在数据集合索引位置
@property (assign ,nonatomic) NSInteger rowIndex;
///留言数量
@property (assign, nonatomic) long mcount;
///点赞数量
@property (assign, nonatomic) long applauds;
///收藏数量
@property (assign, nonatomic) long ccount;
///是否点赞 0：不是  1：是
@property (assign, nonatomic) BOOL isPraise;
///是否收藏 0：不是  1：是
@property (assign, nonatomic) BOOL isCollection;

@end

///微课分类
@interface ModelPracticeType : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///分类名称
@property (retain ,nonatomic) NSString *type;
///分类图片
@property (retain ,nonatomic) NSString *spe_img;
///微课列表
@property (retain ,nonatomic) NSArray *arrPractice;

@end

///精品问答
@interface ModelQuestionBoutique : ModelEntity

///提问ID
@property (retain ,nonatomic) NSString *ids;
///问题标题
@property (retain ,nonatomic) NSString *title;
///问题创建者ID
@property (retain ,nonatomic) NSString *userId;
///问题创建者昵称
@property (retain ,nonatomic) NSString *nickname;
///问题创建者签名
@property (retain ,nonatomic) NSString *sign;
///头像
@property (retain ,nonatomic) NSString *head_img;
///回答ID
@property (retain ,nonatomic) NSString *aid;
///回答内容
@property (retain ,nonatomic) NSString *content;

@end

///精品问题对象
@interface ModelQuestionItem : ModelQuestionBase

///回答内容
@property (retain, nonatomic) NSString *content;
///回答ID
@property (retain, nonatomic) NSString *aid;
///提问者ID
@property (retain ,nonatomic) NSString *userId;
///提问者昵称
@property (retain ,nonatomic) NSString *nickname;
///提问者头像
@property (retain ,nonatomic) NSString *head_img;
///提问者的签名
@property (retain ,nonatomic) NSString *sign;

@end

///订单对象
@interface ModelOrderWT : ModelEntity

/// 订单id
@property (retain, nonatomic) NSString *ids;
/// 用户id
@property (retain, nonatomic) NSString *userId;
/// 订单类型 1为课程 2为充值
@property (assign, nonatomic) int type;
/// 商品名称
@property (retain, nonatomic) NSString *title;
/// 订单号-三方
@property (retain, nonatomic) NSString *order_no;
/// 金额
@property (retain, nonatomic) NSString *price;
/// 支付类型-1、微信 2、支付宝 3、余额
@property (assign, nonatomic) WTPayWayType pay_type;
/// 支付状态 0 未支付 1 已支付
@property (assign, nonatomic) int status;
/// 下单时间
@property (retain, nonatomic) NSString *create_time;
/// 支付时间
@property (retain, nonatomic) NSString *pay_time;

@end

///充值记录对象
@interface ModelRechargeRecord : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///订单标题
@property (retain ,nonatomic) NSString *title;
///价格
@property (retain ,nonatomic) NSString *price;
///完成订单时间
@property (retain ,nonatomic) NSString *pay_time;
///支付类型
@property (retain ,nonatomic) NSString *pay_type;

@end

///打赏记录对象
@interface ModelRewardRecord : ModelEntity

///ID
@property (retain ,nonatomic) NSString *ids;
///订单标题
@property (retain ,nonatomic) NSString *title;
///价格
@property (retain ,nonatomic) NSString *price;
///完成订单时间
@property (retain ,nonatomic) NSString *pay_time;
///支付类型
@property (retain ,nonatomic) NSString *pay_type;

@end

///推荐问题
@interface ModelQuestionRecommend : ModelQuestionBase

@property (retain ,nonatomic) NSString *aid;
@property (retain ,nonatomic) NSString *content;

@property (retain ,nonatomic) NSString *userId;
@property (retain ,nonatomic) NSString *nickname;
@property (retain ,nonatomic) NSString *head_img;
@property (retain ,nonatomic) NSString *sign;

@end

///购物车
@interface ModelPayCart : ModelPractice

@end

///留言对象
@interface ModelMessage : ModelEntity

@property (retain ,nonatomic) NSString *ids;
@property (retain ,nonatomic) NSString *content;

@property (retain ,nonatomic) NSString *userId;
@property (retain ,nonatomic) NSString *nickname;
@property (retain ,nonatomic) NSString *head_img;
@property (retain ,nonatomic) NSString *sign;

@end

///我的留言对象
@interface ModelMyMessage : ModelEntity

@property (retain ,nonatomic) NSString *ids;
@property (retain ,nonatomic) NSString *content;

@property (retain ,nonatomic) NSString *course_id;
@property (retain ,nonatomic) NSString *subscribe_id;
@property (retain ,nonatomic) NSString *create_time;
@property (retain ,nonatomic) NSString *title;
@property (assign ,nonatomic) long applaudCount;
@property (assign ,nonatomic) int free_read;
@property (retain ,nonatomic) NSString *price;
@property (retain ,nonatomic) NSString *units;

@property (retain ,nonatomic) NSString *reply;
@property (retain ,nonatomic) NSString *reply_lecturer;
@property (retain ,nonatomic) NSString *reply_time;

@end

///律师事务所
@interface ModelLawFirm : ModelEntity

@property (retain ,nonatomic) NSString *ids;
///标题
@property (retain ,nonatomic) NSString *title;
///描述
@property (retain ,nonatomic) NSString *desc;
///Logo
@property (retain ,nonatomic) NSString *logo;
///顶部背景图片
@property (retain ,nonatomic) NSString *picture;
///课程数量
@property (assign ,nonatomic) int total;

@end

///意见反馈
@interface ModelFeedBack : ModelEntity

@property (retain ,nonatomic) NSString *ids;
///反馈内容
@property (retain ,nonatomic) NSString *content;
///创建时间
@property (retain ,nonatomic) NSString *createTime;
///图片集合
@property (retain ,nonatomic) NSArray *images;
///回复内容
@property (retain ,nonatomic) NSString *reply;
///回复时间
@property (retain ,nonatomic) NSString *replyTime;

@end
