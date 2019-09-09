//
//  ZAlertPhotoView.h
//  PlaneLive
//
//  Created by Daniel on 09/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"



@interface ZAlertPhotoView : ZView

///按钮点击 0相册 1相机
@property (copy, nonatomic) void(^onButtonClick)(int index);

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
