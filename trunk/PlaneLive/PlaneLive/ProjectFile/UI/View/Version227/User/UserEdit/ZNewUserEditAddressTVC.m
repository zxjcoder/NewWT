//
//  ZNewUserEditAddressTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditAddressTVC.h"

@interface ZNewUserEditAddressTVC()

@property (strong, nonatomic) NSString *address;

@end

@implementation ZNewUserEditAddressTVC

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
    [self.lbTitle setText:kResidence];
    
    [self.textField setEnabled:false];
    [self.textField setMaxLength:kNumberResidenceMaxLength];
    [self.textField setPlaceholder:kPleaseSelect];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.address];
    
    return self.cellH;
}

@end
