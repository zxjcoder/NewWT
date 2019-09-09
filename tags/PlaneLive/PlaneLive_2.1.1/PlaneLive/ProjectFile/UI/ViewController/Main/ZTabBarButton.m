//
//  ZTabBarButton.m
//  PlaneLive
//
//  Created by Daniel on 27/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTabBarButton.h"
#import "ZTabBarBadge.h"

@interface ZTabBarButton()

@property (nonatomic, weak) ZTabBarBadge *badgeView;

@end

@implementation ZTabBarButton

// 重写setHighlighted，取消高亮做的事情
- (void)setHighlighted:(BOOL)highlighted{}

// 懒加载badgeView
- (ZTabBarBadge *)badgeView
{    
    if (_badgeView == nil) {
        
        ZTabBarBadge *btn = [ZTabBarBadge buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:btn];
        
        _badgeView = btn;
    }
    
    return _badgeView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置字体颜色
        [self setTitleColor:DESCCOLOR forState:UIControlStateNormal];
        [self setTitleColor:MAINCOLOR forState:UIControlStateSelected];
        // 图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:9];
        
    }
    return self;
}
// 传递UITabBarItem给tabBarButton,给tabBarButton内容赋值
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
    // KVO：时刻监听一个对象的属性有没有改变
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

// 只要监听的属性一有新值，就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setTitle:_item.title forState:UIControlStateNormal];
    
    [self setImage:_item.image forState:UIControlStateNormal];
    
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    
    // 设置badgeValue
    self.badgeView.badgeValue = _item.badgeValue;
}

// 修改按钮内部子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.imageView
    CGFloat imageX = self.width/2-25/2;
    CGFloat imageY = 7;
    CGFloat imageW = 25;
    CGFloat imageH = 23;
    
    // 2.title
    CGFloat titleX = 0;
    CGFloat titleY = imageY + imageH;
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = self.bounds.size.height - titleY;
    if (self.isMiddle) {
        imageX = self.width/2-54/2;
        imageY = -10;
        imageW = 54;
        imageH = 54;
        
        titleX = 0;
        titleY = 0;
        titleW = 0;
        titleH = 0;
    }
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    // 3.badgeView
    self.badgeView.x = self.width - self.badgeView.width - 10;
    self.badgeView.y = 0;
}

@end
