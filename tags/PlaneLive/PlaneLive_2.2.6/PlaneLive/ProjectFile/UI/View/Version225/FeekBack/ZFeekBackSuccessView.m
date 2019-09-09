//
//  ZFeekBackSuccessView.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackSuccessView.h"

@interface ZFeekBackSuccessView()

@property (strong, nonatomic) NSString *content;

@end

@implementation ZFeekBackSuccessView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContent:title];
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat imageSize = 130;
    ZImageView *imageView = [[ZImageView alloc] initWithFrame:(CGRectMake(self.width/2-imageSize/2, 37, imageSize, imageSize))];
    /// TODO: ZWW - 缺省图
    [imageView setImage:[SkinManager getImageWithName:@"default_feedback"]];
    [self addSubview:imageView];
    
    CGFloat itemSpace = 23;
    CGRect titleFrame = CGRectMake(20, imageView.y+imageView.height+itemSpace, self.width-40, 18);
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:(titleFrame)];
    [lbTitle setTextColor:COLORTEXT3];
    [lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [lbTitle setText:self.content];
    [lbTitle setNumberOfLines:0];
    [self addSubview:lbTitle];
    
    titleFrame.size.height = [lbTitle getLabelHeightWithMinHeight:18];
    lbTitle.frame = titleFrame;
    
    CGFloat btnW = 140;
    CGFloat btnH = 36;
    UIButton *btnRecord = [[UIButton alloc] initWithFrame:(CGRectMake(self.width/2-btnW/2, lbTitle.y+lbTitle.height+itemSpace, btnW, btnH))];
    [btnRecord setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra1_36"] forState:(UIControlStateNormal)];
    [btnRecord setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra1_36_c"] forState:(UIControlStateHighlighted)];
    [btnRecord setTitle:@"查看反馈记录" forState:(UIControlStateNormal)];
    [btnRecord setTitleColor:COLORCONTENT1 forState:UIControlStateNormal];
    [[btnRecord titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnRecord addTarget:self action:@selector(btnRecordClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnRecord];
}
/// 设置提示语
-(void)setPromptText:(NSString *)prompt
{
    
}
-(void)btnRecordClick
{
    if (self.onSayRecordClick) {
        self.onSayRecordClick();
    }
}

@end
