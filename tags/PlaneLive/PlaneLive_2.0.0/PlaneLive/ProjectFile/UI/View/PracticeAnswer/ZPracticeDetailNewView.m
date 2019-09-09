//
//  ZPracticeDetailNewView.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailNewView.h"
#import "ClassCategory.h"

@interface ZPracticeDetailNewView()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIView *viewL;

@end

@implementation ZPracticeDetailNewView

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
    [self.lbTitle setText:[NSString stringWithFormat:@"%@ (0)", kNewest]];
    [self.lbTitle setTextColor:TVHEADERCOLOR];
    [self addSubview:self.lbTitle];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewL];
    
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
    
    [self.viewL setFrame:CGRectMake(0, self.height-1, self.width, 1)];
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self.lbTitle setText:[NSString stringWithFormat:@"%@ (%ld)", kNewest, model.question_new]];
    
    [self setViewFrame];
}
+(CGFloat)getViewH
{
    return 35;
}
-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewL);
}


@end
