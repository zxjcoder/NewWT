//
//  ZPickerView.m
//  WJ
//
//  Created by Daniel on 15/9/28.
//  Copyright © 2015年 Z. All rights reserved.
//

#import "ZPickerView.h"
#import "ClassCategory.h"

#define kZPickerViewToobarHeight 40

@interface ZPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    ///PickerView初始化坐标
    CGRect _pvFrame;
    ///判断子级数据是否是Array
    BOOL _isLevelArray;
    ///判断子级数据是否是String
    BOOL _isLevelString;
    ///判断子级数据是否是Dictionary
    BOOL _isLevelDic;
    ///默认选中值
    NSString *_defaultValue;
    ///默认显示日期
    NSDate *_defaulDate;
    ///是否扣除导航栏高度
    BOOL _isHaveNavControler;
    ///是否是生日选择器
    BOOL _isBirthday;
    ///选择器控件高度
    NSInteger _pickeviewHeight;
    
    ZPickerViewType _pikerViewType;
}
///普通选择器
@property(nonatomic, strong) UIPickerView *pickerView;
///日期选择器
@property(nonatomic, strong) UIDatePicker *datePicker;
///选择器ToolBar
@property(nonatomic, strong) UIToolbar *toolbar;
///文件名字
@property(nonatomic, copy)   NSString *plistName;
///文件数据集合
@property(nonatomic, strong) NSArray *plistArray;
///二级数据对象
@property(nonatomic, strong) NSDictionary *levelTwoDic;

///返回选择器选择的数据
@property(nonatomic, copy)   NSString *resultString;
///分区集合
@property(nonatomic, strong) NSMutableArray *componentArray;
///字典Key
@property(nonatomic, strong) NSMutableArray *dicKeyArray;
///省份
@property(nonatomic, copy)   NSString *state;
///城市
@property(nonatomic, copy)   NSString *city;

@end

@implementation ZPickerView

@synthesize pikerViewType = _pikerViewType;

-(NSArray *)plistArray
{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray
{
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPickerViewToolBar];
    }
    return self;
}

-(instancetype)initPickerViewWithCityPlist;
{
    self=[super init];
    if (self) {
        _plistName = @"city";
        _pikerViewType = ZPickerViewCity;
        self.plistArray=[self getPlistArrayByPlistName:_plistName];
        [self setPickView];
        [self setFrameWith:_isHaveNavControler];
    }
    return self;
}

-(instancetype)initPickerViewWithCityPlistWithCity:(NSString*)city state:(NSString*)state;
{
    self=[super init];
    if (self) {
        _city = city;
        _state = state;
        _plistName = @"city";
        _pikerViewType = ZPickerViewCity;
        self.plistArray=[self getPlistArrayByPlistName:_plistName];
        [self setPickView];
        [self setFrameWith:_isHaveNavControler];
    }
    return self;
}

-(instancetype)initPickerViewWithPlistName:(NSString *)plistName
{
    self=[super init];
    if (self) {
        _plistName=plistName;
        _pikerViewType = ZPickerViewCity;
        self.plistArray=[self getPlistArrayByPlistName:_plistName];
        [self setPickView];
        [self setFrameWith:_isHaveNavControler];
    }
    return self;
}

-(instancetype)initPickerViewWithPlistPath:(NSString *)plistPath
{
    self=[super init];
    if (self) {
        _pikerViewType = ZPickerViewCity;
        self.plistArray=[self getPlistArrayByPlistPath:plistPath];
        [self setPickView];
        [self setFrameWith:_isHaveNavControler];
    }
    return self;
}

-(instancetype)initPickerViewWithArray:(NSArray *)array
{
    self=[super init];
    if (self) {
        self.plistArray=array;
        _defaultValue = nil;
        _pikerViewType = ZPickerViewArray;
        [self setArrayClass:array];
        [self setPickView];
        [self setFrameWith:_isHaveNavControler];
    }
    return self;
}

-(instancetype)initPickerViewWithDate:(NSDate *)defaulDate;
{
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        _pikerViewType = ZPickerViewDateTime;
        [self setDatePickerWithdatePickerMode:(UIDatePickerModeDate)];
        [self setFrameWith:_isHaveNavControler];
    }
    return self;
}

-(instancetype)initPickerViewWithDate:(NSDate *)defaulDate maxDate:(NSDate*)maxDate minDate:(NSDate*)minDate
{
    self=[super init];
    if (self) {
        _minDate = minDate;
        _maxDate = maxDate;
        _defaulDate=defaulDate;
        _pikerViewType = ZPickerViewDateTime;
        [self setDatePickerWithdatePickerMode:(UIDatePickerModeDate)];
        [self setFrameWith:_isHaveNavControler];
    }
    return self;
}

