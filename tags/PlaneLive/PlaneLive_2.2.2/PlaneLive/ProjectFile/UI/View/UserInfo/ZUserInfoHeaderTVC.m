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

@property (strong, nonatomic) ZImageView *imgPraise;
@property (strong, nonatomic) ZLabel *lbPraise;
@property (strong, nonatomic) ZImageView *imgShare;
@property (strong, nonatomic) ZLabel *lbShare;
@property (strong, nonatomic) ZImageView *imgCollection;
@property (strong, nonatomic) ZLabel *lbCollection;
@property (strong, nonatomic) ZButton *btnGo;

@property (strong, nonatomic) ZUserInfoShopButton *btnShopCart;
@property (strong, nonatomic) ZUserInfoShopButton *btnPurchaseRecord;
@property (strong, nonatomic) ZUserInfoShopButton *btnBalance;

@property (strong, nonatomic) UIImageView *imgLine;

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
    
    self.imgBack = [[ZImageView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, self.cellH-10)];
    [self.imgBack setImageName:@"my_header_back"];
    [self.imgBack setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgBack];
    
    CGFloat imgS = 83;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(22, 50, imgS, imgS)];
    [self.imgPhoto setDefaultPhoto];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.imgPhoto setViewRoundWithColor:RGBCOLOR(253, 176, 115)];
    [self.viewMain addSubview:self.imgPhoto];
    
    CGFloat lbX = self.imgPhoto.x+self.imgPhoto.width+22;
    CGFloat btnGoS = 45;
    CGFloat lbW = self.cellW-btnGoS-lbX;
    self.lbNickName = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, 53, lbW, self.lbH)];
    [self.lbNickName setTextColor:WHITECOLOR];
    [self.lbNickName setUserInteractionEnabled:YES];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [self.lbNickName setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewMain addSubview:self.lbNickName];
    
    CGFloat signY = self.lbNickName.y+self.lbNickName.height+8;
    self.lbSign = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, signY, lbW, self.lbMinH)];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbSign setTextColor:WHITECOLOR];
    [self.lbSign setUserInteractionEnabled:YES];
    [self.lbSign setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewMain addSubview:self.lbSign];
    
    CGFloat iconY = self.imgPhoto.y+self.imgPhoto.height-16-8;
    self.imgPraise = [[ZImageView alloc] initWithFrame:CGRectMake(lbX, iconY, 16, 16)];
    [self.imgPraise setImageName:@"my_answer_praise_new"];
    [self.viewMain addSubview:self.imgPraise];
    
    self.lbPraise = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, iconY, 10, 16)];
    [self.lbPraise setTextColor:WHITECOLOR];
    [self.lbPraise setText:kZero];
    [self.lbPraise setFont:[ZFont systemFontOfSize:kFont_Minmum_Size]];
    [self.viewMain addSubview:self.lbPraise];
    
    self.imgShare = [[ZImageView alloc] initWithFrame:CGRectMake(lbX, iconY, 16, 16)];
    [self.imgShare setImageName:@"my_answer_share_new"];
    [self.viewMain addSubview:self.imgShare];
    
    self.lbShare = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, iconY, 10, 16)];
    [self.lbShare setTextColor:WHITECOLOR];
    [self.lbShare setText:kZero];
    [self.lbShare setFont:[ZFont systemFontOfSize:kFont_Minmum_Size]];
    [self.viewMain addSubview:self.lbShare];
    
    self.imgCollection = [[ZImageView alloc] initWithFrame:CGRectMake(lbX, iconY, 16, 16)];
    [self.imgCollection setImageName:@"my_answer_collection_new"];
    [self.viewMain addSubview:self.imgCollection];
    
    self.lbCollection = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, iconY, 10, 16)];
    [self.lbCollection setTextColor:WHITECOLOR];
    [self.lbCollection setText:kZero];
    [self.lbCollection setFont:[ZFont systemFontOfSize:kFont_Minmum_Size]];
    [self.viewMain addSubview:self.lbCollection];
    
    [self setShareViewFrame];
    
    self.btnGo = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnGo setFrame:CGRectMake(self.cellW-btnGoS, self.lbNickName.y+self.lbNickName.height-5, btnGoS, btnGoS)];
    [self.btnGo setImage:[SkinManager getImageWithName:@"my_edituser_new"] forState:(UIControlStateNormal)];
    [self.btnGo setImageEdgeInsets:(UIEdgeInsetsMake(2, 2, 2, 2))];
    [self.btnGo addTarget:self action:@selector(btnEditClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnGo];
    
    UITapGestureRecognizer *tapGesturePhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self.imgPhoto addGestureRecognizer:tapGesturePhoto];
    
    CGFloat btnW = ZUserInfoShopButtonWidth;
    CGFloat itemW = self.cellW/3;
    CGFloat btnY = self.cellH-ZUserInfoShopButtonHeight-10;
    self.btnShopCart = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(itemW/2-btnW/2, btnY) type:(ZUserInfoCenterItemTypeShoppingCart)];
    [self.btnShopCart addTarget:self action:@selector(btnShopCartClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnShopCart];
    
    self.btnPurchaseRecord = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(self.cellW/2-btnW/2, btnY) type:(ZUserInfoCenterItemTypePurchaseRecord)];
    [self.btnPurchaseRecord addTarget:self action:@selector(btnPurchaseRecordClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnPurchaseRecord];
    
    self.btnBalance = [[ZUserInfoShopButton alloc] initWithPoint:CGPointMake(self.cellW-itemW/2-btnW/2, btnY) type:(ZUserInfoCenterItemTypeBalance)];
    [self.btnBalance addTarget:self action:@selector(btnBalanceClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnBalance];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.cellH-10, self.cellW, 10)];
    [self.viewMain addSubview:self.imgLine];
    
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
-(void)setShareViewFrame
{
    CGFloat lbPraiseX = self.imgPraise.x+self.imgPraise.width+5;
    CGRect lbPraiseFrame = self.lbPraise.frame;
    CGFloat lbPraiseW = [self.lbPraise getLabelWidthWithMinWidth:10];
    lbPraiseFrame.size.width = lbPraiseW;
    lbPraiseFrame.origin.x = lbPraiseX;
    [self.lbPraise setFrame:lbPraiseFrame];
    
    CGFloat imgShareX = self.lbPraise.x+self.lbPraise.width+7;
    CGRect imgShareFrame = self.imgShare.frame;
    imgShareFrame.origin.x = imgShareX;
    [self.imgShare setFrame:imgShareFrame];
    
    CGFloat lbShareX = self.imgShare.x+self.imgShare.width+5;
    CGRect lbShareFrame = self.lbShare.frame;
    CGFloat lbShareW = [self.lbShare getLabelWidthWithMinWidth:10];
    lbShareFrame.size.width = lbShareW;
    lbShareFrame.origin.x = lbShareX;
    [self.lbShare setFrame:lbShareFrame];
    
    CGFloat imgCollectionX = self.lbShare.x+self.lbShare.width+7;
    CGRect imgCollectionFrame = self.imgCollection.frame;
    imgCollectionFrame.origin.x = imgCollectionX;
    [self.imgCollection setFrame:imgCollectionFrame];
    
    CGFloat lbCollectionX = self.imgCollection.x+self.imgCollection.width+5;
    CGRect lbCollectionFrame = self.lbCollection.frame;
    CGFloat lbCollectionW = [self.lbCollection getLabelWidthWithMinWidth:10];
    lbCollectionFrame.size.width = lbCollectionW;
    lbCollectionFrame.origin.x = lbCollectionX;
    [self.lbCollection setFrame:lbCollectionFrame];
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.imgPhoto setPhotoURLStr:model.head_img];
    [self.lbNickName setText:model.nickname];
    [self.lbSign setText:model.sign];
    
    [self.lbPraise setText:[NSString stringWithFormat:@"%d", model.myAnswerAgreeCount]];
    [self.lbShare setText:[NSString stringWithFormat:@"%d", model.myAnswerShareCount]];
    [self.lbCollection setText:[NSString stringWithFormat:@"%d", model.myAnswerCollectCount]];
    
    [self.btnShopCart setItemCount:model.shoppingCartCount];
    
    [self setShareViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnGo);
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_lbShare);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_imgShare);
    OBJC_RELEASE(_lbPraise);
    OBJC_RELEASE(_imgPraise);
    OBJC_RELEASE(_btnBalance);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_btnShopCart);
    OBJC_RELEASE(_lbCollection);
    OBJC_RELEASE(_imgCollection);
    
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
    return 260;
}

@end
