//
//  FontKeyManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "AppSetting.h"

///发布或编辑问题的文本字体
#define kQuestion_TextView_Font [ZFont fontWithName:@"HelveticaNeue" size:kFont_Middle_Size]

//字体
#define kFont_Huge_Size 18
#define kFont_Max_Size 17
#define kFont_Default_Size 16
#define kFont_Middle_Size 15
#define kFont_Small_Size 14
#define kFont_Least_Size 13
#define kFont_Min_Size 12
#define kFont_Minmum_Size 11
#define kFont_Minimum_Size 10

//读区设置字体大小
#define kSet_Font_Huge_Size(defaultSize) (defaultSize+2)
#define kSet_Font_Max_Size(defaultSize)  (defaultSize+1)
#define kSet_Font_Default_Size(defaultSize)  (defaultSize)
#define kSet_Font_Middle_Size(defaultSize)  (defaultSize-1)
#define kSet_Font_Small_Size(defaultSize)  (defaultSize-2)
#define kSet_Font_Least_Size(defaultSize)  (defaultSize-3)
#define kSet_Font_Min_Size(defaultSize)  (defaultSize-4)
#define kSet_Font_Minimum_Size(defaultSize)  (defaultSize-5)

//配置全局字体大小
#define kFont_Set_Min_Size 15
#define kFont_Set_Default_Size 16
#define kFont_Set_Middle_Size 17
#define kFont_Set_Big_Size 18
#define kFont_Set_Large_Size 20