-(instancetype)initPickerViewWithDate:(NSDate *)defaulDate isBirthday:(BOOL)isBirthday;
{
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        _isBirthday=isBirthday;
        _pikerViewType = isBirthday==YES?ZPickerViewBirthday:ZPickerViewDateTime;
        [self setDatePickerWithdatePickerMode:(UIDatePickerModeDate)];
        [self setFrameWith:_isHaveNavControler];
    }
    return self;
}

-(NSArray *)getPlistArrayByPlistName:(NSString *)plistName
{
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

-(NSArray *)getPlistArrayByPlistPath:(NSString *)plistPath
{
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:plistPath];
    [self setArrayModel:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array
{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSDictionary class]]){
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

-(void)setArrayModel:(NSArray *)array
{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSDictionary class]]){
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

-(void)setFrameWith:(BOOL)isHaveNavControler
{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+kZPickerViewToobarHeight;
    CGFloat toolViewY ;
    toolViewY = 0;
//    if (isHaveNavControler) {
//        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
//    }else {
//        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
//    }
    _pvFrame = CGRectMake(toolViewX, toolViewY, APP_FRAME_WIDTH, toolViewH);
    self.frame = _pvFrame;
}

-(void)setPickView
{
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor whiteColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, kZPickerViewToobarHeight, APP_FRAME_WIDTH, pickView.frame.size.height);
    _pickeviewHeight=pickView.frame.size.height;
    [self addSubview:pickView];
}

