//
//  ZCircleNewItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleNewItemTVC.h"

@interface ZCircleNewItemTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;
///回复数图标
@property (strong, nonatomic) UIImageView *imgCount;
///回复数
@property (strong, nonatomic) UILabel *lbCount;

@property (strong, nonatomic) UIView *viewRight;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///时间图标
@property (strong, nonatomic) UIImageView *imgTime;
///时间
@property (strong, nonatomic) UILabel *lbTime;

///回答分割线
@property (strong, nonatomic) UIView *viewAnswerLine;

///回答内容区域
@property (strong, nonatomic) UIView *viewAnswer;
///回答
@property (strong, nonatomic) ZImageView *imgPhotoAnswer;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///个性签名
@property (strong, nonatomic) UILabel *lbSign;
///回答内容
@property (strong, nonatomic) UILabel *lbAnswerContent;

///实体对象
@property (strong, nonatomic) ModelCircleNew *model;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZCircleNewItemTVC

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
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    
    self.imgCount = [[UIImageView alloc] init];
    [self.imgCount setImage:[SkinManager getImageWithName:@"icon_answers"]];
    [self.viewMain addSubview:self.imgCount];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setTextColor:RGBCOLOR(190, 190, 190)];
    [self.lbCount setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbCount setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCount];
    
    self.viewRight = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewRight];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewRight addSubview:self.lbTitle];
    
    self.viewAnswer = [[UIView alloc] init];
    [self.viewRight addSubview:self.viewAnswer];
    
    self.viewAnswerLine = [[UIView alloc] init];
    [self.viewAnswerLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewAnswer addSubview:self.viewAnswerLine];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR2];
    [self.lbNickName setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setTextColor:RGBCOLOR(182, 182, 182)];
    [self.lbSign setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbSign];
    
    self.imgPhotoAnswer = [[ZImageView alloc] init];
    [self.imgPhotoAnswer setDefaultImage];
    [self.viewAnswer addSubview:self.imgPhotoAnswer];
    
    self.lbAnswerContent = [[UILabel alloc] init];
    [self.lbAnswerContent setTextColor:BLACKCOLOR2];
    [self.lbAnswerContent setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbAnswerContent setNumberOfLines:4];
    [self.lbAnswerContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbAnswerContent];
    
    self.lbTime = [[UILabel alloc] init];
    [self.lbTime setTextColor:RGBCOLOR(190, 190, 190)];
    [self.lbTime setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbTime];
    
    self.imgTime = [[ZImageView alloc] init];
    [self.imgTime setImage:[SkinManager getImageWithName:@"icon_time"]];
    [self.viewAnswer addSubview:self.imgTime];
    
    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewAnswer addGestureRecognizer:tapAnswerClick];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)tapAnswerClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAnswerClick) {
            self.onAnswerClick(self.model);
        }
    }
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//}

