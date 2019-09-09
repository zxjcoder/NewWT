//
//  ZPlaySendMailView.h
//  PlaneLive
//
//  Created by WT on 20/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPlaySendMailView : UIView

-(id)initWithContent:(NSString *)text mail:(NSString *)mail;

@property (copy, nonatomic) void(^onSendMailClick)(ZPlaySendMailView* view);

-(void)show;
-(void)dismiss;

@end
