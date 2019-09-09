//
//  ZQuestionDetailAnswerView.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionDetailAnswerView.h"

@interface ZQuestionDetailAnswerView()

///邀请回答
@property (strong, nonatomic) UIButton *btnInvitation;
///添加答案
@property (strong, nonatomic) UIButton *btnAdd;

@property (strong, nonatomic) UIView *viewLine1;
@property (strong, nonatomic) UIView *viewLine2;

@property (strong, nonatomic) ModelQuestionDetail *model;

@end

@implementation ZQuestionDetailAnswerView

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
    self.btnInvitation = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnInvitation setImage:[SkinManager getImageWithName:@"btn_yaoqinghuida"] forState:(UIControlStateNormal)];
    [self.btnInvitation setImage:[SkinManager getImageWithName:@"btn_yaoqinghuida_pressed"] forState:(UIControlStateHighlighted)];
    [self.btnInvitation setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnInvitation addTarget:self action:@selector(btnInvitationClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnInvitation];
    
    self.btnAdd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAdd setImage:[SkinManager getImageWithName:@"btn_tianjiadaan_default"] forState:(UIControlStateNormal)];
    [self.btnAdd setImage:[SkinManager getImageWithName:@"btn_tianjiadaan_pressed"] forState:(UIControlStateHighlighted)];
    [self.btnAdd setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnAdd];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self addSubview:self.viewLine2];
    
    [self setViewFrame];
}

-(void)dealloc
{
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_btnAdd);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_btnInvitation);
    OBJC_RELEASE(_onAddAnswerClick);
    OBJC_RELEASE(_onInvitationClick);
}

-(void)btnInvitationClick
{
    if (self.model.isInvitation == 0) {
        if (self.onInvitationClick) {
            self.onInvitationClick(self.model);
        }
    }
}

-(void)btnAddClick
{
    if (self.onAddAnswerClick) {
        self.onAddAnswerClick(self.model);
    }
}

-(void)setViewDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    ///可以继续邀请
    if (self.model.isInvitation == 0) {
        [self.btnInvitation setImage:[SkinManager getImageWithName:@"btn_yaoqinghuida"] forState:(UIControlStateNormal)];
        [self.btnInvitation setImage:[SkinManager getImageWithName:@"btn_yaoqinghuida_pressed"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnInvitation setImage:[SkinManager getImageWithName:@"btn_yaoqinghuida_invitation"] forState:(UIControlStateNormal)];
        [self.btnInvitation setImage:[SkinManager getImageWithName:@"btn_yaoqinghuida_invitation"] forState:(UIControlStateHighlighted)];
    }
    //已经回答过了
    if (self.model.answerQuestion && [self.model.answerQuestion intValue] > 0) {
        [self.btnAdd setImage:[SkinManager getImageWithName:@"btn_chakandaan"] forState:(UIControlStateNormal)];
        [self.btnAdd setImage:[SkinManager getImageWithName:@"btn_daan_pressed"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnAdd setImage:[SkinManager getImageWithName:@"btn_tianjiadaan_default"] forState:(UIControlStateNormal)];
        [self.btnAdd setImage:[SkinManager getImageWithName:@"btn_tianjiadaan_pressed"] forState:(UIControlStateHighlighted)];
    }
}

-(void)setViewFrame
{
    self.width = APP_FRAME_WIDTH;
    
    CGFloat itemW = 140;
    CGFloat itemH = 35;
    CGFloat itemS = (self.width-itemW*2)/3;
    [self.btnInvitation setFrame:CGRectMake(itemS, 13, itemW, itemH)];
    [self.btnAdd setFrame:CGRectMake(self.width-itemS-itemW, 13, itemW, itemH)];
    
    [self.viewLine1 setFrame:CGRectMake(0, 0, self.width, 1)];
    [self.viewLine2 setFrame:CGRectMake(0, self.height-5, self.width, 5)];
}

+(CGFloat)getViewH
{
    return 60;
}

@end
