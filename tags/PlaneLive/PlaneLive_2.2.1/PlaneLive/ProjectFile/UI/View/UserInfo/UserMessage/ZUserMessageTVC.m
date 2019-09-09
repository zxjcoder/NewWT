//
//  ZUserMessageTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/5.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZUserMessageTVC.h"
#import "ZCalculateLabel.h"

@interface ZUserMessageTVC()

@property (strong, nonatomic) ZView *viewTitile;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbTime;
@property (strong, nonatomic) ZImageView *imgGo;
@property (strong, nonatomic) UIImageView *imgLine1;

@property (strong, nonatomic) ZLabel *lbContent;

@property (strong, nonatomic) ZView *viewButton;
@property (strong, nonatomic) ZButton *btnAll;
@property (strong, nonatomic) ZButton *btnDel;

@property (strong, nonatomic) ZView *viewReply;
@property (strong, nonatomic) ZLabel *lbReply;
@property (strong, nonatomic) ZLabel *lbReplyTime;

@property (strong, nonatomic) UIImageView *imgLine2;

@property (strong, nonatomic) ModelMyMessage *model;
@property (assign, nonatomic) BOOL isShowAll;

@end

@implementation ZUserMessageTVC

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
    
    self.viewTitile = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, 70)];
    [self.viewTitile setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewTitile];
    
    CGFloat lbW = self.cellW-self.space-30;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(self.space, self.space, lbW, self.lbH)];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewTitile addSubview:self.lbTitle];
    
    self.lbTime = [[ZLabel alloc] initWithFrame:CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+6, lbW, self.lbMinH)];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setUserInteractionEnabled:NO];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewTitile addSubview:self.lbTime];
    
    self.imgGo = [[ZImageView alloc] initWithFrame:CGRectMake(self.cellW-25, self.viewTitile.height/2-7, 7, 14)];
    [self.imgGo setImageName:@"wode_btn_enter_s"];
    [self.imgGo setUserInteractionEnabled:NO];
    [self.viewTitile addSubview:self.imgGo];
    
    self.imgLine1 = [UIImageView getTLineView];
    [self.imgLine1 setUserInteractionEnabled:NO];
    [self.imgLine1 setFrame:CGRectMake(self.space, self.viewTitile.height-kLineHeight, self.cellW-self.space*2, kLineHeight)];
    [self.viewTitile addSubview:self.imgLine1];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self.viewTitile addGestureRecognizer:tapGesture];
    
    self.lbContent = [[ZLabel alloc] init];
    [self.lbContent setNumberOfLines:0];
    [self.lbContent setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbContent];
    
    self.viewButton = [[ZView alloc] init];
    [self.viewMain addSubview:self.viewButton];
    
    self.btnAll = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAll setFrame:CGRectMake(self.space, 5, 80, 35)];
    [self.btnAll setTitle:kSayAll forState:(UIControlStateNormal)];
    [self.btnAll setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [[self.btnAll titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnAll setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [self.btnAll addTarget:self action:@selector(btnAllClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnAll setTag:1];
    [self.viewButton addSubview:self.btnAll];
    
    self.btnDel = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDel setFrame:CGRectMake(self.cellW-self.space-60, 5, 60, 35)];
    [self.btnDel setTitle:kDelete forState:(UIControlStateNormal)];
    [self.btnDel setTitleColor:RGBCOLOR(103, 124, 150) forState:(UIControlStateNormal)];
    [self.btnDel setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [[self.btnDel titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewButton addSubview:self.btnDel];
    
    self.viewReply = [[ZView alloc] init];
    [self.viewReply setBackgroundColor:RGBCOLOR(244, 244, 244)];
    [self.viewMain addSubview:self.viewReply];
    
    self.lbReply = [[ZLabel alloc] init];
    [self.lbReply setTextColor:BLACKCOLOR1];
    [self.lbReply setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbReply setNumberOfLines:0];
    [self.lbReply setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewReply addSubview:self.lbReply];
    
    self.lbReplyTime =  [[ZLabel alloc] init];
    [self.lbReplyTime setTextColor:DESCCOLOR];
    [self.lbReplyTime setFont:[ZFont systemFontOfSize:kFont_Minmum_Size]];
    [self.lbReplyTime setNumberOfLines:1];
    [self.lbReplyTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbReplyTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewReply addSubview:self.lbReplyTime];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine2];
    
    [self setViewFrame];
}
-(void)btnAllClick:(ZButton *)sender
{
    if (sender.tag == 1) {
        [self.btnAll setTag:2];
        [self.btnAll setTitle:kPackUp forState:(UIControlStateNormal)];
        [self setIsShowAll:YES];
    } else {
        [self.btnAll setTag:1];
        [self.btnAll setTitle:kSayAll forState:(UIControlStateNormal)];
        [self setIsShowAll:NO];
    }
    if (self.onRowHeightChange) {
        self.onRowHeightChange(sender.tag == 2, self.model.ids);
    }
}
-(void)tapGestureClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onSubscribeClick) {
            self.onSubscribeClick(self.model);
        }
    }
}
-(void)btnDelClick:(ZButton *)sender
{
    if (self.onDeleteClick) {
        self.onDeleteClick(self.tag, self.model);
    }
}

