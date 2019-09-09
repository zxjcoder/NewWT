//
//  ZUserInfoItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZUserInfoItemTVC.h"

@interface ZUserInfoItemTVC()

///ICON
@property (strong, nonatomic) UIImageView *imgIcon;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///数量
@property (strong, nonatomic) UILabel *lbCount;
///消息
@property (strong, nonatomic) UILabel *lbDesc;
///分割线
@property (strong, nonatomic) UIImageView *imageLine;
@property (assign, nonatomic) ZUserInfoItemTVCType cellType;

@end

@implementation ZUserInfoItemTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZUserInfoItemTVCType)type
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
        [self setCellType:type];
        [self innerData];
    }
    return self;
}

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
    
    self.cellH = [ZUserInfoItemTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    [self.viewMain setBackgroundColor:WHITECOLOR];
    self.space = 20;
    CGFloat iconSize = 24;
    self.imgIcon = [[UIImageView alloc] initWithFrame:(CGRectMake(self.space, self.cellH / 2 - iconSize / 2, iconSize, iconSize))];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(self.imgIcon.x + self.imgIcon.width + 11, self.cellH / 2 - self.lbH / 2, 100, self.lbH))];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    [self setImageAccessoryView];
    
    CGFloat countSize = 20;
    CGFloat countX = self.arrowX-countSize-2;
    CGFloat countY = self.cellH / 2 - countSize / 2;
    self.lbCount = [[UILabel alloc] initWithFrame:(CGRectMake(countX, countY, countSize, countSize))];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbCount setViewRoundNoBorder];
    [self.lbCount setBackgroundColor:COLORCOUNTBG];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setHidden:YES];
    [self.viewMain addSubview:self.lbCount];
    
    CGFloat descW = 70;
    CGFloat descX = self.arrowX-countSize-2;
    CGFloat descY = self.cellH / 2 - self.lbMinH / 2;
    self.lbDesc = [[UILabel alloc] initWithFrame:(CGRectMake(descX, descY, descW, self.lbMinH))];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbDesc setTextColor:COLORCONTENT3];
    [self.lbDesc setTextAlignment:(NSTextAlignmentRight)];
    [self.lbDesc setHidden:YES];
    [self.lbDesc setText:@"有新回复"];
    [self.viewMain addSubview:self.lbDesc];
    
    CGFloat lineX = self.lbTitle.x - 3;
    self.imageLine = [UIImageView getDLineView];
    self.imageLine.frame = CGRectMake(lineX, self.cellH - 1, self.cellW - lineX - self.space, kLineHeight);
    [self.viewMain addSubview:self.imageLine];
}

-(void)innerData
{
    switch (self.cellType) {
        case ZUserInfoItemTVCTypeCollection:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"favs1"]];
            [self.lbTitle setText:kMyCollection];
            break;
        case ZUserInfoItemTVCTypeMessage:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"info"]];
            [self.lbTitle setText:kMyNoticeCenter];
            break;
        case ZUserInfoItemTVCTypeNews:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"message"]];
            [self.lbTitle setText:kMessageCenter];
            break;
        case ZUserInfoItemTVCTypeFeedback:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"help"]];
            [self.lbTitle setText:kFeedback];
            break;
        case ZUserInfoItemTVCTypeSetting:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"setting"]];
            [self.lbTitle setText:kSetting];
            break;
        case ZUserInfoItemTVCTypeBind:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"band"]];
            [self.lbTitle setText:kAccountManager];
            break;
        default:break;
    }
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.lbDesc setHidden:true];
    [self.lbCount setHidden:true];
    if (model) {
        //TODO:ZWW备注-个数设置
        switch (self.cellType) {
            case ZUserInfoItemTVCTypeCollection:
            {
                [self.lbCount setHidden:model.myCollectAccount==0];
                if (model.myCollectAccount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myCollectAccount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            case ZUserInfoItemTVCTypeMessage:
            {
                [self.lbCount setHidden:model.myMessageCount==0];
                if (model.myMessageCount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myMessageCount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            case ZUserInfoItemTVCTypeNews:
            {
                [self.lbCount setHidden:model.myNoticeCenterCount==0];
                if (model.myNoticeCenterCount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myNoticeCenterCount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            case ZUserInfoItemTVCTypeFeedback:
            {
                //[self.lbDesc setHidden:model.myFeedbackReplyCount==0];
                [self.lbCount setHidden:model.myFeedbackReplyCount==0];
                if (model.myFeedbackReplyCount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myFeedbackReplyCount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            default: break;
        }
    }
    return self.cellH;
}
-(ZUserInfoItemTVCType)getType
{
    return self.cellType;
}
-(void)setViewNil
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbTitle);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 50;
}

@end
