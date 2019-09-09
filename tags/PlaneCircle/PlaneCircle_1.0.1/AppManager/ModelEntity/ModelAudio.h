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

///ID
@property (retain, nonatomic) NSString *ids;

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

///上次播放时长->秒
@property (assign ,nonatomic) long audioPlayTime;

@end
