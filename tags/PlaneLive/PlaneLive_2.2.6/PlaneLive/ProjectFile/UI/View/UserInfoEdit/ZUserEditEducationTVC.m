//
//  ZUserEditEducationTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditEducationTVC.h"
#import "ZUserSelectEducationView.h"

@interface ZUserEditEducationTVC()

@property (strong, nonatomic) ZUserSelectEducationView *pickerView;

@end

@implementation ZUserEditEducationTVC

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
    
    [self.lbTitle setText:kEducation];
    [self.textField setEnabled:false];
    [self setMaxTextLength:4];
    
    [self.textField setPlaceholder:kPleaseSelect];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.education];
    
    [self.pickerView setDefaultSelectValue:model.education];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_pickerView);
    [super setViewNil];
}

@end
