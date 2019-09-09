//
//  ZUserEditSignTVC.h
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///个性签名
@interface ZUserEditSignTVC : ZBaseTVC

@property (copy ,nonatomic) void(^onBeginEdit)();

///获取个性签名
-(NSString *)getSign;

@end
