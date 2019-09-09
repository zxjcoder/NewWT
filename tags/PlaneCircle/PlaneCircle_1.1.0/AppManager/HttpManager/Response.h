//
//  Response.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AESCrypt.h"

@interface Response : NSObject

+ (id)sharedWithJSONDictionary:(NSDictionary *)result;
+ (id)sharedWithJSONString:(NSString *)result;
+ (id)sharedWithJSONData:(NSData *)result;
+ (id)sharedWithError:(NSError *)error;
+ (id)sharedWithException;

@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) id body;

@end
