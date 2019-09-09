//
//  ZUserEditTradeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditTradeTVC.h"

@interface ZUserEditTradeTVC()

@end

@implementation ZUserEditTradeTVC

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
    
    [self.lbTitle setText:@"行业"];
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.trade];
}

@end
