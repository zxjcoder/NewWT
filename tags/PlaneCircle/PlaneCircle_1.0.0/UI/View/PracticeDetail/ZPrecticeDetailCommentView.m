//
//  ZPrecticeDetailCommentView.m
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPrecticeDetailCommentView.h"

@interface ZPrecticeDetailCommentView()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIView *viewL;

@end

@implementation ZPrecticeDetailCommentView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:(CGRect)frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:@"评论 (0)"];
    [self.lbTitle setTextColor:MAINCOLOR];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTitle setLabelFontWithRange:NSMakeRange(0, 2) font:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self addSubview:self.lbTitle];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewL];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat lbH = 30;
    [self.lbTitle setFrame:CGRectMake(10, self.height/2-lbH/2, APP_FRAME_WIDTH-20, lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.height-0.8, self.width, 0.8)];
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self.lbTitle setText:[NSString stringWithFormat:@"评论 (%ld)", model.mcount]];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTitle setLabelFontWithRange:NSMakeRange(0, 2) font:[UIFont systemFontOfSize:kFont_Default_Size]];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewL);
}

@end
