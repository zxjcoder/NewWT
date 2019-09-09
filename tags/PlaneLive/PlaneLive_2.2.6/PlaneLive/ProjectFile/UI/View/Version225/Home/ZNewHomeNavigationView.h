//
//  ZNewHomeNavigationView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNewHomeNavigationView : UIView

///搜索按钮点击事件
@property (copy ,nonatomic) void(^onSearchClick)();
///下载按钮点击事件
@property (copy ,nonatomic) void(^onDownloadClick)();

-(void)setViewBackAlpha:(CGFloat)alpha;

+(CGFloat)getH;

@end
