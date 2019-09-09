//
//  ZSwitchToolView.m
//  PlaneCircle
//
//  Created by Daniel on 7/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSwitchToolView.h"
#import "ClassCategory.h"

#import <UMMobClick/MobClick.h>

@interface ZSwitchToolView()

///子项1
@property (strong, nonatomic) UIButton *btnItem1;
///子项2
@property (strong, nonatomic) UIButton *btnItem2;
///子项3
@property (strong, nonatomic) UIButton *btnItem3;
///子项4
@property (strong, nonatomic) UIButton *btnItem4;
///子项数量
@property (strong, nonatomic) UILabel *lbCount;
///分割线
@property (strong, nonatomic) UIView *viewLine;
///选中线
@property (strong, nonatomic) UIView *viewLine1;
///当前属于那个模块
@property (assign, nonatomic) ZSwitchToolViewItem type;
///子项宽度
@property (assign, nonatomic) CGFloat itemW;
///子项数量
@property (assign, nonatomic) int itemCount;

@end

@implementation ZSwitchToolView

-(id)initWithType:(ZSwitchToolViewItem)type
{
    self = [super init];
    if (self) {
        [self setType:type];
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setHidden:NO];
    [self.viewLine setBackgroundColor:MAINCOLOR];
    [self addSubview:self.viewLine];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setHidden:NO];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewLine1];
    
    [self sendSubviewToBack:self.viewLine1];
    
    switch (self.type) {
        case ZSwitchToolViewItemCircle:
        {
            [self setItemCount:4];
            [self createButtonItem1];
            [self createButtonItem2];
            [self createButtonItem3];
            [self createButtonItem4];
            [self.btnItem1 setTitle:@"推荐" forState:(UIControlStateNormal)];
            [self.btnItem2 setTitle:@"话题" forState:(UIControlStateNormal)];
            [self.btnItem3 setTitle:@"最新" forState:(UIControlStateNormal)];
            [self.btnItem4 setTitle:@"动态" forState:(UIControlStateNormal)];
            break;
        }
        case ZSwitchToolViewItemMyQuestion:
        {
            [self setItemCount:2];
            [self createButtonItem1];
            [self createButtonItem2];
            [self createLabelCount];
            [self.btnItem1 setTitle:@"所有问题" forState:(UIControlStateNormal)];
            [self.btnItem2 setTitle:@"最新答案" forState:(UIControlStateNormal)];
            break;
        }
        case ZSwitchToolViewItemMyAttention:
        {
            [self setItemCount:3];
            [self createButtonItem1];
            [self createButtonItem2];
            [self createButtonItem3];
            [self.btnItem1 setTitle:@"问题" forState:(UIControlStateNormal)];
            [self.btnItem2 setTitle:@"话题" forState:(UIControlStateNormal)];
            [self.btnItem3 setTitle:@"用户" forState:(UIControlStateNormal)];
            break;
        }
        case ZSwitchToolViewItemMyCollection:
        {
            [self setItemCount:3];
            [self createButtonItem1];
            [self createButtonItem2];
            [self createButtonItem3];
            [self.btnItem1 setTitle:@"实务" forState:(UIControlStateNormal)];
            [self.btnItem2 setTitle:@"答案" forState:(UIControlStateNormal)];
            [self.btnItem3 setTitle:@"榜单" forState:(UIControlStateNormal)];
            break;
        }
        case ZSwitchToolViewItemMyAnswer:
        {
            [self setItemCount:2];
            [self createButtonItem1];
            [self createButtonItem2];
            [self createLabelCount];
            [self.btnItem1 setTitle:@"我的答案" forState:(UIControlStateNormal)];
            [self.btnItem2 setTitle:@"收到的评论" forState:(UIControlStateNormal)];
            break;
        }
        case ZSwitchToolViewItemCircleSearch:
        {
            [self setItemCount:2];
            [self createButtonItem1];
            [self createButtonItem2];
            [self.btnItem1 setTitle:@"问答" forState:(UIControlStateNormal)];
            [self.btnItem2 setTitle:@"用户" forState:(UIControlStateNormal)];
            break;
        }
        case ZSwitchToolViewItemRankDetail:
        {
            [self setItemCount:2];
            [self createButtonItem1];
            [self createButtonItem2];
            [self.viewLine1 setHidden:YES];
            [self.btnItem1 setTitle:@"新三板" forState:(UIControlStateNormal)];
            [self.btnItem2 setTitle:@"人员" forState:(UIControlStateNormal)];
            break;
        }
        default: break;
    }
}

