//
//  ZToolbar.h
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZToolbar : UIToolbar

///完成事件
@property (nonatomic, copy) void (^onDoneClick)(void);

@end
