//
//  ZDownloadFooterView.m
//  PlaneLive
//
//  Created by Daniel on 10/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDownloadFooterView.h"
#import "ZButton.h"
#import "ZShadowButtonView.h"

@interface ZDownloadFooterView()

/// 合计区域
@property (strong, nonatomic) UIView *viewContent;
/// 合计金额
@property (strong, nonatomic) UILabel *lbAll;
/// 全选
@property (strong, nonatomic) ZButton *btnSelectAll;
/// 删除
@property (strong, nonatomic) ZShadowButtonView *btnDelete;

@end

@implementation ZDownloadFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [self setAllShadowColor];
    [self setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 55)];
    [self addSubview:self.viewContent];
    
    CGFloat btnSize = 45;
    self.btnSelectAll = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSelectAll setFrame:CGRectMake(kSize1, self.height/2-btnSize/2, btnSize, btnSize)];
    [self.btnSelectAll setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnSelectAll setSelected:false];
    [self.btnSelectAll setImage:[SkinManager getImageWithName:@"checkbox"] forState:(UIControlStateNormal)];
    [self.btnSelectAll setImage:[SkinManager getImageWithName:@"checkbox_s"] forState:(UIControlStateSelected)];
    [self.btnSelectAll addTarget:self action:@selector(btnSelectAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSelectAll];
    
    CGFloat priceX = self.btnSelectAll.x+self.btnSelectAll.width-5;
    CGFloat priceW = self.width-priceX - 105;
    CGFloat priceH = 25;
    CGFloat priceY = self.height/2-priceH/2;
    self.lbAll = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, priceW, priceH)];
    [self.lbAll setText:[NSString stringWithFormat:@"%@  已选择0条", kSelectAll]];
    [self.lbAll setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbAll setTextColor:COLORTEXT3];
    [self.lbAll setUserInteractionEnabled:false];
    [self.lbAll setLabelColorWithRange:NSMakeRange(0, 2) color:COLORTEXT2];
    [self.viewContent addSubview:self.lbAll];
    
    self.btnDelete = [[ZShadowButtonView alloc] initWithFrame:CGRectMake(self.width - 20 - 80, self.height / 2 - 32 / 2, 80, 32)];
    [self.btnDelete setButtonTitle:@"删除"];
    [self.btnDelete setButtonBGImage:@"btn_gra2"];
    ZWEAKSELF
    [self.btnDelete setOnButtonClick:^{
        [weakSelf btnDeleteClick];
    }];
    [self.viewContent addSubview:self.btnDelete];
}
-(void)btnDeleteClick
{
    if (self.onDeleteClick) {
        self.onDeleteClick();
    }
}
-(void)btnSelectAllClick
{
    [self setViewCheckStatus:!self.btnSelectAll.selected];
    if (self.onCheckAllClick) {
        self.onCheckAllClick(self.btnSelectAll.selected);
    }
}
-(void)setSelectCount:(NSInteger)count
{
    [self.lbAll setText:[NSString stringWithFormat:@"%@  已选择%d条", kSelectAll, count]];
    [self.lbAll setTextColor:COLORTEXT3];
    [self.lbAll setLabelColorWithRange:NSMakeRange(0, 2) color:COLORTEXT2];
}
/// 选中状态
-(void)setViewCheckStatus:(BOOL)check
{
    [self.btnSelectAll setSelected:check];
}
/// 获取View高度
+(CGFloat)getH
{
    if (IsIPhoneX) {
        return 55+kIPhoneXButtonHeight;
    }
    return 55;
}
@end




