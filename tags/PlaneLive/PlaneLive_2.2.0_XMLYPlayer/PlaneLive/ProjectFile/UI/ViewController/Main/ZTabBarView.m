//
//  ZTabBarView.m
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTabBarView.h"
#import "ZTabBarButton.h"
#import "Utils.h"

@interface ZTabBarView()

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, weak) UIButton *selectedButton;

@property (nonatomic, strong) UIImageView *imgLine;

@end

@implementation ZTabBarView

- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgLine = [UIImageView getSLineView];
        
        [self addSubview:self.imgLine];
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    for (UITabBarItem * item in _items) {
        ZTabBarButton *btnItem = [ZTabBarButton buttonWithType:UIButtonTypeCustom];
        btnItem.item = item;
        
        btnItem.tag = self.buttons.count;
        
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchDown];
        
        if (btnItem.tag == 0) {
            [self btnItemClick:btnItem];
        }
        
        [self addSubview:btnItem];
        [self.buttons addObject:btnItem];
    }
}

// 点击tabBarButton调用
-(void)btnItemClick:(UIButton *)sender
{
    _selectedButton.selected = NO;
    sender.selected = YES;
    _selectedButton = sender;
    
    // 通知tabBarVc切换控制器，
    if (self.onTabBarItemClick) {
        self.onTabBarItemClick(sender.tag);
    }
}

// self.items UITabBarItem模型，有多少个子控制器就有多少个UITabBarItem模型
// 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgLine setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = 65;
    CGFloat btnH = self.height;
    CGFloat space = (self.bounds.size.width-(btnW*5))/6;
    
    int i = 0;
    // 设置tabBarButton的frame
    for (ZTabBarButton *tabBarButton in self.buttons) {
        if (i == 2) {
            [tabBarButton setIsMiddle:YES];
        }
        btnX = space * (i+1) + i * btnW;
        tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
        i++;
    }
}

@end