///设置坐标
-(void)setViewFrame
{
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
        if (titleH > self.lbH) {titleH=40;}
        titleFrame.size.height = titleH;
        [self.lbTitle setFrame:titleFrame];
    }
    CGRect answerFrame = CGRectMake(0, self.lbTitle.y+self.lbTitle.height+8, self.viewRight.width, 0);
    //回答区域
    [self.viewAnswer setFrame:answerFrame];
    CGFloat timeY = 0;
    
    if ([self.model.aid intValue] == 0) {
        [self.viewAnswer setUserInteractionEnabled:NO];
        [self.viewAnswerLine setHidden:YES];
        [self.lbNickName setHidden:YES];
        [self.lbSign setHidden:YES];
        [self.imgPhotoAnswer setHidden:YES];
        [self.lbAnswerContent setHidden:YES];
        timeY = 20;
    } else {
        [self.viewAnswer setUserInteractionEnabled:YES];
        [self.viewAnswerLine setHidden:NO];
        [self.lbNickName setHidden:NO];
        [self.lbSign setHidden:NO];
        [self.imgPhotoAnswer setHidden:NO];
        [self.lbAnswerContent setHidden:NO];
        //昵称
        CGFloat nickNameW = [self.lbNickName getLabelWidthWithMinWidth:0];
        [self.lbNickName setFrame:CGRectMake(self.space, 6, nickNameW, self.lbH)];
        //个性签名
        CGFloat imgASize = 25;
        CGFloat signX = self.lbNickName.x+self.lbNickName.width+self.space;
        CGFloat signW = self.viewAnswer.width-signX-imgASize-self.space-3;
        [self.lbSign setFrame:CGRectMake(signX, 10, signW, self.lbMinH)];
        //回答者头像
        [self.imgPhotoAnswer setFrame:CGRectMake(self.viewAnswer.width-self.space-imgASize, 5, imgASize, imgASize)];
        [self.imgPhotoAnswer setViewRound];
        //回答内容
        CGFloat lbW = self.viewAnswer.width-self.space*2;
        CGRect answerContentFrame = CGRectMake(self.space, self.imgPhotoAnswer.y+self.imgPhotoAnswer.height, lbW, 0);
        [self.lbAnswerContent setFrame:answerContentFrame];
        if (self.lbAnswerContent.text.length > 0) {
            CGFloat acH = [self.lbAnswerContent getLabelHeightWithMinHeight:self.lbMinH];
            if (acH > 70) {acH = 70;}
            answerContentFrame.size.height = acH;
            answerContentFrame.origin.y = answerContentFrame.origin.y+5;
            [self.lbAnswerContent setFrame:answerContentFrame];
        }
        timeY = self.lbAnswerContent.y+self.lbAnswerContent.height+8;
    }
    //时间
    CGRect timeLbFrame = CGRectMake(answerFrame.size.width-self.space, timeY, 0, self.lbH);
    [self.lbTime setFrame:timeLbFrame];
    if (self.lbTime.text.length > 0) {
        CGFloat timeLbW = [self.lbTime getLabelWidthWithMinWidth:0];
        timeLbFrame.size.width = timeLbW;
        timeLbFrame.origin.x = timeLbFrame.origin.x-timeLbW;
        [self.lbTime setFrame:timeLbFrame];
    }
    CGFloat timeS = 10;
    CGFloat timeX = self.lbTime.x-timeS-2.5;
    CGRect timeImgFrame = CGRectMake(timeX, self.lbTime.y+self.lbTime.height/2-timeS/2, timeS, timeS);
    [self.imgTime setFrame:timeImgFrame];
    
    answerFrame.size.height = self.lbTime.y+self.lbTime.height+3;
    [self.viewAnswer setFrame:answerFrame];
    
    [self.viewAnswerLine setFrame:CGRectMake(self.space, 0, self.viewAnswer.width, self.lineH)];
    
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

-(void)setCellDataWithModel:(ModelCircleNew *)model
{
    [self setModel:model];
    
    [self setViewValue];
}

-(CGFloat)getHWithModel:(ModelCircleNew *)model
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
        [self.lbTime setText:self.model.time];
        [self.lbNickName setText:self.model.nicknameA];
        [self.lbSign setText:self.model.signA];
        [self.lbTitle setText:self.model.title];
        
        NSString *content = self.model.answerContent.imgReplacing;
        if (content) {
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
            content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
        }
//        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:content];
//        [strAttributed addAttribute:NSFontAttributeName value:self.lbAnswerContent.font range:NSMakeRange(0, strAttributed.length)];
//        [strAttributed addAttribute:NSForegroundColorAttributeName value:self.lbAnswerContent.textColor range:NSMakeRange(0, strAttributed.length)];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 5;
//        [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
//        
//        [self.lbAnswerContent setAttributedText:strAttributed];
        
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
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbAnswerContent);
    OBJC_RELEASE(_imgTime);
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
