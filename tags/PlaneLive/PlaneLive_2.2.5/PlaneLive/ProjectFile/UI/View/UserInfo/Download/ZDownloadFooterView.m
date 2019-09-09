//
//  ZDownloadFooterView.m
//  PlaneLive
//
//  Created by Daniel on 10/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDownloadFooterView.h"
#import "ZButton.h"

@interface ZDownloadFooterView()

/// 合计区域
@property (strong, nonatomic) UIView *viewAll;
/// 合计金额
@property (strong, nonatomic) UILabel *lbAll;
/// 全选
@property (strong, nonatomic) ZButton *btnSelectAll;
/// 删除
@property (strong, nonatomic) ZButton *btnDelete;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZDownloadFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setAllShadowColor];
    
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    [self addSubview:self.imgLine];
    
    self.viewAll = [[UIView alloc] initWithFrame:CGRectMake(0, kLineHeight, self.width, self.height-kLineHeight)];
    [self.viewAll setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewAll];
    
    CGFloat btnSize = 45;
    self.btnSelectAll = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSelectAll setFrame:CGRectMake(kSize1, self.height/2-btnSize/2, btnSize, btnSize)];
    [self.btnSelectAll setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnSelectAll setSelected:false];
    [self.btnSelectAll setImage:[SkinManager getImageWithName:@"checkbox"] forState:(UIControlStateNormal)];
    [self.btnSelectAll setImage:[SkinManager getImageWithName:@"checkbox_s"] forState:(UIControlStateSelected)];
    [self.btnSelectAll addTarget:self action:@selector(btnSelectAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewAll addSubview:self.btnSelectAll];
    
    CGFloat priceX = self.btnSelectAll.x+self.btnSelectAll.width;
    CGFloat priceW = self.width-priceX - 105;
    CGFloat priceH = 25;
    CGFloat priceY = self.height/2-priceH/2;
    self.lbAll = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, priceW, priceH)];
    [self.lbAll setText:[NSString stringWithFormat:@"%@  已选择0条", kSelectAll]];
    [self.lbAll setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbAll setTextColor:COLORTEXT3];
    [self.lbAll setLabelColorWithRange:NSMakeRange(0, 2) color:COLORTEXT2];
    [self.viewAll addSubview:self.lbAll];
    
    self.btnDelete = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDelete setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2"] forState:(UIControlStateNormal)];
    [self.btnDelete setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2_c"] forState:(UIControlStateHighlighted)];
    [self.btnDelete setFrame:CGRectMake(self.width - 20 - 85, self.height / 2 - 30 / 2, 85, 30)];
    [[self.btnDelete titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnDelete setTitle:kDelete forState:(UIControlStateNormal)];
    [self.btnDelete setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[self.btnDelete layer] setMasksToBounds:true];
    [self.btnDelete setViewRound:14 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewAll addSubview:self.btnDelete];
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

@end




