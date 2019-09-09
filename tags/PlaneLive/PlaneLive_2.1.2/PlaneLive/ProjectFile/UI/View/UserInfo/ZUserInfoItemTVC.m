//
//  ZUserInfoItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZUserInfoItemTVC.h"

@interface ZUserInfoItemTVC()

@property (strong, nonatomic) ZImageView *imgIcon;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbCount;
@property (strong, nonatomic) UIImageView *imgLine;
@property (assign, nonatomic) ZUserInfoItemTVCType type;
@end

@implementation ZUserInfoItemTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZUserInfoItemTVCType)type
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setType:type];
        [self innerInit];
    }
    return self;
}
-(ZUserInfoItemTVCType)getCellType
{
    return self.type;
}
-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZUserInfoItemTVC getH];
    [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    CGFloat space = 15;
    CGFloat iconS = 21;
    CGFloat lbW = 120;
    self.imgIcon = [[ZImageView alloc] initWithFrame:CGRectMake(space, self.cellH/2-iconS/2, iconS, iconS)];
    [self.viewMain addSubview:self.imgIcon];
    
    CGFloat lbX = self.imgIcon.x+self.imgIcon.width+9;
    CGFloat lbH = self.lbH;
    CGFloat lbY = self.cellH/2-lbH/2;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(lbX, lbY, lbW, lbH)];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbCount = [[ZLabel alloc] initWithFrame:CGRectMake(self.cellW-self.arrowW-lbW, lbY, lbW, lbH)];
    [self.lbCount setTextColor:DESCCOLOR];
    [self.lbCount setHidden:YES];
    [self.lbCount setTextAlignment:(NSTextAlignmentRight)];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.viewMain addSubview:self.lbCount];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(space, self.cellH-kLineHeight, self.cellW-space*2, kLineHeight)];
    [self.viewMain addSubview:self.imgLine];
    
    switch (self.type) {
        case ZUserInfoItemTVCQuestion:
        {
            [self.imgIcon setImageName:@"my_question_new"];
            [self.lbTitle setText:@"我的提问"];
            break;
        }
        case ZUserInfoItemTVCAnswer:
        {
            [self.imgIcon setImageName:@"my_answer_new"];
            [self.lbTitle setText:@"我的回答"];
            break;
        }
        case ZUserInfoItemTVCComment:
        {
            [self.imgIcon setImageName:@"my_comment_new"];
            [self.lbTitle setText:@"我的评论"];
            break;
        }
        case ZUserInfoItemTVCFans:
        {
            [self.imgIcon setImageName:@"my_fans_new"];
            [self.lbTitle setText:@"我的粉丝"];
            break;
        }
        case ZUserInfoItemTVCFeedback:
        {
            [self.imgIcon setImageName:@"my_feedback_new"];
            [self.lbTitle setText:@"意见反馈"];
            break;
        }
        case ZUserInfoItemTVCServer:
        {
            [self.imgIcon setImageName:@"my_persion_account_new"];
            [self.lbTitle setText:@"联系客服"];
            break;
        }
        case ZUserInfoItemTVCAccount:
        {
            [self.imgIcon setImageName:@"my_persion_account_new"];
            [self.lbTitle setText:@"个人账号"];
            break;
        }
        case ZUserInfoItemTVCSetting:
        {
            [self.imgIcon setImageName:@"my_setting_new"];
            [self.lbTitle setText:kSetting];
            break;
        }
        default: break;
    }
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.lbCount setHidden:YES];
    switch (self.type) {
        case ZUserInfoItemTVCQuestion:
        {
            [self.lbCount setHidden:model.myQuesCount==0];
            [self.lbCount setText:[NSString stringWithFormat:@"%d", model.myQuesCount]];
            break;
        }
        case ZUserInfoItemTVCAnswer:
        {
            [self.lbCount setHidden:model.myAnswerCommentcount==0];
            [self.lbCount setText:[NSString stringWithFormat:@"%d", model.myAnswerCommentcount]];
            break;
        }
        case ZUserInfoItemTVCFans:
        {
            [self.lbCount setHidden:model.myFunsCount==0];
            [self.lbCount setText:[NSString stringWithFormat:@"%d", model.myFunsCount]];
            break;
        }
        case ZUserInfoItemTVCComment:
        {
            [self.lbCount setHidden:model.myCommentCount==0];
            [self.lbCount setText:[NSString stringWithFormat:@"%d", model.myCommentCount]];
            break;
        }
        default:
            break;
    }
    return self.cellH;
}
-(void)setHiddenLineView
{
    [self.imgLine setHidden:YES];
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_imgLine);
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
