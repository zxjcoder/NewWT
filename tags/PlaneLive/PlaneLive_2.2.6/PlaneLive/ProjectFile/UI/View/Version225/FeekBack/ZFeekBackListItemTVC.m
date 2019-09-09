//
//  ZFeekBackListItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackListItemTVC.h"

@interface ZFeekBackListItemTVC()

@property (strong, nonatomic) ZLabel *lbCreateTime;

@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZLabel *lbContent;

@property (strong, nonatomic) ZView *viewImages;

@property (strong, nonatomic) ZView *viewReply;
@property (strong, nonatomic) ZLabel *lbReply;
@property (strong, nonatomic) ZLabel *lbReplyContent;

@property (strong, nonatomic) ModelFeedBack *modelFB;

@end

@implementation ZFeekBackListItemTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}
static CGFloat imageSize = 60;
-(void)innerInit
{
    [super innerInit];
    self.cellH = [ZFeekBackListItemTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbCreateTime = [[ZLabel alloc] initWithFrame:(CGRectMake(self.space, self.space, self.cellW-self.space*2, self.lbMinH))];
    [self.lbCreateTime setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCreateTime setTextColor:COLORTEXT3];
    [self.lbCreateTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbCreateTime];
    
    self.viewContent = [[ZView alloc] initWithFrame:(CGRectMake(self.space, self.lbCreateTime.y+self.lbCreateTime.height+12, self.cellW-self.space*2, 0))];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewContent];
    CGFloat contentW = self.viewContent.width-self.space*2;
    self.lbContent = [[ZLabel alloc] initWithFrame:(CGRectMake(self.space, self.space, self.viewContent.width-self.space*2, self.lbH))];
    [self.lbContent setNumberOfLines:0];
    [self.lbContent setTextColor:COLORTEXT1];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbContent];
    
    self.viewImages = [[ZView alloc] initWithFrame:(CGRectMake(self.space, self.lbContent.y+self.lbContent.height+17, contentW, 0))];
    [self.viewContent addSubview:self.viewImages];
    
    CGFloat imageSpace = 15;
    for (int i = 0; i < 4; i++) {
        CGFloat imageX = imageSpace*i+imageSize*i;
        ZImageView *imageItem = [[ZImageView alloc] initWithFrame:(CGRectMake(imageX, 0, imageSize, imageSize))];
        imageItem.hidden = true;
        imageItem.tag = i+1;
        imageItem.userInteractionEnabled = true;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageItemTap:)];
        [imageItem addGestureRecognizer:tapImage];
        
        [self.viewImages addSubview:imageItem];
    }
    self.viewReply = [[ZView alloc] initWithFrame:(CGRectMake(self.space, self.viewImages.y+self.viewImages.height+17, contentW, 0))];
    [self.viewContent addSubview:self.viewReply];
    self.lbReply = [[ZLabel alloc] initWithFrame:(CGRectMake(0, 0, 38, self.lbMinH))];
    [self.lbReply setTextColor:COLORTEXT1];
    [self.lbReply setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbReply setText:@"回复:"];
    self.lbReply.hidden = true;
    [self.viewReply addSubview:self.lbReply];
    
    CGFloat lbRCX = self.lbReply.x+self.lbReply.width;
    CGFloat lbRCW = self.viewReply.width-lbRCX;
    self.lbReplyContent = [[ZLabel alloc] initWithFrame:(CGRectMake(lbRCX, 0, lbRCW, self.lbMinH))];
    [self.lbReplyContent setTextColor:COLORTEXT3];
    self.lbReplyContent.hidden = true;
    [self.lbReplyContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbReplyContent setNumberOfLines:0];
    [self.viewReply addSubview:self.lbReplyContent];
}
-(void)imageItemTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.view.tag <= self.modelFB.images.count) {
            if (self.onImageItemClick) {
                self.onImageItemClick(self.modelFB.images, sender.view.tag-1);
            }
        }
    }
}
-(void)setViewFrame
{
    CGRect contentFrame = self.lbContent.frame;
    contentFrame.size.height = [self.lbContent getLabelHeightWithMinHeight:self.lbH];
    self.lbContent.frame = contentFrame;
    
    CGRect imagesFrame = self.viewImages.frame;
    if (self.modelFB.images.count > 0) {
        self.viewImages.hidden = false;
        imagesFrame.origin.y = self.lbContent.y+self.lbContent.height+17;
        imagesFrame.size.height = imageSize;
    } else {
        self.viewImages.hidden = true;
        imagesFrame.size.height = 0;
        imagesFrame.origin.y = self.lbContent.y+self.lbContent.height;
    }
    self.viewImages.frame = imagesFrame;
    
    CGRect replyContentFrame = self.lbReplyContent.frame;
    replyContentFrame.size.height = [self.lbReplyContent getLabelHeightWithMinHeight:self.lbMinH];
    self.lbReplyContent.frame = replyContentFrame;
    
    CGRect replyViewFrame = self.viewReply.frame;
    if (self.modelFB.reply.length > 0) {
        replyViewFrame.origin.y = self.viewImages.y+self.viewImages.height+17;
        replyViewFrame.size.height = replyContentFrame.origin.y+replyContentFrame.size.height;
    } else {
        replyViewFrame.origin.y = self.viewImages.y+self.viewImages.height;
        replyViewFrame.size.height = 0;
    }
    self.viewReply.frame = replyViewFrame;
    
    CGRect contentViewFrame = self.viewContent.frame;
    contentViewFrame.size.height = self.viewReply.y+self.viewReply.height+20;
    self.viewContent.frame = contentViewFrame;
    
    self.cellH = self.viewContent.y+self.viewContent.height;
}
-(CGFloat)setCellDataWithModel:(ModelFeedBack *)model
{
    self.modelFB = model;
    
    self.lbContent.text = model.content;
    self.lbCreateTime.text = model.createTime;
    for (ZImageView *imageView in self.viewImages.subviews) {
        imageView.hidden = true;
    }
    if (model.images.count > 0) {
        int index = 1;
        for (NSString *imagePath in model.images) {
            ZImageView *imageView = [self.viewImages viewWithTag:index];
            if (imageView) {
                imageView.hidden = false;
                [imageView setImageURLStr:imagePath placeImage:[SkinManager getDefaultImage]];
            }
            index++;
        }
    }
    
    self.lbReply.hidden = model.reply.length==0;
    self.lbReplyContent.hidden = model.reply.length==0;
    self.lbReplyContent.text = model.reply;
    
    [self setViewFrame];
    
    return self.cellH;
}
+(CGFloat)getH
{
    return 40;
}

@end
