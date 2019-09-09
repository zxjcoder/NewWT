//
//  ZNewUserEditEducationTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditEducationTVC.h"

@implementation ZNewUserEditEducationTVC

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
    [self.lbTitle setText:kEducation];
    
    [self.textField setMaxLength:20];
    [self.textField setEnabled:false];
    [self.textField setPlaceholder:kPleaseSelect];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.education];
    
    return self.cellH;
}

@end
