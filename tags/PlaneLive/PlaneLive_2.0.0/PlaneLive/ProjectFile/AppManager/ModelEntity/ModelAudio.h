//
//  ModelAudio.h
//  PlaneCircle
//
//  Created by Daniel on 7/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

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

///上次播放时长->秒
@property (assign ,nonatomic) long audioPlayTime;

///播放对象类型 1实务 2订阅
@property (assign ,nonatomic) int audioPlayType;

@end
