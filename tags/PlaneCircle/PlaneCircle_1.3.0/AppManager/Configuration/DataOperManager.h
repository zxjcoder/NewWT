//
//  DataOperManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//


#define kSNS_RETURN_SUCCESS 1000
#define kSNS_RETURN_SUCCESS_Text NSLocalizedString(@"成功", nil)

#define kSNS_RETURN_SERVER_DEFAULT_Text NSLocalizedString(@"请求失败[10000]", nil)

#define kSNS_RETURN_SERVER_DATA_ERROR 10001
#define kSNS_RETURN_SERVER_DATA_ERROR_Text  NSLocalizedString(@"数据错误[10001]", nil)

#define kSNS_RETURN_SERVER_DECRYPTDATA_ERROR 10002
#define kSNS_RETURN_SERVER_DECRYPTDATA_ERROR_Text  NSLocalizedString(@"解密错误[10002]", nil)

#define kSNS_RETURN_SERVER_TOKEN_EXPIRED 10004
#define kSNS_RETURN_SERVER_TOKEN_EXPIRED_Text  NSLocalizedString(@"登录已过期,请重新登录[10004]", nil)

/**
 *  Wechat 错误码
 */
#define kSNS_RETURN_WECHAT_40001 40001
#define kSNS_RETURN_WECHAT_40001_Text NSLocalizedString(@"不合法的调用凭证", nil)
#define kSNS_RETURN_WECHAT_40002 40002
#define kSNS_RETURN_WECHAT_40002_Text NSLocalizedString(@"不合法的grant_type", nil)
#define kSNS_RETURN_WECHAT_40003 40003
#define kSNS_RETURN_WECHAT_40003_Text NSLocalizedString(@"不合法的OpenID", nil)
#define kSNS_RETURN_WECHAT_40004 40004
#define kSNS_RETURN_WECHAT_40004_Text NSLocalizedString(@"不合法的媒体文件类型", nil)
#define kSNS_RETURN_WECHAT_40007 40007
#define kSNS_RETURN_WECHAT_40007_Text NSLocalizedString(@"不合法的media_id", nil)
#define kSNS_RETURN_WECHAT_40008 40008
#define kSNS_RETURN_WECHAT_40008_Text NSLocalizedString(@"不合法的message_type", nil)
#define kSNS_RETURN_WECHAT_40009 40009
#define kSNS_RETURN_WECHAT_40009_Text NSLocalizedString(@"不合法的图片大小", nil)
#define kSNS_RETURN_WECHAT_40010 40010
#define kSNS_RETURN_WECHAT_40010_Text NSLocalizedString(@"不合法的语音大小", nil)
#define kSNS_RETURN_WECHAT_40011 40011
#define kSNS_RETURN_WECHAT_40011_Text NSLocalizedString(@"不合法的视频大小", nil)
#define kSNS_RETURN_WECHAT_40012 40012
#define kSNS_RETURN_WECHAT_40012_Text NSLocalizedString(@"不合法的缩略图大小", nil)
#define kSNS_RETURN_WECHAT_40013 40013
#define kSNS_RETURN_WECHAT_40013_Text NSLocalizedString(@"不合法的AppID", nil)
#define kSNS_RETURN_WECHAT_40014 40014
#define kSNS_RETURN_WECHAT_40014_Text NSLocalizedString(@"不合法的access_token", nil)
#define kSNS_RETURN_WECHAT_40015 40015
#define kSNS_RETURN_WECHAT_40015_Text NSLocalizedString(@"不合法的菜单类型", nil)
#define kSNS_RETURN_WECHAT_40016 40016
#define kSNS_RETURN_WECHAT_40016_Text NSLocalizedString(@"不合法的菜单按钮个数", nil)
#define kSNS_RETURN_WECHAT_40017 40017
#define kSNS_RETURN_WECHAT_40017_Text NSLocalizedString(@"不合法的按钮类型", nil)
#define kSNS_RETURN_WECHAT_40018 40018
#define kSNS_RETURN_WECHAT_40018_Text NSLocalizedString(@"不合法的按钮名称长度", nil)
#define kSNS_RETURN_WECHAT_40019 40019
#define kSNS_RETURN_WECHAT_40019_Text NSLocalizedString(@"不合法的按钮KEY长度", nil)
#define kSNS_RETURN_WECHAT_40020 40020
#define kSNS_RETURN_WECHAT_40020_Text NSLocalizedString(@"不合法的URL长度", nil)
#define kSNS_RETURN_WECHAT_40023 40023
#define kSNS_RETURN_WECHAT_40023_Text NSLocalizedString(@"不合法的子菜单按钮个数", nil)
#define kSNS_RETURN_WECHAT_40024 40024
#define kSNS_RETURN_WECHAT_40024_Text NSLocalizedString(@"不合法的子菜单类型", nil)
#define kSNS_RETURN_WECHAT_40025 40025
#define kSNS_RETURN_WECHAT_40025_Text NSLocalizedString(@"不合法的子菜单按钮名称长度", nil)
#define kSNS_RETURN_WECHAT_40026 40026
#define kSNS_RETURN_WECHAT_40026_Text NSLocalizedString(@"不合法的子菜单按钮KEY长度", nil)
#define kSNS_RETURN_WECHAT_40027 40027
#define kSNS_RETURN_WECHAT_40027_Text NSLocalizedString(@"不合法的子菜单按钮URL长度", nil)
#define kSNS_RETURN_WECHAT_40029 40029
#define kSNS_RETURN_WECHAT_40029_Text NSLocalizedString(@"不合法或已过期的CODE", nil)
#define kSNS_RETURN_WECHAT_40030 40030
#define kSNS_RETURN_WECHAT_40030_Text NSLocalizedString(@"不合法的refresh_token", nil)
#define kSNS_RETURN_WECHAT_40036 40036
#define kSNS_RETURN_WECHAT_40036_Text NSLocalizedString(@"不合法的template_id长度", nil)
#define kSNS_RETURN_WECHAT_40037 40037
#define kSNS_RETURN_WECHAT_40037_Text NSLocalizedString(@"不合法的template_id", nil)
#define kSNS_RETURN_WECHAT_40039 40039
#define kSNS_RETURN_WECHAT_40039_Text NSLocalizedString(@"不合法的URL长度", nil)
#define kSNS_RETURN_WECHAT_40048 40048
#define kSNS_RETURN_WECHAT_40048_Text NSLocalizedString(@"不合法的URL域名", nil)
#define kSNS_RETURN_WECHAT_40054 40054
#define kSNS_RETURN_WECHAT_40054_Text NSLocalizedString(@"不合法的子菜单按钮URL域名", nil)
#define kSNS_RETURN_WECHAT_40055 40055
#define kSNS_RETURN_WECHAT_40055_Text NSLocalizedString(@"不合法的菜单按钮URL域名", nil)
#define kSNS_RETURN_WECHAT_40066 40066
#define kSNS_RETURN_WECHAT_40066_Text NSLocalizedString(@"不合法的URL", nil)
#define kSNS_RETURN_WECHAT_41001 41001
#define kSNS_RETURN_WECHAT_41001_Text NSLocalizedString(@"缺失access_token参数", nil)
#define kSNS_RETURN_WECHAT_41002 41002
#define kSNS_RETURN_WECHAT_41002_Text NSLocalizedString(@"缺失appid参数", nil)
#define kSNS_RETURN_WECHAT_41003 41003
#define kSNS_RETURN_WECHAT_41003_Text NSLocalizedString(@"缺失refresh_token参数", nil)
#define kSNS_RETURN_WECHAT_41004 41004
#define kSNS_RETURN_WECHAT_41004_Text NSLocalizedString(@"缺失secret参数", nil)
#define kSNS_RETURN_WECHAT_41005 41005
#define kSNS_RETURN_WECHAT_41005_Text NSLocalizedString(@"缺失二进制媒体文件", nil)
#define kSNS_RETURN_WECHAT_41006 41006
#define kSNS_RETURN_WECHAT_41006_Text NSLocalizedString(@"缺失media_id参数", nil)
#define kSNS_RETURN_WECHAT_41007 41007
#define kSNS_RETURN_WECHAT_41007_Text NSLocalizedString(@"缺失子菜单数据", nil)
#define kSNS_RETURN_WECHAT_41008 41008
#define kSNS_RETURN_WECHAT_41008_Text NSLocalizedString(@"缺失code参数", nil)
#define kSNS_RETURN_WECHAT_41009 41009
#define kSNS_RETURN_WECHAT_41009_Text NSLocalizedString(@"缺失openid参数", nil)
#define kSNS_RETURN_WECHAT_41010 41010
#define kSNS_RETURN_WECHAT_41010_Text NSLocalizedString(@"缺失url参数", nil)
#define kSNS_RETURN_WECHAT_42001 42001
#define kSNS_RETURN_WECHAT_42001_Text NSLocalizedString(@"access_token超时", nil)
#define kSNS_RETURN_WECHAT_42002 42002
#define kSNS_RETURN_WECHAT_42002_Text NSLocalizedString(@"refresh_token超时", nil)
#define kSNS_RETURN_WECHAT_42003 42003
#define kSNS_RETURN_WECHAT_42003_Text NSLocalizedString(@"code超时", nil)
#define kSNS_RETURN_WECHAT_43001 43001
#define kSNS_RETURN_WECHAT_43001_Text NSLocalizedString(@"需要使用GET方法请求", nil)
#define kSNS_RETURN_WECHAT_43002 43002
#define kSNS_RETURN_WECHAT_43002_Text NSLocalizedString(@"需要使用POST方法请求", nil)
#define kSNS_RETURN_WECHAT_43003 43003
#define kSNS_RETURN_WECHAT_43003_Text NSLocalizedString(@"需要使用HTTPS", nil)
#define kSNS_RETURN_WECHAT_43004 43004
#define kSNS_RETURN_WECHAT_43004_Text NSLocalizedString(@"需要订阅关系", nil)
#define kSNS_RETURN_WECHAT_44001 44001
#define kSNS_RETURN_WECHAT_44001_Text NSLocalizedString(@"空白的二进制数据", nil)
#define kSNS_RETURN_WECHAT_44002 44002
#define kSNS_RETURN_WECHAT_44002_Text NSLocalizedString(@"空白的POST数据", nil)
#define kSNS_RETURN_WECHAT_44003 44003
#define kSNS_RETURN_WECHAT_44003_Text NSLocalizedString(@"空白的news数据", nil)
#define kSNS_RETURN_WECHAT_44004 44004
#define kSNS_RETURN_WECHAT_44004_Text NSLocalizedString(@"空白的内容", nil)
#define kSNS_RETURN_WECHAT_44005 44005
#define kSNS_RETURN_WECHAT_44005_Text NSLocalizedString(@"空白的列表", nil)
#define kSNS_RETURN_WECHAT_45001 45001
#define kSNS_RETURN_WECHAT_45001_Text NSLocalizedString(@"二进制文件超过限制", nil)
#define kSNS_RETURN_WECHAT_45002 45002
#define kSNS_RETURN_WECHAT_45002_Text NSLocalizedString(@"content参数超过限制", nil)
#define kSNS_RETURN_WECHAT_45003 45003
#define kSNS_RETURN_WECHAT_45003_Text NSLocalizedString(@"title参数超过限制", nil)
#define kSNS_RETURN_WECHAT_45004 45004
#define kSNS_RETURN_WECHAT_45004_Text NSLocalizedString(@"description参数超过限制", nil)
#define kSNS_RETURN_WECHAT_45005 45005
#define kSNS_RETURN_WECHAT_45005_Text NSLocalizedString(@"URLl参数长度超过限制", nil)
#define kSNS_RETURN_WECHAT_45006 45006
#define kSNS_RETURN_WECHAT_45006_Text NSLocalizedString(@"picurl参数超过限制", nil)
#define kSNS_RETURN_WECHAT_45007 45007
#define kSNS_RETURN_WECHAT_45007_Text NSLocalizedString(@"播放时间超过限制(语音为60s最大)", nil)
#define kSNS_RETURN_WECHAT_45008 45008
#define kSNS_RETURN_WECHAT_45008_Text NSLocalizedString(@"article参数超过限制", nil)
#define kSNS_RETURN_WECHAT_45009 45009
#define kSNS_RETURN_WECHAT_45009_Text NSLocalizedString(@"接口调动频率超过限制", nil)
#define kSNS_RETURN_WECHAT_45010 45010
#define kSNS_RETURN_WECHAT_45010_Text NSLocalizedString(@"建立菜单被限制", nil)
#define kSNS_RETURN_WECHAT_45011 45011
#define kSNS_RETURN_WECHAT_45011_Text NSLocalizedString(@"频率限制", nil)
#define kSNS_RETURN_WECHAT_45012 45012
#define kSNS_RETURN_WECHAT_45012_Text NSLocalizedString(@"模板大小超过限制", nil)
#define kSNS_RETURN_WECHAT_45016 45016
#define kSNS_RETURN_WECHAT_45016_Text NSLocalizedString(@"不能修改默认组", nil)
#define kSNS_RETURN_WECHAT_45017 45017
#define kSNS_RETURN_WECHAT_45017_Text NSLocalizedString(@"修改组名过长", nil)
#define kSNS_RETURN_WECHAT_45018 45018
#define kSNS_RETURN_WECHAT_45018_Text NSLocalizedString(@"组数量过多", nil)
#define kSNS_RETURN_WECHAT_50001 50001
#define kSNS_RETURN_WECHAT_50001_Text NSLocalizedString(@"接口未授权", nil)

