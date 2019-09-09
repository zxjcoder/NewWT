//
//  ModelTrack.m
//  PlaneLive
//
//  Created by Daniel on 02/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ModelTrack.h"
#import "PlayerTimeManager.h"

@implementation ModelTrack

-(id)initWithModelPractice:(ModelPractice *)model
{
    self = [self init];
    if (self && model) {
        self.ids = model.ids;
        self.kind = @"track";
        self.source = ZDownloadTypePractice;
        self.duration = [model.time integerValue];
        self.playUrl32 = model.speech_url;
        self.playUrl64 = model.speech_url;
        self.playUrl24M4a = model.speech_url;
        self.playUrl64M4a = model.speech_url;
        self.downloadUrl = model.speech_url;
        self.canDownload = YES;
        self.trackTitle = model.title;
        self.trackIntro = model.share_content;
        self.trackId = [[model.ids stringByAppendingString:kMultipleZeros] integerValue];
        self.teamName = model.person_title;
        self.teamInfo = model.person_synopsis;
        self.coverUrlLarge = model.speech_img;
        self.coverUrlMiddle = model.speech_img;
        self.coverUrlSmall = model.speech_img;
        //播放数量
        self.playCount = model.hits;
        //收藏数量
        self.favoriteCount = model.ccount;
        //评论数量
        self.commentCount = model.mcount;
        //点赞数量
        self.orderNum = model.applauds;
        //1实务,2订阅,3系列课程
        self.dataType = self.source;
        //播放时间
        self.listenedTime = model.play_time;
        self.listenedTime = [[PlayerTimeManager shared] getPlayTimeWithId:self.trackId];
        
        XMAnnouncer *announcer = [[XMAnnouncer alloc] init];
        announcer.id = [kLoginUserId integerValue];
        announcer.nickname = model.nickname;
        announcer.kind = @"user";
        self.announcer = announcer;
        
        XMSubordinatedAlbum *subordinatedAlbum = [[XMSubordinatedAlbum alloc] init];
        subordinatedAlbum.albumId = self.dataType;
        subordinatedAlbum.albumTitle = kPractice;
        self.subordinatedAlbum = subordinatedAlbum;
    }
    return self;
}

-(id)initWithModelCurriculum:(ModelCurriculum *)model
{
    self = [self init];
    if (self && model) {
        self.ids = model.ids;
        self.kind = @"track";
        self.source = ZDownloadTypeSubscribe;
        self.duration = [model.audio_time integerValue];
        self.playUrl32 = model.audio_url;
        self.playUrl64 = model.audio_url;
        self.playUrl24M4a = model.audio_url;
        self.playUrl64M4a = model.audio_url;
        self.downloadUrl = model.audio_url;
        self.canDownload = YES;
        self.trackTitle = model.ctitle;
        self.trackIntro = model.content;
        self.trackId = [model.ids integerValue];
        self.teamName = model.team_name;
        self.teamInfo = model.team_intro;
        self.coverUrlLarge = model.audio_picture;
        self.coverUrlMiddle = model.audio_picture;
        self.coverUrlSmall = model.audio_picture;
        //播放数量
        self.playCount = model.hits;
        //播放数量
        self.playCount = 0;
        //收藏数量
        self.favoriteCount = model.ccount;
        //评论数量
        self.commentCount = model.mcount;
        //点赞数量
        self.orderNum = model.applauds;
        //1实务,2订阅,3系列课程
        self.dataType = self.source;
        //播放时间
        self.listenedTime = model.play_time;
        self.listenedTime = [[PlayerTimeManager shared] getPlayTimeWithId:self.trackId];
        
        XMAnnouncer *announcer = [[XMAnnouncer alloc] init];
        announcer.id = [kLoginUserId integerValue];
        announcer.nickname = model.speaker_name;
        announcer.kind = @"user";
        self.announcer = announcer;
        
        XMSubordinatedAlbum *subordinatedAlbum = [[XMSubordinatedAlbum alloc] init];
        subordinatedAlbum.albumId = self.dataType;
        subordinatedAlbum.albumTitle = kSubscribe;
        self.subordinatedAlbum = subordinatedAlbum;
    }
    return self;
}

-(id)initWithModelSeriesCourses:(ModelCurriculum *)model
{
    self = [self init];
    if (self && model) {
        self.ids = model.ids;
        self.kind = @"track";
        self.source = ZDownloadTypeSeriesCourse;
        self.duration = [model.audio_time integerValue];
        self.playUrl32 = model.audio_url;
        self.playUrl64 = model.audio_url;
        self.playUrl24M4a = model.audio_url;
        self.playUrl64M4a = model.audio_url;
        self.downloadUrl = model.audio_url;
        self.canDownload = YES;
        self.trackTitle = model.ctitle;
        self.trackIntro = model.content;
        self.trackId = [model.ids integerValue];
        self.teamName = model.team_name;
        self.teamInfo = model.team_intro;
        self.coverUrlLarge = model.audio_picture;
        self.coverUrlMiddle = model.audio_picture;
        self.coverUrlSmall = model.audio_picture;
        //播放数量
        self.playCount = model.hits;
        //播放数量
        self.playCount = 0;
        //收藏数量
        self.favoriteCount = model.ccount;
        //评论数量
        self.commentCount = model.mcount;
        //点赞数量
        self.orderNum = model.applauds;
        //1实务,2订阅,3系列课程
        self.dataType = self.source;
        //播放时间
        self.listenedTime = model.play_time;
        self.listenedTime = [[PlayerTimeManager shared] getPlayTimeWithId:self.trackId];
        
        XMAnnouncer *announcer = [[XMAnnouncer alloc] init];
        announcer.id = [kLoginUserId integerValue];
        announcer.nickname = model.speaker_name;
        announcer.kind = @"user";
        self.announcer = announcer;
        
        XMSubordinatedAlbum *subordinatedAlbum = [[XMSubordinatedAlbum alloc] init];
        subordinatedAlbum.albumId = self.dataType;
        subordinatedAlbum.albumTitle = kSeriesCourse;
        self.subordinatedAlbum = subordinatedAlbum;
    }
    return self;
}


@end
