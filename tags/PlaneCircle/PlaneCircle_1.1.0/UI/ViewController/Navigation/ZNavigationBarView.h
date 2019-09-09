//
//  ZNavigationBarView.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^onBackButtonClick)(UIButton *button);

@interface ZNavigationBarView : UIView

@property (copy, nonatomic) NSString *title;

-(void)setBackButtonClick:(onBackButtonClick)block;

-(void)setHiddenBackButton:(BOOL)hidden;

@end

@interface UIViewController (ZNavigationBarView)

@property (nonatomic,strong) ZNavigationBarView *navigationBar;
@property (nonatomic,getter=isNavigationBar) BOOL navigationBarHidden;
@property (nonatomic,copy) NSString *title;

@end
