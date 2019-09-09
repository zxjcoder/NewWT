//
//  ZNewHomeLawItemCVC.h
//  PlaneLive
//
//  Created by Daniel on 24/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNewHomeLawItemCVC : UICollectionViewCell

-(void)innerInit;

///律所点击事件
@property (nonatomic, copy) void(^onLawFirmClick)(ModelLawFirm *model);
///设置数据源
-(void)setCellDataWithModel:(ModelLawFirm *)model;

+(CGFloat)getW;
+(CGFloat)getH;

@end
