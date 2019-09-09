//
//  ZPracticeDetailAllView.m
//  PlaneCircle
//
//  Created by Daniel on 8/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailAllView.h"

@interface ZPracticeDetailAllView()

@property (strong, nonatomic) UIView *viewMain;

@property (strong, nonatomic) UIButton *btnAll;

@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZPracticeDetailAllView

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
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    
    self.viewMain = [[UIView alloc] init];
    [self.viewMain setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewMain];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    self.btnAll = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAll setUserInteractionEnabled:YES];
    [self.btnAll setTitle:@"查看全部" forState:(UIControlStateNormal)];
    [self.btnAll setTitle:@"查看全部" forState:(UIControlStateHighlighted)];
    [self.btnAll setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnAll setImage:[SkinManager getImageWithName:@"btn_answer_chakanquanbu"] forState:(UIControlStateNormal)];
    [self.btnAll setImage:[SkinManager getImageWithName:@"btn_answer_chakanquanbu"] forState:(UIControlStateHighlighted)];
    [self.btnAll setImageEdgeInsets:(UIEdgeInsetsMake(4, 60, 4, 0))];
    [self.btnAll setTitleEdgeInsets:(UIEdgeInsetsMake(3, -20, 0, 0))];
    [self.btnAll addTarget:self action:@selector(btnAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    [[self.btnAll titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.btnAll];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.viewMain setFrame:CGRectMake(0, -5, APP_FRAME_WIDTH, self.height)];
    
    [self.viewLine setFrame:CGRectMake(0, 0, self.viewMain.width, 1)];
    
    CGFloat allW = 70;
    [self.btnAll setFrame:CGRectMake(APP_FRAME_WIDTH/2-allW/2, 1+self.viewMain.height/2-30/2, allW, 30)];
}

-(void)btnAllClick
{
    if (self.onAllClick) {
        self.onAllClick();
    }
}

+(CGFloat)getViewH
{
    return 40;
}

@end
