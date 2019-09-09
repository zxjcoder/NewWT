//
//  ZNewUserEditIndustryTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditIndustryTVC.h"

@implementation ZNewUserEditIndustryTVC

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
    [self.lbTitle setText:kIndustry];
    
    [self.textField setMaxLength:kNumberTradeMaxLength];
    [self.textField setTextFieldIndex:ZTextFieldIndexUserEditTrade];
    
    [self delImageAccessoryView];
    
    CGRect textFrame = self.textField.frame;
    textFrame.size.width = self.cellW-textFrame.origin.x-self.space;
    [self.textField setFrame:(textFrame)];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.trade];
    
    return self.cellH;
}

@end
