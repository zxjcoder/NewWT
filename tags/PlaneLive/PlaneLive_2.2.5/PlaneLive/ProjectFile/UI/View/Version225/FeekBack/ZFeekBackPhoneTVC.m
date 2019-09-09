//
//  ZFeekBackPhoneTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackPhoneTVC.h"
#import "ZTextField.h"

@interface ZFeekBackPhoneTVC()

@property (strong, nonatomic) ZLabel *lbPhone;
@property (strong, nonatomic) ZTextField *textPhone;

@end

@implementation ZFeekBackPhoneTVC

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
    self.cellH = [ZFeekBackPhoneTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbPhone = [[ZLabel alloc] init];
    [self.lbPhone setTextColor:COLORTEXT3];
    [self.lbPhone setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbPhone];
    
    self.textPhone = [[ZTextField alloc] init];
    [self.textPhone setKeyboardType:(UIKeyboardTypePhonePad)];
    ZWEAKSELF
    [self.textPhone setOnBeginEditText:^{
        if (weakSelf.onBeginEditText) {
            weakSelf.onBeginEditText();
        }
    }];
    [self.viewMain addSubview:self.textPhone];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale==3) {
        [self.lbPhone setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, 90, self.lbH)];
    } else {
        [self.lbPhone setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, 80, self.lbH)];
    }
    CGFloat textX = self.lbPhone.x+self.lbPhone.width;
    CGFloat textW = self.cellW - textX - self.space;
    CGFloat textH = 32;
    CGFloat textY = self.cellH/2-textH/2;
    
    [self.textPhone setViewFrame:CGRectMake(textX, textY, textW, textH)];
    
    [self.lbPhone setText:@"联系手机号:"];
    [self.textPhone setPlaceholder:@"请输入联系手机号"];
}
-(NSString *)getText
{
    return self.textPhone.text;
}
-(void)setText:(NSString *)text
{
    [self.textPhone setText:text];
}
+(CGFloat)getH
{
    return 40;
}

@end
