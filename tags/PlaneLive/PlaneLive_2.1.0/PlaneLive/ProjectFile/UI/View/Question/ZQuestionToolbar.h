//
//  ZQuestionToolbar.h
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQuestionToolbar : UIToolbar

///完成事件
@property (nonatomic, copy) void (^onDoneClick)(void);

///选中图片
@property (nonatomic, copy) void (^onPhotoClick)(void);

///选中相机
@property (nonatomic, copy) void (^onCameraClick)(void);

@end
