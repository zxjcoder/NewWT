//
//  ZSubscribeDetailImageTVC.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeDetailImageTVC.h"

@interface ZSubscribeDetailImageTVC()

/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 图片
@property (strong, nonatomic) ZImageView *imgBack;
/// 阴影
@property (strong, nonatomic) ZImageView *imgShadow;

@end

@implementation ZSubscribeDetailImageTVC

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
    
    self.cellH = [ZSubscribeDetailImageTVC getH];
    
    self.imgBack = [[ZImageView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    [self.viewMain addSubview:self.imgBack];
    
    self.imgShadow = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"subscribe_rss_background"]];
    [self.imgShadow setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    [self.viewMain addSubview:self.imgShadow];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, self.cellH-self.lbH-kSize5, self.cellW-kSizeSpace*2, self.lbH)];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.imgShadow addSubview:self.lbTitle];
    
    [self.viewMain sendSubviewToBack:self.imgBack];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGRect titleFrame = self.lbTitle.frame;
    titleFrame.size.height = titleH;
    titleFrame.origin.y = self.cellH-titleH-kSize5;
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

-(CGFloat)setCellDataWithModel:(ModelSubscribeDetail *)model
{
    if (model) {
        [self.imgBack setImageURLStr:model.course_picture placeImage:[SkinManager getMaxImage]];
        
        [self.lbTitle setText:model.title];
    } else {
        [self.imgBack setImage:[SkinManager getMaxImage]];
        
        [self.lbTitle setText:kEmpty];
    }
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgBack);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
/// 获取CELL宽度
-(CGFloat)getW
{
    return self.cellW;
}
-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return APP_FRAME_WIDTH*0.69;
}

@end