-(void)setDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode
{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=[UIColor whiteColor];
    if (_isBirthday) {
        if (_defaulDate) {
            [datePicker setDate:_defaulDate];
        }
        datePicker.maximumDate = [NSDate date];
    } else {
        if (_defaulDate) {
            [datePicker setDate:_defaulDate];
        }
        if (_minDate) {
            [datePicker setMinimumDate:_minDate];
        }
        if (_maxDate) {
            [datePicker setMaximumDate:_maxDate];
        }
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, kZPickerViewToobarHeight, APP_FRAME_WIDTH, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
}

-(void)setPickerViewToolBar
{
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}

-(UIToolbar *)setToolbarStyle
{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    //设置背景颜色
    [toolbar setBarTintColor:WHITECOLOR];
    //设置文字颜色
    [toolbar setTintColor:MAINCOLOR];
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    toolbar.items=@[lefttem,centerSpace,right];
//    toolbar.items=@[centerSpace,right];
    
    return toolbar;
}

-(void)setToolbarWithPickViewFrame
{
    _toolbar.frame=CGRectMake(0, 0,APP_FRAME_WIDTH, kZPickerViewToobarHeight);
}

-(void)remove
{
    if ([self.delegate respondsToSelector:@selector(pickerViewToobarClearClick:)]) {
        [self.delegate pickerViewToobarClearClick:self];
    }
//    [UIView animateWithDuration:kANIMATION_TIME animations:^{
//        self.frame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, self.frame.size.height);
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [self setDelegate:nil];
//            [self removeFromSuperview];
//        }
//    }];
}
-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, self.frame.size.height);
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        self.frame = _pvFrame;
    }];
}
-(void)doneClick
{
    if (_pickerView) {
        
        if (_resultString) {
            
        }else{
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                if (_state==nil) {
                    _state =_dicKeyArray[[_pickerView selectedRowInComponent:0]][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    _city=[dicValueDic allValues][[_pickerView selectedRowInComponent:1]][0];
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][[_pickerView selectedRowInComponent:1]][0];
                }
                _resultString=[NSString stringWithFormat:@"%@,%@", _state, _city];
            }
        }
    }else if (_datePicker) {
        if (_isBirthday) {
            _resultString=[_datePicker.date toStringWithFormat:@"yyyy-MM-dd"];
        } else {
            _resultString=[_datePicker.date toStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
    }
    if ([self.delegate respondsToSelector:@selector(pickerViewToobarDoneClick:resultString:)]) {
        [self.delegate pickerViewToobarDoneClick:self resultString:_resultString];
    }
//    [self remove];
}

-(void)didChange
{
    if (_pickerView) {
        
        if (_resultString) {
            
        }else{
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                if (_state==nil) {
                    _state =_dicKeyArray[[_pickerView selectedRowInComponent:0]][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    _city=[dicValueDic allValues][[_pickerView selectedRowInComponent:1]][0];
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][[_pickerView selectedRowInComponent:1]][0];
                }
                _resultString=[NSString stringWithFormat:@"%@,%@", _state, _city];
            }
        }
    }else if (_datePicker) {
        if (_isBirthday) {
            _resultString=[_datePicker.date toStringWithFormat:@"yyyy-MM-dd"];
        } else {
            _resultString=[_datePicker.date toStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
    }
    if ([self.delegate respondsToSelector:@selector(pickerViewValueChange:resultString:)]) {
        [self.delegate pickerViewValueChange:self resultString:_resultString];
    }
}

-(void)setPickViewColer:(UIColor *)color
{
    _pickerView.backgroundColor=color;
}

-(void)setTintColor:(UIColor *)color
{
    _toolbar.tintColor=color;
}

-(void)setToolbarTintColor:(UIColor *)color
{
    _toolbar.barTintColor=color;
}

-(CGFloat)getPickerViewHeight
{
    return kZPickerViewToobarHeight+_pickeviewHeight;
}

-(void)dealloc
{
    OBJC_RELEASE(_defaulDate);
    OBJC_RELEASE(_delegate);
    OBJC_RELEASE(_pickerView);
    OBJC_RELEASE(_plistArray);
    OBJC_RELEASE(_plistName);
    OBJC_RELEASE(_state);
    OBJC_RELEASE(_city);
    OBJC_RELEASE(_toolbar);
    OBJC_RELEASE(_componentArray);
    OBJC_RELEASE(_levelTwoDic);
    OBJC_RELEASE(_resultString);
    OBJC_RELEASE(_defaultValue);
}

-(void)setStateAndCity:(NSString *)resultString
{
    NSArray *arr = [resultString componentsSeparatedByString:@","];
    if (arr.count == 2) {
        [self setCity:arr.lastObject];
        [self setState:arr.firstObject];
    }
    [self selectRowWithDefault];
}

/**
 *  隐藏取消按钮
 */
-(void)setHiddenCancelButton
{
    
}

-(void)selectRowWithDefault
{
    if ([_state length]>0&&[_city length]>0) {
        NSInteger indexState = 0;
        for (NSDictionary *dicState in _plistArray) {
            NSString *state = [dicState objectForKey:@"state"];
            NSArray *cities = [dicState objectForKey:@"cities"];
            if ([state isEqualToString:_state]) {
                _selectState = indexState;
            }
            NSInteger indexCity = 0;
            for (NSString *city in cities) {
                if ([city isEqualToString:_city]) {
                    _selectCity = indexCity;
                    break;
                }
                indexCity++;
            }
            indexState++;
        }
        [_pickerView selectRow:_selectState inComponent:0 animated:NO];
        [_pickerView selectRow:_selectCity inComponent:1 animated:NO];
    } else {
        _selectState = 0;
        _selectCity = 0;
        [_pickerView selectRow:_selectState inComponent:0 animated:NO];
        [_pickerView selectRow:_selectCity inComponent:1 animated:NO];
    }
}

-(void)selectRowWithString:(NSString*)value
{
    _defaultValue = [value copy];
    NSInteger indexState = 0;
    for (NSString *value in _plistArray) {
        if ([value isEqualToString:_defaultValue]) {
            _selectString = indexState;
            break;
        }
        indexState++;
    }
    [_pickerView selectRow:_selectString inComponent:0 animated:NO];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component%2==1) {
                    rowArray=dicValue;
                }else{
                    rowArray=_plistArray;
                }
            }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        if (component == 0) {
            NSDictionary *dic=_plistArray[row];
            rowTitle=[dic objectForKey:@"state"];
            if ([rowTitle isEqualToString:_state]) {
                [pickerView selectRow:row inComponent:component animated:NO];
            }
        } else if (component == 1) {
            NSInteger pIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[pIndex];
            NSArray *dicValueArray=[dicValueDic objectForKey:@"cities"];
            if (dicValueArray.count>row) {
                rowTitle =dicValueArray[row];
                if ([rowTitle isEqualToString:_city]) {
                    [pickerView selectRow:row inComponent:component animated:NO];
                }
            }
        }
    }
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isLevelDic&&component%2==0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    }else if (_isLevelDic){
        if (component==0) {
            NSDictionary *dicValueDic=_plistArray[row];
            _state = [dicValueDic objectForKey:@"state"];
            NSArray *dicValueArray=[dicValueDic objectForKey:@"cities"];
            _city = dicValueArray.firstObject;
        }else if (component == 1){
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic objectForKey:@"cities"];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
        _resultString=[NSString stringWithFormat:@"%@,%@", _state, _city];
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerViewValueChange:resultString:)]) {
        [self.delegate pickerViewValueChange:self resultString:_resultString];
    }
}

@end

