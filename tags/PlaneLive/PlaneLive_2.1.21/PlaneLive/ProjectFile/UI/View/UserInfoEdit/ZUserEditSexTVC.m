//
//  ZUserEditSexTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditSexTVC.h"
#import "ZUserSelectSexView.h"

@interface ZUserEditSexTVC()

@property (strong, nonatomic) ZUserSelectSexView *pickerView;

@property (assign, nonatomic) WTSexType sexType;

@end

@implementation ZUserEditSexTVC

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
    
    [self.lbTitle setText:kCGender];
    
    ZWEAKSELF
    self.pickerView = [[ZUserSelectSexView alloc] init];
    [self.pickerView setOnSelectChange:^(NSString *selectValue) {
        if ([selectValue isEqualToString:kCFemale]) {
            [weakSelf setSexType:(WTSexTypeFeMale)];
        } else if ([selectValue isEqualToString:kCMale]) {
            [weakSelf setSexType:(WTSexTypeMale)];
        } else {
            [weakSelf setSexType:(WTSexTypeNone)];
        }
        [weakSelf.textField setText:selectValue];
    }];
    [self.pickerView setOnCloseClick:^{
        [weakSelf.textField resignFirstResponder];
    }];
    
    [self setMaxTextLength:4];
    
    [self.textField setPlaceholder:kPleaseSelect];
    [self.textField setInputView:self.pickerView];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self setSexType:model.sex];
    switch (model.sex) {
        case WTSexTypeNone:
            [self.textField setText:kCGenderSecrecy];
            break;
        case WTSexTypeMale:
            [self.textField setText:kCMale];
            break;
        case WTSexTypeFeMale:
            [self.textField setText:kCFemale];
            break;
        default:
            [self.textField setText:kEmpty];
            break;
    }
    [self.pickerView setDefaultSelectValue:self.textField.text];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_pickerView);
    [super setViewNil];
}

-(WTSexType)getSelectSexType
{
    return self.sexType;
}

@end
