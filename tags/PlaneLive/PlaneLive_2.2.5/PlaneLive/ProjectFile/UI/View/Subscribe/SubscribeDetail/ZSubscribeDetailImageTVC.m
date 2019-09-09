//
//  ZSubscribeDetailImageTVC.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeDetailImageTVC.h"

@interface ZSubscribeDetailImageTVC()

@property (strong, nonatomic) ZView *viewContent;
/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 图片
@property (strong, nonatomic) ZImageView *imgIcon;
/// 背景图片
@property (strong, nonatomic) ZImageView *imgBackground;

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
    self.space = 20;
    [self.viewMain setClipsToBounds:true];
    
    [self.viewMain setFrame:(CGRectMake(0, 0, self.cellW, self.cellH))];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.viewContent = [[ZView alloc] initWithFrame:self.viewMain.bounds];
    [self.viewMain addSubview:self.viewContent];
    
    self.imgIcon = [[ZImageView alloc] init];
    [[self.imgIcon layer] setMasksToBounds:true];
    [self.imgIcon setViewRound:8 borderWidth:1 borderColor:RGBCOLORA(255, 255, 255, 0.1)];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
    [self.viewContent addSubview:self.lbTitle];
    
    self.imgBackground = [[ZImageView alloc] initWithFrame:self.viewMain.bounds];
    [self.imgBackground setCenter:self.center];
    [self.imgBackground setContentMode:(UIViewContentModeScaleToFill)];
    // 创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 毛玻璃视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.imgBackground.bounds;
    effectView.center = self.imgBackground.center;
    [effectView setTag:1001];
    UIView *imgViewBG = [[UIView alloc] initWithFrame:self.imgBackground.bounds];
    [imgViewBG setAlpha:0.7];
    [imgViewBG setTag:1002];
    [imgViewBG setFrame:effectView.bounds];
    
    [self.imgBackground addSubview:effectView];
    [self.imgBackground addSubview:imgViewBG];
    [self.imgBackground bringSubviewToFront:effectView];
    [self.imgBackground bringSubviewToFront:imgViewBG];
    [self.viewMain addSubview:self.imgBackground];
    
    [self.viewMain sendSubviewToBack:self.imgBackground];
    [self.viewMain bringSubviewToFront:self.viewContent];
}

-(void)setViewFrame
{
    CGFloat iconSize = 96;
    CGFloat iconX = self.cellW/2-iconSize/2;
    CGFloat iconY = 48;
    [self.imgIcon setFrame:(CGRectMake(iconX, iconY, iconSize, iconSize))];
    
    CGFloat titleW = self.cellW-self.space*2;
    CGRect titleFrame = CGRectMake(self.space, self.imgIcon.y+self.imgIcon.height+20, titleW, self.lbH);
    self.lbTitle.frame = titleFrame;
    titleFrame.size.height = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    self.lbTitle.frame = titleFrame;
    
    self.cellH = self.lbTitle.y+self.lbTitle.height+15;
    [self.viewContent setFrame:(CGRectMake(0, 0, self.cellW, self.cellH))];
    [self.viewMain  setFrame:(CGRectMake(0, 0, self.cellW, self.cellH))];
    
    [self.imgBackground setFrame:self.viewMain.bounds];
    [self.imgBackground setCenter:self.viewMain.center];
    [[self.imgBackground viewWithTag:1001] setFrame:self.imgBackground.bounds];
    [[self.imgBackground viewWithTag:1001] setCenter:self.imgBackground.center];
    [[self.imgBackground viewWithTag:1002] setFrame:self.imgBackground.bounds];
    [[self.imgBackground viewWithTag:1002] setBackgroundColor:COLORVIEWBACKCOLOR1];
}
-(CGFloat)setCellDataWithModel:(ModelSubscribeDetail *)model
{
    [self.lbTitle setText:model.title];
    [self.imgBackground setImageURLStr:model.course_picture placeImage:[SkinManager getImageWithName:@"play_background_default"]];
    [self.imgIcon setImageURLStr:model.illustration placeImage:[SkinManager getDefaultImage]];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 200;
}

@end
