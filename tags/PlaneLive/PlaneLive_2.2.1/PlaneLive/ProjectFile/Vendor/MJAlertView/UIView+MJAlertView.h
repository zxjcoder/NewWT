//
//  UIView+MJAlertView.h
//  MJAlertView
//
//  Created by Mayur on 2/16/15.
//  Copyright (c) 2015 Persource. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MJAlertView)

+ (void)addMJNotifierErrorWithText:(NSString *)text dismissAutomatically:(BOOL)shouldDismiss;
+ (void)addMJNotifierSuccessWithText:(NSString *)text dismissAutomatically:(BOOL)shouldDismiss;

+ (void)dismissMJNotifier;

@end
