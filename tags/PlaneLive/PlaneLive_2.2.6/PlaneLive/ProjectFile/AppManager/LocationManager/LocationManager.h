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

/// 国家
@property (copy, nonatomic) NSString *country;
/// 省份
@property (copy, nonatomic) NSString *province;
/// 城市
@property (copy, nonatomic) NSString *city;
/// 区
@property (nonatomic, copy) NSString *district;
///城市编码
@property (nonatomic, copy) NSString *citycode;
///区域编码
@property (nonatomic, copy) NSString *adcode;
///街道名称
@property (nonatomic, copy) NSString *street;
///门牌号
@property (nonatomic, copy) NSString *number;

/// 获取到新的位置信息时调用
@property (copy, nonatomic) void(^onDidUpdateLocation)(CLLocation *location);
/// 获取到新的位置信息时调用
@property (copy, nonatomic) void(^onDidFailWithError)(NSError *error);

///单例模式
+ (LocationManager *)sharedSingleton;

///开始单次定位
-(void)startOneLocation;
///开始定位
-(void)startLocation;
///停止定位
-(void)stopLocation;
///设置允许后台定位
-(void)setWhenInUseAuthorization;

@end
