//
//  KeyChain.h
//  PlaneLive
//
//  Created by Daniel on 11/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
