//
//  ZUserEidtResidenceTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditBaseTVC.h"

///居住地
@interface ZUserEidtResidenceTVC : ZUserEditBaseTVC

///选择城市
@property (copy, nonatomic) void(^onSelectCity)(NSString *value);

///确定事件
@property (copy, nonatomic) void(^onDoneClick)(NSString *value);

@end
