//
//  ZDownloadFooterView.m
//  PlaneLive
//
//  Created by Daniel on 10/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDownloadFooterView.h"

@interface ZDownloadFooterView()

@property (strong, nonatomic) UIButton *btnDelete;

@property (strong, nonatomic) UILabel *lbSelCount;

@end

@implementation ZDownloadFooterView

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
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    self.lbSelCount = [[UILabel alloc] initWithFrame:CGRectMake(kSizeSpace, self.height/2-25/2, 100, 25)];
    [self.lbSelCount setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.lbSelCount setNumberOfLines:1];
    [self.lbSelCount setTextColor:BLACKCOLOR];
    [self.lbSelCount setText:[NSString stringWithFormat:kHasBeenSelectedStrip, 0]];
    [self.lbSelCount setLabelColorWithRange:NSMakeRange(3, self.lbSelCount.text.length-4) color:SPEAKERCOLOR];
    [self.lbSelCount setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbSelCount];
    
    self.btnDelete = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDelete setUserInteractionEnabled:YES];
    [self.btnDelete setTitle:kDelete forState:(UIControlStateNormal)];
    [self.btnDelete setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnDelete titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnDelete setFrame:CGRectMake(self.width-65, 7.5, 55, 30)];
    [self.btnDelete setViewRound:kVIEW_ROUND_SIZE borderWidth:1 borderColor:MAINCOLOR];
    [self addSubview:self.btnDelete];
}
-(void)btnDeleteClick
{
    if (self.onDeleteClick) {
        self.onDeleteClick();
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_onDeleteClick);
    OBJC_RELEASE(_btnDelete);
    OBJC_RELEASE(_lbSelCount);
}

/// 设置总记录数
-(void)setDownloadSelCount:(int)count
{
    [self.lbSelCount setTextColor:BLACKCOLOR];
    [self.lbSelCount setText:[NSString stringWithFormat:kHasBeenSelectedStrip, count]];
    [self.lbSelCount setLabelColorWithRange:NSMakeRange(3, self.lbSelCount.text.length-4) color:SPEAKERCOLOR];
}

/// 获取View高度
+(CGFloat)getH
{
    return 45;
}

@end