/**
 *  ASI 错误码
 */
#define kSNS_RETURN_SERVER_1 1
#define kSNS_RETURN_SERVER_1_Text NSLocalizedString(@"无法连接服务器[1]", nil)
#define kSNS_RETURN_SERVER_2 2
#define kSNS_RETURN_SERVER_2_Text NSLocalizedString(@"连接服务器超时[2]", nil)
#define kSNS_RETURN_SERVER_3 3
#define kSNS_RETURN_SERVER_3_Text NSLocalizedString(@"服务器认证失败[3]", nil)
#define kSNS_RETURN_SERVER_4 4
#define kSNS_RETURN_SERVER_4_Text NSLocalizedString(@"服务器取消请求[4]", nil)
#define kSNS_RETURN_SERVER_5 5
#define kSNS_RETURN_SERVER_5_Text NSLocalizedString(@"请求服务器地址无效[5]", nil)
#define kSNS_RETURN_SERVER_6 6
#define kSNS_RETURN_SERVER_6_Text NSLocalizedString(@"服务器内部请求错误[6]", nil)
#define kSNS_RETURN_SERVER_7 7
#define kSNS_RETURN_SERVER_7_Text NSLocalizedString(@"服务器内部证书错误[7]", nil)
#define kSNS_RETURN_SERVER_8 8
#define kSNS_RETURN_SERVER_8_Text NSLocalizedString(@"文件上传错误[8]", nil)
#define kSNS_RETURN_SERVER_9 9
#define kSNS_RETURN_SERVER_9_Text NSLocalizedString(@"重定向次数太多了[9]", nil)
#define kSNS_RETURN_SERVER_10 10
#define kSNS_RETURN_SERVER_10_Text NSLocalizedString(@"一个未知错误[10]", nil)
#define kSNS_RETURN_SERVER_11 11
#define kSNS_RETURN_SERVER_11_Text NSLocalizedString(@"文件压缩错误[11]", nil)

