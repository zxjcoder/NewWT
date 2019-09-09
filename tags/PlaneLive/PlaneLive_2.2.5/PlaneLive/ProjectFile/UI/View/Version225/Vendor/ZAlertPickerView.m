//
//  ZAlertPickerView.m
//  PlaneLive
//
//  Created by Daniel on 09/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertPickerView.h"

@interface ZAlertPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) UIPickerView *viewPicker;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;
@property (assign, nonatomic) ZAlertPickerViewType viewType;

@property (strong, nonatomic) NSArray *arrayMain;
@property (strong, nonatomic) NSArray *arrayCity;
@property (strong, nonatomic) NSArray *arrayArea;

@property (strong, nonatomic) NSDictionary *dicAllCity;
@property (strong, nonatomic) NSDictionary *dicAllArea;

@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *month;
@property (strong, nonatomic) NSString *day;

@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *area;

@property (assign, nonatomic) NSInteger selectRow1;
@property (assign, nonatomic) NSInteger selectRow2;
@property (assign, nonatomic) NSInteger selectRow3;

@end

@implementation ZAlertPickerView


/// 初始化
-(instancetype)initWithType:(ZAlertPickerViewType)type
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self setViewType:type];
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.viewBack setAlpha:0.1];
    [self addSubview:self.viewBack];
    
    self.contentH = 220;
    [self setReloadInitData];
    
    self.contentFrame = CGRectMake(10, self.height, self.width-20, self.contentH+20);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
  
    CGFloat closeH = 36;
    self.viewPicker = [[UIPickerView alloc] initWithFrame:(CGRectMake(0, 0, self.viewContent.width, self.contentH-closeH))];
    [self.viewPicker setDelegate:self];
    [self.viewPicker setDataSource:self];
    [self.viewPicker setBackgroundColor:WHITECOLOR];
    [self.viewContent addSubview:self.viewPicker];
    
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setTitle:kCancel forState:(UIControlStateNormal)];
    [btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [[btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btnClose.userInteractionEnabled = true;
    btnClose.backgroundColor = CLEARCOLOR;
    btnClose.frame = CGRectMake(0, self.viewContent.height-20-36, 55, closeH);
    [self.viewContent addSubview:btnClose];
    
    UIButton *btnDone = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnDone setTitle:kDetermine forState:(UIControlStateNormal)];
    [btnDone setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
    [[btnDone titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnDone addTarget:self action:@selector(btnDoneEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btnDone.userInteractionEnabled = true;
    btnDone.backgroundColor = CLEARCOLOR;
    btnDone.frame = CGRectMake(self.viewContent.width-55, self.viewContent.height-20-36, 55, closeH);
    [self.viewContent addSubview:btnDone];
    
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(0, btnClose.y, self.viewContent.width, kLineHeight);
    [self.viewContent addSubview:imageLine];
    
    UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
    [self.viewBack addGestureRecognizer:viewBGTapGesture];
}
/// 设置初始化数据
- (void)setReloadInitData
{
    switch (self.viewType) {
        case ZAlertPickerViewTypeSex:
        {
            NSString *path= [[NSBundle mainBundle] pathForResource:@"sex" ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:path];
            if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
                self.arrayMain = array;
                self.text = self.arrayMain.firstObject;
            }
            break;
        }
        case ZAlertPickerViewTypeTime:
        {
            NSArray *timeArray = [self getDateNumbers];
            if (timeArray && [timeArray isKindOfClass:[NSArray class]] && timeArray.count) {
                self.year = timeArray.firstObject;
                self.month = [timeArray objectAtIndex:1];
                self.day = timeArray.lastObject;
                NSInteger startYear = self.year.integerValue;
                NSInteger endYear = startYear - 100;
                NSMutableArray *array = [NSMutableArray array];
                for (NSInteger i = startYear; i >= endYear; i--) {
                    [array addObject:[NSString stringWithFormat:@"%d", (int)i]];
                }
                self.arrayMain =  [NSArray arrayWithArray:array];
            }
            break;
        }
        case ZAlertPickerViewTypeArea:
        {
            NSString *provincePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
            NSString *strAllProvince = [NSString stringWithContentsOfFile:provincePath encoding:(NSUTF8StringEncoding) error:nil];
            if (strAllProvince && strAllProvince.length > 0) {
                NSArray *arrayAllProvince = [strAllProvince mj_JSONObject];
                if (arrayAllProvince && [arrayAllProvince isKindOfClass:[NSArray class]] && arrayAllProvince.count > 0) {
                    self.arrayMain =  [NSArray arrayWithArray:arrayAllProvince];
                }
            }
            NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
            NSString *strAllCity = [NSString stringWithContentsOfFile:cityPath encoding:(NSUTF8StringEncoding) error:nil];
            if (strAllCity && strAllCity.length > 0) {
                NSDictionary *dicAllCity = [strAllCity mj_JSONObject];
                if (dicAllCity && [dicAllCity isKindOfClass:[NSDictionary class]]) {
                    self.dicAllCity = [NSDictionary dictionaryWithDictionary:dicAllCity];
                }
            }
            NSString *areaPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
            NSString *strAllArea = [NSString stringWithContentsOfFile:areaPath encoding:(NSUTF8StringEncoding) error:nil];
            if (strAllArea && strAllArea.length > 0) {
                NSDictionary *dicAllArea = [strAllArea mj_JSONObject];
                if (dicAllArea && [dicAllArea isKindOfClass:[NSDictionary class]]) {
                    self.dicAllArea = [NSDictionary dictionaryWithDictionary:dicAllArea];
                }
            }
            break;
        }
        case ZAlertPickerViewTypeEducation:
        {
            NSString *path= [[NSBundle mainBundle] pathForResource:@"education" ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:path];
            if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
                self.arrayMain =  [NSArray arrayWithArray:array];
                self.text = self.arrayMain.firstObject;
            }
            break;
        }
        default: break;
    }
    [self.viewPicker reloadAllComponents];
}
/// 设置默认性别数据
- (void)setViewSex:(WTSexType)type
{
    switch (type) {
        case WTSexTypeMale: self.text = kCMale; break;
        case WTSexTypeFeMale: self.text = kCFemale; break;
        default: self.text = kCGenderSecrecy; break;
    }
    NSInteger row = [self.arrayMain indexOfObject:self.text];
    self.selectRow1 = row;
    if (row < self.arrayMain.count) {
        [self.viewPicker selectRow:row inComponent:0 animated:false];
    }
}
/// 设置默认行业数据
- (void)setViewEducation:(NSString *)value
{
    if (value && value.length > 0) {
        self.text = value;
        NSInteger row = [self.arrayMain indexOfObject:self.text];
        self.selectRow1 = row;
        if (row < self.arrayMain.count) {
            [self.viewPicker selectRow:row inComponent:0 animated:false];
        }
    }
}
/// 设置默认时间数据
- (void)setViewTime:(NSString *)time
{
    NSArray *timeArray = [time componentsSeparatedByString:@"-"];
    if (timeArray && timeArray.count == 3) {
        self.year = timeArray.firstObject;
        self.month = [timeArray objectAtIndex:1];
        self.day = timeArray.lastObject;
    }
    if (self.year.length == 0) {
        NSArray *timeArray = [self getDateNumbers];
        if (timeArray && [timeArray isKindOfClass:[NSArray class]] && timeArray.count) {
            self.year = timeArray.firstObject;
            self.month = [timeArray objectAtIndex:1];
            self.day = timeArray.lastObject;
        }
    }
    NSInteger yearRow = [self.arrayMain indexOfObject:self.year];
    NSInteger monthRow = [self.month integerValue] - 1;
    NSInteger dayRow = [self.day integerValue] - 1;
    self.selectRow1 = yearRow;
    self.selectRow2 = monthRow;
    self.selectRow3 = dayRow;
    if (yearRow < self.arrayMain.count) {
        [self.viewPicker selectRow:yearRow inComponent:0 animated:false];
    }
    if (monthRow < 12) {
        [self.viewPicker selectRow:monthRow inComponent:1 animated:false];
    }
    if (dayRow < [self getNumberOfDaysInMonth:[[self getSelectDate] toDateWithFormat:kFormat_Date_Date]]) {
        [self.viewPicker selectRow:dayRow inComponent:2 animated:false];
    }
}
/// 设置默认省市区数据
- (void)setViewArea:(NSString *)area
{
    NSArray *areaArray = [area componentsSeparatedByString:@","];
    if (areaArray && areaArray.count == 2) {
        self.province = areaArray.firstObject;
        self.city = areaArray.lastObject;
        self.area = kEmpty;
    } else if (areaArray && areaArray.count == 3) {
        self.province = areaArray.firstObject;
        self.city = [areaArray objectAtIndex:1];
        self.area = areaArray.lastObject;
    } else {
        self.province = kEmpty;
        self.city = kEmpty;
        self.area = kEmpty;
    }
    NSInteger rowProvince = 0;
    NSInteger rowCity = 0;
    NSInteger rowArea = 0;
    if (self.province.length > 0 && self.arrayMain.count > 0) {
        NSDictionary *dicProvince = nil;
        for (NSDictionary *dic in self.arrayMain) {
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                NSString *name = [dic objectForKey:@"name"];
                if ([name isEqualToString:self.province]) {
                    dicProvince = dic;
                    break;
                }
            }
            rowProvince++;
        }
        if (dicProvince != nil) {
            NSString *code = [dicProvince objectForKey:@"id"];
            if (code && [code isKindOfClass:[NSString class]]) {
                self.arrayCity = [self.dicAllCity objectForKey:code];
            }
        }
        if (self.city.length > 0 && self.arrayCity.count > 0) {
            NSDictionary *dicCity = nil;
            for (NSDictionary *dic in self.arrayCity) {
                if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                    NSString *name = [dic objectForKey:@"name"];
                    if ([name isEqualToString:self.city]) {
                        dicCity = dic;
                        break;
                    }
                }
                rowCity++;
            }
            if (dicCity != nil) {
                NSString *code = [dicCity objectForKey:@"id"];
                if (code && [code isKindOfClass:[NSString class]]) {
                    self.arrayArea = [self.dicAllArea objectForKey:code];
                    if (self.area.length > 0 && self.arrayArea.count > 0) {
                        for (NSDictionary *dic in self.arrayArea) {
                            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                                NSString *name = [dic objectForKey:@"name"];
                                if ([name isEqualToString:self.area]) {
                                    break;
                                }
                            }
                            rowArea++;
                        }
                    }
                }
            }
        }
    } else {
        NSString *codeP = kEmpty;
        NSDictionary *dicP = self.arrayMain.firstObject;
        if (dicP && [dicP isKindOfClass:[NSDictionary class]]) {
            self.province = [dicP objectForKey:@"name"];
            codeP = [dicP objectForKey:@"id"];
        }
        NSString *codeC = kEmpty;
        if (codeP.length > 0 && self.dicAllCity) {
            NSArray *arrayCity = [self.dicAllCity objectForKey:codeP];
            if (arrayCity && [arrayCity isKindOfClass:[NSArray class]] && arrayCity.count > 0) {
                self.arrayCity = [NSArray arrayWithArray:arrayCity];
                NSDictionary *dicCity = arrayCity.firstObject;
                if (dicCity && [dicCity isKindOfClass:[NSDictionary class]]) {
                    self.city = [dicCity objectForKey:@"name"];
                    codeC = [dicCity objectForKey:@"id"];
                }
            }
        }
        if (codeC.length > 0 && self.dicAllArea) {
            NSArray *arrayArea = [self.dicAllArea objectForKey:codeC];
            if (arrayArea && [arrayArea isKindOfClass:[NSArray class]] && arrayArea.count > 0) {
                self.arrayArea = [NSArray arrayWithArray:arrayArea];
                NSDictionary *dicArea = arrayArea.firstObject;
                if (dicArea && [dicArea isKindOfClass:[NSDictionary class]]) {
                    self.area = [dicArea objectForKey:@"name"];
                }
            }
        }
    }
    self.selectRow1 = rowProvince;
    self.selectRow2 = rowCity;
    self.selectRow3 = rowArea;
    if (self.arrayMain.count > rowProvince) {
        [self.viewPicker selectRow:rowProvince inComponent:0 animated:false];
    }
    if (self.arrayCity.count > rowCity) {
        [self.viewPicker selectRow:rowCity inComponent:1 animated:false];
    }
    if (self.arrayArea.count > rowArea) {
        [self.viewPicker selectRow:rowArea inComponent:2 animated:false];
    }
}
/// 获取内容高度
- (CGFloat)getContentH
{
    return self.contentH;
}
/// 获取当月的天数
- (NSInteger)getNumberOfDaysInMonth:(NSDate *)currentDate
{
    if (currentDate == nil) {
        return 0;
    }
    // 指定日历的算法
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier: NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:currentDate];
    return range.length;
}
/// 获取今年
- (NSArray *)getDateNumbers
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSString *strYear = [NSString stringWithFormat:@"%d", (int)[components year]];
    NSString *strMonth = [NSString stringWithFormat:@"%d", (int)[components month]];
    NSString *strDay = [NSString stringWithFormat:@"%d", (int)[components day]];
    return @[strYear, strMonth, strDay];
}
/// 获取选择省市区时间
- (NSString *)getSelectDate
{
    return [NSString stringWithFormat:@"%@-%@-%@", self.year, self.month, self.day];
}
/// 获取选择省市区
- (NSString *)getSelectArea
{
    if (self.province.length > 0 && self.city.length > 0 && self.area.length > 0) {
        return [NSString stringWithFormat:@"%@,%@,%@", self.province, self.city, self.area];
    } else if (self.province.length > 0 && self.city.length > 0 && self.area.length == 0) {
        return [NSString stringWithFormat:@"%@,%@", self.province, self.city];
    } else if (self.province.length > 0 && self.city.length == 0 && self.area.length == 0) {
        return [NSString stringWithFormat:@"%@", self.province];
    }
    return kEmpty;
}
/// 数据源
-(NSMutableArray *)arrayMain
{
    if (_arrayMain == nil) {
        _arrayMain = [NSMutableArray array];
    }
    return _arrayMain;
}
/// 城市数据源
-(NSMutableArray *)arrayCity
{
    if (_arrayCity == nil) {
        _arrayCity = [NSMutableArray array];
    }
    return _arrayCity;
}
/// 区域数据源
-(NSMutableArray *)arrayArea
{
    if (_arrayArea == nil) {
        _arrayArea = [NSMutableArray array];
    }
    return _arrayArea;
}
/// 关闭按钮
-(void)btnCloseEvent
{
    [self dismiss];
}
/// 确认按钮
-(void)btnDoneEvent
{
    switch (self.viewType) {
        case ZAlertPickerViewTypeSex:
            if (self.onItemChange) {
                self.onItemChange(self.text);
            }
            break;
        case ZAlertPickerViewTypeEducation:
            if (self.onItemChange) {
                self.onItemChange(self.text);
            }
            break;
        case ZAlertPickerViewTypeTime:
            if (self.onItemChange) {
                self.onItemChange([self getSelectDate]);
            }
            break;
        case ZAlertPickerViewTypeArea:
            if (self.onItemChange) {
                self.onItemChange([self getSelectArea]);
            }
            break;
        default:
            break;
    }
    [self dismiss];
}
/// 屏幕点击
-(void)viewBGTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
///显示
-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.viewBack.alpha = 0;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewBack.alpha = kBackgroundOpacity;
        CGRect contentFrame = self.contentFrame;
        contentFrame.origin.y -= self.contentH;
        self.viewContent.frame = contentFrame;
    } completion:^(BOOL finished) {
        
    }];
}
///隐藏
-(void)dismiss
{
    if (self.onDismissEvent) {
        self.onDismissEvent();
    }
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContent.frame = self.contentFrame;
        self.viewBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.viewType) {
        case ZAlertPickerViewTypeSex: return 1;
        case ZAlertPickerViewTypeEducation: return 1;
        case ZAlertPickerViewTypeTime: return 3;
        case ZAlertPickerViewTypeArea: return 3;
    }
    return 0;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger row = 0;
    switch (self.viewType) {
        case ZAlertPickerViewTypeSex:
        {
            row = self.arrayMain.count;
            break;
        }
        case ZAlertPickerViewTypeEducation:
        {
            row = self.arrayMain.count;
            break;
        }
        case ZAlertPickerViewTypeTime:
        {
            switch (component) {
                case 1: row = 12;
                    break;
                case 2:
                {
                    NSString *strDate = [self getSelectDate];
                    if (strDate == nil) {
                        row = [self getNumberOfDaysInMonth:[NSDate date]];
                    } else {
                        row = [self getNumberOfDaysInMonth:[strDate toDateWithFormat:kFormat_Date_Date]];
                    }
                    break;
                }
                default: row = self.arrayMain.count;
                    break;
            }
            break;
        }
        case ZAlertPickerViewTypeArea:
        {
            switch (component) {
                case 1:
                    row = self.arrayCity.count;
                    break;
                case 2:
                    row = self.arrayArea.count;
                    break;
                default:
                    row = self.arrayMain.count;
                    break;
            }
            break;
        }
    }
    return row;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    for(UIView *speartorView in pickerView.subviews) {
        if (speartorView.frame.size.height < 1) {
            speartorView.backgroundColor = TABLEVIEWCELL_LINECOLOR;
        }
    }
    if (view == nil) {
        CGFloat itemW = self.viewPicker.width;
        switch (self.viewType) {
            case ZAlertPickerViewTypeArea:
                itemW = self.viewPicker.width/2;
                break;
            case ZAlertPickerViewTypeTime:
                itemW = self.viewPicker.width/3;
                break;
            default:
                break;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, itemW, 40))];
        [label setTextAlignment:(NSTextAlignmentCenter)];
        [label setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        switch (component) {
            case 1:
            {
                if (row == self.selectRow2) {
                    [label setTextColor:COLORCONTENT1];
                } else {
                    [label setTextColor:COLORTEXT1];
                }
                break;
            }
            case 2:
            {
                if (row == self.selectRow3) {
                    [label setTextColor:COLORCONTENT1];
                } else {
                    [label setTextColor:COLORTEXT1];
                }
                break;
            }
            default:
            {
                if (row == self.selectRow1) {
                    [label setTextColor:COLORCONTENT1];
                } else {
                    [label setTextColor:COLORTEXT1];
                }
                break;
            }
        }
        view = label;
    }
    NSString *title = kEmpty;
    switch (self.viewType) {
        case ZAlertPickerViewTypeSex:
        {
            title = [self.arrayMain objectAtIndex:row];
            break;
        }
        case ZAlertPickerViewTypeEducation:
        {
            title = [self.arrayMain objectAtIndex:row];
            break;
        }
        case ZAlertPickerViewTypeTime:
        {
            switch (component) {
                case 1:
                    title = [NSString stringWithFormat:@"%d", (row+1)];
                    break;
                case 2:
                    title = [NSString stringWithFormat:@"%d", (row+1)];
                    break;
                default:
                    title = [self.arrayMain objectAtIndex:row];
                    break;
            }
            break;
        }
        case ZAlertPickerViewTypeArea:
        {
            switch (component) {
                case 1:
                {
                    NSDictionary *dic = [self.arrayCity objectAtIndex:row];
                    title = [dic objectForKey:@"name"];
                    break;
                }
                case 2:
                {
                    NSDictionary *dic = [self.arrayArea objectAtIndex:row];
                    title = [dic objectForKey:@"name"];
                    break;
                }
                default:
                {
                    NSDictionary *dic = [self.arrayMain objectAtIndex:row];
                    title = [dic objectForKey:@"name"];
                    break;
                }
            }
            break;
        }
    }
    if ([view isKindOfClass:[UILabel class]]) {
        [(UILabel *)view setText:title];
    }
    return view;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 1:
            self.selectRow2 = row;
            self.selectRow3 = 0;
            break;
        case 2:
            self.selectRow3 = row;
            break;
        default:
            self.selectRow1 = row;
            self.selectRow2 = 0;
            self.selectRow3 = 0;
            break;
    }
    switch (self.viewType) {
        case ZAlertPickerViewTypeSex:
        {
            self.text = [self.arrayMain objectAtIndex:row];
            [pickerView reloadAllComponents];
            break;
        }
        case ZAlertPickerViewTypeEducation:
        {
            self.text = [self.arrayMain objectAtIndex:row];
            [pickerView reloadAllComponents];
            break;
        }
        case ZAlertPickerViewTypeTime:
        {
            switch (component) {
                case 1:
                {
                    self.month = [NSString stringWithFormat:@"%d", (row+1)];
                    self.day = [NSString stringWithFormat:@"%d", (1)];
                    [pickerView reloadAllComponents];
                    [pickerView selectRow:0 inComponent:2 animated:false];
                    break;
                }
                case 2:
                {
                    self.day = [NSString stringWithFormat:@"%d", (row+1)];
                    [pickerView reloadAllComponents];
                    break;
                }
                default:
                {
                    self.year = [self.arrayMain objectAtIndex:row];
                    self.month = [NSString stringWithFormat:@"%d", (1)];
                    self.day = [NSString stringWithFormat:@"%d", (1)];
                    [pickerView reloadAllComponents];
                    [pickerView selectRow:0 inComponent:1 animated:false];
                    [pickerView selectRow:0 inComponent:2 animated:false];
                    break;
                }
            }
            break;
        }
        case ZAlertPickerViewTypeArea:
        {
            switch (component) {
                case 1:
                {
                    self.area = kEmpty;
                    self.arrayArea = nil;
                    if (self.arrayCity.count > row) {
                        NSDictionary *dicCity = [self.arrayCity objectAtIndex:row];
                        if (dicCity && [dicCity isKindOfClass:[NSDictionary class]]) {
                            self.city = [dicCity objectForKey:@"name"];
                            NSString *codeC = [dicCity objectForKey:@"id"];
                            NSArray *areaArray = [self.dicAllArea objectForKey:codeC];
                            if (areaArray && [areaArray isKindOfClass:[NSArray class]] && areaArray.count > 0) {
                                self.arrayArea = [NSArray arrayWithArray:areaArray];
                                NSDictionary *dicArea = [self.arrayArea firstObject];
                                if (dicArea && [dicArea isKindOfClass:[NSDictionary class]]) {
                                    self.area = [dicArea objectForKey:@"name"];
                                }
                            }
                        }
                    }
                    [pickerView reloadAllComponents];
                    if (self.arrayArea.count > 0) {
                        [pickerView selectRow:0 inComponent:2 animated:false];
                    }
                    break;
                }
                case 2:
                {
                    if (self.arrayArea.count > row) {
                        NSDictionary *dicArea = [self.arrayArea objectAtIndex:row];
                        if (dicArea && [dicArea isKindOfClass:[NSDictionary class]]) {
                            self.area = [dicArea objectForKey:@"name"];
                        }
                    }
                    [pickerView reloadAllComponents];
                    break;
                }
                default:
                {
                    self.city = kEmpty;
                    self.area = kEmpty;
                    self.arrayArea = nil;
                    self.arrayCity = nil;
                    if (self.arrayMain.count > row) {
                        NSDictionary *dicProvince = [self.arrayMain objectAtIndex:row];
                        if (dicProvince && [dicProvince isKindOfClass:[NSDictionary class]]) {
                            self.province = [dicProvince valueForKey:@"name"];
                            NSString *codeP = [dicProvince objectForKey:@"id"];
                            codeP = codeP == nil ? kEmpty : codeP;
                            NSArray *cityArray = [self.dicAllCity objectForKey:codeP];
                            if (cityArray && [cityArray isKindOfClass:[NSArray class]] && cityArray.count > 0) {
                                self.arrayCity = [NSArray arrayWithArray:cityArray];
                                NSDictionary *dicCity = [self.arrayCity firstObject];
                                if (dicCity && [dicCity isKindOfClass:[NSDictionary class]]) {
                                    self.city = [dicCity objectForKey:@"name"];
                                    NSString *codeC = [dicCity objectForKey:@"id"];
                                    NSArray *areaArray = [self.dicAllArea objectForKey:codeC];
                                    if (areaArray && [areaArray isKindOfClass:[NSArray class]] && areaArray.count > 0) {
                                        self.arrayArea = [NSArray arrayWithArray:areaArray];
                                        NSDictionary *dicArea = [self.arrayArea firstObject];
                                        if (dicArea && [dicArea isKindOfClass:[NSDictionary class]]) {
                                            self.area = [dicArea objectForKey:@"name"];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    [pickerView reloadAllComponents];
                    if (self.arrayCity.count > 0) {
                        [pickerView selectRow:0 inComponent:1 animated:false];
                    }
                    if (self.arrayArea.count > 0) {
                        [pickerView selectRow:0 inComponent:2 animated:false];
                    }
                    break;
                }
            }
            break;
        }
    }
}

@end