-(void)createLabelCount
{
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[ZFont systemFontOfSize:10]];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setBackgroundColor:MAINCOLOR];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setHidden:YES];
    [self.lbCount setUserInteractionEnabled:NO];
    [self addSubview:self.lbCount];
}

-(void)createButtonItem1
{
    self.btnItem1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem1 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnItem1 setTitleColor:MAINCOLOR forState:(UIControlStateHighlighted)];
    [self.btnItem1 setTag:1];
    [[self.btnItem1 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnItem1 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem1];
}

-(void)createButtonItem2
{
    self.btnItem2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem2 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnItem2 setTitleColor:BLACKCOLOR1 forState:(UIControlStateHighlighted)];
    [self.btnItem2 setTag:2];
    [[self.btnItem2 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnItem2 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem2];
}

-(void)createButtonItem3
{
    self.btnItem3 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem3 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnItem3 setTitleColor:BLACKCOLOR1 forState:(UIControlStateHighlighted)];
    [self.btnItem3 setTag:3];
    [[self.btnItem3 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnItem3 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem3];
}

-(void)createButtonItem4
{
    self.btnItem4 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem4 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnItem4 setTitleColor:BLACKCOLOR1 forState:(UIControlStateHighlighted)];
    [self.btnItem4 setTag:4];
    [[self.btnItem4 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnItem4 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnItem4];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat lineH = 2.5;
    CGFloat lineY = self.height-lineH;
    
    CGFloat btnY = 0;
    CGFloat btnH = lineY;
    CGFloat countS = 15;
    CGFloat countY = (btnH-lineH)/2-countS/2;
    switch (self.type) {
        case ZSwitchToolViewItemCircle:
        {
            [self setItemW:self.width/4];
            [self.btnItem1 setFrame:CGRectMake(0, btnY, self.itemW, btnH)];
            [self.btnItem2 setFrame:CGRectMake(self.itemW, btnY, self.itemW, btnH)];
            [self.btnItem3 setFrame:CGRectMake(self.itemW*2, btnY, self.itemW, btnH)];
            [self.btnItem4 setFrame:CGRectMake(self.itemW*3, btnY, self.itemW, btnH)];
            break;
        }
        case ZSwitchToolViewItemMyQuestion:
        {
            [self setItemW:self.width/2];
            [self.btnItem1 setFrame:CGRectMake(0, btnY, self.itemW, btnH)];
            [self.btnItem2 setFrame:CGRectMake(self.itemW, btnY, self.itemW, btnH)];
            
            [self.lbCount setFrame:CGRectMake(self.btnItem2.x+self.btnItem2.width/2+35, countY, countS, countS)];
            break;
        }
        case ZSwitchToolViewItemMyAnswer:
        {
            [self setItemW:self.width/2];
            [self.btnItem1 setFrame:CGRectMake(0, btnY, self.itemW, btnH)];
            [self.btnItem2 setFrame:CGRectMake(self.itemW, btnY, self.itemW, btnH)];
            
            [self.lbCount setFrame:CGRectMake(self.btnItem2.x+self.btnItem2.width/2+45, countY, countS, countS)];
            break;
        }
        case ZSwitchToolViewItemMyAttention:
        {
            [self setItemW:self.width/3];
            [self.btnItem1 setFrame:CGRectMake(0, btnY, self.itemW, btnH)];
            [self.btnItem2 setFrame:CGRectMake(self.itemW, btnY, self.itemW, btnH)];
            [self.btnItem3 setFrame:CGRectMake(self.itemW*2, btnY, self.itemW, btnH)];
            break;
        }
        case ZSwitchToolViewItemMyCollection:
        {
            [self setItemW:self.width/3];
            [self.btnItem1 setFrame:CGRectMake(0, btnY, self.itemW, btnH)];
            [self.btnItem2 setFrame:CGRectMake(self.itemW, btnY, self.itemW, btnH)];
            [self.btnItem3 setFrame:CGRectMake(self.itemW*2, btnY, self.itemW, btnH)];
            break;
        }
        case ZSwitchToolViewItemCircleSearch:
        {
            [self setItemW:self.width/2];
            [self.btnItem1 setFrame:CGRectMake(0, btnY, self.itemW, btnH)];
            [self.btnItem2 setFrame:CGRectMake(self.itemW, btnY, self.itemW, btnH)];
            break;
        }
        case ZSwitchToolViewItemRankDetail:
        {
            [self setItemW:self.width/2];
            [self.btnItem1 setFrame:CGRectMake(0, btnY, self.itemW, btnH)];
            [self.btnItem2 setFrame:CGRectMake(self.itemW, btnY, self.itemW, btnH)];
            break;
        }
        default: break;
    }
    [self.viewLine setFrame:CGRectMake(0, lineY, self.itemW, lineH)];
    [self.viewLine1 setFrame:CGRectMake(0, self.height-0.8, self.width, 0.8)];
    [self.lbCount setViewRoundNoBorder];
}


