//
//  ZAnswerDetailCommentTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailCommentTVC.h"
#import "ZCommentLabel.h"

@interface ZAnswerDetailCommentTVC()

///头像
@property (strong, nonatomic) ZImageView *imgPhoto;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///评论时间
@property (strong, nonatomic) UILabel *lbCommentTime;
///评论内容
@property (strong, nonatomic) UILabel *lbCommentContent;
///回复内容区域
@property (strong, nonatomic) UIView *viewReply;
///功能按钮
@property (strong, nonatomic) UIButton *btnOper;
///评论查看全部
@property (strong, nonatomic) UIButton *btnCommentMax;
///回复查看全部
@property (strong, nonatomic) UIButton *btnReplyMax;

///评论是否显示默认高度
@property (assign, nonatomic) BOOL isCommentDefaultH;
///回复是否显示默认高度
@property (assign, nonatomic) BOOL isReplyDefaultH;
///回复区域高度
@property (assign, nonatomic) CGFloat viewReplyHeight;

///数据对象
@property (strong, nonatomic) ModelAnswerComment *modelAB;

@end

@implementation ZAnswerDetailCommentTVC

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
    
    self.isCommentDefaultH = YES;
    self.isReplyDefaultH = YES;
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultImage];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *photoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
    [self.imgPhoto addGestureRecognizer:photoClick];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:NICKNAMECOLOR];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setUserInteractionEnabled:YES];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    UITapGestureRecognizer *nickNameClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
    [self.lbNickName addGestureRecognizer:nickNameClick];
    
    self.lbCommentTime = [[UILabel alloc] init];
    [self.lbCommentTime setTextColor:DESCCOLOR];
    [self.lbCommentTime setNumberOfLines:1];
    [self.lbCommentTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbCommentTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCommentTime];
    
    self.lbCommentContent = [[UILabel alloc] init];
    [self.lbCommentContent setTextColor:BLACKCOLOR1];
    [self.lbCommentContent setNumberOfLines:0];
    [self.lbCommentContent setUserInteractionEnabled:YES];
    [self.lbCommentContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCommentContent];
    
    UITapGestureRecognizer *commentContentClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentContentClick:)];
    [self.lbCommentContent addGestureRecognizer:commentContentClick];
    
    self.btnCommentMax = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCommentMax setUserInteractionEnabled:YES];
    [self.btnCommentMax setHidden:YES];
    [self.btnCommentMax setTitle:kOpen forState:(UIControlStateNormal)];
    [self.btnCommentMax setTitle:kOpen forState:(UIControlStateHighlighted)];
    [self.btnCommentMax setTitleColor:NICKNAMECOLOR forState:(UIControlStateNormal)];
    [self.btnCommentMax setTitleColor:NICKNAMECOLOR forState:(UIControlStateHighlighted)];
    [[self.btnCommentMax titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnCommentMax setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [self.btnCommentMax addTarget:self action:@selector(btnCommentMaxClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnCommentMax];
    
    self.viewReply = [[UIView alloc] init];
    [self.viewReply setBackgroundColor:RGBCOLOR(244, 244, 244)];
    [self.viewMain addSubview:self.viewReply];
    
    self.btnReplyMax = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnReplyMax setUserInteractionEnabled:YES];
    [self.btnReplyMax setHidden:YES];
    [self.btnReplyMax setTitle:kOpen forState:(UIControlStateNormal)];
    [self.btnReplyMax setTitle:kOpen forState:(UIControlStateHighlighted)];
    [self.btnReplyMax setTitleColor:NICKNAMECOLOR forState:(UIControlStateNormal)];
    [self.btnReplyMax setTitleColor:NICKNAMECOLOR forState:(UIControlStateHighlighted)];
    [self.btnReplyMax setTitleEdgeInsets:(UIEdgeInsetsMake(0, -20, 0, 0))];
    [[self.btnReplyMax titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnReplyMax setImageEdgeInsets:(UIEdgeInsetsMake(-2, 0, 0, -70))];
    [self.btnReplyMax setImage:[SkinManager getImageWithName:@"btn_answer_zhankai"] forState:(UIControlStateNormal)];
    [self.btnReplyMax setImage:[SkinManager getImageWithName:@"btn_answer_zhankai"] forState:(UIControlStateHighlighted)];
    [self.btnReplyMax addTarget:self action:@selector(btnReplyMaxClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnReplyMax];
    
    [self.viewMain bringSubviewToFront:self.btnReplyMax];
    
    [self setViewFrame];
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
    [self.lbCommentTime setFont:[ZFont boldSystemFontOfSize:kSet_Font_Min_Size(self.fontSize)]];
    [self.lbCommentContent setFont:[ZFont systemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
}
-(void)photoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onUserClick) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:self.modelAB.userId];
            [modelUB setNickname:self.modelAB.nickname];
            [modelUB setHead_img:self.modelAB.head_img];
            self.onUserClick(modelUB);
        }
    }
}
-(void)commentContentClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onCommentClick) {
            self.onCommentClick(self.modelAB, self.tag);
        }
    }
}

