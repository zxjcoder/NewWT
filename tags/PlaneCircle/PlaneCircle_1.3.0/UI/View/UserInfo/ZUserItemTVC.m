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
///小红点
@property (strong, nonatomic) UILabel *lbRedPoint;
///分割线
@property (strong, nonatomic) UIView *viewL;

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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
 
    self.imgIcon = [[UIImageView alloc] init];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setBackgroundColor:MAINCOLOR];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setHidden:YES];
    [self.viewMain addSubview:self.lbCount];
    
    self.lbRedPoint = [[UILabel alloc] init];
    [self.lbRedPoint setText:kEmpty];
    [self.lbRedPoint setTextColor:WHITECOLOR];
    [self.lbRedPoint setBackgroundColor:MAINCOLOR];
    [self.lbRedPoint setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbRedPoint setHidden:YES];
    [self.viewMain addSubview:self.lbRedPoint];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)innerData
{
    switch (self.type) {
        case ZUserItemTVCTypeCollection:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_shoucang"]];
            [self.lbTitle setText:@"我的收藏"];
            break;
        case ZUserItemTVCTypeAnswer:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_answer"]];
            [self.lbTitle setText:@"我的回答"];
            break;
        case ZUserItemTVCTypeAttention:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_guanzhu"]];
            [self.lbTitle setText:@"我的关注"];
            break;
        case ZUserItemTVCTypeFeedback:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_yijianfankui"]];
            [self.lbTitle setText:@"意见反馈"];
            break;
        case ZUserItemTVCTypeSetting:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_settings"]];
            [self.lbTitle setText:@"设置"];
            break;
        case ZUserItemTVCTypeAgreement:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_xieyi"]];
            [self.lbTitle setText:@"使用协议"];
            break;
        case ZUserItemTVCTypeNoticeCenter:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_message"]];
            [self.lbTitle setText:@"消息中心"];
            break;
        case ZUserItemTVCTypeComment:
            [self.imgIcon setImage:[SkinManager getImageWithName:@"mine_icon_comment"]];
            [self.lbTitle setText:@"评论"];
            break;
        default:break;
    }
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    if (model) {
        //TODO:ZWW备注-个数设置
        switch (self.type) {
            case ZUserItemTVCTypeAnswer:
            {
                [self.lbCount setHidden:model.myAnswerCommentcount==0];
                if (model.myAnswerCommentcount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myAnswerCommentcount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            case ZUserItemTVCTypeNoticeCenter:
            {
                [self.lbCount setHidden:model.myNoticeCenterCount==0];
                if (model.myNoticeCenterCount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myNoticeCenterCount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            case ZUserItemTVCTypeComment:
            {
                [self.lbCount setHidden:model.myCommentReplyCount==0];
                if (model.myCommentReplyCount < 100) {
                    [self.lbCount setText:[NSString stringWithFormat:@"%d",model.myCommentReplyCount]];
                } else {
                    [self.lbCount setText:@"99"];
                }
                break;
            }
            default: break;
        }
    }
    [self setNeedsDisplay];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbCount setFrame:CGRectMake(self.cellW-self.arrowW-18, self.cellH/2-18/2, 18, 18)];
    [self.lbCount setViewRoundNoBorder];
    
    [self.lbRedPoint setFrame:CGRectMake(self.cellW-self.arrowW-10, self.cellH/2-5/2, 5, 5)];
    [self.lbRedPoint setViewRoundNoBorder];
    
    [self.imgIcon setFrame:CGRectMake(self.space, self.cellH/2-18/2, 18, 18)];
    [self.lbTitle setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width+kSize13, self.cellH/2-self.lbH/2, self.cellW, self.lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewL);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

@end
