//
//  ZFeekBackButtonTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackButtonTVC.h"

@interface ZFeekBackButtonTVC()

@property (strong, nonatomic) ZLabel *lbRecord;
@property (strong, nonatomic) ZButton *btnRecord;

@end

@implementation ZFeekBackButtonTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    self.cellH = [ZFeekBackButtonTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    ZButton *btnSubmit = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnSubmit setTitle:@"提交反馈" forState:(UIControlStateNormal)];
    [btnSubmit setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[btnSubmit titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [btnSubmit setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1"] forState:(UIControlStateNormal)];
    [btnSubmit setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1_c"] forState:(UIControlStateHighlighted)];
    [btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:(UIControlEventTouchUpInside)];
    [[btnSubmit layer] setMasksToBounds:true];
    [btnSubmit setViewRound:20 borderWidth:0 borderColor:CLEARCOLOR];
    
    ZView *viewSubmit = [[ZView alloc] initWithFrame:CGRectMake(self.space, 10, self.cellW-self.space*2, 40)];
    [viewSubmit setButtonShadowColorCircular];
    [self.viewMain addSubview:viewSubmit];
    
    [btnSubmit setFrame:(viewSubmit.bounds)];
    [viewSubmit addSubview:btnSubmit];
    
    CGFloat recordW = 150;
    self.btnRecord = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnRecord setFrame:(CGRectMake(self.cellW/2-recordW/2, viewSubmit.y+viewSubmit.height+8, recordW, 32))];
    [self.btnRecord addTarget:self action:@selector(btnRecordEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnRecord];
    
    self.lbRecord = [[ZLabel alloc] initWithFrame:(self.btnRecord.bounds)];
    [self.lbRecord setText:@"反馈记录"];
    [self.lbRecord setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbRecord setTextColor:COLORTEXT3];
    [self.lbRecord setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbRecord setUserInteractionEnabled:false];
    [self.btnRecord addSubview:self.lbRecord];
}
-(void)btnSubmitClick
{
    if (self.onSubmitEvent) {
        self.onSubmitEvent();
    }
}
-(void)btnRecordEvent
{
    if (self.onRecordEvent) {
        self.onRecordEvent();
    }
}
///是否有新回复
-(void)setIsNewReply:(BOOL)isNewReply
{
    if (isNewReply) {
        [self.lbRecord setText:@"反馈记录 (有新回复)"];
        [self.lbRecord setTextColor:COLORTEXT2];
        [self.lbRecord setLabelColorWithRange:(NSMakeRange(0, 4)) color:COLORTEXT3];
    } else {
        [self.lbRecord setText:@"反馈记录"];
        [self.lbRecord setTextColor:COLORTEXT3];
    }
}
+(CGFloat)getH
{
    return 130;
}

@end
