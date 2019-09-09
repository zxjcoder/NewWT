//
//  ZNewUserEditBirthdayTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditBirthdayTVC.h"

@implementation ZNewUserEditBirthdayTVC

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
    [self.lbTitle setText:kBirthday];
    
    [self.textField setEnabled:false];
    [self.textField setMaxLength:10];
    [self.textField setPlaceholder:kPleaseSelect];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.birthday];
    
    return self.cellH;
}

@end
