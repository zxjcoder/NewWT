//
//  ZCircleSearchUserTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchUserTVC.h"

@interface ZCircleSearchUserTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UILabel *lbSign;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelUserBase *model;

@property (strong, nonatomic) NSString *keyword;

@end

@implementation ZCircleSearchUserTVC

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
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultPhoto];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSign];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
 
    CGFloat imgS = 50;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space+2, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat lbX = self.imgPhoto.x+imgS+self.space;
    CGFloat lbW = self.cellW-lbX-self.space;
    [self.lbNickName setFrame:CGRectMake(lbX, self.space+3, lbW, self.lbH)];
    
    [self.lbSign setFrame:CGRectMake(lbX, self.cellH/2+3, lbW, self.lbMinH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}
-(void)setCellKeyword:(NSString *)keyword
{
    [self setKeyword:keyword];
}
-(void)setCellDataWithModel:(ModelUserBase *)model
{
    [super setCellDataWithModel:model];
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.head_img];
        [self.lbNickName setText:model.nickname];
        [self.lbNickName setTextColor:BLACKCOLOR1];
        if (self.keyword.length > 0) {
            NSRange range = [self.lbNickName.text rangeOfString:self.keyword.toTrim];
            if (range.location != NSNotFound) {
                [self.lbNickName setLabelColorWithRange:range color:MAINCOLOR];
            } else {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbNickName.text];
                self.lbNickName.attributedText = str;
            }
        }
        [self.lbSign setText:model.sign];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_keyword);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_viewL);
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
