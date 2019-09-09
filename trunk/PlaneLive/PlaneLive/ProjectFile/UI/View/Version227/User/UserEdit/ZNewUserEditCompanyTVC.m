//
//  ZNewUserEditCompanyTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditCompanyTVC.h"

@implementation ZNewUserEditCompanyTVC

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
    [self.lbTitle setText:kCompany];
    
    [self.textField setMaxLength:kNumberCompanyENMaxLength];
    [self.textField setTextFieldIndex:ZTextFieldIndexUserEditCompany];
    
    [self delImageAccessoryView];
    
    CGRect textFrame = self.textField.frame;
    textFrame.size.width = self.cellW-textFrame.origin.x-self.space;
    [self.textField setFrame:(textFrame)];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.company];
    
    return self.cellH;
}

@end
