//
//  ZMyCollectionTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyBaseTVC.h"

@interface ZMyCollectionTVC : ZMyBaseTVC

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelCollection *model, NSInteger row);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end
