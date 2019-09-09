//
//  ZAnswerDetailUserTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailUserTVC.h"

@interface ZAnswerDetailUserTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UILabel *lbSign;

@property (strong, nonatomic) UIButton *btnAgree;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@end

@implementation ZAnswerDetailUserTVC

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
    [self.imgPhoto setDefaultImage];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTapGesture:)];
    [self.imgPhoto addGestureRecognizer:imgTapGesture];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSign];
    
    self.btnAgree = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAgree setUserInteractionEnabled:YES];
    [self.btnAgree setTitle:@"同意 0" forState:(UIControlStateNormal)];
    [self.btnAgree setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnAgree setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnAgree titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnAgree addTarget:self action:@selector(btnAgreeClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAgree];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)imgPhotoTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onImagePhotoClick) {
            self.onImagePhotoClick(self.modelAB);
        }
    }
}

-(void)btnAgreeClick
{
    if (self.modelAB.isAgree == 1) {
        [self.btnAgree setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
        [self.btnAgree setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    } else {
        [self.btnAgree setTitleColor:RGBCOLOR(138, 138, 138) forState:(UIControlStateNormal)];
        [self.btnAgree setViewRound:4 borderWidth:1 borderColor:RGBCOLOR(138, 138, 138)];
    }
    if (self.onAgreeClick) {
        self.onAgreeClick(self.modelAB);
    }
}

-(void)setButtonText
{
    if (self.modelAB.agree > 999) {
        [self.btnAgree setTitle:[NSString stringWithFormat:@"同意 %d", 999] forState:(UIControlStateNormal)];
    } else {
        [self.btnAgree setTitle:[NSString stringWithFormat:@"同意 %ld", self.modelAB.agree] forState:(UIControlStateNormal)];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgS = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, kSize13, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat btnW = 60;
    CGFloat btnH = 28;
    CGFloat btnX = self.cellW-btnW-self.space;
    CGFloat lbX = self.imgPhoto.x+imgS+self.space;
    CGFloat lbW = btnX-lbX;
    [self.lbNickName setFrame:CGRectMake(lbX, kSize13, lbW, self.lbH)];
    
    [self.lbSign setFrame:CGRectMake(lbX, self.lbNickName.y+self.lbNickName.height+3, lbW, self.lbMinH)];
    
    [self.btnAgree setFrame:CGRectMake(btnX, self.cellH/2-btnH/2, btnW, btnH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(void)setCellDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.head_img];
        
        [self.lbNickName setText:model.nickname];
        
        [self.lbSign setText:model.sign];
        
        [self setButtonText];
        
        if (self.modelAB.isAgree == 1) {
            [self.btnAgree setTitleColor:RGBCOLOR(138, 138, 138) forState:(UIControlStateNormal)];
            [self.btnAgree setViewRound:4 borderWidth:1 borderColor:RGBCOLOR(138, 138, 138)];
        } else {
            [self.btnAgree setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
            [self.btnAgree setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
        }
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_imgPhoto);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 70;
}
+(CGFloat)getH
{
    return 70;
}

@end
