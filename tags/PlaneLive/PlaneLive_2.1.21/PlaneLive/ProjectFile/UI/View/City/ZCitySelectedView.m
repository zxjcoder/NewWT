//
//  ZCitySelectedView.m
//  PlaneLive
//
//  Created by Daniel on 02/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCitySelectedView.h"
#import "ZBaseTableView.h"
#import "ZButton.h"

@interface ZCitySelectedView()<UITableViewDelegate, UITableViewDataSource>

/// 省份容器
@property (nonatomic, strong) ZBaseTableView *tvProvince;
/// 城市容器
@property (nonatomic, strong) ZBaseTableView *tvCity;
/// 工具栏
@property (nonatomic, strong) ZView *viewHeader;
/// 分割线
@property (nonatomic, strong) UIImageView *imgline1;
/// 分割线
@property (nonatomic, strong) UIImageView *imgline2;
/// 确定按钮
@property (nonatomic, strong) ZButton *btnDone;
/// 关闭按钮
@property (nonatomic, strong) ZButton *btnClose;

/// 省
@property (nonatomic, strong) NSArray *arrProvince;
/// 市
@property (strong, nonatomic) NSArray *arrCity;
/// 区
//@property (strong, nonatomic) NSArray *arrArea;

/// 选中的省市区
@property (nonatomic, strong) NSString *strSelectValue;

/// 省份选中索引
@property (assign, nonatomic) NSInteger rowProvince;
/// 城市选中索引
@property (assign, nonatomic) NSInteger rowCity;

@end

