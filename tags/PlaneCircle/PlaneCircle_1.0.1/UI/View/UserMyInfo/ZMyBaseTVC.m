//
//  ZMyBaseTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyBaseTVC.h"

#define kZMyBaseTVCHeight 44

@interface ZMyBaseTVC()

@end

@implementation ZMyBaseTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
    self.cellH = kZMyBaseTVCHeight;
    self.cellW = APP_FRAME_WIDTH;
    self.space  = 10;
    self.lineH= 1;
    self.lineMaxH = 5;
    self.lbH = 23;
    self.lbMinH = 20;
    self.arrowW = self.cellW/11;
    self.borderW = 0.8;
    self.buttonH = 30;
    self.leftW = 75;
    self.rightX = self.leftW+self.space*2;
    
    [self setBackgroundColor:TABLEVIEWCELL_BACKCOLOR];
    [self setAccessoryType:(UITableViewCellAccessoryNone)];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    self.viewMain = [[ZTVCBGView alloc] init];
    [self.viewMain setBackgroundColor:TABLEVIEWCELL_BACKCOLOR];
    [self.viewMain setUserInteractionEnabled:YES];
    [self.contentView addSubview:self.viewMain];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellW = APP_FRAME_WIDTH;
    
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

-(void)setCellDataWithModel:(ModelEntity*)model
{
    
}

-(void)setCellKeyword:(NSString *)keyword
{
    
}

+(CGFloat)getH
{
    return kZMyBaseTVCHeight;
}
-(CGFloat)getH
{
    return kZMyBaseTVCHeight;
}
-(void)setH:(CGFloat)h
{
    [self setCellH:h];
}

@end
