//
//  ZUserEidtResidenceTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEidtResidenceTVC.h"
#import "ZCitySelectedView.h"

@interface ZUserEidtResidenceTVC()

@property (strong, nonatomic) ZCitySelectedView *pickerView;

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
    
    [self.lbTitle setText:kResidence];

    [self.textField setEnabled:false];
    [self setMaxTextLength:kNumberResidenceMaxLength];
    
    [self.textField setTextFieldIndex:ZTextFieldIndexUserEidtResidence];
    [self.textField setPlaceholder:kPleaseSelect];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.pickerView setDefaultSelectValue:model.address];
    
    [self.textField setText:model.address];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_pickerView);
    OBJC_RELEASE(_address);
    OBJC_RELEASE(_onDoneClick);
    OBJC_RELEASE(_onSelectCity);
    [super setViewNil];
}

@end
