//
//  ZHomeSubscribeTrailerView.h
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

///首页订阅点击弹窗提示订阅内容View
@interface ZHomeSubscribeTrailerView : ZView

///初始化对象
-(instancetype)initWithModel:(ModelSubscribe *)model;

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
