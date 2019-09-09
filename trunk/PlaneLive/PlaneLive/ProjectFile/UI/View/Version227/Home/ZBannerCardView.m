//
//  ZBannerCardView.m
//  PlaneLive
//
//  Created by WT on 13/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBannerCardView.h"
#import "iCarousel.h"
#import "ZBannerCardItemView.h"

@interface ZBannerCardView()<iCarouselDelegate, iCarouselDataSource>

@property (strong, nonatomic) NSArray *arrayMain;
@property (strong, nonatomic) iCarousel *carousel;

@end

@implementation ZBannerCardView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    if (!self.carousel) {
        self.carousel = [[iCarousel alloc] initWithFrame:(CGRectMake(0, 0, self.width, self.height))];
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        if (IsIPadDevice) {
            self.carousel.scrollSpeed = 3;
        } else {
            self.carousel.scrollSpeed = 1;
        }
        self.carousel.pagingEnabled = true;
        self.carousel.bounces = false;
        self.carousel.type = iCarouselTypeCustom;
        [self addSubview:self.carousel];
    }
}
-(void)setViewData:(NSArray*)array
{
    self.arrayMain = array;
    
    [self.carousel reloadData];
}
/// 获取View高度
+(CGFloat)getViewH
{
    return [ZBannerCardItemView getH];
}

#pragma mark - iCarouselDelegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.arrayMain.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    if (view == nil) {
        ZBannerCardItemView *itemView = [[ZBannerCardItemView alloc] initWithFrame:(CGRectMake(0, 0, [ZBannerCardItemView getW], [ZBannerCardItemView getH]))];
        
        [itemView setViewRound:8];
        
        view = itemView;
    }
    [(ZBannerCardItemView*)view setViewDataWithModel:[self.arrayMain objectAtIndex:index]];
    return view;
}
- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    return true;
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (self.onBannerClick) {
        ModelBanner *model = [self.arrayMain objectAtIndex:index];
        self.onBannerClick(model);
    }
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionWrap: return true;
        default: break;
    }
    return value;
}
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.9f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    return CATransform3DTranslate(transform, offset * [ZBannerCardItemView getW] * 1.09, 0.0, 0.0);
}

@end