/**
 *  AF 错误码
 */
#define kSNS_RETURN_SERVER_3840 3840
#define kSNS_RETURN_SERVER_3840_Text NSLocalizedString(@"服务器数据错误[3840]", nil)

#define kSNS_RETURN_SERVER_NSFileLockingError 255
#define kSNS_RETURN_SERVER_NSFileLockingError_Text NSLocalizedString(@"文件锁定错误[255]", nil)
#define kSNS_RETURN_SERVER_NSFileReadUnknownError 256
#define kSNS_RETURN_SERVER_NSFileReadUnknownError_Text NSLocalizedString(@"文件读取未知错误[256]", nil)
#define kSNS_RETURN_SERVER_NSFileReadNoPermissionError 257
#define kSNS_RETURN_SERVER_NSFileReadNoPermissionError_Text NSLocalizedString(@"文件不允许读取[257]", nil)
#define kSNS_RETURN_SERVER_NSFileReadInvalidFileNameError 258
#define kSNS_RETURN_SERVER_NSFileReadInvalidFileNameError_Text NSLocalizedString(@"读取无效的文件名错误[258]", nil)
#define kSNS_RETURN_SERVER_NSFileReadCorruptFileError 259
#define kSNS_RETURN_SERVER_NSFileReadCorruptFileError_Text NSLocalizedString(@"读取损坏的文件错误[259]", nil)
#define kSNS_RETURN_SERVER_NSFileReadNoSuchFileError 260
#define kSNS_RETURN_SERVER_NSFileReadNoSuchFileError_Text NSLocalizedString(@"读没有这样的文件错误[260]", nil)
#define kSNS_RETURN_SERVER_NSFileReadInapplicableStringEncodingError 261
#define kSNS_RETURN_SERVER_NSFileReadInapplicableStringEncodingError_Text NSLocalizedString(@"不读字符串编码错误[261]", nil)
#define kSNS_RETURN_SERVER_NSFileReadUnsupportedSchemeError 262
#define kSNS_RETURN_SERVER_NSFileReadUnsupportedSchemeError_Text NSLocalizedString(@"读取不支持的计划错误[262]", nil)
#define kSNS_RETURN_SERVER_NSFileReadTooLargeError 263
#define kSNS_RETURN_SERVER_NSFileReadTooLargeError_Text NSLocalizedString(@"读取太大错误[263]", nil)
#define kSNS_RETURN_SERVER_NSFileReadUnknownStringEncodingError 264
#define kSNS_RETURN_SERVER_NSFileReadUnknownStringEncodingError_Text NSLocalizedString(@"读取未知字符串编码错误[264]", nil)

