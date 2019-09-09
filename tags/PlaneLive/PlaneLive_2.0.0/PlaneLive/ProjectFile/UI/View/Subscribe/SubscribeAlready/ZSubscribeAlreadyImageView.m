//
//  ZSubscribeAlreadyImageView.m
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyImageView.h"
#import "ZLabel.h"
#import "ZImageView.h"

@interface ZSubscribeAlreadyImageView()

/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 图片
@property (strong, nonatomic) ZImageView *imgBack;
/// 阴影
@property (strong, nonatomic) ZImageView *imgShadow;

@end

@implementation ZSubscribeAlreadyImageView

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_WIDTH*0.6)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    CGFloat lbH = 20;
    self.imgBack = [[ZImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imgBack];
    
    self.imgShadow = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"subscribe_rss_background"]];
    [self.imgShadow setFrame:self.bounds];
    [self addSubview:self.imgShadow];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, self.height-lbH-kSize5, self.width-kSizeSpace*2, lbH)];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.imgShadow addSubview:self.lbTitle];
    
    [self sendSubviewToBack:self.imgBack];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:20];
    CGRect titleFrame = self.lbTitle.frame;
    titleFrame.size.height = titleH;
    titleFrame.origin.y = self.height-titleH-kSize5;
    [self.lbTitle setFrame:titleFrame];
}

/// 设置图片坐标
-(void)setViewImageFrame:(CGRect)frame
{
    [self.imgBack setFrame:frame];
}
/// 获取图片坐标
-(CGRect)getViewImageFrame
{
    return self.imgBack.frame;
}

///设置数据源
-(void)setViewDataWithModel:(ModelCurriculum *)model
{
    if (model) {
        [self.imgBack setImageURLStr:model.course_picture placeImage:[SkinManager getMaxImage]];
        
        [self.lbTitle setText:model.title];
    } else {
        [self.imgBack setImage:[SkinManager getMaxImage]];
        
        [self.lbTitle setText:kEmpty];
    }
    
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_imgShadow);
}

-(void)dealloc
{
    [self setViewNil];
}


@end