-(void)btnItemClick:(UIButton *)sender
{
    if (self.onItemClick) {
        self.onItemClick(sender.tag);
    }
    [self itemChange:sender.tag];
    switch (self.type) {
        case ZSwitchToolViewItemCircle:
        {
            //TODO:ZWW备注-添加友盟统计事件
            switch (sender.tag) {
                case ZCircleToolViewItemHot:
                    [MobClick event:kEvent_Circle_Recommend];
                    break;
                case ZCircleToolViewItemTopic:
                    [MobClick event:kEvent_Circle_Topic];
                    break;
                case ZCircleToolViewItemNew:
                    [MobClick event:kEvent_Circle_New];
                    break;
                case ZCircleToolViewItemDynamic:
                    [MobClick event:kEvent_Circle_Dynamic];
                    break;
                default: break;
            }
            break;
        }
        default: break;
    }
}


-(void)itemChange:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            if (self.btnItem1) {
                [self.btnItem1 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
            }
            if (self.btnItem2) {
                [self.btnItem2 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem3) {
                [self.btnItem3 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem4) {
                [self.btnItem4 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            break;
        }
        case 2:
        {
            if (self.btnItem1) {
                [self.btnItem1 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem2) {
                [self.btnItem2 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
            }
            if (self.btnItem3) {
                [self.btnItem3 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem4) {
                [self.btnItem4 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            break;
        }
        case 3:
        {
            if (self.btnItem1) {
                [self.btnItem1 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem2) {
                [self.btnItem2 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem3) {
                [self.btnItem3 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
            }
            if (self.btnItem4) {
                [self.btnItem4 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            break;
        }
        case 4:
        {
            if (self.btnItem1) {
                [self.btnItem1 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem2) {
                [self.btnItem2 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem3) {
                [self.btnItem3 setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }
            if (self.btnItem4) {
                [self.btnItem4 setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
            }
            break;
        }
        default:break;
    }
}
///设置选择默认子项
-(void)setViewSelectItemWithType:(NSInteger)item
{
    [self itemChange:item];
}
///设置按钮文字
-(void)setButtonText:(NSString *)text index:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            if (self.btnItem1) {
                [self.btnItem1 setTitle:text forState:(UIControlStateNormal)];
            }
            break;
        }
        case 2:
        {
            if (self.btnItem2) {
                [self.btnItem2 setTitle:text forState:(UIControlStateNormal)];
            }
            break;
        }
        case 3:
        {
            if (self.btnItem3) {
                [self.btnItem3 setTitle:text forState:(UIControlStateNormal)];
            }
            break;
        }
        case 4:
        {
            if (self.btnItem4) {
                [self.btnItem4 setTitle:text forState:(UIControlStateNormal)];
            }
            break;
        }
        default:
            break;
    }
}
///设置横向偏移量
-(void)setOffsetChange:(CGFloat)offX
{
    CGRect lineFrame = self.viewLine.frame;
//    CGFloat lineH = 2.5;
//    CGFloat lineY = [ZSwitchToolView getViewH]-lineH;
//    lineFrame.size.height = lineH;
//    lineFrame.origin.y = lineY;
//    lineFrame.size.width = APP_FRAME_WIDTH/self.itemCount;
    lineFrame.origin.x = offX/self.itemCount;
    [self.viewLine setFrame:lineFrame];
}
///设置对应子项显示数量
-(void)setItemCount:(int)count index:(NSInteger)index
{
    //TODO:ZWW备注-个数设置
    [self.lbCount setHidden:count==0];
    if (count < 100) {
        [self.lbCount setText:[NSString stringWithFormat:@"%d",count]];
    } else {
        [self.lbCount setText:@"99"];
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_btnItem1);
    OBJC_RELEASE(_btnItem2);
    OBJC_RELEASE(_btnItem3);
    OBJC_RELEASE(_btnItem4);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewLine1);
}

+(CGFloat)getViewH
{
    return 35;
}

@end
