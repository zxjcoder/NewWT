//
//  ZAccountHeaderTVC.m
//  PlaneLive
//
//  Created by Daniel on 29/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountHeaderTVC.h"

@interface ZAccountHeaderTVC()

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@end

@implementation ZAccountHeaderTVC

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
    
    self.cellH = [ZAccountHeaderTVC getH];
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR2];
    
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, kSize10, self.cellW, self.cellH-20)];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    CGFloat imgS = 55;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(self.cellW/2-imgS/2, 25, imgS, imgS)];
    [self.imgPhoto setDefaultPhoto];
    [self.imgPhoto setViewRoundNoBorder];
    [self.viewContent addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imgPhoto.y+self.imgPhoto.height+10, self.viewContent.width, self.lbH)];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewContent addSubview:self.lbNickName];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.imgPhoto setPhotoURLStr:model.head_img];
    
    [self.lbNickName setText:model.nickname];
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_imgPhoto);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 150;
}

@end
