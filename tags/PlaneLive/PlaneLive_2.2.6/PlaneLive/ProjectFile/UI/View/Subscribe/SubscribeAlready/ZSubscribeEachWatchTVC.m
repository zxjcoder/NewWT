//
//  ZSubscribeEachWatchTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeEachWatchTVC.h"

#define kZSubscribeEachWatchBannerViewHeight (110*APP_FRAME_WIDTH/320)
#define kZSubscribeEachWatchTVCeight (76+kZSubscribeEachWatchBannerViewHeight)

@interface ZSubscribeEachWatchTVC()

///课程介绍
@property (strong, nonatomic) ZLabel *lbDesc;
///分期图片
@property (strong, nonatomic) ZImageView *imgBanner;
@property (strong, nonatomic) UIView *viewBanner;
///时间
@property (strong, nonatomic) ZLabel *lbTime;
///阅读全文
@property (strong, nonatomic) ZLabel *lbReadText;
///CELL分割线
//@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZSubscribeEachWatchTVC

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
    
    self.cellH = [ZSubscribeEachWatchTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    if (!self.viewBanner) {
        self.viewBanner = [[UIView alloc] init];
        [self.viewBanner setAllShadowColorWithRadius:4];
        [[self.viewBanner layer] setShadowOpacity:0.10];
        [self.viewMain addSubview:self.viewBanner];
    }
    if (!self.lbDesc) {
        self.lbDesc = [[ZLabel alloc] init];
        [self.lbDesc setTextColor:COLORTEXT1];
        [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbDesc setNumberOfLines:1];
        [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewMain addSubview:self.lbDesc];
    }
    if (!self.imgBanner) {
        self.imgBanner = [[ZImageView alloc] init];
        [[self.imgBanner layer] setMasksToBounds:true];
        [self.imgBanner setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
        [self.viewBanner addSubview:self.imgBanner];
    }
    if (!self.lbTime) {
        self.lbTime = [[ZLabel alloc] init];
        [self.lbTime setTextColor:COLORTEXT3];
        [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbTime setNumberOfLines:1];
        [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewMain addSubview:self.lbTime];
    }
    if (!self.lbReadText) {
        self.lbReadText = [[ZLabel alloc] init];
        [self.lbReadText setTextColor:COLORTEXT3];
        [self.lbReadText setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbReadText setNumberOfLines:1];
        [self.lbReadText setTextAlignment:(NSTextAlignmentRight)];
        [self.lbReadText setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewMain addSubview:self.lbReadText];
    }
}
-(void)setViewFrame
{
    [self.viewBanner setFrame:CGRectMake(self.space, 12, self.cellW-self.space*2, kZSubscribeEachWatchBannerViewHeight)];
    [self.imgBanner setFrame:self.viewBanner.bounds];
    
    [self.lbDesc setFrame:CGRectMake(self.space, self.viewBanner.y+self.viewBanner.height+10, self.cellW-self.space*2, self.lbMinH)];
    
    [self.lbTime setFrame:(CGRectMake(self.space, self.lbDesc.y+self.lbDesc.height+10, 150, self.lbMinH))];
    
    [self.lbReadText setFrame:CGRectMake(self.cellW-self.space-100, self.lbDesc.y+self.lbDesc.height+10, 100, self.lbMinH)];
}
-(CGFloat)setCellDataWithModel:(ModelCurriculum *)model
{
    [self.lbReadText setText:kReadFullText];
    [self.lbDesc setText:model.ctitle];
    [self.imgBanner setImageURLStr:model.audio_picture placeImage:[SkinManager getMaxImage]];
    if (model.createTimeFormat.length > 0) {
        [self.lbTime setText:model.createTimeFormat];
    } else {
        [self.lbTime setText:model.create_time];
    }
    [self setViewFrame];
    
    return self.cellH;
}
-(CGFloat)setCellDataWithModelCollection:(ModelCollection *)model
{
    [self.lbDesc setText:model.title];
    
    [self.imgBanner setImageURLStr:model.img placeImage:[SkinManager getMaxImage]];
    
    [self.lbTime setText:model.create_time];
    
    [self setViewFrame];
    return self.cellH;
}

-(void)setViewNil
{
//    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgBanner);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbReadText);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return kZSubscribeEachWatchTVCeight;
}


@end
