//
//  ZCircleDynamicItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleDynamicItemTVC.h"
#import "ZImageView.h"

@interface ZCircleDynamicItemTVC()

///头像
@property (strong, nonatomic) ZImageView *imgPhoto;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///昵称后面的描述
@property (strong, nonatomic) UILabel *lbNickNameDec;

///标题
@property (strong, nonatomic) UILabel *lbTitle;

///标题描述分割线
@property (strong, nonatomic) UIView *viewLineDesc;
///标题描述区域
@property (strong, nonatomic) UIView *viewDesc;
///标题描述
@property (strong, nonatomic) UILabel *lbDesc;

///实体对象
@property (strong, nonatomic) ModelCircleDynamic *model;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZCircleDynamicItemTVC

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
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultPhoto];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:MAINCOLOR];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbNickNameDec = [[UILabel alloc] init];
    [self.lbNickNameDec setTextColor:DESCCOLOR];
    [self.lbNickNameDec setNumberOfLines:1];
    [self.lbNickNameDec setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickNameDec];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewDesc = [[UIView alloc] init];
    [self.viewDesc setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewDesc];
    
    self.viewLineDesc = [[UIView alloc] init];
    [self.viewLineDesc setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewDesc addSubview:self.viewLineDesc];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setNumberOfLines:4];
    [self.lbDesc setUserInteractionEnabled:NO];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewDesc addSubview:self.lbDesc];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self.viewDesc addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)]];
    
    [self setCellFontSize];
}

-(void)tapAnswerClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAnswerClick) {
            self.onAnswerClick(self.model);
        }
    }
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbNickName setFont:[ZFont systemFontOfSize:kSet_Font_Min_Size(self.fontSize)]];
    [self.lbNickNameDec setFont:[ZFont systemFontOfSize:kSet_Font_Min_Size(self.fontSize)]];
    
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kSet_Font_Min_Size(self.fontSize)]];
}

///设置坐标
-(void)setViewFrame
{
    [self setCellFontSize];
    
    self.cellW = APP_FRAME_WIDTH;
    //头像
    CGFloat imgSize = 25;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
    
    //昵称
    CGFloat nickNameX = self.imgPhoto.x+imgSize+5;
    CGFloat nickNameY = self.imgPhoto.y+imgSize/2-self.lbH/2;
    CGFloat nickNameW = [self.lbNickName getLabelWidthWithMinWidth:0];
    [self.lbNickName setFrame:CGRectMake(nickNameX, nickNameY, nickNameW, self.lbH)];
    
    //昵称后的说明
    CGFloat signX = self.lbNickName.x+self.lbNickName.width+kSize8;
    CGFloat signW = self.cellW-nickNameX-nickNameW;
    CGFloat signY = self.lbNickName.y+self.lbNickName.height-self.lbMinH;
    [self.lbNickNameDec setFrame:CGRectMake(signX, signY, signW, self.lbMinH)];
    
    //标题
    CGFloat titleY = self.imgPhoto.y+imgSize+kSize8;
    CGRect titleFrame = CGRectMake(self.space, titleY, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {titleH = maxH;}
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    //内容
    CGFloat lbW = self.cellW-self.space*2;
    CGRect answerContentFrame = CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+kSize8, lbW, 0);
    [self.viewDesc setFrame:answerContentFrame];
    
    if (self.model.wid.intValue > 0 && self.model.content.length > 0) {
        [self.viewLineDesc setHidden:NO];
        [self.viewDesc setHidden:NO];
        [self.lbDesc setHidden:NO];
        
        [self.lbDesc setFrame:CGRectMake(0, kSize8, lbW, self.lbMinH)];
        CGFloat acH = [self.lbDesc getLabelHeightWithMinHeight:self.lbMinH];
        CGFloat amaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbDesc];
        if (acH > amaxH) {acH = amaxH;}
        [self.lbDesc setFrame:CGRectMake(self.lbDesc.x, self.lbDesc.y, self.lbDesc.width, acH)];
        
        answerContentFrame.size.height = self.lbDesc.y+self.lbDesc.height+18;
        //问题分割线
        [self.viewLineDesc setFrame:CGRectMake(0, 0, self.cellW, self.lineH)];
    } else {
        [self.viewLineDesc setHidden:YES];
        [self.viewDesc setHidden:YES];
        [self.lbDesc setHidden:YES];
        
        [self.lbDesc setFrame:CGRectMake(0, 0, lbW, 0)];
        
        answerContentFrame.size.height = kSize14;
    }
    [self.viewDesc setFrame:answerContentFrame];
    
    [self.viewLine setFrame:CGRectMake(0, self.viewDesc.y+self.viewDesc.height, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelCircleDynamic *)model
{
    [self setModel:model];
    if (model) {
        [self.lbTitle setText:model.title];
        
        NSString *content = self.model.content.imgReplacing;
        if (content) {
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
            content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
        }
        
        [self.lbDesc setText:content];
        
        [self.lbNickName setText:model.nickname];
        [self.lbNickNameDec setText:model.flag];
        [self.imgPhoto setPhotoURLStr:model.head_img];
    }
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewDesc);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewDesc);
    OBJC_RELEASE(_viewLineDesc);
    OBJC_RELEASE(_lbNickNameDec);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getHWithModel:(ModelCircleDynamic *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(CGFloat)getH
{
    return self.cellH;
}

@end
