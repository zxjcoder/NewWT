//
//  ZUserNumberTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserNumberTVC.h"

@interface ZUserNumberTVC()

///我的问题标题
@property (strong, nonatomic) UILabel *lbQuestionTitle;
///我的问题值
@property (strong, nonatomic) UILabel *lbQuestionValue;

@property (strong, nonatomic) UIView *viewLine1;
///我的粉丝标题
@property (strong, nonatomic) UILabel *lbFansTitle;
///我的粉丝值
@property (strong, nonatomic) UILabel *lbFansValue;

@property (strong, nonatomic) UIView *viewLine2;
///等我回答标题
@property (strong, nonatomic) UILabel *lbAnswerTitle;
///等我回答值
@property (strong, nonatomic) UILabel *lbAnswerValue;

@property (strong, nonatomic) UIButton *btnQuestion;
@property (strong, nonatomic) UIButton *btnFans;
@property (strong, nonatomic) UIButton *btnAnswer;

@end

@implementation ZUserNumberTVC

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
    
    self.lbQuestionTitle = [[UILabel alloc] init];
    [self.lbQuestionTitle setText:@"我的问题"];
    [self.lbQuestionTitle setTextColor:DESCCOLOR];
    [self.lbQuestionTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbQuestionTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbQuestionTitle setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbQuestionTitle];
    
    self.lbQuestionValue = [[UILabel alloc] init];
    [self.lbQuestionValue setTextColor:BLACKCOLOR1];
    [self.lbQuestionValue setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbQuestionValue setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbQuestionValue setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbQuestionValue];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine1];
    
    self.lbFansTitle = [[UILabel alloc] init];
    [self.lbFansTitle setText:@"我的粉丝"];
    [self.lbFansTitle setTextColor:DESCCOLOR];
    [self.lbFansTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbFansTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbFansTitle setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbFansTitle];
    
    self.lbFansValue = [[UILabel alloc] init];
    [self.lbFansValue setTextColor:BLACKCOLOR1];
    [self.lbFansValue setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbFansValue setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbFansValue setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbFansValue];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine2];
    
    self.lbAnswerTitle = [[UILabel alloc] init];
    [self.lbAnswerTitle setText:@"等我回答"];
    [self.lbAnswerTitle setTextColor:DESCCOLOR];
    [self.lbAnswerTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbAnswerTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbAnswerTitle setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbAnswerTitle];
    
    self.lbAnswerValue = [[UILabel alloc] init];
    [self.lbAnswerValue setTextColor:BLACKCOLOR1];
    [self.lbAnswerValue setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbAnswerValue setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbAnswerValue setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbAnswerValue];
    
    self.btnQuestion = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnQuestion setBackgroundColor:CLEARCOLOR];
    [self.btnQuestion addTarget:self action:@selector(btnQuestionClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnQuestion];
    
    self.btnFans = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnFans setBackgroundColor:CLEARCOLOR];
    [self.btnFans addTarget:self action:@selector(btnFansClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnFans];
    
    self.btnAnswer = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAnswer setBackgroundColor:CLEARCOLOR];
    [self.btnAnswer addTarget:self action:@selector(btnAnswerClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAnswer];
    
    [self.viewMain bringSubviewToFront:self.btnQuestion];
    [self.viewMain bringSubviewToFront:self.btnFans];
    [self.viewMain bringSubviewToFront:self.btnAnswer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat topY = 18;
    CGFloat itemW = self.cellW/3;
    CGFloat titleY = self.cellH/2;
    [self.lbQuestionValue setFrame:CGRectMake(0, topY, itemW, self.lbMinH)];
    [self.lbQuestionTitle setFrame:CGRectMake(0, titleY, itemW, self.lbH)];
    
    CGFloat lineY = 8;
    [self.viewLine1 setFrame:CGRectMake(itemW, lineY, 1, self.cellH-lineY*2)];
   
    [self.lbFansValue setFrame:CGRectMake(itemW, topY, itemW, self.lbMinH)];
    [self.lbFansTitle setFrame:CGRectMake(itemW, titleY, itemW, self.lbH)];
    
    [self.viewLine2 setFrame:CGRectMake(itemW*2, lineY, 1, self.cellH-lineY*2)];
    
    [self.lbAnswerValue setFrame:CGRectMake(itemW*2, topY, itemW, self.lbMinH)];
    [self.lbAnswerTitle setFrame:CGRectMake(itemW*2, titleY, itemW, self.lbH)];
    
    [self.btnQuestion setFrame:CGRectMake(0, 0, itemW, self.cellH)];
    [self.btnFans setFrame:CGRectMake(itemW, 0, itemW, self.cellH)];
    [self.btnAnswer setFrame:CGRectMake(itemW*2, 0, itemW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    [super setCellDataWithModel:model];
    if (model) {
        [self.lbQuestionValue setText:[NSString stringWithFormat:@"%d",[model myQuesCount]]];
        [self.lbFansValue setText:[NSString stringWithFormat:@"%d",[model myFunsCount]]];
        [self.lbAnswerValue setText:[NSString stringWithFormat:@"%d",[model myWaitAnsCount]]];
    }
}

-(void)btnQuestionClick
{
    if (self.onQuestionClick) {
        self.onQuestionClick();
    }
}

-(void)btnFansClick
{
    if (self.onFansClick) {
        self.onFansClick();
    }
}

-(void)btnAnswerClick
{
    if (self.onAnswerClick) {
        self.onAnswerClick();
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_lbQuestionTitle);
    OBJC_RELEASE(_lbQuestionValue);
    OBJC_RELEASE(_lbFansTitle);
    OBJC_RELEASE(_lbFansValue);
    OBJC_RELEASE(_lbAnswerTitle);
    OBJC_RELEASE(_lbAnswerValue);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 80;
}
+(CGFloat)getH
{
    return 80;
}

@end
