//
//  ZUserMessageTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/5.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZUserMessageTVC.h"
#import "ZCalculateLabel.h"
#import "ZImageView.h"
#import "Utils.h"

@interface ZUserMessageTVC()

@property (strong, nonatomic) ZView *viewTitle;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbTime;
//@property (strong, nonatomic) ZLabel *lbCount;
@property (strong, nonatomic) ZImageView *imgGo;

@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZLabel *lbContent;

@property (strong, nonatomic) ZView *viewButton;
@property (strong, nonatomic) ZButton *btnAll;
@property (strong, nonatomic) ZButton *btnDel;

@property (strong, nonatomic) ZImageView *viewReply;
@property (strong, nonatomic) ZLabel *lbReply;
@property (strong, nonatomic) ZLabel *lbReplyTime;

@property (strong, nonatomic) ModelMyMessage *model;
@property (assign, nonatomic) BOOL isShowAll;

@end

@implementation ZUserMessageTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [super innerInit];
    
    self.space = 20;
    if (!self.viewTitle) {
        self.viewTitle = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, 70)];
        [self.viewTitle setUserInteractionEnabled:YES];
        [self.viewMain addSubview:self.viewTitle];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
        [self.viewTitle addGestureRecognizer:tapGesture];
    }
    CGFloat lbW = self.cellW-self.space-33;
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(self.space, 15, lbW, self.lbH)];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
        [self.lbTitle setNumberOfLines:2];
        [self.lbTitle setUserInteractionEnabled:NO];
        [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.viewTitle addSubview:self.lbTitle];
    }
    if (!self.lbTime) {
        self.lbTime = [[ZLabel alloc] initWithFrame:CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+10, 200, self.lbMinH)];
        [self.lbTime setTextColor:COLORTEXT3];
        [self.lbTime setNumberOfLines:1];
        [self.lbTime setUserInteractionEnabled:NO];
        [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.lbTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.viewTitle addSubview:self.lbTime];
    }
