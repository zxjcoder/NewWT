//
//  ZBaseTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"


#define kZBaseTVCH 44

@interface ZBaseTVC()
{
    UIImageView *imgAccessory;
}
@end

@implementation ZBaseTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self innerInit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Event

-(void)innerInit
{
    self.cellH = kZBaseTVCH;
    self.cellW = APP_FRAME_WIDTH;
    self.space = kSize20;
    self.lineH = kLineHeight;
    self.lineMaxH = kLineMaxHeight;
    self.lbH = 20;
    self.lbMinH = 18;
    self.arrowX = self.cellW-self.space-10;
    self.borderW = 0.8;
    self.buttonH = 30;
    self.leftW = 75;
    self.rightX = self.leftW+self.space*2;
    
    [self setBackgroundColor:TABLEVIEWCELL_BACKCOLOR];
    [self setAccessoryType:(UITableViewCellAccessoryNone)];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    self.viewMain = [[ZTVCBGView alloc] init];
    [self.viewMain setBackgroundColor:CLEARCOLOR];
    [self.viewMain setUserInteractionEnabled:YES];
    [self.contentView addSubview:self.viewMain];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewMain setFrame:self.getMainFrame];
}

-(CGRect)getMainFrame
{
    return CGRectMake(0, 0, self.cellW, self.cellH);
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewMain);
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)setCellDataWithModel:(ModelEntity *)model
{
    return self.cellH;
}

-(void)setCellKeyword:(NSString *)keyword
{
    
}

-(void)setImageAccessoryView
{
    imgAccessory = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"arrow_right"]];
    [self.viewMain addSubview:imgAccessory];
    
    imgAccessory.frame = CGRectMake(self.cellW - self.space - 8, self.cellH / 2 - 8, 10, 16);
}
-(void)delImageAccessoryView
{
    [imgAccessory removeFromSuperview];
    imgAccessory = nil;
}

+(CGFloat)getH
{
    return kZBaseTVCH;
}
-(CGFloat)getH
{
    return self.cellH;
}



@end
