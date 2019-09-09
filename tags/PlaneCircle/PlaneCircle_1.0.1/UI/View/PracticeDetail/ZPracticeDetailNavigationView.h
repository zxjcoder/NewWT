//
//  ZPracticeDetailNavigationView.h
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPracticeDetailNavigationView : ZView

@property (strong, nonatomic) UILabel *lbTitle;

@property (copy, nonatomic) void(^onBackClick)();

@property (copy, nonatomic) void(^onMoreClick)();

@property (copy, nonatomic) void(^onViewClick)();

-(void)setViewTitle:(NSString *)title;

-(void)setViewBGAlpha:(CGFloat)alpha;

-(void)setHiddenMore:(BOOL)isHidden;

@end
