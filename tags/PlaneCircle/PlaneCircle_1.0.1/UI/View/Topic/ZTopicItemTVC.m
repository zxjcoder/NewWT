//
//  ZTopicItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicItemTVC.h"

@interface ZTopicItemTVC()

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///标题分割线
@property (strong, nonatomic) UIView *viewTitleLine;

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

@implementation ZTopicItemTVC

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
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewTitleLine = [[UIView alloc] init];
    [self.viewTitleLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewTitleLine];
    
    self.viewAnswer = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewAnswer];
    
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
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
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
    
    //右边区域
    //标题
    CGRect titleFrame = CGRectMake(self.space, 8, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    if (self.lbTitle.text.length > 0) {
        CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
        if (titleH > self.lbH) {titleH=40;}
        titleFrame.size.height = titleH;
        [self.lbTitle setFrame:titleFrame];
    }
    [self.viewTitleLine setFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+5, self.cellW, self.lineH)];
    
    CGRect answerFrame = CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.viewTitleLine.width, 0);
    //回答区域
    [self.viewAnswer setFrame:answerFrame];
    CGFloat timeY = 0;
    if ([self.model.aid intValue] == 0) {
        [self.lbNickName setHidden:YES];
        [self.lbSign setHidden:YES];
        [self.imgPhotoAnswer setHidden:YES];
        [self.lbAnswerContent setHidden:YES];
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
        CGFloat signX = self.lbNickName.x+self.lbNickName.width+self.space;
        CGFloat signW = self.viewAnswer.width-signX-imgASize-self.space-3;
        [self.lbSign setFrame:CGRectMake(signX, 10, signW, self.lbMinH)];
        //回答者头像
        [self.imgPhotoAnswer setFrame:CGRectMake(self.viewAnswer.width-self.space-imgASize, 5, imgASize, imgASize)];
        [self.imgPhotoAnswer setViewRound];
        //回答内容
        CGFloat lbW = self.viewAnswer.width-self.space*2;
        CGRect answerContentFrame = CGRectMake(self.space, self.imgPhotoAnswer.y+self.imgPhotoAnswer.height+2, lbW, 0);
        [self.lbAnswerContent setFrame:answerContentFrame];
        if (self.lbAnswerContent.text.length > 0) {
            CGFloat acH = [self.lbAnswerContent getLabelHeightWithMinHeight:self.lbMinH];
            if (acH > 70) {acH = 70;}
            answerContentFrame.size.height = acH;
            [self.lbAnswerContent setFrame:answerContentFrame];
        }
        timeY = self.lbAnswerContent.y+self.lbAnswerContent.height+8;
    }
    answerFrame.size.height = timeY;
    [self.viewAnswer setFrame:answerFrame];
    //分割线
    [self.viewLine setFrame:CGRectMake(0, self.viewAnswer.y+self.viewAnswer.height, self.cellW, self.lineMaxH)];
    self.cellH = self.viewLine.y+self.viewLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
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
        [self.imgPhotoAnswer setPhotoURLStr:self.model.head_imgA];
        [self.lbNickName setText:self.model.nicknameA];
        [self.lbSign setText:self.model.signA];
        [self.lbTitle setText:self.model.title];
        
        NSString *content = self.model.answerContent.imgReplacing;
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:content];
        
        [strAttributed addAttribute:NSFontAttributeName value:self.lbAnswerContent.font range:NSMakeRange(0, strAttributed.length)];
        [strAttributed addAttribute:NSForegroundColorAttributeName value:self.lbAnswerContent.textColor range:NSMakeRange(0, strAttributed.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
        
        [self.lbAnswerContent setAttributedText:strAttributed];
    }
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewAnswer);
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbAnswerContent);
    OBJC_RELEASE(_imgPhotoAnswer);
    
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
