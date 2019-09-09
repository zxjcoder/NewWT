//
//  ZMyAttentionQuestionTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAttentionQuestionTVC.h"

@interface ZMyAttentionQuestionTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;
///回复数图标
@property (strong, nonatomic) UIImageView *imgCount;
///回复数
@property (strong, nonatomic) UILabel *lbCount;

///右边区域
@property (strong, nonatomic) UIView *viewRight;
///标题
@property (strong, nonatomic) UILabel *lbTitle;

///回答分割线
@property (strong, nonatomic) UIView *viewLineAnswer;

///回答内容区域
@property (strong, nonatomic) UIView *viewAnswer;
///回答
@property (strong, nonatomic) ZImageView *imgPhotoAnswer;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///个性签名
@property (strong, nonatomic) UILabel *lbSign;
///回答内容
@property (strong, nonatomic) ZRichStyleLabel *lbAnswerContent;

///实体对象
@property (strong, nonatomic) ModelAttentionQuestion *model;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZMyAttentionQuestionTVC

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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultPhoto];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    
    self.imgCount = [[UIImageView alloc] init];
    [self.imgCount setImage:[SkinManager getImageWithName:@"icon_answers"]];
    [self.viewMain addSubview:self.imgCount];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setTextColor:RGBCOLOR(190, 190, 190)];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbCount setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCount];
    
    self.viewRight = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewRight];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewRight addSubview:self.lbTitle];
    
    self.viewLineAnswer = [[UIView alloc] init];
    [self.viewLineAnswer setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewRight addSubview:self.viewLineAnswer];
    
    self.viewAnswer = [[UIView alloc] init];
    [self.viewAnswer setUserInteractionEnabled:YES];
    [self.viewRight addSubview:self.viewAnswer];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setUserInteractionEnabled:NO];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setTextColor:RGBCOLOR(182, 182, 182)];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setUserInteractionEnabled:NO];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbSign];
    
    self.imgPhotoAnswer = [[ZImageView alloc] init];
    [self.imgPhotoAnswer setDefaultImage];
    [self.imgPhotoAnswer setUserInteractionEnabled:NO];
    [self.viewAnswer addSubview:self.imgPhotoAnswer];
    
    self.lbAnswerContent = [[ZRichStyleLabel alloc] init];
    [self.lbAnswerContent setTextColor:BLACKCOLOR1];
    [self.lbAnswerContent setNumberOfLines:4];
    [self.lbAnswerContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbAnswerContent setUserInteractionEnabled:NO];
    [self.viewAnswer addSubview:self.lbAnswerContent];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewAnswer addGestureRecognizer:tapAnswerClick];
    
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
    
    [self.lbCount setFont:[ZFont systemFontOfSize:kSet_Font_Min_Size(self.fontSize)]];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
    [self.lbSign setFont:[ZFont systemFontOfSize:kSet_Font_Min_Size(self.fontSize)]];
    [self.lbAnswerContent setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
}
///设置坐标
-(void)setViewFrame
{
    [self setCellFontSize];
    
    self.cellW = APP_FRAME_WIDTH;
    //头像
    CGFloat imgSize = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
    //数量图标
    CGFloat countY = self.imgPhoto.y+imgSize+2;
    [self.imgCount setFrame:CGRectMake(self.imgPhoto.x+1, countY+6, 10, 10)];
    [self.lbCount setFrame:CGRectMake(self.imgCount.x+self.imgCount.width+3, countY, 30, self.lbMinH)];
    //右边区域
    CGFloat rightX = self.imgPhoto.x+imgSize;
    CGFloat rightW = self.cellW - rightX;
    CGRect rightFrame = CGRectMake(rightX, 0, rightW, 0);
    [self.viewRight setFrame:rightFrame];
    //标题
    CGRect titleFrame = CGRectMake(self.space, self.space, self.viewRight.width-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    if (self.lbTitle.text.length > 0) {
        CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
        CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
        if (titleH > maxH) {titleH=maxH;}
        titleFrame.size.height = titleH;
        [self.lbTitle setFrame:titleFrame];
    }
    [self.viewLineAnswer setFrame:CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+self.lineH+5, self.viewRight.width-self.space, self.lineH)];
    CGRect answerFrame = CGRectMake(0, self.viewLineAnswer.y+self.viewLineAnswer.height, self.viewRight.width, 0);
    //回答区域
    [self.viewAnswer setFrame:answerFrame];
    CGFloat timeY = 0;
    if ([self.model.aid intValue] == 0) {
        [self.lbNickName setHidden:YES];
        [self.lbSign setHidden:YES];
        [self.imgPhotoAnswer setHidden:YES];
        [self.lbAnswerContent setHidden:YES];
        timeY = 20;
    } else {
        [self.lbNickName setHidden:NO];
        [self.lbSign setHidden:NO];
        [self.imgPhotoAnswer setHidden:NO];
        [self.lbAnswerContent setHidden:NO];
        //昵称
        CGFloat nickNameW = [self.lbNickName getLabelWidthWithMinWidth:0];
        [self.lbNickName setFrame:CGRectMake(self.space, 6, nickNameW, self.lbH)];
        //个性签名
        CGFloat imgASize = 25;
        CGFloat signX = self.lbNickName.x+self.lbNickName.width+kSize8;
        CGFloat signW = self.viewAnswer.width-signX-imgASize-self.space-3;
        CGFloat signY = self.lbNickName.y+self.lbNickName.height-self.lbMinH;
        [self.lbSign setFrame:CGRectMake(signX, signY, signW, self.lbMinH)];
        //回答者头像
        [self.imgPhotoAnswer setFrame:CGRectMake(self.viewAnswer.width-self.space-imgASize, 6, imgASize, imgASize)];
        [self.imgPhotoAnswer setViewRound];
        //回答内容
        CGFloat lbW = self.viewAnswer.width-self.space*2;
        CGRect answerContentFrame = CGRectMake(self.space, self.imgPhotoAnswer.y+imgASize, lbW, 0);
        [self.lbAnswerContent setFrame:answerContentFrame];
        if (self.lbAnswerContent.text.length > 0) {
            CGFloat acH = [self.lbAnswerContent getLabelHeightWithMinHeight:self.lbMinH];
            CGFloat amaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswerContent];
            if (acH > amaxH) {acH = amaxH;}
            answerContentFrame.size.height = acH;
            answerContentFrame.origin.y = answerContentFrame.origin.y+5;
            
            [self.lbAnswerContent setFrame:answerContentFrame];
        }
        timeY = self.lbAnswerContent.y+self.lbAnswerContent.height+8;
    }
    answerFrame.size.height = timeY;
    [self.viewAnswer setFrame:answerFrame];
    CGFloat answerBottom = self.viewAnswer.y+self.viewAnswer.height;
    if (answerBottom > (self.imgCount.y+self.imgCount.height)) {
        rightFrame.size.height = self.viewAnswer.y+self.viewAnswer.height;
        [self.viewRight setFrame:rightFrame];
    } else {
        rightFrame.size.height = self.imgCount.y+self.imgCount.height+15;
        [self.viewRight setFrame:rightFrame];
    }
    //分割线
    [self.viewLine setFrame:CGRectMake(0, self.viewRight.y+self.viewRight.height, self.cellW, self.lineMaxH)];
    self.cellH = self.viewLine.y+self.viewLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)imgPhotoTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onImagePhotoClick) {
            self.onImagePhotoClick(self.model);
        }
    }
}

-(void)setCellDataWithModel:(ModelAttentionQuestion *)model
{
    [self setModel:model];
    
    [self setViewValue];
}

-(CGFloat)getHWithModel:(ModelAttentionQuestion *)model
{
    [self setModel:model];
    [self setViewValue];
    return self.cellH;
}

-(void)setViewValue
{
    if (self.model) {
        [self.imgPhoto setPhotoURLStr:self.model.head_imgQ];
        [self.imgPhotoAnswer setPhotoURLStr:self.model.head_imgA];
        [self.lbCount setText:self.model.count];
        [self.lbNickName setText:self.model.nicknameA];
        [self.lbSign setText:self.model.signA];
        [self.lbTitle setText:self.model.title];
        
        NSString *content = self.model.answerContent;
        [self.lbAnswerContent setText:content];
    }
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewRight);
    OBJC_RELEASE(_viewAnswer);
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbAnswerContent);
    OBJC_RELEASE(_imgCount);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_imgPhotoAnswer);
    OBJC_RELEASE(_model);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}

@end
