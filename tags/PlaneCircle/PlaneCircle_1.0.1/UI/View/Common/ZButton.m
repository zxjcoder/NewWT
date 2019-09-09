//
//  ZButton.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButton.h"
#import "ClassCategory.h"

@interface ZButton()

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@end

@implementation ZButton

-(id)initWithShareType:(ZShareType)type
{
    self = [super init];
    if (self) {
        [self setType:type];
        [self innerShareInit];
    }
    return self;
}

-(void)innerShareInit
{
    [self setUserInteractionEnabled:YES];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self addSubview:self.lbTitle];
    
    self.imgIcon = [[UIImageView alloc] init];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self addSubview:self.imgIcon];
    
    [self innerShareData];
}

-(void)innerShareData
{
    switch (self.type) {
        case ZShareTypeWeChat:
        {
            [self.lbTitle setText:@"微信"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_weixin"]];
            break;
        }
        case ZShareTypeWeChatCircle:
        {
            [self.lbTitle setText:@"朋友圈"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_pengyouquan"]];
            break;
        }
        case ZShareTypeQQ:
        {
            [self.lbTitle setText:@"QQ好友"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_qq"]];
            break;
        }
        case ZShareTypeQZone:
        {
            [self.lbTitle setText:@"QQ空间"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_qzone"]];
            break;
        }
//        case ZShareTypeSina:
//        {
//            [self.lbTitle setText:@"新浪微博"];
//            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_weibo"]];
//            break;
//        }
        case ZShareTypeReport:
        {
            [self.lbTitle setText:@"举报"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_jubao"]];
            break;
        }
        case ZShareTypeBlackList:
        {
            [self.lbTitle setText:@"加入黑名单"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_heimingdan"]];
            break;
        }
        case ZShareTypeEdit:
        {
            [self.lbTitle setText:@"编辑"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDelete:
        {
            [self.lbTitle setText:@"删除"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeEditAnswer:
        {
            [self.lbTitle setText:@"编辑回答"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDeleteAnswer:
        {
            [self.lbTitle setText:@"删除回答"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeEditQuestion:
        {
            [self.lbTitle setText:@"编辑问题"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDeleteQuestion:
        {
            [self.lbTitle setText:@"删除问题"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeDownload:
        {
            [self.lbTitle setText:@"下载"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_download"]];
            break;
        }
        case ZShareTypeCollection:
        {
            [self.lbTitle setText:@"收藏"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_shoucang"]];
            break;
        }
        case ZShareTypeYouDao:
        {
            [self.lbTitle setText:@"有道云笔记"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_youdao"]];
            break;
        }
        case ZShareTypeYingXiang:
        {
            [self.lbTitle setText:@"印象笔记"];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_yinxiang"]];
            break;
        }
        default: break;
    }
}

-(void)setButtonText:(NSString *)text
{
    [self.lbTitle setText:text];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    if (self.imgIcon) {
        CGFloat imgSize = 50;
        [self.imgIcon setFrame:CGRectMake(self.width/2-imgSize/2, 0, imgSize, imgSize)];
    }
    if (self.lbTitle) {
        [self.lbTitle setFrame:CGRectMake(0, self.height-25, self.width, 25)];
    }
}

-(void)setBtnPoint:(CGPoint)point
{
    [self setFrame:CGRectMake(point.x, point.y, kButtonShareW, kButtonShareH)];
    [self setViewFrame];
}

@end
