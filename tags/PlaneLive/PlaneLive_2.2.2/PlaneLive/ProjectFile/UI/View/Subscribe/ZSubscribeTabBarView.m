//
//  ZSubscribeTabBarView.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeTabBarView.h"
#import "ZButton.h"

#define kZSubscribeTabBarViewHeight 45

@interface ZSubscribeTabBarView()

/// 分割线
@property (strong, nonatomic) UIImageView *imgline1;
/// 试读
@property (strong, nonatomic) ZButton *btnProbation;
/// 试读
@property (strong, nonatomic) ZButton *btnSubscribe;
/// 分割线
@property (strong, nonatomic) UIImageView *imgline2;

@end

@implementation ZSubscribeTabBarView

///初始化  0试读,订阅 1订阅
-(instancetype)initWithPoint:(CGPoint)point type:(int)type
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, APP_FRAME_WIDTH, kZSubscribeTabBarViewHeight)];
    if (self) {
        switch (type) {
            case 0:
                [self innerInit];
                break;
            case 1:
                [self innerInitWithShare];
                break;
        }
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.imgline1 = [UIImageView getDLineView];
    [self.imgline1 setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    [self addSubview:self.imgline1];
    
    self.imgline2 = [UIImageView getDLineView];
    [self.imgline2 setFrame:CGRectMake(self.width/2, 0, kLineHeight, self.height)];
    [self addSubview:self.imgline2];
    
    self.btnProbation = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnProbation setFrame:CGRectMake(0, 0, self.width/2, self.height)];
    [self.btnProbation setTitle:kProbation forState:(UIControlStateNormal)];
    [self.btnProbation setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[self.btnProbation titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnProbation setTag:2];
    [self.btnProbation addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnProbation];
    
    self.btnSubscribe = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSubscribe setFrame:CGRectMake(self.width/2, 0, self.width/2, self.height)];
    [self.btnSubscribe setTitle:kPayCartMoney forState:(UIControlStateNormal)];
    [self.btnSubscribe setBackgroundColor:MAINCOLOR];
    [[self.btnSubscribe titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnSubscribe setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnSubscribe setTag:3];
    [self.btnSubscribe addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnSubscribe];
}

-(void)innerInitWithShare
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.imgline1 = [UIImageView getDLineView];
    [self.imgline1 setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    [self addSubview:self.imgline1];
    
    self.btnSubscribe = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSubscribe setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.btnSubscribe setTitle:kPayCartMoney forState:(UIControlStateNormal)];
    [self.btnSubscribe setBackgroundColor:MAINCOLOR];
    [[self.btnSubscribe titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnSubscribe setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnSubscribe setTag:3];
    [self.btnSubscribe addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnSubscribe];
}
-(void)btnItemClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 2:
            if (self.onProbationClick) {
                self.onProbationClick();
            }
            break;
        case 3:
            if (self.onSubscribeClick) {
                self.onSubscribeClick();
            }
            break;
        default:
            break;
    }
}
///设置数据
-(void)setViewDataWithModel:(ModelSubscribe *)model
{
    NSString *btnText = kPayCartMoney;
    if (model) {
        if (model.units && model.units.length > 0) {
            [self.btnSubscribe setTitle:[NSString stringWithFormat:@"%@ ¥%.2f/%@", btnText, [model.price floatValue], model.units] forState:(UIControlStateNormal)];
        } else {
            [self.btnSubscribe setTitle:[NSString stringWithFormat:@"%@ ¥%.2f", btnText, [model.price floatValue]] forState:(UIControlStateNormal)];
        }
    } else {
        [self.btnSubscribe setTitle:btnText forState:(UIControlStateNormal)];
    }
}
///设置数据
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model
{
    NSString *btnText = kPayCartMoney;
    if (model) {
        if (model.units && model.units.length > 0) {
            [self.btnSubscribe setTitle:[NSString stringWithFormat:@"%@ ¥%.2f/%@", btnText, [model.price floatValue], model.units] forState:(UIControlStateNormal)];
        } else {
            [self.btnSubscribe setTitle:[NSString stringWithFormat:@"%@ ¥%.2f", btnText, [model.price floatValue]] forState:(UIControlStateNormal)];
        }
    } else {
        [self.btnSubscribe setTitle:btnText forState:(UIControlStateNormal)];
    }
}
///获取高度
+(CGFloat)getViewHeight
{
    return kZSubscribeTabBarViewHeight;
}

-(void)dealloc
{
    OBJC_RELEASE(_imgline1);
    OBJC_RELEASE(_imgline2);
    OBJC_RELEASE(_btnProbation);
    OBJC_RELEASE(_btnSubscribe);
    OBJC_RELEASE(_onProbationClick);
    OBJC_RELEASE(_onSubscribeClick);
}

@end
