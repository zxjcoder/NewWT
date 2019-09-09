//
//  ZPickerView.h
//  WJ
//
//  Created by Daniel on 15/9/28.
//  Copyright © 2015年 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPickerView;

typedef NS_ENUM(NSInteger, ZPickerViewType) {
    ZPickerViewCity = 1,   //省市区选择
    ZPickerViewBirthday =2,//生日选择器
    ZPickerViewDateTime =3,//时间选择器
    ZPickerViewArray = 4,  //自定义数组选择器
    ZPickerViewNone = 5    //未定义选择器类型
} ;

@protocol ZPickerViewDelegate <NSObject>

@optional
-(void)pickerViewValueChange:(ZPickerView *)pickView resultString:(NSString *)resultString;
-(void)pickerViewToobarDoneClick:(ZPickerView *)pickView resultString:(NSString *)resultString;
-(void)pickerViewToobarClearClick:(ZPickerView *)pickView;

@end

@interface ZPickerView : UIView
{
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSInteger _selectState;
    NSInteger _selectCity;
    NSInteger _selectString;
}
@property(nonatomic, weak) id<ZPickerViewDelegate> delegate;
@property(nonatomic, assign) ZPickerViewType pikerViewType;

/**
 *  通过plist文件添加一个省市区pickerView
 *
 *  @param plistName          plist文件的名字
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickerViewWithCityPlist;
/**
 *  通过plist文件添加一个省市区pickerView
 *
 *  @param plistName    plist文件的名字
 *  @param city         默认城市
 *  @param state        默认省份
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickerViewWithCityPlistWithCity:(NSString*)city state:(NSString*)state;

/**
 *  通过plistName添加一个pickerView
 *
 *  @param plistName          plist文件的名字
 *
 *  @return 带有toolbar的pickerView
 */
-(instancetype)initPickerViewWithPlistName:(NSString *)plistName;

/**
 *  通过plistName添加一个pickerView
 *
 *  @param plistPath          plist文件的地址
 *
 *  @return 带有toolbar的pickerView
 */
-(instancetype)initPickerViewWithPlistPath:(NSString *)plistPath;

/**
 *  通过array添加一个pickerView
 *
 *  @param array              需要显示的数组
 *
 *  @return 带有toolbar的pickerView
 */
-(instancetype)initPickerViewWithArray:(NSArray *)array;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param defaulDate   默认选中时间
 *
 *  @return 带有toolbar的datePicker
 */
-(instancetype)initPickerViewWithDate:(NSDate *)defaulDate;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param defaulDate   默认选中时间
 *  @param maxDate      默认最大时间
 *  @param minDate      默认最小时间
 *
 *  @return 带有toolbar的datePicker
 */
-(instancetype)initPickerViewWithDate:(NSDate *)defaulDate maxDate:(NSDate*)maxDate minDate:(NSDate*)minDate;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param defaulDate   默认选中时间
 *  @param isBirthday   是否是选择生日
 *
 *  @return 带有toolbar的datePicker
 */
-(instancetype)initPickerViewWithDate:(NSDate *)defaulDate isBirthday:(BOOL)isBirthday;

/**
 *  移除选择器
 */
-(void)remove;
/**
 *  显示选择器
 */
-(void)show;
/**
 *  设置PickerView的颜色
 */
-(void)setPickViewColer:(UIColor *)color;
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color;
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color;
/**
 *  获取控件高度
 */
-(CGFloat)getPickerViewHeight;
/**
 *  默认选中对应的值->省市区
 */
-(void)selectRowWithDefault;
/**
 *  默认选中对应的值->单体数据集合
 */
-(void)selectRowWithString:(NSString*)value;
/**
 *  设置选中对应的值->省市区
 */
-(void)setStateAndCity:(NSString *)resultString;
/**
 *  隐藏取消按钮
 */
-(void)setHiddenCancelButton;

@end

/*
 *  生日选择器使用方法
 *
 *  ZPickerView *_pickerView = [[ZPickerView alloc] initPickerViewWithDate:[NSDate date] isBirthday:YES];
 *  _pickerView.delegate = self;
 *  [_pickerView show];
 *
 *
 *  省市区选择器使用方法
 *
 *  ZPickerView *_pickerView = [[ZPickerView alloc] initPickerViewWithCityPlist];
 *  _pickerView.delegate = self;
 *  [_pickerView show];
 *
 *
 *  自定义数据集合选择器使用方法
 *
 *  ZPickerView *_pickerView = [[ZPickerView alloc] initPickerViewWithArray:array];
 *  _pickerView.delegate = self;
 *  [_pickerView show];
 *
 */


