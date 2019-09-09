//
//  ZMyAnswerCommentTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAnswerCommentTVC.h"

@interface ZMyAnswerCommentTVC()

///评论者头像
@property (strong, nonatomic) ZImageView *imgPhoto;
///评论者昵称
@property (strong, nonatomic) UILabel *lbNickName;
///评论时间
@property (strong, nonatomic) UILabel *lbTime;
///回答内容
@property (strong, nonatomic) ZRichStyleLabel *lbContent;
///评论区域
@property (strong, nonatomic) UIView *viewComment;
///评论内容
@property (strong, nonatomic) UILabel *lbComment;
///分割线
@property (strong, nonatomic) UIView *viewLine;
///数据源
@property (strong, nonatomic) ModelQuestionMyAnswerComment *modelQMAC;

@end

@implementation ZMyAnswerCommentTVC

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
    
    self.lbContent = [[ZRichStyleLabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbContent setNumberOfLines:2];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.viewComment = [[UIView alloc] init];
    [self.viewComment setBackgroundColor:RGBCOLOR(244, 244, 244)];
    [self.viewComment setViewRound:3 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewComment];
    
    self.lbComment = [[UILabel alloc] init];
    [self.lbComment setTextColor:BLACKCOLOR1];
    [self.lbComment setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbComment setNumberOfLines:2];
    [self.lbComment setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewComment addSubview:self.lbComment];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
}

-(void)photoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPhotoClick) {
            self.onPhotoClick(self.modelQMAC);
        }
    }
}

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
    [self.lbContent setFrame:contentFrame];
    
    CGFloat newH = [self.lbContent getLabelHeightWithMinHeight:self.lbH];
    CGFloat newMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
    if (newH > newMaxH) {
        newH = newMaxH;
    }
    contentFrame.size.height = newH;
    [self.lbContent setFrame:contentFrame];
    
    [self.viewComment setFrame:CGRectMake(self.space, self.lbContent.y+newH+8, self.cellW-self.space*2, self.lbMinH)];
    [self.lbComment setFrame:CGRectMake(9, 8, self.viewComment.width-18, self.viewComment.height)];
    CGFloat commentH = [self.lbComment getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat commentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbComment];
    if (commentH > commentMaxH) {
        commentH = commentMaxH;
    }
    [self.lbComment setFrame:CGRectMake(self.lbComment.x, self.lbComment.y, self.lbComment.width, commentH)];
    [self.viewComment setFrame:CGRectMake(self.viewComment.x, self.viewComment.y, self.viewComment.width, commentH+18)];
    
    [self.viewLine setFrame:CGRectMake(0, self.viewComment.y+self.viewComment.height+10, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelQuestionMyAnswerComment *)model
{
    [self setModelQMAC:model];
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.head_img];
        
        [self.lbTime setText:model.com_time];
        
        if (model.nickname.length > 0) {
            [self.lbNickName setText:[NSString stringWithFormat:@"%@%@",model.nickname,kCommentYourAnswer]];
            [self.lbNickName setTextColor:RGBCOLOR(251, 107, 33)];
            [self.lbNickName setLabelColorWithRange:NSMakeRange(model.nickname.length, kCommentYourAnswer.length) color:BLACKCOLOR1];
        } else {
            [self.lbNickName setText:kCommentYourAnswer];
            [self.lbNickName setTextColor:BLACKCOLOR1];
        }
        
        NSString *content = model.acontent;
        [self.lbContent setText:content];
        
        [self.lbComment setText:model.content];
        
        if (model.status == 0) {
            [self.viewMain setBackgroundColor:RGBCOLOR(255, 244, 236)];
            [self.viewComment setBackgroundColor:WHITECOLOR];
        } else {
            [self.viewMain setBackgroundColor:WHITECOLOR];
            [self.viewComment setBackgroundColor:RGBCOLOR(244, 244, 244)];
        }
    }
    [self setViewFrame];
}

-(CGFloat)getHWithModel:(ModelQuestionMyAnswerComment *)model
{
    [self setCellDataWithModel:model];
    
    return self.getH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_viewComment);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbComment);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_lbNickName);
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
+(CGFloat)getH
{
    return 45;
}

@end
