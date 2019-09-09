//
//  ZDragButton.m
//  PlaneCircle
//
//  Created by Daniel on 8/9/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDragButton.h"
#import "AudioPlayerView.h"

#define kDRAGBUTTON_WAITING_KEYWINDOW_AVAILABLE 0.f
#define kDRAGBUTTON_AUTODOCKING_ANIMATE_DURATION 0.2f
#define kDRAGBUTTON_DOUBLE_TAP_TIME_INTERVAL 0.36f

@interface ZDragButton()
{
    BOOL _loadFrame;
    BOOL _isDragging;
    BOOL _singleTapBeenCanceled;
    CGPoint _beginLocation;
    /// 是否显示
    BOOL _isShow;
    /// 是否已经添加事件
    BOOL _isAddEvent;
}

///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;
///是否能显示
@property (assign, nonatomic) BOOL isCanShowView;
///是否允许拖动
@property (nonatomic,assign) BOOL draggable;
///是否允许自动定位
@property (nonatomic,assign) BOOL autoDocking;
///是否是横屏操作
@property (nonatomic,assign) BOOL isHorizontalScreen;

@property (strong, nonatomic) NSArray *arrPractice;

@property (assign, nonatomic) NSInteger rowIndex;

@end

static ZDragButton *dragButton;

@implementation ZDragButton

@synthesize draggable = _draggable;
@synthesize autoDocking = _autoDocking;

+(ZDragButton *)shareDragButton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dragButton = [[ZDragButton alloc] initWithFrame:CGRectMake(APP_FRAME_WIDTH-56, APP_FRAME_HEIGHT-55-APP_TABBAR_HEIGHT, 55, 55)];
        [dragButton setBackgroundColor:CLEARCOLOR];
        [[dragButton layer] setMasksToBounds:YES];
        [[dragButton layer] setCornerRadius:5];
        
        [dragButton setHidden:YES];
        [dragButton setAlpha:0.0f];
        
        [dragButton setIsCanShowView:YES];
        [dragButton setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
       
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setFrame:CGRectMake(5, 5, 45, 45)];
        NSMutableArray *arrImages = [NSMutableArray array];
        for (int i = 1; i < 74; i++) {
            [arrImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"p_all_paly_btn%d",i]]];
        }
        imgView.animationImages = arrImages;
        [imgView setImage:[SkinManager getImageWithName:@"p_all_paly_btn1"]];
        [imgView setAnimationDuration:1.8f];
        [imgView setAnimationRepeatCount:0];
        [imgView setBackgroundColor:WHITECOLOR];
        [[imgView layer] setMasksToBounds:YES];
        [[imgView layer] setCornerRadius:imgView.frame.size.width/2];
        [[imgView layer] setBorderColor:WHITECOLOR.CGColor];
        [[imgView layer] setBorderWidth:1.0f];
        [imgView setUserInteractionEnabled:NO];
        [imgView setTag:121];
        [imgView setAlpha:0.9f];
        [dragButton addSubview:imgView];
        
        [dragButton setUserInteractionEnabled:YES];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:dragButton];
    });
    return dragButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _loadFrame = YES;
        [self innerInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _loadFrame = NO;
        [self innerInit];
    }
    return self;
}

-(void)dealloc
{
    [self setViewNil];
}

