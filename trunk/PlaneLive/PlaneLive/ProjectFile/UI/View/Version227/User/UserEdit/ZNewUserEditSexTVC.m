//
//  ZNewUserEditSexTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditSexTVC.h"

@interface ZNewUserEditSexTVC()

@property (assign, nonatomic) WTSexType sexType;

@end

@implementation ZNewUserEditSexTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [self.lbTitle setText:kCGender];
    
    [self.textField setMaxLength:10];
    [self.textField setEnabled:false];
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
    return self.cellH;
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
