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

///分享显示图标
@property (strong, nonatomic) UIImageView *imgIcon;
///分享标题
@property (strong, nonatomic) UILabel *lbTitle;

///选中文本
@property (strong, nonatomic) UILabel *lbText;
///举报分类
@property (assign, nonatomic) ZReportViewType rtype;

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

///初始化
-(id)initWithReportType:(ZReportViewType)type
{
    self = [super init];
    if (self) {
        [self setRtype:type];
        [self innerCheckInit];
    }
    return self;
}

-(NSString *)getText
{
    return self.lbText.text;
}

-(NSString *)getTitle
{
    return self.lbTitle.text;
}

-(void)innerCheckInit
{
    [self setUserInteractionEnabled:YES];
    
    [self setTag:self.rtype];
    
    self.lbText = [[UILabel alloc] init];
    [self.lbText setTextColor:BLACKCOLOR1];
    [self.lbText setUserInteractionEnabled:NO];
    [self.lbText setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbText setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self addSubview:self.lbText];
    
    switch (self.rtype) {
        case ZReportViewTypeLJGG:
            [self.lbText setText:@"垃圾广告"];
            break;
        case ZReportViewTypeBYSNR:
            [self.lbText setText:@"不友善内容"];
            break;
        case ZReportViewTypeWFXX:
            [self.lbText setText:@"违法信息"];
            break;
        case ZReportViewTypeZZMG:
            [self.lbText setText:@"政治敏感"];
            break;
        case ZReportViewTypeOther:
            [self.lbText setText:@"其他"];
            break;
        default:
            break;
    }
    
}

-(void)innerShareInit
{
    [self setUserInteractionEnabled:YES];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
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
        case ZShareTypeYinXiang:
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
    if (self.lbText) {
        [self.lbText setText:text];
    }
    if (self.lbTitle) {
        [self.lbTitle setText:text];
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
    
    OBJC_RELEASE(_lbText);
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
    
    if (self.lbText) {
        CGFloat lbH = 22;
        [self.lbText setFrame:CGRectMake(0, self.height/2-lbH/2, self.width, lbH)];
    }
}

-(void)setBtnPoint:(CGPoint)point
{
    [self setFrame:CGRectMake(point.x, point.y, kButtonShareW, kButtonShareH)];
    [self setViewFrame];
}

@end
