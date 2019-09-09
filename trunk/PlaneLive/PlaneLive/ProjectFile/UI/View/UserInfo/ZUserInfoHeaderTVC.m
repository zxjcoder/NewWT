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
@property (strong, nonatomic) ZView *viewContent;

@property (strong, nonatomic) ZImageView *imgPhoto;
@property (strong, nonatomic) ZLabel *lbNickName;
@property (strong, nonatomic) ZLabel *lbSign;
@property (strong, nonatomic) ZButton *btnGo;

@property (strong, nonatomic) ZView *viewButton;
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
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.cellH = [ZUserInfoHeaderTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgBack = [[ZImageView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, self.cellH-57)];
    [self.imgBack setImageName:@"bg_profile"];
    [self.imgBack setUserInteractionEnabled:true];
    [self.viewMain addSubview:self.imgBack];
    
    CGFloat contentH = 162;
    self.viewContent = [[ZView alloc] initWithFrame:(CGRectMake(10, 80, self.cellW-20, contentH))];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [[self.viewContent layer] setShadowColor:RGBCOLORA(121, 135, 163, 0.18).CGColor];
    [[self.viewContent layer] setShadowOffset:(CGSizeMake(0, 0))];
    [[self.viewContent layer] setShadowRadius:20];
    [[self.viewContent layer] setShadowOpacity:0.18];
    [self.viewContent.layer setCornerRadius:8];
    [self.viewContent.layer setBorderWidth:0];
    [self.viewMain addSubview:self.viewContent];
    
    CGFloat imgS = 70;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(20, -12, imgS, imgS)];
    [self.imgPhoto setDefaultPhoto];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.imgPhoto.layer setMasksToBounds:true];
    [self.imgPhoto setViewRound:8 borderWidth:3 borderColor:RGBCOLORA(255, 255, 255, 0.5)];
    [self.viewContent addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self.imgPhoto addGestureRecognizer:imageTapGesture];
    
    self.btnGo = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnGo setImage:[SkinManager getImageWithName:@"arrow_right"] forState:(UIControlStateNormal)];
    [self.btnGo setImage:[SkinManager getImageWithName:@"arrow_right"] forState:(UIControlStateHighlighted)];
    [self.btnGo setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnGo setFrame:(CGRectMake(self.viewContent.width-50, 10, 40, 40))];
    [self.btnGo addTarget:self action:@selector(btnGoClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnGo];
    
    CGFloat lbX = self.imgPhoto.x+self.imgPhoto.width+15;
    CGFloat lbW = self.btnGo.x-lbX-20;
    self.lbNickName = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, 12, lbW, 26)];
    [self.lbNickName setTextColor:COLORTEXT1];
    [self.lbNickName setUserInteractionEnabled:YES];
    [self.lbNickName setFont:[ZFont systemFontOfSize:24]];
    [self.lbNickName setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewContent addSubview:self.lbNickName];
    
    CGFloat signY = self.lbNickName.y + self.lbNickName.height + 5;
    self.lbSign = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, signY, lbW, 20)];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbSign setTextColor:COLORTEXT3];
    [self.lbSign setUserInteractionEnabled:YES];
    [self.lbSign setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewContent addSubview:self.lbSign];
    
    self.viewButton = [[UIView alloc] initWithFrame:(CGRectMake(0, self.imgPhoto.y + self.imgPhoto.height, self.viewContent.width, 90))];
    [self.viewContent addSubview:self.viewButton];
    
    CGFloat btnY = 17;
    CGFloat btnX = 20;
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
    return 255;
}

@end
