//
//  ZReportView.m
//  PlaneCircle
//
//  Created by Daniel on 7/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZReportView.h"
#import "ZButton.h"
#import "ClassCategory.h"

@interface ZReportView()

///背景
@property (strong, nonatomic) UIView *viewBG;
///内容
@property (strong, nonatomic) UIView *viewContent;

///垃圾内容分割线
@property (strong, nonatomic) UIView *viewLine1;
///不友善内容分割线
@property (strong, nonatomic) UIView *viewLine2;
///违法信息分割线
@property (strong, nonatomic) UIView *viewLine3;
///政治敏感分割线
@property (strong, nonatomic) UIView *viewLine4;
///底部区域
@property (strong, nonatomic) UIView *viewBottom;
///垃圾内容
@property (strong, nonatomic) ZButton *btnItem1;
///不友善内容
@property (strong, nonatomic) ZButton *btnItem2;
///违法信息
@property (strong, nonatomic) ZButton *btnItem3;
///政治敏感
@property (strong, nonatomic) ZButton *btnItem4;
///其他
@property (strong, nonatomic) ZButton *btnOther;
///清楚
@property (strong, nonatomic) ZButton *btnCancel;
///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;
///内容坐标
@property (assign, nonatomic) CGRect contentFrame;

@end

@implementation ZReportView

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self getBgView];
    [self getContentView];
    
    self.btnItem1 = [[ZButton alloc] initWithReportType:(ZReportViewTypeLJGG)];
    [self.btnItem1 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnItem1];
    
    self.btnItem2 = [[ZButton alloc] initWithReportType:(ZReportViewTypeBYSNR)];
    [self.btnItem2 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnItem2];
    
    self.btnItem3 = [[ZButton alloc] initWithReportType:(ZReportViewTypeWFXX)];
    [self.btnItem3 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnItem3];
    
    self.btnItem4 = [[ZButton alloc] initWithReportType:(ZReportViewTypeZZMG)];
    [self.btnItem4 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnItem4];
    
    self.btnOther = [[ZButton alloc] initWithReportType:(ZReportViewTypeOther)];
    [self.btnOther addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnOther];
    
    self.viewBottom= [[UIView alloc] init];
    [self.viewBottom setBackgroundColor:RGBCOLOR(255, 246, 241)];
    [self.viewContent addSubview:self.viewBottom];
    
    self.btnCancel = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnCancel setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBottom addSubview:self.btnCancel];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine2];
    
    self.viewLine3 = [[UIView alloc] init];
    [self.viewLine3 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine3];
    
    self.viewLine4 = [[UIView alloc] init];
    [self.viewLine4 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine4];
    
    [self setViewFrame];
}

-(void)getBgView
{
    self.viewBG = [[UIView alloc] init];
    [self.viewBG setBackgroundColor:BLACKCOLOR];
    [self.viewBG setAlpha:0.4f];
    [self addSubview:self.viewBG];
    
    UITapGestureRecognizer *viewBGTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTap:)];
    [self.viewBG addGestureRecognizer:viewBGTap];
}

-(void)getContentView
{
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewContent];
    
    [self sendSubviewToBack:self.viewBG];
}
-(void)btnItemClick:(ZButton *)sender
{
    switch (sender.tag) {
        case ZReportViewTypeOther:
        {
            if (self.onOtherClick) {
                self.onOtherClick();
            }
            break;
        }
        default:
        {
            if (self.onSubmitClick) {
                self.onSubmitClick(sender.getText);
            }
            break;
        }
    }
    [self dismiss];
}
-(void)viewBGTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
-(void)btnCancelClick
{
    if (self.onCancelClick) {
        self.onCancelClick();
    }
    [self dismiss];
}
-(void)setViewFrame
{
    [self.viewBG setFrame:self.bounds];
    
    CGFloat viewW = self.viewBG.width;
    CGFloat btnH = 45;
    CGFloat lineH = 0.5;
    [self.btnItem1 setFrame:CGRectMake(0, 0, viewW, btnH)];
    [self.viewLine1 setFrame:CGRectMake(0, self.btnItem1.y+self.btnItem1.height, viewW, lineH)];
    
    [self.btnItem2 setFrame:CGRectMake(0, self.viewLine1.y+self.viewLine1.height, viewW, btnH)];
    [self.viewLine2 setFrame:CGRectMake(0, self.btnItem2.y+self.btnItem2.height, viewW, lineH)];
    
    [self.btnItem3 setFrame:CGRectMake(0, self.viewLine2.y+self.viewLine2.height, viewW, btnH)];
    [self.viewLine3 setFrame:CGRectMake(0, self.btnItem3.y+self.btnItem3.height, viewW, lineH)];
    
    [self.btnItem4 setFrame:CGRectMake(0, self.viewLine3.y+self.viewLine3.height, viewW, btnH)];
    [self.viewLine4 setFrame:CGRectMake(0, self.btnItem4.y+self.btnItem4.height, viewW, lineH)];
    
    [self.btnOther setFrame:CGRectMake(0, self.viewLine4.y+self.viewLine4.height, viewW, btnH)];
    
    CGFloat bottomY = self.btnOther.y+self.btnOther.height;
    [self.viewBottom setFrame:CGRectMake(0, bottomY, viewW, btnH)];
    
    [self.btnCancel setFrame:CGRectMake(0, 0, viewW, btnH)];
 
    self.contentFrame = CGRectMake(0, self.viewBG.height, self.viewBG.width, bottomY+self.viewBottom.height);
    
    [self.viewContent setFrame:self.contentFrame];
}
-(void)setViewNil
{
    OBJC_RELEASE(_btnItem1);
    OBJC_RELEASE(_btnItem2);
    OBJC_RELEASE(_btnItem3);
    OBJC_RELEASE(_btnItem4);
    OBJC_RELEASE(_btnOther);
    OBJC_RELEASE(_btnCancel);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_viewLine3);
    OBJC_RELEASE(_viewLine4);
    OBJC_RELEASE(_viewBottom);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewBG);
}
-(void)dealloc
{
    [self setViewNil];
}
///显示
-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.viewBG setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        CGRect cFrame = self.contentFrame;
        cFrame.origin.y = cFrame.origin.y-cFrame.size.height;
        [self.viewBG setAlpha:0.4f];
        [self.viewContent setFrame:cFrame];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}
///隐藏
-(void)dismiss
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.viewBG setAlpha:0];
        [self.viewContent setFrame:CGRectMake(0, self.viewBG.height, self.viewContent.width, self.viewContent.height)];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
        [self setViewNil];
        [self removeFromSuperview];
    }];
}

@end
