//
//  ZMyTaskItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 9/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyTaskItemTVC.h"

@interface ZMyTaskItemTVC()

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIImageView *viewLine;

@end

@implementation ZMyTaskItemTVC

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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"mine_task_icon"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setLineBreakMode:1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewLine = [[UIImageView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 50;
    [self.imgIcon setFrame:CGRectMake(self.space, kSize10, imgSize, imgSize)];
    
    CGFloat lbX = self.imgIcon.x+imgSize+self.space;
    CGFloat titleW = self.cellW-lbX-self.space;
    [self.lbTitle setFrame:CGRectMake(lbX, self.cellH/2-self.lbH/2, titleW, self.lbH)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(CGFloat)setCellDataWithModel:(ModelTask *)model
{
    if (model) {
        if (model.status == 0) {
            [self.imgIcon setImage:[SkinManager getImageWithName:@"mine_task_icon"]];
        } else {
            [self.imgIcon setImage:[SkinManager getImageWithName:@"mine_task_icon_end"]];
        }
        [self.lbTitle setText:model.content];
    }
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 70;
}
+(CGFloat)getH
{
    return 70;
}

@end
