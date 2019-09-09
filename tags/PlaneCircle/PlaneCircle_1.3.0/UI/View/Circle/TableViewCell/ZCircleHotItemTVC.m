//
//  ZCircleHotItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleHotItemTVC.h"
#import "TYAttributedLabel.h"

@interface ZCircleHotItemTVC()

///标签
//@property (strong, nonatomic) UIView *viewTags;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///标题分割线
@property (strong, nonatomic) UIView *viewTitleLine;
///回答内容区域
@property (strong, nonatomic) UIView *viewContent;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///个性签名
@property (strong, nonatomic) UILabel *lbSign;
///头像
//@property (strong, nonatomic) ZImageView *imgPhoto;
///回答内容
@property (strong, nonatomic) UILabel *lbAnswerContent;

///实体对象
@property (strong, nonatomic) ModelCircleHot *model;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZCircleHotItemTVC

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
    
//    self.viewTags = [[UIView alloc] init];
//    [self.viewMain addSubview:self.viewTags];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewTitleLine = [[UIView alloc] init];
    [self.viewTitleLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewTitleLine];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbSign];
    
//    self.imgPhoto = [[ZImageView alloc] init];
//    [self.imgPhoto setDefaultImage];
//    [self.viewContent addSubview:self.imgPhoto];
    
    self.lbAnswerContent = [[UILabel alloc] init];
    [self.lbAnswerContent setTextColor:BLACKCOLOR1];
    [self.lbAnswerContent setNumberOfLines:3];
    [self.lbAnswerContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbAnswerContent];
    
    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewContent addGestureRecognizer:tapAnswerClick];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
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
    
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
    
    [self.lbNickName setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
    [self.lbSign setFont:[ZFont systemFontOfSize:kSet_Font_Minimum_Size(self.fontSize)]];
    
    [self.lbAnswerContent setFont:[ZFont systemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
}

///设置坐标
-(void)setViewFrame
{
    [self setCellFontSize];
    
    self.cellW = APP_FRAME_WIDTH;
    //标签
//    if (self.model.tags.count == 0) {
//        [self.viewTags setFrame:CGRectMake(0, 0, self.cellW, kSize8)];
//    } else {
//        CGFloat viewTagsH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:[ZFont systemFontOfSize:kSet_Font_Min_Size(self.fontSize)] width:300];
//        [self.viewTags setFrame:CGRectMake(0, 0, self.cellW, viewTagsH+kSize8*2)];
//    }
    //标题
//    CGRect titleFrame = CGRectMake(self.space, self.viewTags.height, self.cellW-self.space*2, self.lbH);
    CGRect titleFrame = CGRectMake(self.space, kSize8, self.cellW-self.space*2, self.lbH);
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
//        [self.imgPhoto setHidden:YES];
        [self.lbAnswerContent setHidden:YES];
        
        [self.viewLine setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lineMaxH)];
    } else {
        [self.viewContent setHidden:NO];
        [self.lbNickName setHidden:NO];
        [self.lbSign setHidden:NO];
//        [self.imgPhoto setHidden:NO];
        [self.lbAnswerContent setHidden:NO];
        
        [self.viewContent setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lbH)];
        //昵称
        CGFloat nickNameW = [self.lbNickName getLabelWidthWithMinWidth:0];
        [self.lbNickName setFrame:CGRectMake(self.space, kSize10, nickNameW, self.lbH)];
        //个性签名
//        CGFloat imgSize = 20;
        CGFloat imgSize = 0;
        CGFloat signX = self.lbNickName.x+self.lbNickName.width+kSize8;
        CGFloat signW = self.viewContent.width-signX-imgSize-kSize13-kSize5;
        CGFloat signY = self.lbNickName.y+self.lbNickName.height-self.lbMinH;
        [self.lbSign setFrame:CGRectMake(signX, signY, signW, self.lbMinH)];
        //头像
//        [self.imgPhoto setFrame:CGRectMake(self.viewContent.width-self.space-imgSize, kSize11, imgSize, imgSize)];
//        [self.imgPhoto setViewRound];
        //回答内容
        CGFloat lbW = self.viewContent.width-self.space*2;
        CGRect answerContentFrame = CGRectMake(self.space, self.lbNickName.y+self.lbNickName.height, lbW, 0);
        [self.lbAnswerContent setFrame:answerContentFrame];
        if (self.lbAnswerContent.text.length > 0) {
            CGFloat acH = [self.lbAnswerContent getLabelHeightWithMinHeight:self.lbMinH];
            CGFloat amaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswerContent];
            if (acH > amaxH) {acH = amaxH;}
            answerContentFrame.size.height = acH;
            answerContentFrame.origin.y = answerContentFrame.origin.y+kSize8;
            
            [self.lbAnswerContent setFrame:answerContentFrame];
        }
        //内容区域
        [self.viewContent setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lbAnswerContent.y+self.lbAnswerContent.height+kSize12)];
        
        [self.viewLine setFrame:CGRectMake(0, self.viewContent.y+self.viewContent.height, self.cellW, self.lineMaxH)];
    }
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelCircleHot *)model
{
    [self setModel:model];
//    for (UIView *view in self.viewTags.subviews) {
//        [view removeFromSuperview];
//    }
//    if (model) {
//        NSInteger rowIndex = 0;
//        CGFloat btnX = kSize14;
//        CGFloat btnH = 20;
//        for (NSDictionary *dic in model.tags) {
//            ModelTag *modelTag = [[ModelTag alloc] initWithCustom:dic];
//            if (modelTag.tagName.length > 0) {
//                UIButton *btnTag = [UIButton buttonWithType:(UIButtonTypeCustom)];
//                [btnTag setTitle:modelTag.tagName forState:(UIControlStateNormal)];
//                [btnTag setTag:rowIndex];
//                [btnTag setBackgroundColor:TOPICBGCOLOR];
//                [btnTag setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
//                [btnTag setUserInteractionEnabled:NO];
//                [btnTag addTarget:self action:@selector(btnTagClick:) forControlEvents:(UIControlEventTouchUpInside)];
//                [[btnTag titleLabel] setFont:[ZFont systemFontOfSize:kSet_Font_Minimum_Size(self.fontSize)]];
//                [[btnTag titleLabel] setText:modelTag.tagName];
//                CGFloat btnW = [btnTag.titleLabel getLabelWidthWithMinWidth:0];
//                [btnTag setFrame:CGRectMake(btnX, kSize8, btnW+kSize12, btnH)];
//                [btnTag setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
//                [self.viewTags addSubview:btnTag];
//                btnX = btnX+btnTag.width+kSize13;
//            }
//            rowIndex++;
//        }
//    }
    [self setViewValue];
}

-(void)setViewValue
{
    if (self.model) {
        [self.lbTitle setText:self.model.title];
        
        NSString *content = self.model.answerContent.imgReplacing;
        if (content) {
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
            content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
        }
        [self.lbAnswerContent setText:content];
        
        [self.lbNickName setText:self.model.nickname];
        [self.lbSign setText:self.model.sign];
//        [self.imgPhoto setPhotoURLStr:self.model.head_img];
    }
    [self setViewFrame];
}

-(CGFloat)getHWithModel:(ModelCircleHot *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)btnTagClick:(UIButton *)sender
{
    if (self.onTagItemClick) {
        NSDictionary *dic = [self.model.tags objectAtIndex:sender.tag];
        ModelTag *modelTag = [[ModelTag alloc] initWithCustom:dic];
        self.onTagItemClick(modelTag);
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbAnswerContent);
    OBJC_RELEASE(_viewLine);
//    OBJC_RELEASE(_viewTags);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewTitleLine);
//    OBJC_RELEASE(_imgPhoto);
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
