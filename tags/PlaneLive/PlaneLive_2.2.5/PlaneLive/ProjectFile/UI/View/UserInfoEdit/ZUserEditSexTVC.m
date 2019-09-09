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

    [self.textField setEnabled:false];
    [self setMaxTextLength:4];
    
    [self.textField setPlaceholder:kPleaseSelect];
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
    if ([self.textField.text isEqualToString:kCMale]) {
        self.sexType = WTSexTypeMale;
    } else if ([self.textField.text isEqualToString:kCFemale]) {
        self.sexType = WTSexTypeFeMale;
    } else {
        self.sexType = WTSexTypeNone;
    }
    return self.sexType;
}

@end
