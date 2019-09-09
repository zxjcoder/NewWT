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
        [self setAudioTitle:model.title==nil?kEmpty:model.title];
        [self setAudioImage:model.bkimg==nil?kEmpty:model.speech_img];
        [self setAudioAuthor:model.nickname==nil?kEmpty:model.nickname];
        [self setAudioPath:model.speech_url];
        [self setAudioPlayTime:model.play_time];
    }
    return self;
}

@end
