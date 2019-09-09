//
//  ZRankDetailItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailItemTVC.h"

@interface ZRankDetailItemTVC()
///序号
@property (strong, nonatomic) UILabel *lbSerialNumber;
///代码
@property (strong, nonatomic) UILabel *lbCode;
///名称
@property (strong, nonatomic) UILabel *lbName;

@end

@implementation ZRankDetailItemTVC

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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.lbSerialNumber = [[UILabel alloc] init];
    [self.lbSerialNumber setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbSerialNumber setTextColor:BLACKCOLOR1];
    [self.lbSerialNumber setNumberOfLines:1];
    [self.lbSerialNumber setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbSerialNumber setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSerialNumber];
    
    self.lbName = [[UILabel alloc] init];
    [self.lbName setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbName setTextColor:BLACKCOLOR1];
    [self.lbName setNumberOfLines:0];
    [self.lbName setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbName];
    
    self.lbCode = [[UILabel alloc] init];
    [self.lbCode setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCode setTextColor:BLACKCOLOR1];
    [self.lbCode setNumberOfLines:1];
    [self.lbCode setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbCode setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCode];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    if (self.tag%2 == 0) {
        [self.viewMain setBackgroundColor:WHITECOLOR];
    } else {
        [self.viewMain setBackgroundColor:RGBCOLOR(249, 249, 249)];
    }
    CGFloat lbY = kSize10;
    
    if (self.lbCode.hidden) {
        [self.lbSerialNumber setFrame:CGRectMake(0, lbY, 60, self.lbH)];
        
        CGFloat nameX = self.lbSerialNumber.x+self.lbSerialNumber.width;
        CGRect nameFrame = CGRectMake(nameX, lbY, self.cellW-nameX-5, self.lbH);
        [self.lbName setFrame:nameFrame];
        CGFloat nameH = [self.lbName getLabelHeightWithMinHeight:self.lbH];
        nameFrame.size.height = nameH;
        [self.lbName setFrame:nameFrame];
    } else {
        [self.lbSerialNumber setFrame:CGRectMake(0, lbY, 50, self.lbH)];
        
        CGRect codeFrame = CGRectMake(self.lbSerialNumber.x+self.lbSerialNumber.width, lbY, 110, self.lbH);
        [self.lbCode setFrame:codeFrame];
        
        CGFloat nameX = self.lbCode.x+self.lbCode.width;
        CGRect nameFrame = CGRectMake(self.lbCode.x+self.lbCode.width, lbY, self.cellW-nameX-5, self.lbH);
        [self.lbName setFrame:nameFrame];
        CGFloat nameH = [self.lbName getLabelHeightWithMinHeight:self.lbH];
        nameFrame.size.height = nameH;
        [self.lbName setFrame:nameFrame];
    }
    self.cellH = self.lbName.y+self.lbName.height+kSize10;
}

-(void)setCellDataWithModel:(ModelEntity *)model
{
    [self.lbSerialNumber setText:[NSString stringWithFormat:@"%d",(int)self.tag]];
    if ([model isKindOfClass:[ModelRankCompany class]]) {
        ModelRankCompany *modelRC = (ModelRankCompany*)model;
        [self.lbName setText:modelRC.company_name];
        if (modelRC.count.length == 0) {
            [self.lbCode setText:modelRC.code];
        } else {
            [self.lbCode setText:modelRC.count];
        }
        [self.lbCode setHidden:NO];
    } else if ([model isKindOfClass:[ModelRankUser class]]) {
        ModelRankUser *modelRU = (ModelRankUser*)model;
        [self.lbName setText:modelRU.nickname];
        [self.lbCode setHidden:YES];
    }
    [self setViewFrame];
}

-(CGFloat)getHWithModel:(ModelEntity *)model
{
    [self setCellDataWithModel:model];
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbCode);
    OBJC_RELEASE(_lbName);
    OBJC_RELEASE(_lbSerialNumber);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}

@end