- (void)innerInit
{
    _draggable = YES;
    _autoDocking = YES;
    _singleTapBeenCanceled = NO;
    [self setAlpha:1.0f];
}
///是否允许拖动
- (BOOL)isDragging
{
    return _isDragging;
}
-(void)setViewNil
{
    OBJC_RELEASE(_tapClickBlock);
    OBJC_RELEASE(_arrPractice);
}
///设置播放的语音集合
-(void)setPlayArray:(NSArray *)arr rowIndex:(NSInteger)rowIndex
{
    [self setArrPractice:arr];
    [self setRowIndex:rowIndex];
}
///获取播放的语音集合
-(NSArray *)getPlayArray
{
    return self.arrPractice;
}
///获取当前播放索引
-(NSInteger)getPlayRowIndex
{
    return self.rowIndex;
}
- (void)buttonTouched:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (!_singleTapBeenCanceled && self.arrPractice.count > 0) {
            if (self.enabled) {
                [self setEnabled:NO];
                if (_tapClickBlock) {
                    _tapClickBlock();
                }
            }
//            [[AudioPlayerView shareAudioPlayerView] setStateChange];
//            if ([[AudioPlayerView shareAudioPlayerView] isPlay]) {
//                UIImageView *imgView = [self viewWithTag:121];
//                [imgView startAnimating];
//            } else {
//                UIImageView *imgView = [self viewWithTag:121];
//                [imgView stopAnimating];
//            }
        }
    }
}
///设置是否能显示
-(void)setIsCanShow:(BOOL)isShow
{
    self.isCanShowView = isShow;
    if (!isShow) {
        [self dismiss];
    }
}
///获取是否能显示
-(BOOL)getIsCanShow
{
    return self.isCanShowView;
}
///显示
-(void)show
{
    if (self.isAnimateing || _isShow || !self.isCanShowView) {return;}
    
    [self setIsAnimateing:YES];
    [self setAlpha:0];
    [self setHidden:NO];
    
    UIImageView *imgView = [self viewWithTag:121];
    [imgView startAnimating];
    
    if (!_isAddEvent) {
        _isAddEvent = YES;
        UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouched:)];
        [self addGestureRecognizer:tapClick];
    }
    
    _isShow = YES;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}
///隐藏
-(void)dismiss
{
    if (!_isShow) {
        return;
    }
    if (self.isAnimateing || self.hidden) {return;}
    
    UIImageView *imgView = [self viewWithTag:121];
    [imgView stopAnimating];
    
    [self setIsAnimateing:YES];
    _isShow = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [weakSelf setIsAnimateing:NO];
        [weakSelf setHidden:YES];
        GCDAfterBlock(0.25f, ^{
            [weakSelf setEnabled:YES];
        });
    }];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isDragging = NO;
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        
    } else {
        _singleTapBeenCanceled = NO;
    }
    _beginLocation = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_draggable) {
        _isDragging = YES;
        
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self];
        
        float offsetX = currentLocation.x - _beginLocation.x;
        float offsetY = currentLocation.y - _beginLocation.y;
        
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        
        CGRect superviewFrame = self.superview.frame;
        CGRect frame = self.frame;
        CGFloat leftLimitX = frame.size.width / 2;
        CGFloat rightLimitX = superviewFrame.size.width - leftLimitX;
        CGFloat topLimitY = frame.size.height / 2;
        CGFloat bottomLimitY = superviewFrame.size.height - topLimitY;
        
        if (self.center.x > rightLimitX) {
            self.center = CGPointMake(rightLimitX, self.center.y);
        }else if (self.center.x <= leftLimitX) {
            self.center = CGPointMake(leftLimitX, self.center.y);
        }
        
        if (self.center.y > bottomLimitY) {
            self.center = CGPointMake(self.center.x, bottomLimitY);
        }else if (self.center.y <= topLimitY){
            self.center = CGPointMake(self.center.x, topLimitY);
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded: touches withEvent: event];
    
    if (_isDragging && _autoDocking) {
        CGRect superviewFrame = self.superview.frame;
        CGRect frame = self.frame;
        CGFloat middleX = superviewFrame.size.width / 2;
        
        if (self.center.x >= middleX) {
            [UIView animateWithDuration:kDRAGBUTTON_AUTODOCKING_ANIMATE_DURATION animations:^{
                self.center = CGPointMake(superviewFrame.size.width - frame.size.width / 2, self.center.y);
            }];
        } else {
            [UIView animateWithDuration:kDRAGBUTTON_AUTODOCKING_ANIMATE_DURATION animations:^{
                self.center = CGPointMake(frame.size.width / 2, self.center.y);
            }];
        }
    }
    _isDragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isDragging = NO;
    [super touchesCancelled:touches withEvent:event];
}
@end
