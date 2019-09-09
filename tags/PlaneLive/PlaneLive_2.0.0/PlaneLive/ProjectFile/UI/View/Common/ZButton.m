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

///初始化
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

///初始化
-(id)initWithText:(NSString *)text imageName:(NSString *)imageName
{
    self = [super init];
    if (self) {
        [self innerTextInit:text imageName:imageName];
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

-(void)innerTextInit:(NSString *)text imageName:(NSString *)imageName
{
    [self setUserInteractionEnabled:YES];
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:imageName]];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:TABLEVIEWCELL_TLINECOLOR];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbTitle setText:text];
    [self addSubview:self.lbTitle];
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
            [self.lbText setText:kJunkAds];
            break;
        case ZReportViewTypeBYSNR:
            [self.lbText setText:kNotFriendlyContent];
            break;
        case ZReportViewTypeWFXX:
            [self.lbText setText:kIllegalInformation];
            break;
        case ZReportViewTypeZZMG:
            [self.lbText setText:kPoliticallySensitive];
            break;
        case ZReportViewTypeOther:
            [self.lbText setText:kOther];
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
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
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
            [self.lbTitle setText:kCWeChatFriend];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_weixin"]];
            break;
        }
        case ZShareTypeWeChatCircle:
        {
            [self.lbTitle setText:kCWeChatTimeline];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_pengyouquan"]];
            break;
        }
        case ZShareTypeQQ:
        {
            [self.lbTitle setText:kCQQFriend];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_qq"]];
            break;
        }
        case ZShareTypeQZone:
        {
            [self.lbTitle setText:kCQZone];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_qzone"]];
            break;
        }
        case ZShareTypeReport:
        {
            [self.lbTitle setText:kReport];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_jubao"]];
            break;
        }
        case ZShareTypeBlackList:
        {
            [self.lbTitle setText:kJoinBlacklist];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_heimingdan"]];
            break;
        }
        case ZShareTypeEdit:
        {
            [self.lbTitle setText:kEdit];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDelete:
        {
            [self.lbTitle setText:kDelete];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeEditAnswer:
        {
            [self.lbTitle setText:kEditAnswer];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDeleteAnswer:
        {
            [self.lbTitle setText:kDeleteAnswer];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeEditQuestion:
        {
            [self.lbTitle setText:kEditQuestion];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDeleteQuestion:
        {
            [self.lbTitle setText:kDeleteQuestion];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeDownload:
        {
            [self.lbTitle setText:kDownload];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_download"]];
            break;
        }
        case ZShareTypeCollection:
        {
            [self.lbTitle setText:kCollection];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_shoucang"]];
            break;
        }
        case ZShareTypeYouDao:
        {
            [self.lbTitle setText:kYouDaoYunBiJi];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_youdao"]];
            break;
        }
        case ZShareTypeYinXiang:
        {
            [self.lbTitle setText:kYinXiangBiJi];
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

-(void)setButtonImageName:(NSString *)imageName
{
    [self.imgIcon setImage:[SkinManager getImageWithName:imageName]];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
    
    OBJC_RELEASE(_lbText);
    OBJC_RELEASE(_model);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    if (self.imgIcon && self.imgIcon.frame.size.width==0) {
        CGFloat imgSize = 50;
        [self.imgIcon setFrame:CGRectMake(self.width/2-imgSize/2, 0, imgSize, imgSize)];
    }
    if (self.lbTitle && self.lbTitle.frame.size.width==0) {
        [self.lbTitle setFrame:CGRectMake(0, self.height-25, self.width, 25)];
    }
    
    if (self.lbText && self.lbText.frame.size.width==0) {
        CGFloat lbH = 22;
        [self.lbText setFrame:CGRectMake(0, self.height/2-lbH/2, self.width, lbH)];
    }
}

-(void)setBtnFrame:(CGRect)frame
{
    [self setFrame:frame];
    
    CGFloat imgSize = 25;
    [self.imgIcon setFrame:CGRectMake(self.width/2-imgSize/2, 0, imgSize, imgSize)];
    
    [self.lbTitle setFrame:CGRectMake(0, self.height-25, self.width, 25)];
}

-(void)setBtnPoint:(CGPoint)point
{
    [self setFrame:CGRectMake(point.x, point.y, kButtonShareW, kButtonShareH)];
    [self setViewFrame];
}

@end
