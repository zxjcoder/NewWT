//
//  PlayerTimeManager.m
//  PlaneLive
//
//  Created by Daniel on 19/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "PlayerTimeManager.h"

UIKIT_EXTERN NSString *const PLAYERTIMEFILENAME;
NSString *const PLAYERTIMEFILENAME=@"PLAYERTIME.PLIST";

@interface PlayerTimeManager()

@end

@implementation PlayerTimeManager

static NSMutableDictionary *dicCurrPlayerTimeSettings;

static PlayerTimeManager *_playerTimeInstance;
+ (PlayerTimeManager *)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerTimeInstance = [[self alloc] init];
    });
    return _playerTimeInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    NSString *filepath = [self getFilePath];
    [dicCurrPlayerTimeSettings removeAllObjects];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        dicCurrPlayerTimeSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
    } else {
        dicCurrPlayerTimeSettings = [NSMutableDictionary dictionary];
    }
}
-(void)dealloc
{
    [self save];
    [dicCurrPlayerTimeSettings removeAllObjects];
}
-(void)setPlayTimeWithId:(NSInteger)ids playTime:(NSUInteger)playTime percent:(CGFloat)percent
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)ids];
    NSString *strTime = [NSString stringWithFormat:@"%ld", playTime];
    NSString *strPercent = [NSString stringWithFormat:@"%f", percent];
    NSDictionary *dicValue = [NSDictionary dictionaryWithObjectsAndKeys:strTime, @"time", strPercent, @"percent", nil];
    [dicCurrPlayerTimeSettings setObject:dicValue forKey:key];
}
-(NSUInteger)getPlayTimeWithId:(NSInteger)ids
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)ids];
    NSDictionary *dicValue = [dicCurrPlayerTimeSettings valueForKey:key];
    NSString *time = [dicValue objectForKey:@"time"];
    if (time == nil || time.length == 0) {
        return 0;
    }
    return time.longLongValue;
}
-(CGFloat)getPercentWithId:(NSInteger)ids
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)ids];
    NSDictionary *dicValue = [dicCurrPlayerTimeSettings valueForKey:key];
    NSString *percent = [dicValue objectForKey:@"percent"];
    if (percent == nil || percent.length == 0) {
        return 0;
    }
    return percent.floatValue;
}
-(void)save
{
    if (dicCurrPlayerTimeSettings) {
        NSString *filepath = [self getFilePath];
        [dicCurrPlayerTimeSettings writeToFile:filepath atomically:YES];
    }
}
-(NSString*)getFilePath
{
    NSString *filepath = [[AppSetting getDocumentPath] stringByAppendingPathComponent:PLAYERTIMEFILENAME];
    return filepath;
}

@end
