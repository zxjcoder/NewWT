//
//  ZAccountBindPhoneTVC.m
//  PlaneLive
//
//  Created by Daniel on 29/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountBindPhoneTVC.h"
#import "Utils.h"

@interface ZAccountBindPhoneTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) UILabel *lbBind;

@property (strong, nonatomic) UIImageView *imgNext;

@end

@implementation ZAccountBindPhoneTVC

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
    
    self.cellH = [ZAccountBindPhoneTVC getH];
    
    self.imgNext = [[UIImageView alloc] initWithFrame:CGRectMake(self.cellW-25, self.cellH/2-18/2, 10, 18)];
    [self.imgNext setImage:[SkinManager getImageWithName:@"wode_btn_enter_s"]];
    [self.viewMain addSubview:self.imgNext];
    
    self.lbBind = [[UILabel alloc] init];
    [self.lbBind setTextAlignment:(NSTextAlignmentRight)];
    [self.lbBind setTextColor:DESCCOLOR];
    [self.lbBind setText:kNotBound];
    [self.lbBind setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbBind];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setText:kMyMobilePhoneNumber];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setText:kMyMobilePhoneNumberDesc];
    [self.viewMain addSubview:self.lbDesc];
    
    [self setViewFrame:nil];
}
-(void)setViewFrame:(NSString *)phone
{
    CGFloat bindW = 60;
    CGFloat bindX = self.imgNext.x-bindW-kSize8;
    [self.lbBind setFrame:CGRectMake(bindX, self.cellH/2-self.lbH/2, bindW, self.lbH)];
    CGFloat bindNewW = [self.lbBind getLabelWidthWithMinWidth:bindW];
    bindX = self.imgNext.x-bindNewW-kSize8;
    [self.lbBind setFrame:CGRectMake(bindX, self.cellH/2-self.lbH/2, bindNewW, self.lbH)];
    
    CGFloat titleW = bindX-kSizeSpace;
    if (phone == nil || phone.length == 0) {
        [self.lbDesc setHidden:NO];
        [self.lbTitle setFrame:CGRectMake(kSizeSpace, 6, titleW, self.lbH)];
        [self.lbDesc setFrame:CGRectMake(kSizeSpace, self.cellH/2+2, titleW, self.lbMinH)];
    } else {
        [self.lbDesc setHidden:YES];
        [self.lbTitle setFrame:CGRectMake(kSizeSpace, self.cellH/2-self.lbH/2, titleW, self.lbH)];
    }
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    if (model.phone == nil || model.phone.length == 0) {
        [self.lbBind setText:kNotBound];
        
    } else {
        [self.lbBind setText:[Utils getStringStarWithStr:model.phone]];
    }
    [self setViewFrame:model.phone];
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbBind);
    OBJC_RELEASE(_imgNext);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 50;
}

@end
