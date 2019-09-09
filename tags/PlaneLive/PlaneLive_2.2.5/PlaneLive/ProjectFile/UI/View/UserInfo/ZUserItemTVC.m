//
//  ZUserItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserItemTVC.h"

@interface ZUserItemTVC()

///ICON
@property (strong, nonatomic) UIImageView *imgIcon;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///数量
@property (strong, nonatomic) UILabel *lbCount;
///消息
@property (strong, nonatomic) UILabel *lbDesc;
///前进箭头
@property (strong, nonatomic) UIImageView *imgGo;
///分割线
@property (strong, nonatomic) UIImageView *imageLine;

@end

@implementation ZUserItemTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellType:(ZUserItemTVCType)cellType
{
    self = [self initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setType:cellType];
        [self innerData];
    }
    return self;
}

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
    
    self.cellH = [ZUserItemTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    self.space = 20;
    CGFloat iconSize = 24;
    self.imgIcon = [[UIImageView alloc] initWithFrame:(CGRectMake(self.space, self.cellH / 2 - iconSize / 2, iconSize, iconSize))];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(self.imgIcon.x + self.imgIcon.width + 12, self.cellH / 2 - self.lbH / 2, 100, self.lbH))];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    CGFloat goW = 12;
    self.imgGo = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"arrow_right"]];
    self.imgGo.frame = CGRectMake(self.cellW - self.space - goW, self.cellH / 2 - 9, goW, 18);
    [self.viewMain addSubview:self.imgGo];
    
    self.lbCount = [[UILabel alloc] initWithFrame:(CGRectMake(self.imgGo.x - 8 - 50 , self.cellH / 2 - self.lbMinH / 2, 50, self.lbMinH))];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbCount setTextColor:COLORTEXT3];
    [self.lbCount setTextAlignment:(NSTextAlignmentRight)];
    [self.lbCount setHidden:YES];
    [self.viewMain addSubview:self.lbCount];
    
    self.lbDesc = [[UILabel alloc] initWithFrame:(CGRectMake(self.cellW - 20 - 10 - 100, self.cellH/2 - self.lbMinH/2, 100, self.lbMinH))];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setTextColor:REDCOLOR];
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
    switch (self.type) {
        case ZUserItemTVCTypeCollection:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"favs1"]];
            [self.lbTitle setText:kMyCollection];
            break;
        case ZUserItemTVCTypeMessage:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"info"]];
            [self.lbTitle setText:kMyAnswer];
            break;
        case ZUserItemTVCTypeNews:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"message"]];
            [self.lbTitle setText:kMyAttention];
            break;
        case ZUserItemTVCTypeFeedback:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"help"]];
            [self.lbTitle setText:kMyFeedback];
            break;
        case ZUserItemTVCTypeSetting:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"setting"]];
            [self.lbTitle setText:kSetting];
            break;
        case ZUserItemTVCTypeBind:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"band"]];
            [self.lbTitle setText:kMyAgreement];
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
        switch (self.type) {
            case ZUserItemTVCTypeCollection:
            {
                [self.lbCount setHidden:model.myCollectAccount==0];
                if (model.myCollectAccount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myCollectAccount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            case ZUserItemTVCTypeMessage:
            {
                [self.lbCount setHidden:model.myMessageCount==0];
                if (model.myMessageCount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myMessageCount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            case ZUserItemTVCTypeNews:
            {
                [self.lbCount setHidden:model.myNoticeCenterCount==0];
                if (model.myNoticeCenterCount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myNoticeCenterCount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            case ZUserItemTVCTypeFeedback:
            {
                [self.lbDesc setHidden:model.myFeedbackReplyCount==0];
                break;
            }
            default: break;
        }
    }
    [self setNeedsDisplay];
    
    return self.cellH;
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
