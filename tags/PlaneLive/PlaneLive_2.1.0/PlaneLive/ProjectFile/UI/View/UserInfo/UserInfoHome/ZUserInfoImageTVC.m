//
//  ZUserInfoImageTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoImageTVC.h"
#import "ZUserInfoShareButton.h"

@interface ZUserInfoImageTVC()

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

@implementation ZUserInfoImageTVC

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.cellH = [ZUserInfoImageTVC getH];
    
    CGFloat photoSize = 80;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(self.cellW/2-photoSize/2, 60, photoSize, photoSize)];
    [self.imgPhoto setDefaultPhoto];
    [[self.imgPhoto layer] setMasksToBounds:YES];
    [self.imgPhoto setViewRoundNoBorder];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imagePhotoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePhotoClick:)];
    [self.imgPhoto addGestureRecognizer:imagePhotoClick];
    
    CGFloat nickNameY = self.imgPhoto.y+self.imgPhoto.height+16;
    CGFloat lbW = self.cellW - kSizeSpace*2;
    self.lbNickName = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, nickNameY, lbW, self.lbH)];
    [self.lbNickName setTextColor:WHITECOLOR];
    [self.lbNickName setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    CGRect signFrame = CGRectMake(kSizeSpace, self.lbNickName.y+self.lbNickName.height+kSize6, lbW, self.lbMinH);
    self.lbSign = [[ZLabel alloc] initWithFrame:signFrame];
    [self.lbSign setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbSign setTextColor:TABLEVIEWCELL_TLINECOLOR];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSign];
    
    CGFloat btnW = 100;
    CGFloat space = (self.cellW-btnW*3)/4;
    CGFloat btnH = 55;
    CGFloat btnY = self.lbSign.y+self.lbSign.height+kSize6;
    
    self.btnAgree = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(space, btnY, btnW, btnH)];
    [self.btnAgree setViewDataWithTitle:kTheAnswerIsAgreed imageName:@"mine_agreenum_icon" count:0];
    [self.viewMain addSubview:self.btnAgree];
    
    self.btnShare = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(self.cellW/2-btnW/2, btnY, btnW, btnH)];
    [self.btnShare setViewDataWithTitle:kTheAnswerIsShared imageName:@"mine_sharenum_icon" count:0];
    [self.viewMain addSubview:self.btnShare];
    
    self.btnCollection = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(self.cellW-btnW-space, btnY, btnW, btnH)];
    [self.btnCollection setViewDataWithTitle:kTheAnswerIsCollected imageName:@"mine_collectionnum_icon" count:0];
    [self.viewMain addSubview:self.btnCollection];
    
    CGFloat lineY = btnY+13;
    CGFloat lineW = kLineHeight;
    CGFloat lineH = btnH-23;
    self.imgLine1 = [[UIView alloc] initWithFrame:CGRectMake(self.btnAgree.x+self.btnAgree.width+space/2, lineY, lineW, lineH)];
    [self.imgLine1 setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.btnShare.x+self.btnShare.width+space/2, lineY, lineW, lineH)];
    [self.imgLine2 setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.imgLine2];
    
    self.cellH = btnY+btnH+kSize8;
    
    self.imgBack = [[ZImageView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
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
    
    [self.viewMain addSubview:self.imgBack];
    
    [self.viewMain sendSubviewToBack:self.imgBack];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
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

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    ZWEAKSELF
    [self.imgPhoto setPhotoURLStr:model.head_img completed:^(UIImage *image) {
        GCDMainBlock(^{
            [weakSelf.imgBack setImage:image];
        });
    }];
    
    [self.lbNickName setText:model.nickname];
    
    [self.lbSign setText:model.sign];
    
    [self.btnAgree setViewDataWithTitle:kTheAnswerIsAgreed imageName:@"mine_agreenum_icon" count:model.myAnswerAgreeCount];
    
    [self.btnShare setViewDataWithTitle:kTheAnswerIsShared imageName:@"mine_sharenum_icon" count:model.myAnswerShareCount];
    
    [self.btnCollection setViewDataWithTitle:kTheAnswerIsCollected imageName:@"mine_collectionnum_icon"  count:model.myAnswerCollectCount];
    
    return self.cellH;
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
    [super setViewNil];
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
    return 255;
}

@end
