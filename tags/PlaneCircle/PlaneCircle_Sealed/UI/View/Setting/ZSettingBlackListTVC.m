//
//  ZSettingBlackListTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSettingBlackListTVC.h"

@interface ZSettingBlackListTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelUserBase *modelUser;

@end

@implementation ZSettingBlackListTVC

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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.imgPhoto = [[ZImageView alloc] initWithImage:[SkinManager getDefaultPhoto]];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbNickName];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, kSize10, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
    
    CGFloat lbX = self.imgPhoto.x+self.imgPhoto.width+self.space;
    CGFloat lbW = self.cellW-lbX-self.space;
    [self.lbNickName setFrame:CGRectMake(lbX, self.cellH/2-self.lbH/2, lbW, self.lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithModel:(ModelUserBase *)model
{
    [self setModelUser:model];
    
    [self.imgPhoto setPhotoURLStr:model.head_img];
    [self.lbNickName setText:model.nickname];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_modelUser);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 60;
}
+(CGFloat)getH
{
    return 60;
}

@end
