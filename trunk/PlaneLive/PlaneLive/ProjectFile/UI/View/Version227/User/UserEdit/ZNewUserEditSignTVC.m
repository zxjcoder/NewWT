//
//  ZNewUserEditSignTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditSignTVC.h"

@implementation ZNewUserEditSignTVC

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
    [self.lbTitle setText:@"个性签名"];
    
    [self.textField setMaxLength:kNumberSignMaxLength];
    [self.textField setTextFieldIndex:ZTextFieldIndexUserEditSign];
    
    [self delImageAccessoryView];
    
    CGRect textFrame = self.textField.frame;
    textFrame.size.width = self.cellW-textFrame.origin.x-self.space;
    [self.textField setFrame:(textFrame)];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.sign];
    
    return self.cellH;
}

@end