#define kSNS_RETURN_SERVER_NSFileWriteUnknownError 512
#define kSNS_RETURN_SERVER_NSFileWriteUnknownError_Text NSLocalizedString(@"写入未知错误[512]", nil)
#define kSNS_RETURN_SERVER_NSFileWriteNoPermissionError 513
#define kSNS_RETURN_SERVER_NSFileWriteNoPermissionError_Text NSLocalizedString(@"写入不允许错误[513]", nil)
#define kSNS_RETURN_SERVER_NSFileWriteInvalidFileNameError 514
#define kSNS_RETURN_SERVER_NSFileWriteInvalidFileNameError_Text NSLocalizedString(@"写入无效的文件名错误[514]", nil)
#define kSNS_RETURN_SERVER_NSFileWriteInapplicableStringEncodingError 517
#define kSNS_RETURN_SERVER_NSFileWriteInapplicableStringEncodingError_Text NSLocalizedString(@"不写字符串编码错误[517]", nil)
#define kSNS_RETURN_SERVER_NSFileWriteUnsupportedSchemeError 518
#define kSNS_RETURN_SERVER_NSFileWriteUnsupportedSchemeError_Text NSLocalizedString(@"写入不支持的计划错误[518]", nil)

#define kSNS_RETURN_SERVER_NSFileWriteOutOfSpaceError 640
#define kSNS_RETURN_SERVER_NSFileWriteOutOfSpaceError_Text NSLocalizedString(@"写出空间误差[640]", nil)
#define kSNS_RETURN_SERVER_NSFileWriteVolumeReadOnlyError 642
#define kSNS_RETURN_SERVER_NSFileWriteVolumeReadOnlyError_Text NSLocalizedString(@"写卷只读错误[642]", nil)
#define kSNS_RETURN_SERVER_NSKeyValueValidationError 1024
#define kSNS_RETURN_SERVER_NSKeyValueValidationError_Text NSLocalizedString(@"值验证错误[1024]", nil)
#define kSNS_RETURN_SERVER_NSFormattingError 2048
#define kSNS_RETURN_SERVER_NSFormattingError_Text NSLocalizedString(@"格式错误[2048]", nil)
#define kSNS_RETURN_SERVER_NSUserCancelledError 3072
#define kSNS_RETURN_SERVER_NSUserCancelledError_Text NSLocalizedString(@"用户取消错误[3072]", nil)

