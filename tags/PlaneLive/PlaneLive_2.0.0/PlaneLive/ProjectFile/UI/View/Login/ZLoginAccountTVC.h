//
//  ZLoginAccountTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///登录帐号CELL
@interface ZLoginAccountTVC : ZBaseTVC

///开始编辑
@property (copy ,nonatomic) void(^onBeginEditText)();

-(void)setText:(NSString *)text;
-(NSString *)getText;

@end
