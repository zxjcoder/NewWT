//
//  ZUserEditNickNameTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditNickNameTVC.h"

@implementation ZUserEditNickNameTVC

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
    
    [self setMaxTextLength:kNumberNickNameMaxLength];
    
    [self.lbTitle setText:kCNickName];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.nickname];
    
    return self.cellH;
}

@end
