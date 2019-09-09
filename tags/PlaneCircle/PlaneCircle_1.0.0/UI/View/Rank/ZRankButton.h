//
//  ZRankButton.h
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

@interface ZRankButton : UIButton

///公司
@property (strong, nonatomic) ModelRankCompany *modelCommpany;
///用户
@property (strong, nonatomic) ModelRankUser *modelUser;

///1 公司 2 人
@property (assign, nonatomic) int type;

@end
