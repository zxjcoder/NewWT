//
//  ZUserHeaderTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserHeaderTVC.h"

@interface ZUserHeaderTVC()

///头像
@property (strong ,nonatomic) ZImageView *imgPhoto;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///个性签名
@property (strong, nonatomic) UILabel *lbSign;

@property (strong, nonatomic) UIView *viewL;

@end

@implementation ZUserHeaderTVC

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
    [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    self.imgPhoto = [[ZImageView alloc] initWithImage:[SkinManager getDefaultPhoto]];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbSign setNumberOfLines:2];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSign];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat topY = 15;
    CGFloat imgS = 60;
    [self.imgPhoto setFrame:CGRectMake(self.space, topY, imgS, imgS)];
    [self.imgPhoto setViewRound];
    CGFloat lbX = self.imgPhoto.x+imgS+self.space+2;
    CGFloat lbW = self.cellW - lbX - self.arrowW;
    [self.lbNickName setFrame:CGRectMake(lbX, topY+5, lbW, self.lbH)];
    CGFloat signY = topY + imgS/2;
    CGFloat signH = [self.lbSign getLabelHeightWithMinHeight:self.lbMinH];
    if (signH > self.lbMinH) {signH = 40;}
    [self.lbSign setFrame:CGRectMake(lbX, signY, lbW, signH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithModel:(ModelEntity *)model
{
    [super setCellDataWithModel:model];
    if (model) {
        [self.lbNickName setText:[(ModelUser*)model nickname]];
        [self.imgPhoto setPhotoURLStr:[(ModelUser*)model head_img]];
        [self.lbSign setText:[(ModelUser*)model sign]];
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_viewL);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 95;
}
+(CGFloat)getH
{
    return 95;
}

@end