#define kSNS_RETURN_SERVER_NSPropertyListReadUnknownVersionError 3841
#define kSNS_RETURN_SERVER_NSPropertyListReadUnknownVersionError_Text NSLocalizedString(@"属性列表读取未知版本错误[3841]", nil)
#define kSNS_RETURN_SERVER_NSPropertyListReadStreamError 3842
#define kSNS_RETURN_SERVER_NSPropertyListReadStreamError_Text NSLocalizedString(@"属性列表读取流错误[3842]", nil)
#define kSNS_RETURN_SERVER_NSPropertyListWriteStreamError 3851
#define kSNS_RETURN_SERVER_NSPropertyListWriteStreamError_Text NSLocalizedString(@"属性列表写入流错误[3851]", nil)
#define kSNS_RETURN_SERVER_NSPropertyListErrorMaximum 4095
#define kSNS_RETURN_SERVER_NSPropertyListErrorMaximum_Text NSLocalizedString(@"属性列表错误最大值[4095]", nil)

#define kSNS_RETURN_SERVER_NSExecutableNotLoadableError 3584
#define kSNS_RETURN_SERVER_NSExecutableNotLoadableError_Text NSLocalizedString(@"可执行文件没有加载错误[3584]", nil)
#define kSNS_RETURN_SERVER_NSExecutableArchitectureMismatchError 3585
#define kSNS_RETURN_SERVER_NSExecutableArchitectureMismatchError_Text NSLocalizedString(@"可执行架构不匹配错误[3585]", nil)
#define kSNS_RETURN_SERVER_NSExecutableRuntimeMismatchError 3586
#define kSNS_RETURN_SERVER_NSExecutableRuntimeMismatchError_Text NSLocalizedString(@"可执行的运行时不匹配错误[3586]", nil)
#define kSNS_RETURN_SERVER_NSExecutableLoadError 3587
#define kSNS_RETURN_SERVER_NSExecutableLoadError_Text NSLocalizedString(@"可执行文件加载错误[3587]", nil)
#define kSNS_RETURN_SERVER_NSExecutableLinkError 3588
#define kSNS_RETURN_SERVER_NSExecutableLinkError_Text NSLocalizedString(@"可执行链接错误[3588]", nil)
#define kSNS_RETURN_SERVER_NSExecutableErrorMaximum 3839
#define kSNS_RETURN_SERVER_NSExecutableErrorMaximum_Text NSLocalizedString(@"执行误差最大[3839]", nil)