-(void)btnCommentMaxClick
{
    self.isCommentDefaultH = !self.isCommentDefaultH;
    if (self.onRowHeightChange) {
        self.onRowHeightChange(self.modelAB, self.isCommentDefaultH, self.isReplyDefaultH);
    }
}

-(void)btnReplyMaxClick
{
    self.isReplyDefaultH = !self.isReplyDefaultH;
    if (self.onRowHeightChange) {
        self.onRowHeightChange(self.modelAB, self.isCommentDefaultH, self.isReplyDefaultH);
    }
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGFloat imgSize = 30;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    [self.imgPhoto setViewRoundNoBorder];
    
    CGFloat rightX = self.imgPhoto.x+imgSize+kSize10;
    CGFloat rightW = self.cellW-rightX-kSize10;
    //时间
    CGFloat timeMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbCommentTime];
    CGRect timeFrame = CGRectMake(self.cellW-rightW, self.space, 0, timeMaxH);
    [self.lbCommentTime setFrame:timeFrame];
    CGFloat timeW = [self.lbCommentTime getLabelWidthWithMinWidth:0];
    timeFrame.size.width = timeW;
    timeFrame.origin.x = self.cellW-kSize10-timeW;
    [self.lbCommentTime setFrame:timeFrame];
    //昵称
    CGFloat nickNameMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbNickName];
    [self.lbNickName setFrame:CGRectMake(rightX, self.space, rightW-timeW, nickNameMaxH)];
    
    //计算评论内容
    CGRect contentFrame = CGRectMake(rightX, self.lbNickName.y+nickNameMaxH+kSize8, rightW, 0);
    [self.lbCommentContent setFrame:contentFrame];
    CGFloat contentH = [self.lbCommentContent getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbCommentContent line:4];
    
    [self.btnCommentMax setHidden:contentH <= contentMaxH];
    
    if (self.isCommentDefaultH) {
        if (contentH > contentMaxH) {
            contentH = contentMaxH;
        }
    }
    contentFrame.size.height = contentH;
    [self.lbCommentContent setFrame:contentFrame];
    //计算评论展开按钮
    CGFloat btnW = 35;
    CGFloat btnH = 35;
    if (self.btnCommentMax.hidden) {
        btnH = 0;
    }
    CGFloat btnY = self.lbCommentContent.y+self.lbCommentContent.height;
    [self.btnCommentMax setFrame:CGRectMake(self.cellW-kSize13-btnW, btnY, btnW, btnH)];
    //计算回复区域
    CGRect replyFrame = CGRectMake(rightX, self.btnCommentMax.y+self.btnCommentMax.height, rightW, self.viewReplyHeight);
    [self.viewReply setFrame:replyFrame];
    
    replyFrame.size.height = self.viewReplyHeight;
    //计算评论展开按钮
    if (!self.btnReplyMax.hidden) {
        CGFloat btnReplyW = 55;
        CGFloat btnReplyH = 30;
        replyFrame.size.height = replyFrame.size.height+btnReplyH;
        [self.btnReplyMax setFrame:CGRectMake(self.cellW-kSize13-kSize12-btnReplyW, replyFrame.size.height+replyFrame.origin.y-btnReplyH+kSize8, btnReplyW, btnReplyH)];
    } else {
        if (self.modelAB.arrReply.count > 0) {
            replyFrame.size.height = replyFrame.size.height+kSize10;
        }
        [self.btnReplyMax setFrame:CGRectZero];
    }
    //计算Cell高度
    if (self.modelAB.arrReply.count == 0) {
        self.cellH = replyFrame.origin.y+replyFrame.size.height+kSize12;
    } else {
        replyFrame.origin.y = replyFrame.origin.y+kSize10;
        self.cellH = replyFrame.origin.y+replyFrame.size.height+kSize8;
    }
    [self.viewReply setFrame:replyFrame];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

static int defaultRow = 4;

