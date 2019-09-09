//
//  ZMyCollectionSubscribeTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/5.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZMyCollectionSubscribeTVC.h"

#define kZMyCollectionSubscribeTVCBannerViewHeight (110*APP_FRAME_WIDTH/320)
#define kZMyCollectionSubscribeTVCHeight (70+kZMyCollectionSubscribeTVCBannerViewHeight)

@interface ZMyCollectionSubscribeTVC()

///课程介绍
@property (strong, nonatomic) ZLabel *lbDesc;
///分期图片
@property (strong, nonatomic) ZImageView *imgBanner;
///时间
@property (strong, nonatomic) ZLabel *lbTime;
///阅读全文
@property (strong, nonatomic) ZLabel *lbReadText;
///CELL分割线
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZMyCollectionSubscribeTVC

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
    
    self.cellH = [ZMyCollectionSubscribeTVC getH];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, kSize10, self.cellW-kSizeSpace*2, self.lbMinH)];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setNumberOfLines:1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbDesc];
    
    self.imgBanner = [[ZImageView alloc] initWithFrame:CGRectMake(kSizeSpace, self.lbDesc.y+self.lbDesc.height+kSize8, self.cellW-kSizeSpace*2, kZMyCollectionSubscribeTVCBannerViewHeight)];
    [self.imgBanner setImage:[SkinManager getMaxImage]];
    [self.viewMain addSubview:self.imgBanner];
    
    self.lbTime = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, self.imgBanner.y+self.imgBanner.height+kSize5, 150, self.lbMinH)];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTime];
    
    self.lbReadText = [[ZLabel alloc] initWithFrame:CGRectMake(self.cellW-kSizeSpace-100, self.imgBanner.y+self.imgBanner.height+kSize5, 100, self.lbMinH)];
    [self.lbReadText setTextColor:DESCCOLOR];
    [self.lbReadText setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbReadText setNumberOfLines:1];
    [self.lbReadText setTextAlignment:(NSTextAlignmentRight)];
    [self.lbReadText setText:kReadFullText];
    [self.lbReadText setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbReadText];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    [self.viewMain addSubview:self.imgLine];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelCollection *)model
{
    [self.lbDesc setText:model.title];
    
    [self.imgBanner setImageURLStr:model.img placeImage:[SkinManager getMaxImage]];
    
    [self.lbTime setText:model.create_time];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLine);
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

-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return kZMyCollectionSubscribeTVCHeight;
}

@end
