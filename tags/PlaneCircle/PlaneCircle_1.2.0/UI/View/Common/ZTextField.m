//
//  ZTextField.m
//  PlaneCircle
//
//  Created by Daniel on 8/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTextField.h"

@implementation ZTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
