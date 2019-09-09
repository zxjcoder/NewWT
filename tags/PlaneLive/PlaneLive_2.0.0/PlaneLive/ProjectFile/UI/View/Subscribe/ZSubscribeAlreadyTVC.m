//
//  ZSubscribeAlreadyTVC.m
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyTVC.h"

#define kZSubscribeAlreadyBannerViewHeight (110*APP_FRAME_WIDTH/320)
#define kZSubscribeAlreadyTVCHeight (120+kZSubscribeAlreadyBannerViewHeight)

@interface ZSubscribeAlreadyTVC()

///课程区域
@property (strong, nonatomic) ZView *viewSubscribe;
///课程图片
@property (strong, nonatomic) ZImageView *imgPhoto;
///课程名称
@property (strong, nonatomic) ZLabel *lbName;
///进入阅读课程图标
@property (strong, nonatomic) UIImageView *imgNext;
///课程分割线
@property (strong, nonatomic) UIImageView *imgLine1;
///课程介绍
@property (strong, nonatomic) ZLabel *lbDesc;
///分期图片
@property (strong, nonatomic) ZImageView *imgBanner;
///时间
@property (strong, nonatomic) ZLabel *lbTime;
///阅读全文
@property (strong, nonatomic) ZLabel *lbReadText;
///CELL分割线
@property (strong, nonatomic) UIImageView *imgLine2;

@property (strong, nonatomic) ModelCurriculum *model;

@end

@implementation ZSubscribeAlreadyTVC

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
    
    self.cellH = [ZSubscribeAlreadyTVC getH];
    
    self.viewSubscribe = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, 50)];
    [self.viewSubscribe setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewSubscribe];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewSubscribeClick:)];
    [self.viewSubscribe addGestureRecognizer:tapGesture];
    
    CGFloat imgSize = 36;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(kSizeSpace, kSize8, imgSize, imgSize)];
    [self.imgPhoto setImage:[SkinManager getDefaultImage]];
    [self.imgPhoto setUserInteractionEnabled:NO];
    [self.imgPhoto setViewRound];
    [self.viewSubscribe addSubview:self.imgPhoto];
    
    CGFloat imgGoW = 8;
    
    CGFloat nameX = self.imgPhoto.x+self.imgPhoto.width+kSize10;
    CGFloat nameW = self.cellW-nameX-kSizeSpace-imgGoW-kSize3;
    CGFloat nameY = self.imgPhoto.y+self.imgPhoto.height/2-self.lbH/2;
    self.lbName = [[ZLabel alloc] initWithFrame:CGRectMake(nameX, nameY, nameW, self.lbH)];
    [self.lbName setTextColor:BLACKCOLOR1];
    [self.lbName setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbName setNumberOfLines:1];
    [self.lbName setUserInteractionEnabled:NO];
    [self.lbName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewSubscribe addSubview:self.lbName];
    
    UIImage *imgN = [UIImage imageWithCGImage:[SkinManager getImageWithName:@"btn_back1"].CGImage scale:1 orientation:(UIImageOrientationDown)];
    CGFloat imgnextY = self.imgPhoto.y+self.imgPhoto.height/2-15/2;
    CGFloat imgnextX = self.cellW-kSizeSpace-imgGoW;
    self.imgNext = [[UIImageView alloc] initWithFrame:CGRectMake(imgnextX, imgnextY, imgGoW, 15)];
    [self.imgNext setImage:imgN];
    [self.imgNext setUserInteractionEnabled:NO];
    [self.viewSubscribe addSubview:self.imgNext];
    
    self.imgLine1 = [UIImageView getTLineView];
    [self.imgLine1 setUserInteractionEnabled:NO];
    [self.imgLine1 setFrame:CGRectMake(kSize15, self.viewSubscribe.height-self.lineH, self.cellW-kSize15*2, self.lineH)];
    [self.viewSubscribe addSubview:self.imgLine1];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, self.viewSubscribe.y+self.viewSubscribe.height+kSize6, self.cellW-kSizeSpace*2, self.lbMinH)];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setNumberOfLines:1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbDesc];
    
    self.imgBanner = [[ZImageView alloc] initWithFrame:CGRectMake(kSizeSpace, self.lbDesc.y+self.lbDesc.height+kSize8, self.cellW-kSizeSpace*2, kZSubscribeAlreadyBannerViewHeight)];
    [self.imgBanner setImage:[SkinManager getMaxImage]];
    [self.viewMain addSubview:self.imgBanner];
    
    self.lbTime = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, self.imgBanner.y+self.imgBanner.height+kSize5, 130, self.lbMinH)];
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
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    [self.viewMain addSubview:self.imgLine2];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)viewSubscribeClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onSubscribeClick) {
            self.onSubscribeClick(self.model);
        }
    }
}

-(CGFloat)setCellDataWithModel:(ModelCurriculum *)model
{
    [self setModel:model];
    
    [self.imgPhoto setImageURLStr:model.illustration placeImage:[SkinManager getDefaultImage]];
    
    [self.lbName setText:model.title];
    
    [self.lbDesc setText:model.ctitle];
    
    [self.imgBanner setImageURLStr:model.audio_picture placeImage:[SkinManager getMaxImage]];
    
    [self.lbTime setText:model.create_time];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgNext);
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_imgBanner);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbName);
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
    return kZSubscribeAlreadyTVCHeight;
}

@end
