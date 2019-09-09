//
//  ZUserEditBirthdayTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditBirthdayTVC.h"
#import "ZUserSelectDateTimeView.h"

@interface ZUserEditBirthdayTVC()

@property (strong, nonatomic) ZUserSelectDateTimeView *pickerView;

@end

@implementation ZUserEditBirthdayTVC

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
    
    [self.lbTitle setText:kBirthday];
    
    ZWEAKSELF
    self.pickerView = [[ZUserSelectDateTimeView alloc] init];
    [self.pickerView setOnSelectChange:^(NSString *selectValue) {
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
    [self.textField setText:model.birthday];
    
    return self.cellH;
}

-(void)setCellDateTimeWithModel:(ModelUser *)model
{
    [self.pickerView setDefaultSelectValue:model.birthday];
}

-(void)setViewNil
{
    OBJC_RELEASE(_pickerView);
    [super setViewNil];
}

@end