/**
 *  2xx  成功
 */
#define kSNS_RETURN_200 200
#define kSNS_RETURN_200_Text NSLocalizedString(@"请求已完成[200]", nil)
#define kSNS_RETURN_201 201
#define kSNS_RETURN_201_Text NSLocalizedString(@"紧接 POST 命令[201]", nil)
#define kSNS_RETURN_202 202
#define kSNS_RETURN_202_Text NSLocalizedString(@"已接受用于处理,但处理尚未完成[202]", nil)
#define kSNS_RETURN_203 203
#define kSNS_RETURN_203_Text NSLocalizedString(@"部分信息-返回的信息只是一部分[203]", nil)
#define kSNS_RETURN_204 204
#define kSNS_RETURN_204_Text NSLocalizedString(@"无响应-已接收请求,但不存在要回送的信息[204]", nil)
/**
 *  3xx  重定向
 */
#define kSNS_RETURN_301 301
#define kSNS_RETURN_301_Text NSLocalizedString(@"已移动-请求的数据具有新的位置且更改是永久的[301]", nil)
#define kSNS_RETURN_302 302
#define kSNS_RETURN_302_Text NSLocalizedString(@"已找到-请求的数据临时具有不同 URI[302]", nil)
#define kSNS_RETURN_303 303
#define kSNS_RETURN_303_Text NSLocalizedString(@"请参阅其它-可在另一 URI 下找到对请求的响应,且应使用 GET 方法检索此响应[303]", nil)
#define kSNS_RETURN_304 304
#define kSNS_RETURN_304_Text NSLocalizedString(@"未修改-未按预期修改文档[304]", nil)
#define kSNS_RETURN_305 305
#define kSNS_RETURN_305_Text NSLocalizedString(@"使用代理-必须通过位置字段中提供的代理来访问请求的资源[305]", nil)
#define kSNS_RETURN_306 306
#define kSNS_RETURN_306_Text NSLocalizedString(@"未使用-不再使用,保留此代码以便将来使用[406]", nil)
/**
 *  4xx  客户机中出现的错误
 */
