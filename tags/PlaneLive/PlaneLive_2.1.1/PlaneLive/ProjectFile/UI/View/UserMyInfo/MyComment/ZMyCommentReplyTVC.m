//
//  ZMyCommentReplyTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCommentReplyTVC.h"
#import "Utils.h"

@interface ZMyCommentReplyTVC()

///头像
@property (strong, nonatomic) ZImageView *imgPhoto;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///回复内容
@property (strong, nonatomic) UILabel *lbTitle;
///时间
@property (strong, nonatomic) UILabel *lbTime;
///评论&答案区域
@property (strong, nonatomic) UIView *viewContent;
///评论&答案内容
@property (strong, nonatomic) ZRichStyleLabel *lbContent;
///分割线
@property (strong, nonatomic) UIView *viewLine;
///数据模型
@property (strong, nonatomic) ModelQuestionMyAnswerComment *modelCR;

@end

@implementation ZMyCommentReplyTVC

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
    
    self.imgPhoto = [[ZImageView alloc] initWithImage:[SkinManager getDefaultImage]];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *photoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
    [self.imgPhoto addGestureRecognizer:photoClick];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbTime = [[UILabel alloc] init];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTime];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:RGBCOLOR(244, 244, 244)];
    [self.viewContent setViewRound:3 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewContent setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewContent];
    
    UITapGestureRecognizer *contentClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentClick:)];
    [self.viewContent addGestureRecognizer:contentClick];
    
    self.lbContent = [[ZRichStyleLabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:2];
    [self.lbContent setUserInteractionEnabled:NO];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbContent];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
}
-(void)contentClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.modelCR.status = 1;
        [self setViewBackColorChange];
        if (self.modelCR.type == 1) {
            if (self.onAnswerClick) {
                self.onAnswerClick(self.modelCR);
            }
        } else {
            if (self.onCommentClick) {
                self.onCommentClick(self.modelCR);
            }
        }
    }
}
-(void)photoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (![Utils isMyUserId:self.modelCR.userid]) {
            self.modelCR.status = 1;
            [self setViewBackColorChange];
            if (self.onPhotoClick) {
                self.onPhotoClick(self.modelCR);
            }
        }
    }
}
///设置坐标
-(void)setViewFrame
{
    CGFloat imgS = 25;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgS, imgS)];
    [self.imgPhoto setViewRoundNoBorder];
    
    CGFloat timeY = self.imgPhoto.y+self.imgPhoto.height/2-self.lbMinH/2;
    [self.lbTime setFrame:CGRectMake(self.cellW-self.space-10, timeY, 10, self.lbMinH)];
    CGFloat timeW = [self.lbTime getLabelWidthWithMinWidth:10];
    [self.lbTime setFrame:CGRectMake(self.cellW-self.space-timeW, timeY, timeW, self.lbMinH)];
    
    CGFloat nickNameX = self.imgPhoto.x+5+imgS;
    CGFloat nickNameY = self.imgPhoto.y+self.imgPhoto.height/2-self.lbH/2;
    CGFloat nickNameW = self.cellW-self.space-nickNameX-timeW;
    [self.lbNickName setFrame:CGRectMake(nickNameX, nickNameY, nickNameW, self.lbH)];
    
    CGRect contentFrame = CGRectMake(self.space, self.imgPhoto.y+imgS+7, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:contentFrame];
    
    CGFloat newH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat newMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (newH > newMaxH) {
        newH = newMaxH;
    }
    contentFrame.size.height = newH;
    [self.lbTitle setFrame:contentFrame];
    
    [self.viewContent setFrame:CGRectMake(self.space, self.lbTitle.y+newH+8, self.cellW-self.space*2, self.lbMinH)];
    [self.lbContent setFrame:CGRectMake(9, 8, self.viewContent.width-18, self.viewContent.height)];
    CGFloat commentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat commentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
    if (commentH > commentMaxH) {
        commentH = commentMaxH;
    }
    [self.lbContent setFrame:CGRectMake(self.lbContent.x, self.lbContent.y, self.lbContent.width, commentH)];
    [self.viewContent setFrame:CGRectMake(self.viewContent.x, self.viewContent.y, self.viewContent.width, commentH+18)];
    
    [self.viewLine setFrame:CGRectMake(0, self.viewContent.y+self.viewContent.height+10, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewContent);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(void)setViewBackColorChange
{
    if (self.modelCR.status == 0) {
        [self.viewMain setBackgroundColor:MESSAGECOLOR];
        [self.viewContent setBackgroundColor:WHITECOLOR];
    } else {
        [self.viewMain setBackgroundColor:WHITECOLOR];
        [self.viewContent setBackgroundColor:RGBCOLOR(244, 244, 244)];
    }
}

-(CGFloat)setCellDataWithModel:(ModelQuestionMyAnswerComment *)model
{
    [self setModelCR:model];
    
    [self.imgPhoto setPhotoURLStr:model.head_img];
    
    [self.lbTime setText:model.com_time];
    
    if (model.nickname.length > 0) {
        if (model.type == 0) {
            [self.lbNickName setText:[NSString stringWithFormat:@"%@%@",model.nickname,kCommentYourAnswer]];
            [self.lbNickName setTextColor:RGBCOLOR(251, 107, 33)];
            [self.lbNickName setLabelColorWithRange:NSMakeRange(model.nickname.length, kCommentYourAnswer.length) color:BLACKCOLOR1];
        } else {
            [self.lbNickName setText:[NSString stringWithFormat:@"%@%@",model.nickname,kReplyYourComment]];
            [self.lbNickName setTextColor:RGBCOLOR(251, 107, 33)];
            [self.lbNickName setLabelColorWithRange:NSMakeRange(model.nickname.length, kReplyYourComment.length) color:BLACKCOLOR1];
        }
    } else {
        if (model.type == 0) {
            [self.lbNickName setText:kCommentYourAnswer];
            [self.lbNickName setTextColor:BLACKCOLOR1];
        } else {
            [self.lbNickName setText:kReplyYourComment];
            [self.lbNickName setTextColor:BLACKCOLOR1];
        }
    }
    [self.lbTitle setText:model.content];
    
    NSString *content = model.acontent.imgReplacing;
    if (content) {
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
    }
    [self.lbContent setText:content];
    
    [self setViewBackColorChange];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(CGFloat)getHWithModel:(ModelQuestionMyAnswerComment *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(CGFloat)getH
{
    return self.cellH;
}

@end
