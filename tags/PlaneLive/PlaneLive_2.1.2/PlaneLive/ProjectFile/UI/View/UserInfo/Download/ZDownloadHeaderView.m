//
//  ZDownloadHeaderView.m
//  PlaneLive
//
//  Created by Daniel on 10/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDownloadHeaderView.h"

#define kDownloadButtonHeight 35

@interface ZDownloadHeaderView()

@property (strong, nonatomic) UIButton *btnCheck;

@property (strong, nonatomic) UILabel *lbMaxCount;

@property (strong, nonatomic) UIButton *btnDelete;

@property (strong, nonatomic) UIButton *btnCancel;

@property (assign, nonatomic) int maxCount;

@end

@implementation ZDownloadHeaderView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

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
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    
    CGFloat btnSize = kDownloadButtonHeight;
    self.btnCheck = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_normal"] forState:(UIControlStateNormal)];
    [self.btnCheck setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnCheck setTag:1];
    [self.btnCheck setHidden:YES];
    [self.btnCheck setFrame:CGRectMake(-btnSize, 0, btnSize, btnSize)];
    [self.btnCheck addTarget:self action:@selector(btnCheckClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnCheck];
    
    self.lbMaxCount = [[UILabel alloc] initWithFrame:CGRectMake(kSizeSpace, 5, 100, 25)];
    [self.lbMaxCount setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.lbMaxCount setNumberOfLines:1];
    [self.lbMaxCount setTextColor:BLACKCOLOR];
    [self.lbMaxCount setText:[NSString stringWithFormat:kTotalStrip, 0]];
    [self.lbMaxCount setLabelColorWithRange:NSMakeRange(1, self.lbMaxCount.text.length-2) color:SPEAKERCOLOR];
    [self.lbMaxCount setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbMaxCount];
    
    self.btnDelete = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDelete setTitle:kDeleteAll forState:(UIControlStateNormal)];
    [self.btnDelete setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[self.btnDelete titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnDelete setFrame:CGRectMake(self.width-60, 0, 55, kDownloadButtonHeight)];
    [self addSubview:self.btnDelete];
    
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel setTitle:kCancel forState:(UIControlStateNormal)];
    [self.btnCancel setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnCancel setFrame:CGRectMake(self.width-60, 0, 55, kDownloadButtonHeight)];
    [self.btnCancel setHidden:YES];
    [self addSubview:self.btnCancel];
}
/// 获取总记录数
-(int)getDownloadMaxCount
{
    return self.maxCount;
}
-(void)setDownloadMaxCount:(int)count
{
    [self setMaxCount:count];
    
    [self.btnDelete setEnabled:count!=0];
    [self.lbMaxCount setText:[NSString stringWithFormat:kTotalStrip, count]];
    [self.lbMaxCount setTextColor:BLACKCOLOR];
    [self.lbMaxCount setLabelColorWithRange:NSMakeRange(1, self.lbMaxCount.text.length-2) color:SPEAKERCOLOR];
    
    [self setNeedsDisplay];
}
/// 取消全选
-(void)setCancelCheckAll
{
    [self btnCancelClick];
}
/// 设置选中按钮
-(void)setCheckAllStatus:(BOOL)checkAll
{
    if (checkAll) {
        [self.btnCheck setTag:2];
        [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_select"] forState:(UIControlStateNormal)];
    } else {
        [self.btnCheck setTag:1];
        [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_normal"] forState:(UIControlStateNormal)];
    }
}

-(void)btnCheckClick
{
    if (self.onCheckClick) {
        self.onCheckClick(self.btnCheck.tag==1);
    }
    [self setCheckAllStatus:self.btnCheck.tag==1];
}

-(void)btnDeleteClick
{
    [self setShowCancelButton];
    if (self.onDeleteClick) {
        self.onDeleteClick();
    }
}

-(void)btnCancelClick
{
    [self setDismissCancelButton];
    if (self.onCancelClick) {
        self.onCancelClick();
    }
}
-(void)setShowCancelButton
{
    [self.btnCancel setAlpha:0];
    [self.btnCancel setHidden:NO];
    [self.btnCheck setHidden:NO];
    [self.btnCheck setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.btnCancel setAlpha:1];
        [self.btnDelete setAlpha:0];
        [self.btnCheck setAlpha:1];
        CGFloat btnSize = kDownloadButtonHeight;
        [self.btnCheck setFrame:CGRectMake(0, 0, btnSize, btnSize)];
        [self.lbMaxCount setFrame:CGRectMake(btnSize, self.height/2-25/2, 100, 25)];
    } completion:^(BOOL finished) {
        [self.btnDelete setHidden:YES];
    }];
}
-(void)setDismissCancelButton
{
    [self.btnDelete setAlpha:0];
    [self.btnDelete setHidden:NO];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.btnDelete setAlpha:1];
        [self.btnCancel setAlpha:0];
        [self.btnCheck setAlpha:0];
        CGFloat btnSize = kDownloadButtonHeight;
        [self.btnCheck setFrame:CGRectMake(-btnSize, 0, btnSize, btnSize)];
        [self.lbMaxCount setFrame:CGRectMake(kSizeSpace, 5, 100, 25)];
    } completion:^(BOOL finished) {
        [self.btnCancel setHidden:YES];
        [self.btnCheck setHidden:YES];
    }];
}
-(void)dealloc
{
    OBJC_RELEASE(_lbMaxCount);
    OBJC_RELEASE(_btnCheck);
    OBJC_RELEASE(_btnCancel);
    OBJC_RELEASE(_btnDelete);
}
+(CGFloat)getH
{
    return 35;
}

@end
