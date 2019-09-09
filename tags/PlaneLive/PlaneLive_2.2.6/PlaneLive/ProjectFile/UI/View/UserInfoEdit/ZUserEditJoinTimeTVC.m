//
//  ZUserEditJoinTimeTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditJoinTimeTVC.h"
#import "ZUserSelectDateTimeView.h"

@interface ZUserEditJoinTimeTVC()

@property (strong, nonatomic) ZUserSelectDateTimeView *pickerView;

@end

@implementation ZUserEditJoinTimeTVC

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
    
    [self.lbTitle setText:kJoinTime];
    [self.textField setEnabled:false];
    [self setMaxTextLength:4];
    
    [self.textField setPlaceholder:kPleaseSelect];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.joinTime];
    
    return self.cellH;
}

-(void)setCellDateTimeWithModel:(ModelUser *)model
{
    [self.pickerView setDefaultSelectValue:model.joinTime];
}

-(void)setViewNil
{
    OBJC_RELEASE(_pickerView);
    [super setViewNil];
}

@end
