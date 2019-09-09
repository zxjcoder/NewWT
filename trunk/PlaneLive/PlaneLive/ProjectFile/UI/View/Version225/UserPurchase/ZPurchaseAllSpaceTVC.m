//
//  ZPurchaseAllSpaceTVC.m
//  PlaneLive
//
//  Created by Daniel on 02/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPurchaseAllSpaceTVC.h"

@interface ZPurchaseAllSpaceTVC()

@property (strong, nonatomic) ZImageView *imageView;
@property (strong, nonatomic) ZLabel *lbTitle;

@end

@implementation ZPurchaseAllSpaceTVC

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
    
    self.cellH = [ZPurchaseAllSpaceTVC getH];
    
    if (!self.imageView) {
        self.imageView = [[ZImageView alloc] init];
        [self.viewMain addSubview:self.imageView];
    }
    if (!self.lbTitle) {
        self.lbTitle = [[UILabel alloc] init];
        [self.lbTitle setTextColor:COLORTEXT2];
        [self.lbTitle setUserInteractionEnabled:false];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self.viewMain addSubview:self.lbTitle];
    }
    self.imageView.image = [SkinManager getImageWithName:@"default_order"];
    [self.lbTitle setText:@"您还没有购买课程"];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:(CGRectMake(self.cellW/2-175/2, 30, 175, 175))];
    self.lbTitle.frame = CGRectMake(self.space, self.imageView.y+self.imageView.height+20, self.cellW-self.space*2, self.lbH);
}
+(CGFloat)getH
{
    return 260;
}

@end
