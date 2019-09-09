//
//  ZLabel.m
//  PlaneCircle
//
//  Created by Daniel on 8/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLabel.h"

@interface ZLabel()

@end

@implementation ZLabel

-(id)init
{
    self = [super init];
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
    self.linesSpacing = 2;
    self.characterSpacing = 0;
    
    [self addCopyTouchEvent];
}

///添加长按事件
-(void)addCopyTouchEvent
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self addGestureRecognizer:longPressGesture];
}
///长按事件回调
-(void)longPressGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

/// 接收事件
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

/// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

/// 针对于响应方法的实现
-(void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

@end