@implementation ZCitySelectedView

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
    [self.btnClose setTitle:kClose forState:(UIControlStateNormal)];
    [self.btnClose setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnClose setFrame:CGRectMake(5, 0, 60, self.viewHeader.height)];
    [self.btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewHeader addSubview:self.btnClose];
    
    self.btnDone = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDone setTitle:kDone forState:(UIControlStateNormal)];
    [self.btnDone setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnDone titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnDone setFrame:CGRectMake(self.viewHeader.width-65, 0, 60, self.viewHeader.height)];
    [self.btnDone addTarget:self action:@selector(btnDoneClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewHeader addSubview:self.btnDone];
    
    CGFloat tvY = self.viewHeader.height;
    self.tvProvince = [[ZBaseTableView alloc] initWithFrame:CGRectMake(0, tvY, self.width*0.4, self.height-tvY)];
    [self.tvProvince setDelegate:self];
    [self.tvProvince setDataSource:self];
    [self.tvProvince setShowsVerticalScrollIndicator:NO];
    [self.tvProvince setShowsHorizontalScrollIndicator:NO];
    [self.tvProvince setRowHeight:40];
    [self.tvProvince registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ProvinceCellID"];
    [self.tvProvince setSeparatorStyle:(UITableViewCellSeparatorStyleSingleLine)];
    [self addSubview:self.tvProvince];
    
    self.tvCity = [[ZBaseTableView alloc] initWithFrame:CGRectMake(self.width*0.4, tvY, self.width*0.6, self.height-tvY)];
    [self.tvCity setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvCity setDelegate:self];
    [self.tvCity setDataSource:self];
    [self.tvCity setShowsVerticalScrollIndicator:NO];
    [self.tvCity setShowsHorizontalScrollIndicator:NO];
    [self.tvCity setRowHeight:40];
    [self.tvCity registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CityCellID"];
    [self.tvCity setSeparatorStyle:(UITableViewCellSeparatorStyleSingleLine)];
    [self addSubview:self.tvCity];
    
    //解决cell分割线最左边开始绘制问题
    if ([self.tvProvince respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tvProvince setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tvProvince respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tvProvince setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self.tvCity respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tvCity setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tvCity respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tvCity setLayoutMargins:UIEdgeInsetsZero];
    }
    [self innerProvinceData];
}
-(void)btnDoneClick
{
    [self setChangeSelectValue];
    
    [self btnCloseClick];
}
-(void)btnCloseClick
{
    if (self.onCloseClick) {
        self.onCloseClick();
    }
}
-(void)setChangeSelectValue
{
    NSString *province = [self.arrProvince objectAtIndex:self.rowProvince][@"state"];
    NSString *city = [self.arrCity objectAtIndex:self.rowCity];
    self.strSelectValue = [NSString stringWithFormat:@"%@,%@", province, city];
    if (self.onSelectChange) {
        self.onSelectChange(self.strSelectValue);
    }
}
-(void)innerProvinceData
{
    NSString *path= [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    self.arrProvince = [[NSArray alloc] initWithContentsOfFile:path];
    
    [self innerCityData:0];
    
    [self setRowProvince:0];
    [self setRowCity:0];
    
    NSString *province = [self.arrProvince objectAtIndex:0][@"state"];
    NSString *city = [self.arrCity objectAtIndex:0];
    self.strSelectValue = [NSString stringWithFormat:@"%@,%@", province, city];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tvProvince selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [self.tvProvince reloadData];
    [self.tvCity reloadData];
}
-(void)innerCityData:(NSInteger)provinceRow
{
    NSArray *cityArr = self.arrProvince[provinceRow][@"cities"];
    self.arrCity = [NSArray arrayWithArray:cityArr];
}
-(void)setDefaultSelectValue:(NSString *)selValue
{
    NSArray *arrSelectValue = [selValue componentsSeparatedByString:@","];
    if (arrSelectValue && arrSelectValue.count == 2) {
        NSInteger row = 0;
        for (NSDictionary *dic in self.arrProvince) {
            if ([arrSelectValue.firstObject isEqualToString:[dic objectForKey:@"state"]]) {
                [self setRowProvince:row];
                self.arrCity = [dic objectForKey:@"cities"];
                NSInteger cityRow = 0;
                for (NSString *city in self.arrCity) {
                    if ([city isEqualToString:arrSelectValue.lastObject]) {
                        [self setRowCity:cityRow];
                        break;
                    }
                    cityRow++;
                }
                break;
            }
            row++;
        }
        [self.tvProvince reloadData];
        [self.tvCity reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowProvince inSection:0];
        [self.tvProvince selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        NSIndexPath *indexPathCity = [NSIndexPath indexPathForRow:self.rowCity inSection:0];
        [self.tvCity selectRowAtIndexPath:indexPathCity animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [_tvProvince setDelegate:nil];
    [_tvProvince setDataSource:nil];
    OBJC_RELEASE(_tvProvince);
    [_tvCity setDelegate:nil];
    [_tvCity setDataSource:nil];
    OBJC_RELEASE(_tvCity);
    OBJC_RELEASE(_arrCity);
    OBJC_RELEASE(_arrProvince);
    OBJC_RELEASE(_strSelectValue);
    OBJC_RELEASE(_onSelectChange);
    OBJC_RELEASE(_btnDone);
    OBJC_RELEASE(_btnClose);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_imgline1);
    OBJC_RELEASE(_imgline2);
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

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tvProvince]) {
        return self.arrProvince.count;
    }
    return self.arrCity.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tvProvince]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProvinceCellID"];
        if (self.rowProvince == indexPath.row) {
            [cell setBackgroundColor:VIEW_BACKCOLOR2];
        } else {
            [cell setBackgroundColor:VIEW_BACKCOLOR1];
        }
        [cell setSelectionStyle:(UITableViewCellSelectionStyleGray)];
        NSString *province = [self.arrProvince objectAtIndex:indexPath.row][@"state"];
        [cell.textLabel setText:province];
        [cell.textLabel setTextAlignment:(NSTextAlignmentCenter)];
        [cell.textLabel setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
        
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCellID"];
    if (self.rowCity == indexPath.row) {
        [cell setBackgroundColor:RGBCOLOR(222, 222, 222)];
    } else {
        [cell setBackgroundColor:VIEW_BACKCOLOR2];
    }
    [cell setSelectionStyle:(UITableViewCellSelectionStyleGray)];
    NSString *city = [self.arrCity objectAtIndex:indexPath.row];
    [cell.textLabel setText:city];
    [cell.textLabel setTextAlignment:(NSTextAlignmentCenter)];
    [cell.textLabel setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tvProvince]) {
        [self setRowProvince:indexPath.row];
        [self innerCityData:indexPath.row];
        [self.tvProvince reloadData];
        
        [self setRowCity:0];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [self.tvCity reloadSections:set withRowAnimation:UITableViewRowAnimationRight];
        [self.tvCity scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionNone) animated:YES];
    } else if ([tableView isEqual:self.tvCity]) {
        [self setRowCity:indexPath.row];
        [self.tvCity reloadData];
        
        //[self setChangeSelectValue];
    }
}

@end
