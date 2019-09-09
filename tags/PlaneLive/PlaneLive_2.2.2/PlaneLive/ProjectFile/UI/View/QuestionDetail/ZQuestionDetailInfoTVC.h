//
//  ZQuestionDetailInfoTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZQuestionDetailInfoTVC : ZBaseTVC

///改变高度
@property (copy, nonatomic) void(^onHeightClick)(CGFloat rowH);
///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelQuestionDetail *model);

///获取高度
-(CGFloat)getHWithModel:(ModelQuestionDetail *)model;

@end
