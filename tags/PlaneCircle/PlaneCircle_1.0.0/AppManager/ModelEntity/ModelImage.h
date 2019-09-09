//
//  ModelImage.h
//  PlaneCircle
//
//  Created by Daniel on 6/30/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

///图片对象
@interface ModelImage : NSObject

///图片本地地址
@property (retain, nonatomic) NSString *imagePath;

///图片本地名称
@property (retain, nonatomic) NSString *imageName;

///图片索引位置
@property (assign, nonatomic) NSInteger location;

@end
