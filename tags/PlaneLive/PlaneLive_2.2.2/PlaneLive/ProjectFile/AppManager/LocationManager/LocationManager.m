//
//  LocationManager.m
//  PlaneLive
//
//  Created by Daniel on 13/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()<CLLocationManagerDelegate>

// 设置位置管理者属性
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

static LocationManager *_locationManagerInstance;
///单例模式
+ (LocationManager *)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManagerInstance = [[self alloc] init];
    });
    return _locationManagerInstance;
}
///开始定位
-(void)startLocation
{
    // 判断是否打开了位置服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 设置定位距离过滤参数 (当本次定位和上次定位之间的距离大于或等于这个值时，调用代理方法)
        _locationManager.distanceFilter = 100;
        // 设置定位精度(精度越高越耗电)
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
}
///停止定位
-(void)stopLocation
{
    [self.lcManager stopUpdatingLocation];
}
///设置后台定位
-(void)setWhenInUseAuthorization
{
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
}
-(void)dealloc
{
    _locationManager.delegate = nil;
    _locationManager = nil;
}
// 创建位置管理者对象
-(CLLocationManager *)lcManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        // 设置代理
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - CLLocationManagerDelegate

/// 定位服务状态改变时调用
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            GBLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            GBLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                GBLog(@"定位服务开启，被拒绝");
            } else {
                GBLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            GBLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            GBLog(@"获得前台授权");
            break;
        }
        default: break;
    }
}
/// 获取到新的位置信息时调用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    if (self.onDidUpdateLocation) {
        self.onDidUpdateLocation(location);
    }
    [manager stopUpdatingHeading];
    GBLog(@"didUpdateLocations: %@", location);
}
/// 不能获取位置信息时调用
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.onDidFailWithError) {
        self.onDidFailWithError(error);
    }
    GBLog(@"didFailWithError: %@", error);
}

@end
