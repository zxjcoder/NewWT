//
//  ZTopicLabel.m
//  PlaneCircle
//
//  Created by Daniel on 6/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicLabel.h"
#import "ClassCategory.h"

@interface ZTopicLabel()

@property (strong, nonatomic) UILabel *lbTopic;

@property (strong, nonatomic) UIButton *btnTopic;

@property (strong, nonatomic) ModelTag *model;

@end

@implementation ZTopicLabel

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    self.lbTopic = [[UILabel alloc] init];
    [self.lbTopic setTextColor:MAINCOLOR];
    [self.lbTopic setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [[self.lbTopic layer] setMasksToBounds:YES];
    [self.lbTopic setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [self.lbTopic setUserInteractionEnabled:NO];
    [self.lbTopic setTextAlignment:(NSTextAlignmentCenter)];
    [self addSubview:self.lbTopic];
    
    self.btnTopic = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnTopic setImage:[SkinManager getImageWithName:@"btn_tianjiahuida_delete"] forState:(UIControlStateNormal)];
    [self.btnTopic setImage:[SkinManager getImageWithName:@"btn_tianjiahuida_delete"] forState:(UIControlStateHighlighted)];
    [self.btnTopic setImageEdgeInsets:(UIEdgeInsetsMake(6, 6, 6, 6))];
    [self.btnTopic addTarget:self action:@selector(btnTopicClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnTopic setHidden:YES];
    [self addSubview:self.btnTopic];
}

-(void)setViewFont:(UIFont *)font
{
    [self.lbTopic setFont:font];
}

-(void)dealloc
{
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_lbTopic);
    OBJC_RELEASE(_btnTopic);
    OBJC_RELEASE(_onDeleteClick);
}

-(void)setViewFrame
{
    CGFloat lbH = 28;
    [self.lbTopic setFrame:CGRectMake(0, self.getH-lbH, self.getW-15, lbH)];
    CGFloat btnS = 35;
    [self.btnTopic setFrame:CGRectMake(self.getW-btnS, 0, btnS, btnS)];
}

-(void)btnTopicClick
{
    if (self.onDeleteClick) {
        self.onDeleteClick(self.model);
    }
}

-(void)setTopicWithModel:(ModelTag *)model
{
    [self setModel:model];
    if (model) {
        [self.lbTopic setText:model.tagName];
    }
    [self setViewFrame];
}

-(CGFloat)getH
{
    return 45;
}
+(CGFloat)getH
{
    return 45;
}

-(CGFloat)getW
{
    CGFloat lbW = [self.lbTopic getLabelWidthWithMinWidth:0];
    if (lbW < 50) {
        lbW = 50;
    } else {
        lbW = lbW+20;
    }
    return lbW;
}

@end
