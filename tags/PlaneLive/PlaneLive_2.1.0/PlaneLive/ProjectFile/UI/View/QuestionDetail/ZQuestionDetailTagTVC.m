//
//  ZQuestionDetailTagTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionDetailTagTVC.h"

@interface ZQuestionDetailTagTVC()

@property (strong, nonatomic) ModelQuestionDetail *model;

@end

@implementation ZQuestionDetailTagTVC

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
}

-(CGFloat)setCellDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    
    [self setViewContent];
    
    return self.cellH;
}
-(void)setViewContent
{
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.cellW = APP_FRAME_WIDTH;
    self.fontSize = [[AppSetting getFontSize] floatValue];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    int index = 1;
    CGFloat itemH = 26;
    CGFloat itemX = self.space;
    CGFloat itemY = 0;
    for (NSDictionary *dicTopic in self.model.arrTopic) {
        ModelTag *modelTag = [[ModelTag alloc] initWithCustom:dicTopic];
        UIButton *btnItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btnItem setViewRound:13 borderWidth:1 borderColor:MAINCOLOR];
        [btnItem setTitle:modelTag.tagName forState:(UIControlStateNormal)];
        [btnItem setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
        [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kSet_Font_Minimum_Size(self.fontSize)]];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewMain addSubview:btnItem];
        CGFloat itemW = [[btnItem titleLabel] getLabelWidthWithMinWidth:0]+20;
        if ((itemX+itemW) > (self.cellW-self.space)) {
            itemY = itemY + itemH +self.space;
            itemX = self.space;
        }
        [btnItem setFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        [btnItem setTag:index];
        itemX = itemX+itemW+10;
        index++;
    }
    if (self.model.arrTopic.count == 0) {
        self.cellH = 0;
    } else {
        self.cellH = itemY + itemH + kSize5;
    }
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(void)btnItemClick:(UIButton *)sender
{
    if (self.onTopicClick) {
        NSDictionary *dicTopic = [self.model.arrTopic objectAtIndex:sender.tag-1];
        ModelTag *modelTag = [[ModelTag alloc] initWithCustom:dicTopic];
        self.onTopicClick(modelTag);
    }
}
-(void)setViewNil
{
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
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
