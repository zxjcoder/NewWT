//
//  ZUserInfoHeaderTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZUserInfoHeaderTVC.h"
#import "ZUserInfoShopButton.h"

@interface ZUserInfoHeaderTVC()

@property (strong, nonatomic) ZImageView *imgBack;

@property (strong, nonatomic) ZImageView *imgPhoto;
@property (strong, nonatomic) ZLabel *lbNickName;
@property (strong, nonatomic) ZLabel *lbSign;
@property (strong, nonatomic) UIButton *btnGo;
@property (strong, nonatomic) UIImageView *imageGo;

@property (strong, nonatomic) UIView *viewButton;
@property (strong, nonatomic) ZUserInfoShopButton *btnShopCart;
@property (strong, nonatomic) ZUserInfoShopButton *btnPurchaseRecord;
@property (strong, nonatomic) ZUserInfoShopButton *btnBalance;
@property (strong, nonatomic) ZUserInfoShopButton *btnDownload;

@end

@implementation ZUserInfoHeaderTVC

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
    
    self.cellH = [ZUserInfoHeaderTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgBack = [[ZImageView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, 150)];
    [self.imgBack setImageName:@"bg_profile"];
    [self.imgBack setUserInteractionEnabled:true];
    [self.viewMain addSubview:self.imgBack];
    
    CGFloat imgS = 70;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(20, self.imgBack.height-imgS-25, imgS, imgS)];
    [self.imgPhoto setDefaultPhoto];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.imgPhoto.layer setMasksToBounds:true];
    [self.imgPhoto setViewRound:6 borderWidth:0 borderColor:CLEARCOLOR];
    [self.imgBack addSubview:self.imgPhoto];
    
    CGFloat lbX = self.imgPhoto.x+self.imgPhoto.width+15;
    CGFloat lbW = self.cellW-lbX-20;
    self.lbNickName = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, self.imgPhoto.y + 2, lbW, self.lbH)];
    [self.lbNickName setTextColor:WHITECOLOR];
    [self.lbNickName setUserInteractionEnabled:YES];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
    [self.lbNickName setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.imgBack addSubview:self.lbNickName];
    
    self.imageGo = [[UIImageView alloc] initWithFrame:(CGRectMake(self.cellW - self.space - 24, self.lbNickName.y + self.lbNickName.height / 2 - 12, 24, 24))];
    [self.imageGo setUserInteractionEnabled: true];
    [self.imageGo setImage:[SkinManager getImageWithName:@"arrow_right"]];
    [self.imageGo setUserInteractionEnabled:false];
    [self.imgBack addSubview:self.imageGo];
    
    self.btnGo = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnGo setUserInteractionEnabled:true];
    [self.btnGo setFrame:(CGRectMake(self.imageGo.x-10, self.imageGo.y-10, 44, 44))];
    [self.btnGo addTarget:self action:@selector(btnGoClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.imgBack addSubview:self.btnGo];
    
    CGFloat signY = self.imgPhoto.y + self.imgPhoto.height - self.lbMinH - 10;
    self.lbSign = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, signY, lbW, self.lbMinH)];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbSign setTextColor:RGBCOLORA(255, 255, 255, 0.7)];
    [self.lbSign setUserInteractionEnabled:YES];
    [self.lbSign setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.imgBack addSubview:self.lbSign];
    
    UITapGestureRecognizer *tapGesturePhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self.imgPhoto addGestureRecognizer:tapGesturePhoto];
    //UITapGestureRecognizer *tapGesturePhotoGo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    //[self.imageGo addGestureRecognizer:tapGesturePhotoGo];
    
    self.viewButton = [[UIView alloc] initWithFrame:(CGRectMake(20, self.imgPhoto.y + self.imgPhoto.height + 15, self.cellW - 40, 90))];
    [self.viewButton setShadowColorWithRadius:11];
    [self.viewButton.layer setShadowOpacity:0.05];
    [self.viewButton setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewButton];
    
    CGFloat btnY = 5;
    CGFloat btnX = 10;
    CGFloat btnW = ZUserInfoShopButtonWidth;
    CGFloat itemSpace = (self.viewButton.width - btnX*2 - btnW * 4)/3;
    self.btnShopCart = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(btnX, btnY) type:(ZUserInfoCenterItemTypeShoppingCart)];
    [self.btnShopCart addTarget:self action:@selector(btnShopCartClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewButton addSubview:self.btnShopCart];
    
    self.btnPurchaseRecord = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(btnX + btnW + itemSpace, btnY) type:(ZUserInfoCenterItemTypePurchaseRecord)];
    [self.btnPurchaseRecord addTarget:self action:@selector(btnPurchaseRecordClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewButton addSubview:self.btnPurchaseRecord];
    
    self.btnBalance = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(btnX + btnW*2 + itemSpace*2, btnY) type:(ZUserInfoCenterItemTypeBalance)];
    [self.btnBalance addTarget:self action:@selector(btnBalanceClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewButton addSubview:self.btnBalance];
    
    self.btnDownload = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(btnX + btnW*3 + itemSpace*3, btnY) type:(ZUserInfoCenterItemTypeDownload)];
    [self.btnDownload addTarget:self action:@selector(btnDownloadClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewButton addSubview:self.btnDownload];
    
    [self.viewMain sendSubviewToBack:self.imgBack];
}
-(void)tapGestureClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onUserPhotoClick) {
            self.onUserPhotoClick();
        }
    }
}
-(void)btnGoClick
{
    if (self.onUserPhotoClick) {
        self.onUserPhotoClick();
    }
}
-(void)btnDownloadClick
{
    if (self.onDownloadClick) {
        self.onDownloadClick();
    }
}
-(void)btnEditClick:(ZButton *)sender
{
    if (self.onUserPhotoClick) {
        self.onUserPhotoClick();
    }
}
-(void)btnShopCartClick
{
    if (self.onShopCartClick) {
        self.onShopCartClick();
    }
}
-(void)btnPurchaseRecordClick
{
    if (self.onPurchaseRecordClick) {
        self.onPurchaseRecordClick();
    }
}
-(void)btnBalanceClick
{
    if (self.onBalanceClick) {
        self.onBalanceClick();
    }
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    if (model.head_img.length > 0) {
        [self.imgPhoto setPhotoURLStr:model.head_img];
    } else {
        [self.imgPhoto setDefaultPhoto];
    }
    if (model.nickname.length > 0) {
        [self.lbNickName setText:model.nickname];
    } else {
        [self.lbNickName setText:kEmpty];
    }
    if (model.nickname.length > 0) {
        [self.lbSign setText:model.sign];
    } else {
        [self.lbSign setText:kEmpty];
    }
    [self.btnShopCart setItemCount:model.shoppingCartCount];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_btnBalance);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_btnShopCart);
    OBJC_RELEASE(_btnDownload);
    
    OBJC_RELEASE(_onBalanceClick);
    OBJC_RELEASE(_onUserPhotoClick);
    OBJC_RELEASE(_onShopCartClick);
    OBJC_RELEASE(_onPurchaseRecordClick);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 235;
}

@end
