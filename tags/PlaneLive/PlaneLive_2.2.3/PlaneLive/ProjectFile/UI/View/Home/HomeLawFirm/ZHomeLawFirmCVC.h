//
//  ZHomeLawFirmCVC.h
//  PlaneLive
//
//  Created by Daniel on 11/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

//192/330图片比例
#define kZHomeLawFirmCVCHeight APP_FRAME_WIDTH/2*192/330

@interface ZHomeLawFirmCVC : UICollectionViewCell

///律所点击事件
@property (nonatomic, copy) void(^onLogoClick)(ModelLawFirm *model);
///设置数据源
-(void)setCellDataWithModel:(ModelLawFirm *)model;

@end
