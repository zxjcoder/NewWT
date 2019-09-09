//
//  ZPracticeDetailHotView.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailHotView.h"

@interface ZPracticeDetailHotView()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZPracticeDetailHotView

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
    [self.lbTitle setText:@"热门 (0)"];
    [self.lbTitle setTextColor:TVHEADERCOLOR];
    [self addSubview:self.lbTitle];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewLine];
    
    [self setViewFrame];
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    CGFloat fontSize = [[AppSetting getFontSize] floatValue];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kSet_Font_Min_Size(fontSize)]];
    [self.lbTitle setLabelFontWithRange:NSMakeRange(0, 2) font:[ZFont boldSystemFontOfSize:kSet_Font_Small_Size(fontSize)]];
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGFloat lbH = 25;
    [self.lbTitle setFrame:CGRectMake(10, self.height/2-lbH/2, APP_FRAME_WIDTH-20, lbH)];
    
    [self.viewLine setFrame:CGRectMake(0, self.height-1, self.width, 1)];
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self.lbTitle setText:[NSString stringWithFormat:@"热门 (%ld)", model.question_hot]];
    
    [self setViewFrame];
}
+(CGFloat)getViewH
{
    return 35;
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewLine);
}


@end
