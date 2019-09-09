//
//  ZUserInfoGridCVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZUserInfoGridCVC.h"
#import "ZImageView.h"
#import "ZView.h"
#import "ZLabel.h"
#import "ZCalculateLabel.h"

@interface ZUserInfoGridCVC()

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

@implementation ZUserInfoGridCVC

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
        [self.lbCount setBackgroundColor:REDCOLOR];
        [self.lbCount setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbCount setNumberOfLines:1];
        [self.lbCount setUserInteractionEnabled:NO];
        [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Minmum_Size]];
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
        self.imgLine = [UIImageView getDLineView];
        [self.imgLine setHidden:YES];
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
    CGFloat imgSize = 25;
    CGFloat imgX = (self.viewMain.width-imgSize)/2;
    [self.imgIcon setFrame:CGRectMake(imgX, space, imgSize, imgSize)];
    
    [self.lbCount setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width+5, 9, 16, 16)];
    [self.lbCount setViewRoundNoBorder];
    
    [self.lbTitle setFrame:CGRectMake(0, self.imgIcon.y+self.imgIcon.height+10, self.width, 22)];
    
    [self.imgLine setFrame:CGRectMake(0, self.viewMain.height-kLineHeight/2, self.viewMain.width, kLineHeight/2)];
}

-(void)setViewDataWithType:(ZUserInfoGridCVCType)type count:(long)count
{
    [self setType:type];
    [self innerInit];
    [self.lbCount setHidden:count==0];
    [self.lbCount setText:[NSString stringWithFormat:@"%ld",count]];
    switch (type) {
        case ZUserInfoGridCVCTypeColl:
            [self.lbTitle setText:kCollection];
            [self.imgIcon setImageName:@"my_collection_new"];
            break;
        case ZUserInfoGridCVCTypeAtt:
            [self.lbTitle setText:kAttention];
            [self.imgIcon setImageName:@"my_attention_new"];
            break;
        case ZUserInfoGridCVCTypeDownload:
            [self.lbTitle setText:kDownloadManager];
            [self.imgIcon setImageName:@"my_download_new"];
            break;
        case ZUserInfoGridCVCTypeMessage:
            [self.lbTitle setText:kMessage];
            [self.imgIcon setImageName:@"my_message_new"];
            break;
        case ZUserInfoGridCVCTypeWaitAnswer:
            [self.lbTitle setText:kStayAnswer];
            [self.imgIcon setImageName:@"my_tobe_answere_new"];
            break;
        case ZUserInfoGridCVCTypeMessageCenter:
            [self.lbTitle setText:kMessageCenter];
            [self.imgIcon setImageName:@"my_message_center__new"];
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
