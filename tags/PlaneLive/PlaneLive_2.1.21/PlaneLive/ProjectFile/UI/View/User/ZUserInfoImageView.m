//
//  ZUserInfoImageView.m
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZUserInfoImageView.h"
#import "ZUserInfoShareButton.h"
#import "ZLabel.h"

@interface ZUserInfoImageView()

@property (strong, nonatomic) ZImageView *imgBack;

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) ZLabel *lbNickName;

@property (strong, nonatomic) ZLabel *lbSign;

///同意
@property (strong, nonatomic) ZUserInfoShareButton *btnAgree;
///分享
@property (strong, nonatomic) ZUserInfoShareButton *btnShare;
///收藏
@property (strong, nonatomic) ZUserInfoShareButton *btnCollection;

@property (strong, nonatomic) UIView *imgLine1;
@property (strong, nonatomic) UIView *imgLine2;

@end

@implementation ZUserInfoImageView

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
    CGFloat lbH = 20;
    CGFloat lbMinH = 18;
    CGFloat photoSize = 80;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(self.width/2-photoSize/2, 60, photoSize, photoSize)];
    [self.imgPhoto setDefaultPhoto];
    [[self.imgPhoto layer] setMasksToBounds:YES];
    [self.imgPhoto setViewRoundNoBorder];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imagePhotoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePhotoClick:)];
    [self.imgPhoto addGestureRecognizer:imagePhotoClick];
    
    CGFloat nickNameY = self.imgPhoto.y+self.imgPhoto.height+16;
    CGFloat lbW = self.width - kSizeSpace*2;
    self.lbNickName = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, nickNameY, lbW, lbH)];
    [self.lbNickName setTextColor:WHITECOLOR];
    [self.lbNickName setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbNickName];
    
    CGRect signFrame = CGRectMake(kSizeSpace, self.lbNickName.y+self.lbNickName.height+kSize6, lbW, lbMinH);
    self.lbSign = [[ZLabel alloc] initWithFrame:signFrame];
    [self.lbSign setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbSign setTextColor:TABLEVIEWCELL_TLINECOLOR];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbSign];
    
    CGFloat btnW = 110;
    CGFloat space = (self.width-btnW*3)/4;
    CGFloat btnH = 55;
    CGFloat btnY = self.lbSign.y+self.lbSign.height+kSize6;
    
    self.btnAgree = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(space, btnY, btnW, btnH)];
    [self.btnAgree setViewDataWithTitle:kTheAnswerIsAgreed imageName:@"mine_agreenum_icon" count:0];
    [self addSubview:self.btnAgree];
    
    self.btnShare = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(self.width/2-btnW/2, btnY, btnW, btnH)];
    [self.btnShare setViewDataWithTitle:kTheAnswerIsShared imageName:@"mine_sharenum_icon" count:0];
    [self addSubview:self.btnShare];
    
    self.btnCollection = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(self.width-btnW-space, btnY, btnW, btnH)];
    [self.btnCollection setViewDataWithTitle:kTheAnswerIsCollected imageName:@"mine_collectionnum_icon" count:0];
    [self addSubview:self.btnCollection];
    
    CGFloat lineY = btnY+13;
    CGFloat lineW = kLineHeight;
    CGFloat lineH = btnH-23;
    self.imgLine1 = [[UIView alloc] initWithFrame:CGRectMake(self.btnAgree.x+self.btnAgree.width+space/2, lineY, lineW, lineH)];
    [self.imgLine1 setBackgroundColor:WHITECOLOR];
    [self addSubview:self.imgLine1];
    
    self.imgLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.btnShare.x+self.btnShare.width+space/2, lineY, lineW, lineH)];
    [self.imgLine2 setBackgroundColor:WHITECOLOR];
    [self addSubview:self.imgLine2];
    
    self.imgBack = [[ZImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, btnY+btnH+kSize8)];
    [self.imgBack setImageName:@"user_background_default"];
    // 创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 毛玻璃视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.imgBack.bounds;
    effectView.center = self.imgBack.center;
    [effectView setTag:1001];
    UIImageView *imgViewBG = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"play_transparent_back"]];
    [imgViewBG setTag:1002];
    [imgViewBG setFrame:effectView.bounds];
    
    [self.imgBack addSubview:effectView];
    [self.imgBack addSubview:imgViewBG];
    [self.imgBack bringSubviewToFront:effectView];
    [self.imgBack bringSubviewToFront:imgViewBG];
    
    [self addSubview:self.imgBack];
    
    [self sendSubviewToBack:self.imgBack];
}
-(void)imagePhotoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onUserPhotoClick) {
            self.onUserPhotoClick();
        }
    }
}
/// 设置图片坐标
-(void)setViewImageFrame:(CGRect)frame
{
    [self.imgBack setFrame:frame];
    UIVisualEffectView *effectView = [self.imgBack viewWithTag:1001];
    if (effectView) {
        [effectView setFrame:self.imgBack.bounds];
    }
    UIImageView *imgBG = [self.imgBack viewWithTag:1002];
    if (imgBG) {
        [imgBG setFrame:self.imgBack.bounds];
    }
}
/// 获取图片坐标
-(CGRect)getViewImageFrame
{
    return self.imgBack.frame;
}

-(void)setViewDataWithModel:(ModelUser *)model
{
    ZWEAKSELF
    [self.imgPhoto setPhotoURLStr:model.head_img completed:^(UIImage *image) {
        if (image && ![image isKindOfClass:[NSNull class]]) {
            [weakSelf.imgBack setImage:image];
        }
    }];
    
    [self.lbNickName setText:model.nickname];
    
    [self.lbSign setText:model.sign];
    
    [self.btnAgree setViewDataWithTitle:kTheAnswerIsAgreed imageName:@"mine_agreenum_icon" count:model.myAnswerAgreeCount];
    
    [self.btnShare setViewDataWithTitle:kTheAnswerIsShared imageName:@"mine_sharenum_icon" count:model.myAnswerShareCount];
    
    [self.btnCollection setViewDataWithTitle:kTheAnswerIsCollected imageName:@"mine_collectionnum_icon"  count:model.myAnswerCollectCount];
}
-(void)dealloc
{
    UIVisualEffectView *effectView = [self.imgBack viewWithTag:1001];
    if (effectView) {
        OBJC_RELEASE(effectView);
    }
    UIImageView *imgBG = [self.imgBack viewWithTag:1002];
    if (imgBG) {
        OBJC_RELEASE(imgBG);
    }
    OBJC_RELEASE(_btnAgree);
    OBJC_RELEASE(_btnShare);
    OBJC_RELEASE(_btnCollection);
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_onUserPhotoClick);
}
+(CGFloat)getH
{
    return 275;
}

@end
