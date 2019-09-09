//
//  ZBannerCardItemView.m
//  PlaneLive
//
//  Created by WT on 13/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBannerCardItemView.h"
#import "ZImageView.h"

@interface ZBannerCardItemView()

@property (strong, nonatomic) ZImageView *imageIcon;

@end

@implementation ZBannerCardItemView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    self.imageIcon = [[ZImageView alloc] initWithFrame:(self.bounds)];
    [self addSubview:self.imageIcon];
}
/// 设置数据源
-(void)setViewDataWithModel:(ModelBanner *)model
{
    [self.imageIcon setImageURLStr:model.imageUrl placeImage:[UIImage imageNamed:@"default_banner"]];
}
+(CGFloat)getW
{
    return APP_FRAME_WIDTH-40;
}
+(CGFloat)getH
{
    return [ZBannerCardItemView getW]*0.42;
}

@end
