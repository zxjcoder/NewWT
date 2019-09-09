//
//  ZPictureViewerView.m
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPictureViewerView.h"
#import "ZImageView.h"

@interface ZPictureViewerView()<UIScrollViewDelegate>
{
    NSInteger currentScale;
    NSInteger maxScale;
    NSInteger minScale;
}

@property (strong, nonatomic) UIView *viewBG;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ZImageView *imageView;

@property (assign, nonatomic) BOOL isAnimateing;

@end

@implementation ZPictureViewerView

///初始化
-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:CLEARCOLOR];
    
    maxScale = 10;
    minScale = 1;
    currentScale = 1;
    
    self.viewBG = [[UIView alloc] initWithFrame:self.bounds];
    [self.viewBG setAlpha:0.55f];
    [self.viewBG setBackgroundColor:[UIColor blackColor]];
    [self addSubview:self.viewBG];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self.scrollView setDelegate:self];
    self.scrollView.maximumZoomScale=maxScale;
    self.scrollView.minimumZoomScale=minScale;
    self.scrollView.decelerationRate=currentScale;
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setBackgroundColor:CLEARCOLOR];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:self.scrollView];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)setViewPictureUrlWithImageUrl:(NSURL *)imageUrl defaultImage:(UIImage *)defaultImage defaultSize:(CGSize)defaultSize
{
    ZImageView *imgItem = [[ZImageView alloc] initWithFrame:self.scrollView.bounds];
    
    [imgItem setImageURLStr:imageUrl.absoluteString placeImage:defaultImage];
    
    imgItem.userInteractionEnabled=YES;
    imgItem.contentMode = UIViewContentModeScaleAspectFit;
    
    //添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    doubleTap.numberOfTapsRequired = 2;//需要点两下
    twoFingerTap.numberOfTouchesRequired = 2;//需要两个手指touch
    
    [imgItem addGestureRecognizer:singleTap];
    [imgItem addGestureRecognizer:doubleTap];
    [imgItem addGestureRecognizer:twoFingerTap];
    //如果双击了，则不响应单击事件
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self.scrollView setZoomScale:1];
    [self.scrollView addSubview:imgItem];
    self.imageView = imgItem;

}
-(void)setViewNil
{
    OBJC_RELEASE(_viewBG);
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_imageView);
}
///显示
-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.scrollView setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}
///隐藏
-(void)dismiss
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
        [self setViewNil];
        [self removeFromSuperview];
    }];
}
#pragma mark - 图片的点击，touch事件

-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.numberOfTapsRequired == 1) {
        [self dismiss];
    }
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if(_scrollView.zoomScale == 1){
            float newScale = [_scrollView zoomScale] *2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
        }else{
            float newScale = [_scrollView zoomScale]/2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
        }
    }
}

-(void)handleTwoFingerTap:(UITapGestureRecognizer *)gestureRecongnizer
{
    float newScale = [_scrollView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecongnizer locationInView:gestureRecongnizer.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark - 缩放大小获取方法

-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    //大小
    zoomRect.size.height = [_scrollView frame].size.height/scale;
    zoomRect.size.width = [_scrollView frame].size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}

#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

@end
