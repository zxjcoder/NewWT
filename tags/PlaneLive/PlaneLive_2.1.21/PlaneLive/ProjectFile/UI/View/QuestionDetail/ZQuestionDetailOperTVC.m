//
//  ZQuestionDetailOperTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionDetailOperTVC.h"

@interface ZQuestionDetailOperTVC()

///邀请回答
@property (strong, nonatomic) ZButton *btnInvitation;
///添加答案
@property (strong, nonatomic) ZButton *btnAdd;

@property (strong, nonatomic) UIImageView *imgLine1;
@property (strong, nonatomic) UIImageView *imgLine2;
@property (strong, nonatomic) UIImageView *imgLine3;

@property (strong, nonatomic) ModelQuestionDetail *model;

@end

@implementation ZQuestionDetailOperTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZQuestionDetailOperTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.btnInvitation = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnInvitation setImage:[SkinManager getImageWithName:@"crlcle_invite_icon"] forState:(UIControlStateNormal)];
    [self.btnInvitation setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnInvitation setTitle:kInvitationQuestionAnswer forState:(UIControlStateNormal)];
    [[self.btnInvitation titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnInvitation setTitleEdgeInsets:(UIEdgeInsetsMake(5, 10, 0, 0))];
    [self.btnInvitation addTarget:self action:@selector(btnInvitationClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnInvitation];
    
    self.btnAdd = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAdd setImage:[SkinManager getImageWithName:@"cricle_addanswer_icon"] forState:(UIControlStateNormal)];
    [self.btnAdd setImageEdgeInsets:(UIEdgeInsetsMake(6, 0, 0, 0))];
    [self.btnAdd setTitle:kAddAnswerKey forState:(UIControlStateNormal)];
    [self.btnAdd setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [self.btnAdd setTitleEdgeInsets:(UIEdgeInsetsMake(3, 10, 0, 0))];
    [[self.btnAdd titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAdd];
    
    self.imgLine1 = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[SkinManager getImageWithName:@"image_line"].CGImage scale:1 orientation:(UIImageOrientationLeftMirrored)]];
    [self.viewMain addSubview:self.imgLine2];
    
    self.imgLine3 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine3];
    
    [self setViewFrame];
}

-(void)dealloc
{
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_btnAdd);
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_imgLine3);
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

-(CGFloat)setCellDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    ///可以继续邀请
    if (self.model.isInvitation == 0) {
        [self.btnInvitation setImage:[SkinManager getImageWithName:@"crlcle_invite_icon"] forState:(UIControlStateNormal)];
        [self.btnInvitation setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    } else {
        [self.btnInvitation setImage:[SkinManager getImageWithName:@"crlcle_invite_icon_disable"] forState:(UIControlStateNormal)];
        [self.btnInvitation setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    }
    //已经回答过了
    if (self.model.answerQuestion && [self.model.answerQuestion intValue] > 0) {
        [self.btnAdd setTitle:kSayAnswerKey forState:(UIControlStateNormal)];
    } else {
        [self.btnAdd setTitle:kAddAnswerKey forState:(UIControlStateNormal)];
    }
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewFrame
{
    CGFloat itemW = (self.cellW-self.space*2)/2;
    CGFloat itemH = 40;
    CGFloat itemS = self.space;
    [self.btnInvitation setFrame:CGRectMake(itemS, 5, itemW, itemH)];
    
    [self.btnAdd setFrame:CGRectMake(self.btnInvitation.x+self.btnInvitation.width, 5, itemW, itemH)];
    
    [self.imgLine1 setFrame:CGRectMake(self.space, 5, self.cellW-self.space*2, self.lineH)];
    
    [self.imgLine2 setFrame:CGRectMake(self.cellW/2, 5, self.lineH/2, self.height-10)];
    
    [self.imgLine3 setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)getH
{
    return self.cellH;
}

+(CGFloat)getH
{
    return 50;
}

@end
