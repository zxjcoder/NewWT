//
//  ZButtonTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButtonTVC.h"

@interface ZButtonTVC()

@property (strong, nonatomic) ZButton *btnSubmit;

@end

@implementation ZButtonTVC

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
    
    self.cellH = [ZButtonTVC getH];
    
    self.btnSubmit = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSubmit setViewRoundWithRound];
    [self.btnSubmit setTitle:kSubmit forState:(UIControlStateNormal)];
    [self.btnSubmit setTitle:kSubmit forState:(UIControlStateHighlighted)];
    [self.btnSubmit setBackgroundColor:MAINCOLOR];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnSubmit];
    
    CGFloat btnH = 40;
    [self.btnSubmit setFrame:CGRectMake(self.space, self.cellH/2-btnH/2, self.cellW-self.space*2, btnH)];
}
-(void)btnSubmitClick
{
    if (self.onSubmitClick) {
        self.onSubmitClick();
    }
}
-(void)setCellBackGroundColor:(UIColor *)color
{
    [self.viewMain setBackgroundColor:color];
}
-(void)setButtonText:(NSString *)text
{
    [self.btnSubmit setTitle:text forState:(UIControlStateNormal)];
    [self.btnSubmit setTitle:text forState:(UIControlStateHighlighted)];
}
-(void)setViewNil
{
    OBJC_RELEASE(_btnSubmit);
    OBJC_RELEASE(_onSubmitClick);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 45;
}

@end
