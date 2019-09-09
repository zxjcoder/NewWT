//
//  ZNewUserEditNickNameTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditNickNameTVC.h"

@implementation ZNewUserEditNickNameTVC

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
    [self.lbTitle setText:@"昵称"];
    
    [self.textField setPlaceholder:@"请输入昵称"];
    [self.textField setMaxLength:kNumberNickNameMaxLength];
    [self.textField setTextFieldIndex:ZTextFieldIndexUserEditNickName];
    
    [self delImageAccessoryView];
    
    CGRect textFrame = self.textField.frame;
    textFrame.size.width = self.cellW-textFrame.origin.x-self.space;
    [self.textField setFrame:(textFrame)];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.nickname];
    
    return self.cellH;
}

@end
