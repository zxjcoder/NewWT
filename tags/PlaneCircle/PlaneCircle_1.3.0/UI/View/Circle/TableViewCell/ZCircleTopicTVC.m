//
//  ZCircleTopicTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleTopicTVC.h"
#import "ZTopicButton.h"

@interface ZCircleTopicTVC()

///顶部区域
@property (strong, nonatomic) UIView *viewHeader;
///分类标示线
@property (strong, nonatomic) UIView *viewIcon;
///分类标题
@property (strong, nonatomic) UILabel *lbTitle;
///顶部分割线
@property (strong, nonatomic) UIView *viewHL;
///查看全部
@property (strong, nonatomic) UIButton *btnMore;
///内容区域
@property (strong, nonatomic) UIView *viewContent;
///内容底部分割线
@property (strong, nonatomic) UIView *viewLine;
///数据对象
@property (strong, nonatomic) ModelTagType *modelType;

@end

@implementation ZCircleTopicTVC

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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewHeader = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewHeader];
    
    self.viewIcon = [[UIView alloc] init];
    [self.viewIcon setBackgroundColor:MAINCOLOR];
    [self.viewHeader addSubview:self.viewIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.viewHeader addSubview:self.lbTitle];
    
    self.btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMore setUserInteractionEnabled:YES];
    [self.btnMore setTitle:@"查看全部" forState:(UIControlStateNormal)];
    [self.btnMore setTitle:@"查看全部" forState:(UIControlStateHighlighted)];
    [self.btnMore setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [self.btnMore setImage:[SkinManager getImageWithName:@"wode_btn_enter_s"] forState:(UIControlStateNormal)];
    [self.btnMore setImage:[SkinManager getImageWithName:@"wode_btn_enter_s"] forState:(UIControlStateHighlighted)];
    [self.btnMore setImageEdgeInsets:(UIEdgeInsetsMake(4, 60, 4, 0))];
    [self.btnMore setTitleEdgeInsets:(UIEdgeInsetsMake(3, -20, 0, 0))];
    [self.btnMore addTarget:self action:@selector(btnMoreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [[self.btnMore titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewHeader addSubview:self.btnMore];
    
    self.viewHL = [[UIView alloc] init];
    [self.viewHL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewHeader addSubview:self.viewHL];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewContent];
    
    CGFloat itemX = kSize10;
    CGFloat itemY = kSize10;
    for (int i = 1 ; i< 30; i++) {
        ZTopicButton *btnTopic = [[ZTopicButton alloc] initWithPoint:CGPointMake(itemX, itemY)];
        [btnTopic setTag:i];
        [btnTopic setHidden:YES];
        [btnTopic addTarget:self action:@selector(btnTopicClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:btnTopic];
        itemX += btnTopic.width+13;
        if (itemX > self.cellW) {
            break;
        }
    }
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)btnMoreClick
{
    if (self.onAllClick) {
        self.onAllClick(self.modelType);
    }
}

-(void)btnTopicClick:(ZTopicButton *)sender
{
    if (self.onItemClick) {
        self.onItemClick(sender.modelT);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewHeader setFrame:CGRectMake(0, 0, self.cellW, 35)];
    
    [self.viewIcon setFrame:CGRectMake(self.space, 10, self.lineMaxH, 15)];
    
    CGFloat allW = 70;
    CGFloat titleX = self.viewIcon.x+self.viewIcon.width+kSize8;
    CGFloat titleW = self.cellW-titleX-allW;
    [self.lbTitle setFrame:CGRectMake(titleX, self.viewHeader.height/2-self.lbH/2, titleW, self.lbH)];
    
    [self.btnMore setFrame:CGRectMake(self.cellW-allW-10, 2, allW, 30)];
    
    [self.viewHL setFrame:CGRectMake(0, self.viewHeader.height-self.lineH/2, self.viewHeader.width, self.lineH/2)];
    
    [self.viewContent setFrame:CGRectMake(0, self.viewHeader.height, self.cellW, 90)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(void)setViewNil
{
    for (UIView *view in self.viewContent.subviews) {
        [view removeFromSuperview];
    }
    OBJC_RELEASE(_viewHL);
    OBJC_RELEASE(_viewIcon);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_btnMore);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(void)setCellDataWithModel:(ModelTagType *)model
{
    [self setModelType:model];
    for (UIView *view in self.viewContent.subviews) {
        [view setHidden:YES];
    }
    if (model) {
        [self.lbTitle setText:self.modelType.typeName];
        int index = 1;
        for (ModelTag *tag in model.tagArray) {
            ZTopicButton *btnTopic = [self.viewContent viewWithTag:index];
            if (btnTopic) {
                [btnTopic setHidden:NO];
                [btnTopic setButtonModel:tag];
            }
            index++;
        }
    }
}

-(CGFloat)getH
{
    return 135;
}
+(CGFloat)getH
{
    return 135;
}

@end
