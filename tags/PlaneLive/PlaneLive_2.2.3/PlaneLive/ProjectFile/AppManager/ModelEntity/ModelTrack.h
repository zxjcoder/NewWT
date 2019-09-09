//
//  ModelTrack.h
//  PlaneLive
//
//  Created by Daniel on 02/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "XMTrack.h"
#import "ModelEntity.h"

@interface ModelTrack : XMTrack

@property (strong, nonatomic) NSString *ids;
///1实务,2订阅,3系列课程
@property (assign, nonatomic) ZDownloadType dataType;
///团队名称
@property (strong, nonatomic) NSString *teamName;
///团队描述
@property (strong, nonatomic) NSString *teamInfo;
///实务
-(id)initWithModelPractice:(ModelPractice *)model;
///订阅课程
-(id)initWithModelCurriculum:(ModelCurriculum *)model;
///系列课程
-(id)initWithModelSeriesCourses:(ModelCurriculum *)model;

@end
