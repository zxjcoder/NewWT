//
//  ZUserInfoCenterItemCVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoCenterItemCVC.h"
#import "ZImageView.h"
#import "ZView.h"
#import "ZLabel.h"
#import "ZCalculateLabel.h"

@interface ZUserInfoCenterItemCVC()

///内容区域
@property (strong, nonatomic) UIButton *viewMain;
///图片
@property (strong, nonatomic) ZImageView *imgIcon;
///标题
@property (strong, nonatomic) ZLabel *lbTitle;
///数量
@property (strong, nonatomic) ZLabel *lbCount;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserInfoCenterItemCVC

-(void)innerInit
{
    if (!self.viewMain) {
        self.viewMain = [[UIButton alloc] init];
        [self.viewMain setBackgroundImage:[UIImage createImageWithColor:WHITECOLOR] forState:(UIControlStateNormal)];
        [self.viewMain setBackgroundImage:[UIImage createImageWithColor:TABLEVIEWCELL_TLINECOLOR] forState:(UIControlStateHighlighted)];
        [self.viewMain addTarget:self action:@selector(btnBackClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewMain setUserInteractionEnabled:YES];
        [self.contentView addSubview:self.viewMain];
    }
    if (!self.imgIcon) {
        self.imgIcon = [[ZImageView alloc] init];
        [self.imgIcon setUserInteractionEnabled:NO];
        [self.viewMain addSubview:self.imgIcon];
    }
    if (!self.lbCount) {
        self.lbCount = [[ZLabel alloc] init];
        [self.lbCount setTextColor:WHITECOLOR];
        [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbCount setBackgroundColor:MAINCOLOR];
        [self.lbCount setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbCount setNumberOfLines:1];
        [self.lbCount setUserInteractionEnabled:NO];
        [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.viewMain addSubview:self.lbCount];
    }
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] init];
        [self.lbTitle setTextColor:BLACKCOLOR];
        [self.lbTitle setBackgroundColor:CLEARCOLOR];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbTitle setNumberOfLines:1];
        [self.lbTitle setUserInteractionEnabled:NO];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.viewMain addSubview:self.lbTitle];
    }
    if (!self.imgLine) {
        self.imgLine = [UIImageView getSLineView];
        [self.viewMain addSubview:self.imgLine];
    }
}

-(void)btnBackClick
{
    if (self.onUserInfoCenterItemClick) {
        self.onUserInfoCenterItemClick(self.type);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewMain setFrame:self.contentView.bounds];
    
    CGFloat space = 15;
    CGFloat imgSize = 30;
    CGFloat imgX = (self.viewMain.width-imgSize)/2;
    [self.imgIcon setFrame:CGRectMake(imgX, space, imgSize, imgSize)];
    
    [self.lbCount setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width+5, 9, 16, 16)];
    [self.lbCount setViewRoundNoBorder];
    
    [self.lbTitle setFrame:CGRectMake(0, self.imgIcon.y+self.imgIcon.height+10, self.width, 22)];
    
    [self.imgLine setFrame:CGRectMake(0, self.viewMain.height-kLineHeight/2, self.viewMain.width, kLineHeight/2)];
}

-(void)setViewDataWithType:(ZUserInfoCenterItemType)type count:(long)count
{
    [self setType:type];
    [self innerInit];
    [self.lbCount setHidden:count==0];
    [self.lbCount setText:[NSString stringWithFormat:@"%ld",count]];
    switch (type) {
        case ZUserInfoCenterItemTypePay:
            [self.lbTitle setText:kPurchaseRecord];
            [self.imgIcon setImageName:@"mine_record_icon"];
            break;
        case ZUserInfoCenterItemTypeBalance:
            [self.lbTitle setText:kBalanceQuery];
            [self.imgIcon setImageName:@"mine_balance_icon"];
            break;
        case ZUserInfoCenterItemTypeCollection:
            [self.lbTitle setText:kCollection];
            [self.imgIcon setImageName:@"mine-collection_icon"];
            break;
        case ZUserInfoCenterItemTypeAttention:
            [self.lbTitle setText:kAttention];
            [self.imgIcon setImageName:@"mine_follow_icon"];
            break;
        case ZUserInfoCenterItemTypeAnswer:
            [self.lbTitle setText:kRejoin];
            [self.imgIcon setImageName:@"mine_answer_icon"];
            break;
        case ZUserInfoCenterItemTypeComment:
            [self.lbTitle setText:kMyComment];
            [self.imgIcon setImageName:@"mine_comment_icon"];
            break;
        case ZUserInfoCenterItemTypeTask:
            [self.lbTitle setText:kTaskCenter];
            [self.imgIcon setImageName:@"mine_taskcenter_icon"];
            break;
        case ZUserInfoCenterItemTypeMessage:
            [self.lbTitle setText:kMessageCenter];
            [self.imgIcon setImageName:@"mine_message_icon"];
            break;
        case ZUserInfoCenterItemTypeFeedback:
            [self.lbTitle setText:kFeedback];
            [self.imgIcon setImageName:@"mine_feedback_"];
            break;
        case ZUserInfoCenterItemTypeSetting:
            [self.lbTitle setText:kSetting];
            [self.imgIcon setImageName:@"mien_seetings_icon"];
            break;
        case ZUserInfoCenterItemTypeAccount:
            [self.lbTitle setText:kAccountManager];
            [self.imgIcon setImageName:@"mien_account_icon"];
            break;
        case ZUserInfoCenterItemTypeDownload:
            [self.lbTitle setText:kDownloadManager];
            [self.imgIcon setImageName:@"mien_download_icon"];
            break;
        case ZUserInfoCenterItemTypeShoppingCart:
            [self.lbTitle setText:kShoppingCart];
            [self.imgIcon setImageName:@"mien_shoppingcart_icon"];
            break;
        case ZUserInfoCenterItemTypePurchaseRecord:
            [self.lbTitle setText:kPurchaseRecord];
            [self.imgIcon setImageName:@"mien_purchaserecord_icon"];
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

-(void)dealloc
{
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbTitle);
}

@end
