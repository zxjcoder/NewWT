//
//  PlayerTimeManager.h
//  PlaneLive
//
//  Created by Daniel on 19/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerTimeManager : NSObject

+ (PlayerTimeManager *)shared;

-(void)setPlayTimeWithId:(NSInteger)ids playTime:(NSUInteger)playTime percent:(CGFloat)percent;

-(NSUInteger)getPlayTimeWithId:(NSInteger)ids;

-(CGFloat)getPercentWithId:(NSInteger)ids;

-(void)save;

@end
