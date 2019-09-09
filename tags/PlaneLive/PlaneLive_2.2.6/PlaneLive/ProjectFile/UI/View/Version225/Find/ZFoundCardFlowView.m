//
//  ZFoundCardFlowView.m
//  PlaneLive
//
//  Created by Daniel on 01/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFoundCardFlowView.h"
#import "iCarousel.h"

@interface ZFoundCardFlowView()<iCarouselDelegate, iCarouselDataSource>

@property (strong, nonatomic) NSArray *arrayMain;
@property (strong, nonatomic) iCarousel *carousel;

@end

@implementation ZFoundCardFlowView

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

#pragma mark - iCarouselDelegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.arrayMain.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    if (view == nil) {
        ZFoundCardItemView *itemView = [[ZFoundCardItemView alloc] initWithFrame:(CGRectMake(0, 0, [ZFoundCardItemView getW], [ZFoundCardItemView getH]))];
        ZWEAKSELF
        [itemView setOnStartPlayEvent:^(ModelPracticeType *type) {
            if (weakSelf.onStartPlayEvent) {
                weakSelf.onStartPlayEvent(type);
            }
        }];
        view = itemView;
    }
    [(ZFoundCardItemView*)view setViewDataWithModel:[self.arrayMain objectAtIndex:index]];
    return view;
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (self.onIndexChange) {
        self.onIndexChange(self.arrayMain.count, carousel.currentItemIndex+1);
    }
}
- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    return false;
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
    return CATransform3DTranslate(transform, offset * [ZFoundCardItemView getW] * 1.09, 0.0, 0.0);
}

@end
