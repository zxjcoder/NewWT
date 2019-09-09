//
//  ZUserSelectSexView.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserSelectSexView.h"
#import "ZButton.h"

@interface ZUserSelectSexView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (assign, nonatomic) NSInteger selectIndex;
/// 工具栏
@property (nonatomic, strong) ZView *viewHeader;
/// 分割线
@property (nonatomic, strong) UIImageView *imgline1;
/// 分割线
@property (nonatomic, strong) UIImageView *imgline2;
/// 关闭按钮
@property (nonatomic, strong) ZButton *btnClose;

/// 显示数据对象
@property (strong, nonatomic) UIPickerView *pickerView;

/// 数据集合
@property (strong, nonatomic) NSArray *arrMain;

/// 选中的值
@property (nonatomic, strong) NSString *strSelectValue;

@end

@implementation ZUserSelectSexView

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, 280)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    [self innerData];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewHeader = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    [self.viewHeader setBackgroundColor:VIEW_BACKCOLOR2];
    [self addSubview:self.viewHeader];
    
    self.imgline1 = [UIImageView getDLineView];
    [self.imgline1 setFrame:CGRectMake(0, 0, self.viewHeader.width, kLineHeight)];
    [self.viewHeader addSubview:self.imgline1];
    
    self.imgline2 = [UIImageView getDLineView];
    [self.imgline2 setFrame:CGRectMake(0, self.viewHeader.height-kLineHeight, self.viewHeader.width, kLineHeight)];
    [self.viewHeader addSubview:self.imgline2];
    
    self.btnClose = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnClose setTitle:kDetermine forState:(UIControlStateNormal)];
    [self.btnClose setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnClose setFrame:CGRectMake(self.width-65, 0, 60, self.viewHeader.height)];
    [self.btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewHeader addSubview:self.btnClose];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.viewHeader.height, self.width, self.height-self.viewHeader.height)];
    [self.pickerView setDataSource:self];
    [self.pickerView setDelegate:self];
    [self addSubview:self.pickerView];
}
-(void)innerData
{
    NSString *path= [[NSBundle mainBundle] pathForResource:@"sex" ofType:@"plist"];
    self.arrMain = [[NSArray alloc] initWithContentsOfFile:path];
}
-(void)btnCloseClick
{
    if (self.arrMain.count > 0 && self.arrMain.count > self.selectIndex) {
        [self setStrSelectValue:[self.arrMain objectAtIndex:self.selectIndex]];
        if (self.onSelectChange) {
            self.onSelectChange(self.strSelectValue);
        }
    }
    if (self.onCloseClick) {
        self.onCloseClick();
    }
}
/// 设置默认选中值
-(void)setDefaultSelectValue:(NSString *)selValue
{
    if (selValue == nil || [selValue isEmpty]) {
        return;
    }
    int row = 0;
    for (NSString *title in self.arrMain) {
        if ([title isEqualToString:selValue]) {
            [self.pickerView selectRow:row inComponent:0 animated:NO];
        }
        row++;
    }
    self.selectIndex = row;
    [self.pickerView reloadAllComponents];
}

-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    OBJC_RELEASE(_strSelectValue);
    OBJC_RELEASE(_onSelectChange);
    OBJC_RELEASE(_btnClose);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_imgline1);
    OBJC_RELEASE(_imgline2);
    _pickerView.dataSource = nil;
    _pickerView.delegate = nil;
    OBJC_RELEASE(_pickerView);
}
-(void)show
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        self.frame = CGRectMake(self.frame.origin.x, APP_FRAME_HEIGHT-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}
-(void)dismiss
{
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self setFrame:CGRectMake(0, APP_FRAME_HEIGHT, self.width, self.height)];
    } completion:^(BOOL finished) {
        [self setViewNil];
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrMain.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arrMain objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectIndex = row;
    [self setStrSelectValue:[self.arrMain objectAtIndex:row]];
    if (self.onSelectChange) {
        self.onSelectChange(self.strSelectValue);
    }
}


@end
