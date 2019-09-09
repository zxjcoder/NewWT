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

///回答分割线
@property (strong, nonatomic) UIView *viewLineAnswer;
///标题
@property (strong, nonatomic) UILabel *lbTitle;

///回答区域
@property (strong, nonatomic) UIView *viewAnswer;
///回答
@property (strong, nonatomic) UILabel *lbAnswer;

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
    [self.lbNickName setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbNickNameDec = [[UILabel alloc] init];
    [self.lbNickNameDec setTextColor:RGBCOLOR(170, 170, 170)];
    [self.lbNickNameDec setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbNickNameDec setNumberOfLines:1];
    [self.lbNickNameDec setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickNameDec];
    
    self.viewLineAnswer = [[UIView alloc] init];
    [self.viewLineAnswer setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLineAnswer];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewAnswer = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewAnswer];
    
    self.lbAnswer = [[UILabel alloc] init];
    [self.lbAnswer setTextColor:BLACKCOLOR2];
    [self.lbAnswer setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbAnswer setNumberOfLines:4];
    [self.lbAnswer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbAnswer];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];

    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewAnswer addGestureRecognizer:tapAnswerClick];
}

-(void)tapAnswerClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAnswerClick) {
            self.onAnswerClick(self.model);
        }
    }
}

///设置坐标
-(void)setViewFrame
{
    self.cellW = APP_FRAME_WIDTH;
    //头像
    CGFloat imgSize = 30;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
    
    //昵称
    CGFloat nickNameX = self.imgPhoto.x+imgSize+5;
    CGFloat nickNameY = self.imgPhoto.y+imgSize/2-self.lbH/2;
    CGFloat nickNameW = [self.lbNickName getLabelWidthWithMinWidth:0];
    [self.lbNickName setFrame:CGRectMake(nickNameX, nickNameY, nickNameW, self.lbH)];
    
    //昵称后的说明
    CGFloat signX = self.lbNickName.x+self.lbNickName.width;
    CGFloat signW = self.cellW-nickNameX-nickNameW;
    [self.lbNickNameDec setFrame:CGRectMake(signX, nickNameY+1, signW, self.lbMinH)];
    
    //标题
    CGFloat titleY = self.imgPhoto.y+imgSize+8;
    CGRect titleFrame = CGRectMake(self.space, titleY, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (titleH > self.lbH) {titleH=40;}
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    //问题分割线
    [self.viewLineAnswer setFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+6+self.lineH, self.cellW, self.lineH)];
    
    //内容
    CGFloat lbW = self.cellW-self.space*2;
    CGRect answerContentFrame = CGRectMake(self.space, self.viewLineAnswer.y+self.viewLineAnswer.height, lbW, 0);
    [self.viewAnswer setFrame:answerContentFrame];
    if ([self.model.wid integerValue] > 0) {
        [self.viewLineAnswer setHidden:NO];
        [self.viewAnswer setHidden:NO];
        [self.lbAnswer setHidden:NO];
        
        [self.lbAnswer setFrame:CGRectMake(0, self.space, lbW, self.lbMinH)];
        CGFloat acH = [self.lbAnswer getLabelHeightWithMinHeight:self.lbMinH];
        if (acH > 70) {acH = 70;}
        [self.lbAnswer setFrame:CGRectMake(0, self.space, lbW, acH)];
    } else {
        [self.viewLineAnswer setHidden:YES];
        [self.viewAnswer setHidden:YES];
        [self.lbAnswer setHidden:YES];
        [self.lbAnswer setFrame:CGRectMake(0, 0, lbW, 0)];
    }
    answerContentFrame.size.height = self.lbAnswer.y+self.lbAnswer.height+self.space;
    [self.viewAnswer setFrame:answerContentFrame];
    
    [self.viewLine setFrame:CGRectMake(0, self.viewAnswer.y+self.viewAnswer.height, self.cellW, self.lineMaxH)];
    
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
//        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:content];
//        [strAttributed addAttribute:NSFontAttributeName value:self.lbAnswer.font range:NSMakeRange(0, strAttributed.length)];
//        [strAttributed addAttribute:NSForegroundColorAttributeName value:self.lbAnswer.textColor range:NSMakeRange(0, strAttributed.length)];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 5;
//        [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
        
        [self.lbAnswer setText:content];
        
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
    OBJC_RELEASE(_viewAnswer);
    OBJC_RELEASE(_lbAnswer);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewAnswer);
    OBJC_RELEASE(_viewLineAnswer);
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
