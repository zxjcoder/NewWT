//
//  LocationManager.h
//  PlaneLive
//
//  Created by Daniel on 13/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

/// 获取到新的位置信息时调用
@property (copy, nonatomic) void(^onDidUpdateLocation)(CLLocation *location);
/// 获取到新的位置信息时调用
@property (copy, nonatomic) void(^onDidFailWithError)(NSError *error);

///单例模式
+ (LocationManager *)sharedSingleton;

///开始定位
-(void)startLocation;
///停止定位
-(void)stopLocation;

@end
