//
//  ZZoomingScrollView.h
//  PlaneLive
//
//  Created by Daniel on 07/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import <IDMPhotoBrowser/IDMZoomingScrollView.h>
#import "IDMPhotoProtocol.h"
#import "IDMTapDetectingImageView.h"
#import "IDMTapDetectingView.h"

#import "DACircularProgressView.h"

#import "ZPhotoBrowser.h"

@class IDMPhotoBrowser, IDMPhoto, IDMCaptionView;

@interface ZZoomingScrollView : UIScrollView <UIScrollViewDelegate, IDMTapDetectingImageViewDelegate, IDMTapDetectingViewDelegate> {
    
    IDMPhotoBrowser *__weak _photoBrowser;
    id<IDMPhoto> _photo;
    
    // This view references the related caption view for simplified handling in photo browser
    IDMCaptionView *_captionView;
    
    IDMTapDetectingView *_tapView; // for background taps
    
    DACircularProgressView *_progressView;
}

@property (nonatomic, strong) IDMTapDetectingImageView *photoImageView;
@property (nonatomic, strong) IDMCaptionView *captionView;
@property (nonatomic, strong) id<IDMPhoto> photo;

- (id)initWithPrePhotoBrowser:(ZPhotoBrowser *)browser;

- (id)initWithPhotoBrowser:(IDMPhotoBrowser *)browser;
- (void)displayImage;
- (void)displayImageFailure;
- (void)setProgress:(CGFloat)progress forPhoto:(IDMPhoto*)photo;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)prepareForReuse;

@end
