//
//  ZShowLawFirmInfoView.h
//  PlaneLive
//
//  Created by WT on 21/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 律所详情
@interface ZShowLawFirmInfoView : UIView

-(id)initWithModel:(ModelLawFirm *)model;
///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
