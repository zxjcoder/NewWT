//
//  ZUserAnswerTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserAnswerTVC.h"

@interface ZUserAnswerTVC()

///答案被同意区域
@property (strong, nonatomic) UIView *viewAgree;
///答案被同意图片
@property (strong, nonatomic) UIImageView *imgAgree;
///答案被同意标题
@property (strong, nonatomic) UILabel *lbAgreeTitle;
///答案被同意数量
@property (strong, nonatomic) UILabel *lbAgreeCount;

///答案被分享区域
@property (strong, nonatomic) UIView *viewShare;
///答案被分享图片
@property (strong, nonatomic) UIImageView *imgShare;
///答案被分享图片
@property (strong, nonatomic) UILabel *lbShareTitle;
///答案被分享数量
@property (strong, nonatomic) UILabel *lbShareCount;

///答案被收藏区域
@property (strong, nonatomic) UIView *viewCollection;
///答案被收藏图片
@property (strong, nonatomic) UIImageView *imgCollection;
///答案被收藏标题
@property (strong, nonatomic) UILabel *lbCollectionTitle;
///答案被收藏数量
@property (strong, nonatomic) UILabel *lbCollectionCount;

@end

@implementation ZUserAnswerTVC

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
    
    self.viewAgree = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewAgree];
    
    self.imgAgree = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"my_icon_agree_number"]];
    [self.viewAgree addSubview:self.imgAgree];
    
    self.lbAgreeTitle = [[UILabel alloc] init];
    [self.lbAgreeTitle setText:@"答案被同意"];
    [self.lbAgreeTitle setTextColor:DESCCOLOR];
    [self.lbAgreeTitle setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewAgree addSubview:self.lbAgreeTitle];
    
    self.lbAgreeCount = [[UILabel alloc] init];
    [self.lbAgreeCount setText:@"0"];
    [self.lbAgreeCount setTextColor:BLACKCOLOR1];
    [self.lbAgreeCount setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewAgree addSubview:self.lbAgreeCount];
    
    self.viewShare = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewShare];
    
    self.imgShare = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"my_icon_sharenumber"]];
    [self.viewShare addSubview:self.imgShare];
    
    self.lbShareTitle = [[UILabel alloc] init];
    [self.lbShareTitle setText:@"答案被分享"];
    [self.lbShareTitle setTextColor:DESCCOLOR];
    [self.lbShareTitle setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewShare addSubview:self.lbShareTitle];
    
    self.lbShareCount = [[UILabel alloc] init];
    [self.lbShareCount setText:@"0"];
    [self.lbShareCount setTextColor:BLACKCOLOR1];
    [self.lbShareCount setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewShare addSubview:self.lbShareCount];
    
    self.viewCollection = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewCollection];
    
    self.imgCollection = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"my_icon_collectionnumber"]];
    [self.viewCollection addSubview:self.imgCollection];
    
    self.lbCollectionTitle = [[UILabel alloc] init];
    [self.lbCollectionTitle setText:@"答案被收藏"];
    [self.lbCollectionTitle setTextColor:DESCCOLOR];
    [self.lbCollectionTitle setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewCollection addSubview:self.lbCollectionTitle];
    
    self.lbCollectionCount = [[UILabel alloc] init];
    [self.lbCollectionCount setText:@"0"];
    [self.lbCollectionCount setTextColor:BLACKCOLOR1];
    [self.lbCollectionCount setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewCollection addSubview:self.lbCollectionCount];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemW = self.cellW/3;
    [self.viewAgree setFrame:CGRectMake(0, 0, itemW, self.cellH)];
    [self.viewShare setFrame:CGRectMake(itemW, 0, itemW, self.cellH)];
    [self.viewCollection setFrame:CGRectMake(itemW*2, 0, itemW, self.cellH)];
    
    CGFloat imgS = 18;
    CGFloat imgY = 13;
    CGFloat imgX = self.space;
    [self.imgAgree setFrame:CGRectMake(imgX, imgY, imgS, imgS)];
    [self.imgShare setFrame:CGRectMake(imgX, imgY, imgS, imgS)];
    [self.imgCollection setFrame:CGRectMake(imgX, imgY, imgS, imgS)];
    
    CGFloat lbX = imgX+imgS+5;
    CGFloat titleY = 10;
    CGFloat titleH = 18;
    CGFloat lbW = itemW-lbX;
    [self.lbAgreeTitle setFrame:CGRectMake(lbX, titleY, lbW, titleH)];
    [self.lbShareTitle setFrame:CGRectMake(lbX, titleY, lbW, titleH)];
    [self.lbCollectionTitle setFrame:CGRectMake(lbX, titleY, lbW, titleH)];
    
    CGFloat countH = 20;
    CGFloat countY = titleY+titleH;
    [self.lbAgreeCount setFrame:CGRectMake(lbX, countY, lbW, countH)];
    [self.lbShareCount setFrame:CGRectMake(lbX, countY, lbW, countH)];
    [self.lbCollectionCount setFrame:CGRectMake(lbX, countY, lbW, countH)];
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    [super setCellDataWithModel:model];
    
    if (model) {
        [self.lbAgreeCount setText:[NSString stringWithFormat:@"%d",model.myAnswerAgreeCount]];
        [self.lbShareCount setText:[NSString stringWithFormat:@"%d",model.myAnswerShareCount]];
        [self.lbCollectionCount setText:[NSString stringWithFormat:@"%d",model.myAnswerCollectCount]];
    }
    [self setNeedsDisplay];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbAgreeCount);
    OBJC_RELEASE(_lbAgreeTitle);
    OBJC_RELEASE(_lbShareCount);
    OBJC_RELEASE(_lbShareTitle);
    OBJC_RELEASE(_lbCollectionCount);
    OBJC_RELEASE(_lbCollectionTitle);
    
    OBJC_RELEASE(_imgAgree);
    OBJC_RELEASE(_imgShare);
    OBJC_RELEASE(_imgCollection);
    
    OBJC_RELEASE(_viewAgree);
    OBJC_RELEASE(_viewShare);
    OBJC_RELEASE(_viewCollection);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 55;
}
+(CGFloat)getH
{
    return 55;
}

@end
