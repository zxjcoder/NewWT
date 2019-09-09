//
//  ZUserProfileHeaderTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserProfileHeaderTVC.h"
#import "ZImageView.h"

@interface ZUserProfileHeaderTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbQuestionTitle;
@property (strong, nonatomic) UILabel *lbQuestionValue;

@property (strong, nonatomic) UILabel *lbFansTitle;
@property (strong, nonatomic) UILabel *lbFansValue;

@property (strong, nonatomic) UILabel *lbAnswerTitle;
@property (strong, nonatomic) UILabel *lbAnswerValue;

@property (strong, nonatomic) UIButton *btnQuestion;
@property (strong, nonatomic) UIButton *btnFans;
@property (strong, nonatomic) UIButton *btnAnswer;

@property (strong, nonatomic) UIView *viewLine1;
@property (strong, nonatomic) UIView *viewLine2;
@property (strong, nonatomic) UIView *viewLine3;

@end

@implementation ZUserProfileHeaderTVC

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
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultPhoto];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbQuestionTitle = [[UILabel alloc] init];
    [self.lbQuestionTitle setText:kHeQuestion];
    [self.lbQuestionTitle setTextColor:DESCCOLOR];
    [self.lbQuestionTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbQuestionTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbQuestionTitle setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbQuestionTitle];
    
    self.lbQuestionValue = [[UILabel alloc] init];
    [self.lbQuestionValue setTextColor:BLACKCOLOR1];
    [self.lbQuestionValue setText:@"0"];
    [self.lbQuestionValue setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbQuestionValue setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbQuestionValue setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbQuestionValue];
    
    self.lbFansTitle = [[UILabel alloc] init];
    [self.lbFansTitle setText:kHeFans];
    [self.lbFansTitle setTextColor:DESCCOLOR];
    [self.lbFansTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbFansTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbFansTitle setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbFansTitle];
    
    self.lbFansValue = [[UILabel alloc] init];
    [self.lbFansValue setTextColor:BLACKCOLOR1];
    [self.lbFansValue setText:@"0"];
    [self.lbFansValue setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbFansValue setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbFansValue setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbFansValue];
    
    self.lbAnswerTitle = [[UILabel alloc] init];
    [self.lbAnswerTitle setText:kHeAnswer];
    [self.lbAnswerTitle setTextColor:DESCCOLOR];
    [self.lbAnswerTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbAnswerTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbAnswerTitle setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbAnswerTitle];
    
    self.lbAnswerValue = [[UILabel alloc] init];
    [self.lbAnswerValue setTextColor:BLACKCOLOR1];
    [self.lbAnswerValue setText:@"0"];
    [self.lbAnswerValue setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbAnswerValue setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbAnswerValue setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbAnswerValue];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine2];
    
    self.viewLine3 = [[UIView alloc] init];
    [self.viewLine3 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine3];
    
    self.btnQuestion = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnQuestion setTag:1];
    [self.btnQuestion setUserInteractionEnabled:YES];
    [self.btnQuestion addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnQuestion];
    
    self.btnFans = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnFans setTag:2];
    [self.btnFans setUserInteractionEnabled:YES];
    [self.btnFans addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnFans];
    
    self.btnAnswer = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAnswer setTag:3];
    [self.btnAnswer setUserInteractionEnabled:YES];
    [self.btnAnswer addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAnswer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 55;
    CGFloat space = 15;
    [self.imgPhoto setFrame:CGRectMake(self.space, space, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
    
    CGFloat middle = self.cellH/2;
    CGFloat lbW = (self.cellW-self.imgPhoto.x-imgSize)/3;
    CGFloat lbX = self.imgPhoto.x+self.imgPhoto.width;
    [self.lbQuestionValue setFrame:CGRectMake(lbX, middle-self.lbH, lbW, self.lbH)];
    [self.lbQuestionTitle setFrame:CGRectMake(lbX, middle, lbW, self.lbH)];
    [self.btnQuestion setFrame:CGRectMake(lbX, self.lbQuestionValue.y, lbW, self.lbQuestionValue.height+self.lbQuestionTitle.height)];
    
    [self.viewLine1 setFrame:CGRectMake(lbX+lbW, space, 1, imgSize)];
    
    [self.lbFansValue setFrame:CGRectMake(self.viewLine1.x, middle-self.lbH, lbW, self.lbH)];
    [self.lbFansTitle setFrame:CGRectMake(self.viewLine1.x, middle, lbW, self.lbH)];
    [self.btnFans setFrame:CGRectMake(self.viewLine1.x, self.lbFansValue.y, lbW, self.lbFansValue.height+self.lbFansTitle.height)];
    
    [self.viewLine2 setFrame:CGRectMake(self.lbFansTitle.x+lbW, space, 1, imgSize)];
    
    [self.lbAnswerValue setFrame:CGRectMake(self.viewLine2.x, middle-self.lbH, lbW, self.lbH)];
    [self.lbAnswerTitle setFrame:CGRectMake(self.viewLine2.x, middle, lbW, self.lbH)];
    [self.btnAnswer setFrame:CGRectMake(self.viewLine2.x, self.lbAnswerValue.y, lbW, self.lbAnswerValue.height+self.lbAnswerTitle.height)];
    
    [self.viewLine3 setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)btnItemClick:(UIButton *)sender
{
    if (self.onItemClick) {
        switch (sender.tag) {
            case 1:
            {
                self.onItemClick(ZUserProfileHeaderItemTypeQuestion,self.lbQuestionTitle.text);
                break;
            }
            case 2:
            {
                self.onItemClick(ZUserProfileHeaderItemTypeFans,self.lbFansTitle.text);
                break;
            }
            case 3:
            {
                self.onItemClick(ZUserProfileHeaderItemTypeAnswer,self.lbAnswerTitle.text);
                break;
            }
            default: break;
        }
    }
}

-(void)setCellDataWithModel:(ModelUserProfile *)model
{
    [super setCellDataWithModel:model];
    switch (model.sex) {
        case WTSexTypeFeMale:
        {
            [self.lbAnswerTitle setText:kSheAnswer];
            [self.lbFansTitle setText:kSheFans];
            [self.lbQuestionTitle setText:kSheQuestion];
            break;
        }
        default:
        {
            [self.lbAnswerTitle setText:kHeAnswer];
            [self.lbFansTitle setText:kHeFans];
            [self.lbQuestionTitle setText:kHeQuestion];
            break;
        }
    }
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.head_img];
        [self.lbQuestionValue setText:[NSString stringWithFormat:@"%d",[model hisQues]]];
        [self.lbFansValue setText:[NSString stringWithFormat:@"%d",[model hisFuns]]];
        [self.lbAnswerValue setText:[NSString stringWithFormat:@"%d",[model hisAnswer]]];
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_viewLine3);
    OBJC_RELEASE(_lbFansValue);
    OBJC_RELEASE(_lbFansTitle);
    OBJC_RELEASE(_lbQuestionValue);
    OBJC_RELEASE(_lbQuestionTitle);
    OBJC_RELEASE(_lbAnswerTitle);
    OBJC_RELEASE(_lbAnswerValue);
    OBJC_RELEASE(_imgPhoto);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 85;
}
+(CGFloat)getH
{
    return 85;
}

@end