-(void)setViewFrame
{
    CGFloat contentW = self.cellW-self.space*2;
    CGRect contentFrame = CGRectMake(self.space, self.viewTitile.height+12, contentW, 0);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:0];
    CGFloat contentMax = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent line:4];
    if (self.isShowAll) {
        [self.lbContent setNumberOfLines:0];
        contentFrame.size.height = contentH;
        [self.lbContent setFrame:contentFrame];
    } else {
        [self.lbContent setNumberOfLines:4];
        if (contentH <= contentMax) {
            contentFrame.size.height = contentH;
            [self.lbContent setFrame:contentFrame];
        } else {
            contentFrame.size.height = contentMax;
            [self.lbContent setFrame:contentFrame];
        }
    }
    [self.btnAll setHidden:contentH <= contentMax];
    
    [self.viewButton setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height, self.cellW, 45)];
    
    CGRect replyViewFrame = CGRectMake(self.space, self.viewButton.y+self.viewButton.height, contentW, 0);
    [self.viewReply setFrame:replyViewFrame];
    
    CGRect replyFrame = CGRectMake(10, 13, replyViewFrame.size.width-20, 0);
    [self.lbReply setHidden:self.model.reply.length==0];
    [self.lbReply setFrame:replyFrame];
    if (self.model.reply.length > 0) {
        CGFloat replyH = [self.lbReply getLabelHeightWithMinHeight:0];
        replyFrame.size.height = replyH;
        [self.lbReply setFrame:replyFrame];
        
        [self.lbReplyTime setFrame:CGRectMake(self.viewReply.width-210, self.lbReply.y+self.lbReply.height+8, 200, self.lbMinH)];
        replyViewFrame.size.height = self.lbReplyTime.y+self.lbReplyTime.height+10;
        [self.viewReply setFrame:replyViewFrame];
        
        self.cellH = self.viewReply.y+self.viewReply.height+18;
    } else {
        self.cellH = self.viewReply.y+self.viewReply.height+10;
    }
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-kLineMaxHeight, self.cellW, kLineMaxHeight)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(void)setShowAllState:(BOOL)isShow
{
    [self setIsShowAll:isShow];
}
-(BOOL)getShowAllState
{
    return self.isShowAll;
}
-(CGFloat)setCellDataWithModel:(ModelMyMessage *)model
{
    [self setModel:model];
    [self.lbTitle setText:model.title];
    [self.lbTime setText:[NSString stringWithFormat:@"%@%@    %ld%@", kWrittenIn, model.create_time, model.applaudCount, kPeoplePointPraise]];
    [self.lbContent setText:model.content];
    [self.lbReply setText:[NSString stringWithFormat:@"%@: %@", kLecturerReply, model.reply]];
    [self.lbReply setTextColor:BLACKCOLOR1];
    [self.lbReply setLabelColorWithRange:NSMakeRange(0, 5) color:RGBCOLOR(103, 124, 150)];
    [self.lbReplyTime setText:model.reply_time];
    
    [self setViewFrame];
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_imgGo);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_btnAll);
    OBJC_RELEASE(_btnDel);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbReply);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_viewReply);
    OBJC_RELEASE(_viewButton);
    OBJC_RELEASE(_viewTitile);
    OBJC_RELEASE(_lbReplyTime);
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

@end