#define kSNS_RETURN_400 400
#define kSNS_RETURN_400_Text NSLocalizedString(@"错误请求-请求中有语法问题,或不能满足请求[400]", nil)
#define kSNS_RETURN_401 401
#define kSNS_RETURN_401_Text NSLocalizedString(@"未授权-未授权客户机访问数据[401]", nil)
#define kSNS_RETURN_402 402
#define kSNS_RETURN_402_Text NSLocalizedString(@"需要付款-表示计费系统已有效[402]", nil)
#define kSNS_RETURN_403 403
#define kSNS_RETURN_403_Text NSLocalizedString(@"禁止访问-即使有授权也不需要访问[403]", nil)
#define kSNS_RETURN_404 404
#define kSNS_RETURN_404_Text NSLocalizedString(@"找不到服务器给定的资源,文档不存在[404]", nil)
#define kSNS_RETURN_407 407
#define kSNS_RETURN_407_Text NSLocalizedString(@"代理认证请求-客户机首先必须使用代理认证自身[407]", nil)
#define kSNS_RETURN_415 415
#define kSNS_RETURN_415_Text NSLocalizedString(@"介质类型不受支持-服务器拒绝服务请求,因为不支持请求实体的格式[415]", nil)
/**
 *  5xx  服务器中出现的错误
 */
#define kSNS_RETURN_500 500
#define kSNS_RETURN_500_Text NSLocalizedString(@"内部服务器错误[500]", nil)
#define kSNS_RETURN_501 501
#define kSNS_RETURN_501_Text NSLocalizedString(@"未执行-服务器不支持请求的工具[501]", nil)
#define kSNS_RETURN_502 502
#define kSNS_RETURN_502_Text NSLocalizedString(@"网关错误-服务器接收到来自上游服务器的无效响应[502]", nil)
#define kSNS_RETURN_503 503
#define kSNS_RETURN_503_Text NSLocalizedString(@"无法获得服务-由于临时过载或维护,服务器无法处理请求[503]", nil)









