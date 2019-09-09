//
//  ZNavigationBarView.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZNavigationBarView.h"
#import "objc/runtime.h"
#import "ClassCategory.h"

@interface ZNavigationBarView()

@property (retain,nonatomic) UILabel *titleLabel;

@property (copy, nonatomic) onBackButtonClick backClick;

@property (retain, nonatomic) UIButton *btnBack;
@property (retain, nonatomic) UIButton *btnRight;

@end

@implementation ZNavigationBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:NAVIGATION_BACKCOLOR1];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        lineView.backgroundColor = TABLEVIEWCELL_LINECOLOR;
        [self addSubview:lineView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, self.width-120, 35)];
        self.titleLabel.text = self.title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = NAVIGATION_BACKCOLOR2;
        self.titleLabel.font = [ZFont boldSystemFontOfSize:kFont_Huge_Size];
        [self.titleLabel setTag:1000];
        [self addSubview:_titleLabel];
        
        self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnBack setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
        [self.btnBack setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateHighlighted];
        [self.btnBack setFrame:CGRectMake(0, 10, 60, 54)];
        [self.btnBack setImageEdgeInsets:(UIEdgeInsetsMake(15, 10, 0, 10))];
        [self.btnBack setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [self.btnBack setTag:1001];
        [self.btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.btnBack setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self addSubview:self.btnBack];
    }
    return self;
}
-(void)btnBackClick:(UIButton*)button
{
    if (self.backClick) {
        self.backClick(button);
    }
}
-(void)setBackButtonClick:(onBackButtonClick)block
{
    self.backClick = block;
}
-(void)setHiddenBackButton:(BOOL)hidden
{
    [self.btnBack setHidden:hidden];
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    if (!title) {
        _titleLabel.text = nil;
        return;
    }
    if ([title isEqualToString:_titleLabel.text]) {
        return;
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping;
    }
    _titleLabel.text = title;
    [self setNeedsDisplay];
}

@end

@implementation UIViewController (ZNavigationBarView)

@dynamic navigationBar;
@dynamic navigationBarHidden;
@dynamic title;

-(ZNavigationBarView *)navigationBar
{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setNavigationBar:(ZNavigationBarView *)navigationBar
{
    objc_setAssociatedObject(self, @selector(navigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isNavigationBar
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    objc_setAssociatedObject(self, @selector(isNavigationBar), @(navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}
-(NSString *)title
{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setTitle:(NSString *)title
{
    objc_setAssociatedObject(self, @selector(title), title, OBJC_ASSOCIATION_COPY);
}

@end

