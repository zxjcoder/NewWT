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
@property (strong, nonatomic) UIView *viewContent;
///回答
@property (strong, nonatomic) ZImageView *imgPhoto;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///个性签名
@property (strong, nonatomic) UILabel *lbSign;
///回答内容
@property (strong, nonatomic) UILabel *lbAnswerContent;

///实体对象
@property (strong, nonatomic) ModelQuestionTopic *model;
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
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewTitleLine = [[UIView alloc] init];
    [self.viewTitleLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewTitleLine];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewContent];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setUserInteractionEnabled:NO];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbSign setUserInteractionEnabled:NO];
    [self.viewContent addSubview:self.lbSign];
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultImage];
    [self.imgPhoto setUserInteractionEnabled:NO];
    [self.viewContent addSubview:self.imgPhoto];
    
    self.lbAnswerContent = [[UILabel alloc] init];
    [self.lbAnswerContent setTextColor:BLACKCOLOR1];
    [self.lbAnswerContent setNumberOfLines:4];
    [self.lbAnswerContent setUserInteractionEnabled:NO];
    [self.lbAnswerContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbAnswerContent];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewContent addGestureRecognizer:tapAnswerClick];
    
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
    
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
    [self.lbAnswerContent setFont:[UIFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
    
    [self.lbSign setFont:[UIFont systemFontOfSize:kSet_Font_Min_Size(self.fontSize)]];
    [self.lbNickName setFont:[UIFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
}

///设置坐标
-(void)setViewFrame
{
    [self setCellFontSize];
    
    self.cellW = APP_FRAME_WIDTH;
    
    //标题
    CGRect titleFrame = CGRectMake(self.space, kSize11, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {titleH = maxH;}
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    //标题分割线
    [self.viewTitleLine setFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+kSize8, self.cellW, self.lineH)];
    
    ///没有回答的情况
    if ([self.model.aid intValue] == 0) {
        [self.viewContent setHidden:YES];
        [self.viewContent setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, 0)];
        [self.lbNickName setHidden:YES];
        [self.lbSign setHidden:YES];
        [self.imgPhoto setHidden:YES];
        [self.lbAnswerContent setHidden:YES];
        
        [self.viewLine setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lineMaxH)];
    } else {
        [self.viewContent setHidden:NO];
        [self.lbNickName setHidden:NO];
        [self.lbSign setHidden:NO];
        [self.imgPhoto setHidden:NO];
        [self.lbAnswerContent setHidden:NO];
        
        [self.viewContent setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lbH)];
        //昵称
        CGFloat nickNameW = [self.lbNickName getLabelWidthWithMinWidth:0];
        [self.lbNickName setFrame:CGRectMake(self.space, kSize11, nickNameW, self.lbH)];
        //个性签名
        CGFloat imgSize = 20;
        CGFloat signX = self.lbNickName.x+self.lbNickName.width+kSize13;
        CGFloat signW = self.viewContent.width-signX-imgSize-kSize13-kSize5;
        [self.lbSign setFrame:CGRectMake(signX, kSize15, signW, self.lbMinH)];
        //头像
        [self.imgPhoto setFrame:CGRectMake(self.viewContent.width-self.space-imgSize, kSize11, imgSize, imgSize)];
        [self.imgPhoto setViewRound];
        //回答内容
        CGFloat lbW = self.viewContent.width-self.space*2;
        CGRect answerContentFrame = CGRectMake(self.space, self.imgPhoto.y+self.imgPhoto.height, lbW, 0);
        [self.lbAnswerContent setFrame:answerContentFrame];
        if (self.lbAnswerContent.text.length > 0) {
            CGFloat acH = [self.lbAnswerContent getLabelHeightWithMinHeight:self.lbMinH];
            CGFloat amaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswerContent];
            if (acH > amaxH) {acH = amaxH;}
            answerContentFrame.size.height = acH;
            answerContentFrame.origin.y = answerContentFrame.origin.y+kSize10;
            
            [self.lbAnswerContent setFrame:answerContentFrame];
        }
        //内容区域
        [self.viewContent setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lbAnswerContent.y+self.lbAnswerContent.height+kSize13)];
        
        [self.viewLine setFrame:CGRectMake(0, self.viewContent.y+self.viewContent.height, self.cellW, self.lineMaxH)];
    }
    self.cellH = self.viewLine.y+self.viewLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelQuestionTopic *)model
{
    [self setModel:model];
    
    [self setViewValue];
}

-(CGFloat)getHWithModel:(ModelQuestionTopic *)model
{
    [self setModel:model];
    [self setViewValue];
    return self.cellH;
}

-(void)setViewValue
{
    if (self.model) {
        [self.imgPhoto setPhotoURLStr:self.model.head_imgA];
        [self.lbNickName setText:self.model.nicknameA];
        [self.lbSign setText:self.model.signA];
        [self.lbTitle setText:self.model.title];
        
        NSString *content = self.model.answerContent.imgReplacing;
        if (content) {
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
            content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
        }
        [self.lbAnswerContent setText:content];
    }
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbAnswerContent);
    OBJC_RELEASE(_imgPhoto);
    
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
