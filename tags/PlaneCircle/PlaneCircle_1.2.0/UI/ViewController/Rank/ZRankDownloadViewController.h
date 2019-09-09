//
//  ZRankDownloadViewController.h
//  PlaneCircle
//
//  Created by Daniel on 7/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface ZRankDownloadViewController : QLPreviewController

///表格文件地址
@property (strong, nonatomic) NSString *xlsUrl;

@end
