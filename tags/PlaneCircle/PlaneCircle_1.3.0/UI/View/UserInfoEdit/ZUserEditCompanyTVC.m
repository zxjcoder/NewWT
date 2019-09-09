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
    
    [self setMaxTextLength:kNumberCompanyENMaxLength];
    
    [self.lbTitle setText:@"公司"];
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.company];
}

@end