-(CGFloat)setCellDataWithModel:(ModelAnswerComment *)model
{
    [self setModelAB:model];
    
    if (model.status == 1) {
        [self.viewMain setBackgroundColor:RGBCOLOR(255, 244, 236)];
    } else {
        [self.viewMain setBackgroundColor:WHITECOLOR];
    }
    
    for (UIView *view in self.viewReply.subviews) {
        [view removeFromSuperview];
    }
    CGFloat replyY = kSize13;
    CGFloat replyW = self.viewReply.width;
    CGFloat replyX = 0;
    int itemIndex = 0;
    __weak typeof(self) weakSelf = self;
    for (ModelCommentReply *modelReply in model.arrReply) {
        CGRect replyFrame = CGRectMake(replyX, replyY, replyW, 20);
        ZCommentLabel *lbReply = [[ZCommentLabel alloc] initWithFrame:replyFrame modelReply:modelReply];
        replyFrame.size.height = lbReply.getViewH;
        [lbReply setFrame:replyFrame];
        
        [lbReply setOnUserClick:^(ModelUserBase *model) {
            if (weakSelf.onUserClick) {
                weakSelf.onUserClick(model);
            }
        }];
        //内容点击
        [lbReply setOnContentClick:^(ModelCommentReply *model) {
            if (weakSelf.onReplyClick) {
                weakSelf.onReplyClick(model, weakSelf.tag);
            }
        }];
        [self.viewReply addSubview:lbReply];
        
        replyY = replyY + lbReply.getViewH + kSize3;
        itemIndex++;
        ///回复内容超过4条记录当前高度
        if (itemIndex == defaultRow && self.isReplyDefaultH) {
            break;
        }
    }
    [self.btnReplyMax setHidden:model.arrReply.count <= defaultRow];
    if (model.arrReply.count == 0) {
        self.viewReplyHeight = 0;
    } else {
        self.viewReplyHeight = replyY;
    }
    
    [self.imgPhoto setPhotoURLStr:model.head_img];
    [self.lbNickName setText:model.nickname];
    [self.lbCommentTime setText:model.createTime];
    
    [self.lbCommentContent setText:model.content];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(CGFloat)getHWithModel:(ModelAnswerComment *)model
{
    [self setModelAB:model];
    
    CGFloat replyY = kSize13;
    CGFloat replyW = self.viewReply.width;
    CGFloat replyX = 0;
    int itemIndex = 0;
    
    for (ModelCommentReply *modelReply in model.arrReply) {
        CGRect replyFrame = CGRectMake(replyX, replyY, replyW, 20);
        ZCommentLabel *lbReply = [[ZCommentLabel alloc] initWithCalculation];
        [lbReply setLabelFrame:replyFrame];
        [lbReply setLabelData:modelReply];
        replyFrame.size.height = lbReply.getViewH;
        [lbReply setLabelFrame:replyFrame];
        
        replyY = replyY + lbReply.getViewH + kSize3;
        OBJC_RELEASE(lbReply);
        itemIndex++;
        ///回复内容超过4条记录当前高度
        if (itemIndex == defaultRow && self.isReplyDefaultH) {
            break;
        }
    }
    [self.btnReplyMax setHidden:model.arrReply.count <= defaultRow];
    if (model.arrReply.count == 0) {
        self.viewReplyHeight = 0;
    } else {
        self.viewReplyHeight = replyY;
    }
    
    [self.lbNickName setText:model.nickname];
    [self.lbCommentTime setText:model.createTime];
    
    [self.lbCommentContent setText:model.content];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setCellIsCommentDefaultH:(BOOL)isDF
{
    [self setIsCommentDefaultH:isDF];
    if (self.isCommentDefaultH) {
        [self.btnCommentMax setTitle:kOpen forState:(UIControlStateNormal)];
        [self.btnCommentMax setTitle:kOpen forState:(UIControlStateHighlighted)];
    } else {
        [self.btnCommentMax setTitle:kPackUp forState:(UIControlStateNormal)];
        [self.btnCommentMax setTitle:kPackUp forState:(UIControlStateHighlighted)];
    }
}

-(void)setCellIsReplyDefaultH:(BOOL)isDF
{
    [self setIsReplyDefaultH:isDF];
    if (self.isReplyDefaultH) {
        [self.btnReplyMax setTitle:kOpen forState:(UIControlStateNormal)];
        [self.btnReplyMax setTitle:kOpen forState:(UIControlStateHighlighted)];
        [self.btnReplyMax setImage:[SkinManager getImageWithName:@"btn_answer_zhankai"] forState:(UIControlStateNormal)];
        [self.btnReplyMax setImage:[SkinManager getImageWithName:@"btn_answer_zhankai"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnReplyMax setTitle:kPackUp forState:(UIControlStateNormal)];
        [self.btnReplyMax setTitle:kPackUp forState:(UIControlStateHighlighted)];
        [self.btnReplyMax setImage:[SkinManager getImageWithName:@"btn_answer_shouqi"] forState:(UIControlStateNormal)];
        [self.btnReplyMax setImage:[SkinManager getImageWithName:@"btn_answer_shouqi"] forState:(UIControlStateHighlighted)];
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbCommentTime);
    OBJC_RELEASE(_lbCommentContent);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_viewReply);
    OBJC_RELEASE(_modelAB);
    OBJC_RELEASE(_btnOper);
    OBJC_RELEASE(_btnReplyMax);
    OBJC_RELEASE(_btnCommentMax);
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
