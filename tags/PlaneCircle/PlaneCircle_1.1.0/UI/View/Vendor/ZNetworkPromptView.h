//
//  ZNetworkPromptView.h
//  PlaneCircle
//
//  Created by Daniel on 8/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

///无网络提示视图
@interface ZNetworkPromptView : ZView

///单例模式
+(ZNetworkPromptView *)shareNetworkPromptView;

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
