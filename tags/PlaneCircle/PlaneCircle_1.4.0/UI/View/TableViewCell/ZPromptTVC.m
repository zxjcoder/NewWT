//
//  ZPromptTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPromptTVC.h"

@interface ZPromptTVC()
{
    NSTimer *_timer;
}
@property (strong, nonatomic) UILabel *lbError;

@end

@implementation ZPromptTVC

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
    
    self.cellH = self.getH;
    
    self.lbError = [[UILabel alloc] init];
    [self.lbError setBackgroundColor:RGBCOLOR(225, 219, 212)];
    [self.lbError setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbError setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbError setTextColor:RGBCOLOR(100, 100, 100)];
    [self.lbError setHidden:YES];
    [self.viewMain addSubview:self.lbError];
}

-(void)setErrorText:(NSString *)text
{
    [self.lbError setAlpha:0];
    [self.lbError setText:text];
    [self.lbError setHidden:text.length == 0];
    CGFloat lbW = [self.lbError getLabelWidthWithMinWidth:0]+30;
    [self.lbError setFrame:CGRectMake(self.cellW/2-lbW/2, self.space, lbW, 36)];
    
    OBJC_RELEASE_TIMER(_timer);
    if (text.length > 0) {
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self.lbError setAlpha:1];
        } completion:^(BOOL finished) {
            _timer = [NSTimer timerWithTimeInterval:4.0f target:self selector:@selector(timerCallback) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }];
    }
}

-(void)timerCallback
{
    OBJC_RELEASE_TIMER(_timer);
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.lbError setAlpha:0];
    } completion:^(BOOL finished) {
        [self.lbError setHidden:YES];
    }];
}

-(void)setViewNil
{
    OBJC_RELEASE_TIMER(_timer);
    OBJC_RELEASE(_lbError);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 70;
}
+(CGFloat)getH
{
    return 70;
}

@end