//    if (!self.lbCount) {
//        self.lbCount = [[ZLabel alloc] initWithFrame:CGRectMake(self.cellW - self.space - 110, self.viewTitle.y, 110, self.lbMinH)];
//        [self.lbCount setTextColor:COLORTEXT3];
//        [self.lbCount setTextAlignment:(NSTextAlignmentRight)];
//        [self.lbCount setNumberOfLines:1];
//        [self.lbCount setUserInteractionEnabled:NO];
//        [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
//        [self.lbCount setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
//        [self.viewTitle addSubview:self.lbCount];
//    }
    if (!self.imgGo) {
        self.imgGo = [[ZImageView alloc] initWithFrame:CGRectMake(self.cellW-16-self.space, self.lbTitle.y+2, 10, 16)];
        [self.imgGo setImageName:@"arrow_right"];
        [self.imgGo setUserInteractionEnabled:NO];
        [self.viewTitle addSubview:self.imgGo];
    }
    if (!self.viewContent) {
        self.viewContent = [[ZView alloc] initWithFrame:(CGRectMake(self.space, self.viewTitle.y+self.viewTitle.height+10, self.cellW-self.space*2, 20))];
        [self.viewContent setViewRound:8];
        [self.viewContent setBackgroundColor:RGBCOLOR(239, 244, 246)];
        [self.viewMain addSubview:self.viewContent];
    }
    if (!self.lbContent) {
        self.lbContent = [[ZLabel alloc] init];
        [self.lbContent setNumberOfLines:0];
        [self.lbContent setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbContent setTextColor:COLORTEXT2];
        [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.viewContent addSubview:self.lbContent];
    }
    if (!self.viewButton) {
        self.viewButton = [[ZView alloc] init];
        [self.viewContent addSubview:self.viewButton];
    }
    if (!self.btnAll) {
        self.btnAll = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnAll setUserInteractionEnabled:true];
        [self.btnAll setFrame:CGRectMake(0, 5, 60, 35)];
        [self.btnAll setTitleEdgeInsets:(UIEdgeInsetsMake(0, -15.5, 0, 0))];
        [self.btnAll setImageEdgeInsets:(UIEdgeInsetsMake(0, 30, 0, 0))];
        [self.btnAll setTitle:@"展开" forState:(UIControlStateNormal)];
        [self.btnAll setImage:[SkinManager getImageWithName:@"arrow_down02"] forState:(UIControlStateNormal)];
        [self.btnAll setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
        [[self.btnAll titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnAll setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
        [self.btnAll addTarget:self action:@selector(btnAllClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnAll setTag:1];
        [self.viewButton addSubview:self.btnAll];
    }
    if (!self.btnDel) {
        self.btnDel = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnDel setUserInteractionEnabled:true];
        [self.btnDel setTitle:kDelete forState:(UIControlStateNormal)];
        [self.btnDel setTitleColor:COLORCONTENT3 forState:(UIControlStateNormal)];
        [self.btnDel setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
        [[self.btnDel titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewButton addSubview:self.btnDel];
    }
    if (!self.viewReply) {
        UIImage *image = [[UIImage imageNamed:@"bg_reply"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        self.viewReply = [[ZImageView alloc] initWithImage:image];
        [self.viewReply setContentMode:(UIViewContentModeScaleToFill)];
        [self.viewMain addSubview:self.viewReply];
    }
    if (!self.lbReply) {
        self.lbReply = [[ZLabel alloc] init];
        [self.lbReply setTextColor:COLORTEXT2];
        [self.lbReply setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.lbReply setNumberOfLines:0];
        [self.lbReply setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.viewReply addSubview:self.lbReply];
    }
    if (!self.lbReplyTime) {
        self.lbReplyTime =  [[ZLabel alloc] init];
        [self.lbReplyTime setTextColor:COLORTEXT3];
        [self.lbReplyTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbReplyTime setNumberOfLines:1];
        [self.lbReplyTime setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbReplyTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.viewReply addSubview:self.lbReplyTime];
    }
    //[self setViewFrame];
}
-(void)btnAllClick:(ZButton *)sender
{
    if (sender.tag == 1) {
        [self.btnAll setTag:2];
        [self.btnAll setTitle:@"收起" forState:(UIControlStateNormal)];
        [self.btnAll setImage:[SkinManager getImageWithName:@"arrow_up02"] forState:(UIControlStateNormal)];
        [self.btnAll setTitle:kPackUp forState:(UIControlStateNormal)];
        [self setIsShowAll:YES];
    } else {
        [self.btnAll setTag:1];
        [self.btnAll setTitle:@"展开" forState:(UIControlStateNormal)];
        [self.btnAll setImage:[SkinManager getImageWithName:@"arrow_down02"] forState:(UIControlStateNormal)];
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
    CGRect titleFrame = self.lbTitle.frame;
    CGFloat titleNewH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbTitle.font width:self.lbTitle.width]*self.lbTitle.numberOfLines;
    if (titleNewH <= titleMaxH) {
        titleFrame.size.height = titleNewH;
    } else {
        titleFrame.size.height = titleMaxH;
    }
    [self.lbTitle setFrame:titleFrame];
    CGRect timeFrame = self.lbTime.frame;
    timeFrame.origin.y = self.lbTitle.y+self.lbTitle.height+11;
    self.lbTime.frame = timeFrame;
//    CGRect countFrame = self.lbCount.frame;
//    countFrame.origin.y = self.lbTime.y;
//    self.lbCount.frame = countFrame;
    
    CGRect titleViewFrame = self.viewTitle.frame;
    titleViewFrame.size.height = self.lbTime.y + self.lbTime.height + 10;
    self.viewTitle.frame = titleViewFrame;
    
    // 内容区域
    CGFloat contentW = self.viewContent.width - 28;
    CGRect contentFrame = CGRectMake(14, 13, contentW, 20);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:20];
    CGFloat contentMax = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbContent.font width:self.lbContent.width]*4;
    if (self.isShowAll) {
        [self.lbContent setNumberOfLines:0];
        contentFrame.size.height = contentH;
    } else {
        [self.lbContent setNumberOfLines:4];
        if (contentH <= contentMax) {
            contentFrame.size.height = contentH;
        } else {
            contentFrame.size.height = contentMax;
        }
    }
    [self.lbContent setFrame:contentFrame];
    [self.btnAll setHidden:contentH <= contentMax];
    
    [self.viewButton setFrame:CGRectMake(14, self.lbContent.y+self.lbContent.height, contentW, 45)];
    [self.btnDel setFrame:CGRectMake(contentW-14-60, 5, 60, 35)];
    
    CGRect viewContentFrame = CGRectMake(self.space, self.viewTitle.y+self.viewTitle.height, self.cellW-self.space*2, 20);
    viewContentFrame.size.height = self.viewButton.y+self.viewButton.height;
    self.viewContent.frame = viewContentFrame;
    
    CGRect replyViewFrame = CGRectMake(self.space, self.viewContent.y+self.viewContent.height+11, self.cellW-self.space*2, 0);
    [self.viewReply setFrame:replyViewFrame];
    [self.viewReply setHidden:self.model.reply.length==0];
    CGRect replyFrame = CGRectMake(14, 23, replyViewFrame.size.width-28, 0);
    [self.lbReply setHidden:self.model.reply.length==0];
    [self.lbReply setFrame:replyFrame];
    if (self.model.reply.length > 0) {
        CGFloat replyH = [self.lbReply getLabelHeightWithMinHeight:0];
        replyFrame.size.height = replyH;
        [self.lbReply setFrame:replyFrame];
        
        CGRect lbReplyTimeFrame = CGRectMake(14, self.lbReply.y+self.lbReply.height+5, replyFrame.size.width, self.lbMinH);
        [self.lbReplyTime setFrame:lbReplyTimeFrame];
        
        replyViewFrame.size.height = lbReplyTimeFrame.origin.y+lbReplyTimeFrame.size.height+11;
        [self.viewReply setFrame:replyViewFrame];
        self.cellH = self.viewReply.y+self.viewReply.height+5;
    } else {
         self.cellH = self.viewContent.y+self.viewContent.height+5;
    }
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
    [self.lbTime setText:[NSString stringWithFormat:@"%@ %@", kWrittenIn, model.create_time]];
    //[self.lbCount setText:[NSString stringWithFormat:@"%ld%@", model.applaudCount, kPeoplePointPraise]];
    [self.lbContent setText:model.content];
    [self.lbReply setText:[NSString stringWithFormat:@"%@: %@", kLecturerReply, model.reply]];
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
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_viewReply);
    OBJC_RELEASE(_viewButton);
    OBJC_RELEASE(_viewTitle);
    OBJC_RELEASE(_lbReplyTime);
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

@end
