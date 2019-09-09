//
//  ZTopicListTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicListTVC.h"

@interface ZTopicListTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbTagName;

@property (strong, nonatomic) UIView *viewL;
///关注图片
@property (strong, nonatomic) UIImageView *imgAtt;

@property (strong, nonatomic) ModelTag *model;

@end

@implementation ZTopicListTVC

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
    
    [self setBackgroundColor:WHITECOLOR];
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultPhoto];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.imgAtt = [[UIImageView alloc] init];
    [self.imgAtt setImage:[SkinManager getImageWithName:@"icon_topic_chosen"]];
    [self.imgAtt setUserInteractionEnabled:NO];
    [self.imgAtt setHidden:YES];
    [self.viewMain addSubview:self.imgAtt];
    
    self.lbTagName = [[UILabel alloc] init];
    [self.lbTagName setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTagName setTextColor:BLACKCOLOR1];
    [self.lbTagName setNumberOfLines:1];
    [self.lbTagName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTagName];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewL];
    
    [self.viewMain sendSubviewToBack:self.imgPhoto];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgS = 45;
    [self.imgPhoto setFrame:CGRectMake(self.space, 8, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat lbX = self.imgPhoto.x+imgS+kSize12;
    CGFloat lbW = self.cellW-lbX-self.space;
    CGFloat lbY = (self.cellH-5)/2-self.lbH/2;
    [self.lbTagName setFrame:CGRectMake(lbX, lbY, lbW, self.lbH)];
    
    [self.imgAtt setFrame:CGRectMake(self.imgPhoto.x+self.imgPhoto.width-13, 10, 15, 15)];
    [self.imgAtt setViewRoundNoBorder];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(void)setCellDataWithModel:(ModelTag *)model
{
    [self setModel:model];
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.tagLogo];
        [self.lbTagName setText:model.tagName];
        
        [self.imgAtt setHidden:model.isCollection==0];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTagName);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_model);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 66;
}
+(CGFloat)getH
{
    return 66;
}

@end
