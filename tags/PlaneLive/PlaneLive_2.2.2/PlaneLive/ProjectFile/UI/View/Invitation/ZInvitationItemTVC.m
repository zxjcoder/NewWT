//
//  ZInvitationItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZInvitationItemTVC.h"

@interface ZInvitationItemTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UILabel *lbSign;

@property (strong, nonatomic) UIButton *btnInvitation;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) ModelUserInvitation *model;

@end

@implementation ZInvitationItemTVC

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
    
    self.cellH = [ZInvitationItemTVC getH];
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultPhoto];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSign];
    
    self.btnInvitation = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnInvitation setBackgroundColor:MAINCOLOR];
    [self.btnInvitation setTitle:kInvitation forState:(UIControlStateNormal)];
    [self.btnInvitation setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[self.btnInvitation titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnInvitation setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnInvitation addTarget:self action:@selector(btnInvitationClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnInvitation];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgS = 45;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.cellH/2-imgS/2, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat btnW = 50;
    CGFloat btnH = 25;
    CGFloat lbX = self.imgPhoto.x+imgS+kSize10;
    CGFloat lbW = self.cellW-lbX-self.space-btnW;
    [self.lbNickName setFrame:CGRectMake(lbX, kSize15, lbW, self.lbH)];
    
    [self.lbSign setFrame:CGRectMake(lbX, self.lbNickName.y+self.lbNickName.height+kSize5, lbW, self.lbMinH)];
    
    CGFloat btnX = self.cellW-self.space-btnW;
    [self.btnInvitation setFrame:CGRectMake(btnX, self.cellH/2-btnH/2, btnW, btnH)];
    
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
}

-(void)btnInvitationClick
{
    if (self.onInvitationClick) {
        self.onInvitationClick(self.model, self);
    }
}
-(void)setIsInvitationtate
{
    if (self.model.isInvitation == 1) {
        [self.btnInvitation setBackgroundColor:RGBCOLOR(201, 201, 201)];
    } else {
        [self.btnInvitation setBackgroundColor:MAINCOLOR];
    }
}
-(CGFloat)setCellDataWithModel:(ModelUserInvitation *)model
{
    [self setModel:model];
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.head_img];
        [self.lbNickName setText:model.nickname];
        [self.lbSign setText:model.sign];
    }
    [self setIsInvitationtate];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_btnInvitation);
    OBJC_RELEASE(_imgPhoto);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 75;
}
+(CGFloat)getH
{
    return 75;
}

@end
