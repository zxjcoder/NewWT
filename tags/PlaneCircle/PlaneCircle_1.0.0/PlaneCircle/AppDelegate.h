//
//  AppDelegate.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClassCategory.h"
#import "Utils.h"

#import "AppSetting.h"
#import "DataOper.h"
#import "SQLiteOper.h"

#import "PushManager.h"
#import "ShareManager.h"

#import "ZProgressHUD.h"
#import "ZAlertView.h"
#import "ZActionSheet.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (assign, nonatomic) BOOL appEnterBackground;
@property (strong, nonatomic) NSString *devTokenStr;
@property (assign, nonatomic) BOOL isPaying;
@property (assign, nonatomic) WTOpenURLType openUrlType;

+(AppDelegate *)app;

+(id)getViewControllerWithIdentifier:(NSString*)identifier;

-(void)logout;

@end

