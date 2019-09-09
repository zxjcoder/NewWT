//
//  ModelAudio.m
//  PlaneCircle
//
//  Created by Daniel on 7/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ModelAudio.h"
#import "Utils.h"

@implementation ModelAudio

-(id)initWithModel:(ModelPractice *)model
{
    self = [self init];
    if (self && model) {
        [self setIds:model.ids==nil?kEmpty:model.ids];
        [self setObjId:model.ids==nil?kEmpty:model.ids];
        [self setAudioTitle:model.title==nil?kEmpty:model.title];
        [self setAudioImage:model.speech_img==nil?kEmpty:model.speech_img];
        [self setAudioAuthor:model.nickname==nil?kEmpty:model.nickname];
        [self setAudioPath:model.speech_url==nil?kEmpty:model.speech_url];
        [self setAudioPlayTime:model.play_time];
        [self setTotalDuration:model.time==nil?kEmpty:model.time];
        
        [self setAudioPlayType:1];
    }
    return self;
}

-(id)initWithModelCurriculum:(ModelCurriculum *)model
{
    self = [self init];
    if (self && model) {
        [self setIds:model.ids==nil?kEmpty:model.ids];
        [self setObjId:model.ids==nil?kEmpty:model.ids];
        [self setAudioTitle:model.ctitle==nil?kEmpty:model.ctitle];
        [self setAudioImage:model.audio_picture==nil?kEmpty:model.audio_picture];
        [self setAudioAuthor:model.title==nil?kEmpty:model.title];
        [self setAudioPath:model.audio_url==nil?kEmpty:model.audio_url];
        [self setAudioPlayTime:model.play_time];
        [self setTotalDuration:model.audio_time==nil?kEmpty:model.audio_time];
        
        [self setAudioPlayType:2];
    }
    return self;
}

@end
