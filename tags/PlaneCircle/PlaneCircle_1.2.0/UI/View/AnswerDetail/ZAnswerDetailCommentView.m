//
//  ZAnswerDetailCommentView.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailCommentView.h"

@interface ZAnswerDetailCommentView()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@property (strong, nonatomic) UIView *viewL;

@end

@implementation ZAnswerDetailCommentView

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
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTitle setLabelFontWithRange:NSMakeRange(0, 2) font:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
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

-(void)setViewDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    [self.lbTitle setText:[NSString stringWithFormat:@"评论 (%ld)", model.commentCount]];
    
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTitle setLabelFontWithRange:NSMakeRange(0, 2) font:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewL);
}

@end
