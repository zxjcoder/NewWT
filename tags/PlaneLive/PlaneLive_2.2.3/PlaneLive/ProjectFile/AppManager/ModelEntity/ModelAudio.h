//
//  ModelAudio.h
//  PlaneCircle
//
//  Created by Daniel on 7/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "XMTrack.h"

#import "ModelEntity.h"

///音频文件对象
@interface ModelAudio : ModelEntity

///根据实务对象获取音频对象
-(id)initWithModel:(ModelPractice *)model;
///根据每期内容对象获取音频对象
-(id)initWithModelCurriculum:(ModelCurriculum *)model;

///ID
@property (retain, nonatomic) NSString *ids;
///ID
@property (retain, nonatomic) NSString *objId;
///音频标题
@property (retain, nonatomic) NSString *audioTitle;
///音频作者
@property (retain, nonatomic) NSString *audioAuthor;
///音频地址
@property (retain, nonatomic) NSString *audioPath;
///音频图片
@property (retain, nonatomic) NSString *audioImage;
///音频本地地址
@property (retain, nonatomic) NSString *audioLocalPath;
///音频总时长
@property (retain, nonatomic) NSString *totalDuration;
///价格
@property (retain, nonatomic) NSString *price;
///缓存文件路径
@property (retain, nonatomic) NSString *cachePath;
///上次播放时长->秒
@property (assign ,nonatomic) NSTimeInterval audioPlayTime;
///下载进度0-1
@property (assign ,nonatomic) CGFloat progress;
///下载总大小
@property (assign ,nonatomic) CGFloat totalUnitCount;
///下载完成大小
@property (assign ,nonatomic) CGFloat completedUnitCount;
///播放对象类型 1实务 2订阅
@property (assign ,nonatomic) int audioPlayType;
///下载状态
@property (assign, nonatomic) ZDownloadStatus address;

@end
