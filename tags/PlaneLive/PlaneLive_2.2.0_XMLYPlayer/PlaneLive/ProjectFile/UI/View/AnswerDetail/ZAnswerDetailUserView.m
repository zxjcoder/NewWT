//
//  ZAnswerDetailUserView.m
//  PlaneLive
//
//  Created by Daniel on 14/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailUserView.h"

@interface ZAnswerDetailUserView()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UILabel *lbSign;

@property (strong, nonatomic) UIButton *btnAgree;

@property (strong, nonatomic) UIImageView *imgLine;

@property (assign, nonatomic) CGFloat cellW;
@property (assign, nonatomic) CGFloat cellH;
@property (assign, nonatomic) CGFloat space;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@end

@implementation ZAnswerDetailUserView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.cellH = [ZAnswerDetailUserView getH];
    self.cellW = APP_FRAME_WIDTH;
    self.space = kSizeSpace;
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultImage];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTapGesture:)];
    [self.imgPhoto addGestureRecognizer:imgTapGesture];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbSign];
    
    self.btnAgree = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAgree setUserInteractionEnabled:YES];
    [self.btnAgree setBackgroundColor:TOPICBGCOLOR];
    [self.btnAgree setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
    [self.btnAgree setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnAgree setImage:[SkinManager getImageWithName:@"cricle_agree_btn_def"] forState:(UIControlStateNormal)];
    [self.btnAgree setTitle:kZero forState:(UIControlStateNormal)];
    [self.btnAgree setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [self.btnAgree setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [[self.btnAgree titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnAgree addTarget:self action:@selector(btnAgreeClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnAgree];
    
    self.imgLine = [UIImageView getSLineView];
    [self addSubview:self.imgLine];
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
    [self setChangeButtonImage];
    if (self.onAgreeClick) {
        self.onAgreeClick(self.modelAB);
    }
}
-(void)setChangeButtonImage
{
    if (self.modelAB.isAgree == 1) {
        [self.btnAgree setImage:[SkinManager getImageWithName:@"cricle_agree_btn_pre"] forState:(UIControlStateNormal)];
        [self.btnAgree setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    } else {
        [self.btnAgree setImage:[SkinManager getImageWithName:@"cricle_agree_btn_def"] forState:(UIControlStateNormal)];
        [self.btnAgree setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgS = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, kSize13, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat lbH = 20;
    CGFloat btnW = 60;
    CGFloat btnH = 28;
    CGFloat btnX = self.cellW-btnW-self.space;
    CGFloat lbX = self.imgPhoto.x+imgS+self.space;
    CGFloat lbW = btnX-lbX;
    [self.lbNickName setFrame:CGRectMake(lbX, kSize13, lbW, lbH)];
    
    [self.lbSign setFrame:CGRectMake(lbX, self.lbNickName.y+self.lbNickName.height+3, lbW, 18)];
    
    [self.btnAgree setFrame:CGRectMake(btnX, self.cellH/2-btnH/2, btnW, btnH)];
    
    [self.imgLine setFrame:CGRectMake(0, self.cellH-kLineHeight, self.cellW, kLineHeight)];
}

-(CGFloat)setCellDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.head_img];
        
        [self.lbNickName setText:model.nickname];
        
        [self.lbSign setText:model.sign];
        
        [self setButtonText];
        
        [self setChangeButtonImage];
    }
    return self.cellH;
}
-(void)setButtonText
{
    if (self.modelAB.agree > kNumberMaxCount) {
        [self.btnAgree setTitle:[NSString stringWithFormat:@"%d", kNumberMaxCount] forState:(UIControlStateNormal)];
    } else {
        [self.btnAgree setTitle:[NSString stringWithFormat:@"%ld", self.modelAB.agree] forState:(UIControlStateNormal)];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_btnAgree);
    OBJC_RELEASE(_imgPhoto);
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 70;
}

@end
