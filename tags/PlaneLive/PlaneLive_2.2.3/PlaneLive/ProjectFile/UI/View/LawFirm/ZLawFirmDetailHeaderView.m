//
//  ZLawFirmDetailHeaderView.m
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmDetailHeaderView.h"

@interface ZLawFirmDetailHeaderView()

///颜色
@property (strong, nonatomic) UIImageView *imgIcon;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZLawFirmDetailHeaderView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit:title];
    }
    return self;
}
-(void)innerInit:(NSString *)title
{
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeSpace, self.height/2-13/2, 10, 13)];
    [self.imgIcon setImage:[SkinManager getImageWithName:@"item_nav_icon"]];
    [self addSubview:self.imgIcon];
    
    CGFloat btnW = 55;
    CGFloat titleX = self.imgIcon.x+self.imgIcon.width+8;
    CGFloat titleW = self.width-titleX-btnW-kSizeSpace;
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, self.height/2-20/2, titleW, 20)];
    [self.lbTitle setTextColor:RGBCOLOR(70, 70, 70)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setText:title];
    [self addSubview:self.lbTitle];
    
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, self.height-kLineHeight, self.width, kLineHeight)];
    [self addSubview:self.imgLine];
}
-(void)dealloc
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLine);
}

@end
