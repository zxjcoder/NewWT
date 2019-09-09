//
//  ZUserEditCompanyTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditCompanyTVC.h"

@implementation ZUserEditCompanyTVC

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
    
    [self.textField setMaxLength:kNumberCompanyENMaxLength];
    [self.textField setTextFieldIndex:ZTextFieldIndexUserEditCompany];
    
    [self delImageAccessoryView];
    [self.lbTitle setText:kCompany];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.company];
    
    return self.cellH;
}

@end
