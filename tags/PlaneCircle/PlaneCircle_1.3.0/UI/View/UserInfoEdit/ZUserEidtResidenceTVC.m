//
//  ZUserEidtResidenceTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEidtResidenceTVC.h"
#import "ZPickerView.h"

@interface ZUserEidtResidenceTVC()<ZPickerViewDelegate>

@property (strong, nonatomic) ZPickerView *pickerView;

@property (strong, nonatomic) NSString *address;

@end

@implementation ZUserEidtResidenceTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    [self.lbTitle setText:@"居住地"];
    
    self.pickerView = [[ZPickerView alloc] initPickerViewWithCityPlist];
    [self.pickerView setDelegate:self];
    
    [self setMaxTextLength:kNumberResidenceMaxLength];
    
    [self.textField setPlaceholder:@"请选择"];
    [self.textField setInputView:self.pickerView];
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    NSArray *arr = [model.address componentsSeparatedByString:@","];
    if (arr.count == 2) {
        [self.pickerView setStateAndCity:model.address];
    }
    [self.textField setText:model.address];
}

-(void)setViewNil
{
    OBJC_RELEASE(_pickerView);
    OBJC_RELEASE(_address);
    OBJC_RELEASE(_onDoneClick);
    OBJC_RELEASE(_onSelectCity);
    [super setViewNil];
}

#pragma mark - ZPickerViewDelegate

-(void)pickerViewValueChange:(ZPickerView *)pickView resultString:(NSString *)resultString
{
    if (self.onSelectCity) {
        self.onSelectCity(resultString);
    }
}

-(void)pickerViewToobarClearClick:(ZPickerView *)pickView
{
    [self.textField setText:kEmpty];
}

-(void)pickerViewToobarDoneClick:(ZPickerView *)pickView resultString:(NSString *)resultString
{
    if (self.onDoneClick) {
        self.onDoneClick(resultString);
    }
}

@end
