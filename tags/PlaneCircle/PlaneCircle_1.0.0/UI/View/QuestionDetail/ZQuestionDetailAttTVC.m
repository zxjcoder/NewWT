//
//  ZQuestionDetailAttTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionDetailAttTVC.h"

@interface ZQuestionDetailAttTVC()

@property (strong, nonatomic) UIImageView *imgAttIcon;
@property (strong, nonatomic) UILabel  *lbAttIcon;
@property (strong, nonatomic) UIImageView *imgAnswerIcon;
@property (strong, nonatomic) UILabel *lbAnswerIcon;

@property (strong, nonatomic) UIButton *btnAtt;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) ModelQuestionDetail *model;

@end

@implementation ZQuestionDetailAttTVC

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
    
    self.imgAttIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_wentixiangqing_guanzhu"]];
    [self.viewMain addSubview:self.imgAttIcon];
    
    self.imgAnswerIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_wentixiangqing_huida"]];
    [self.viewMain addSubview:self.imgAnswerIcon];
    
    self.lbAttIcon = [[UILabel alloc] init];
    [self.lbAttIcon setNumberOfLines:1];
    [self.lbAttIcon setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbAttIcon setTextColor:DESCCOLOR];
    [self.lbAttIcon setText:@"0个关注"];
    [self.lbAttIcon setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbAttIcon];
    
    self.lbAnswerIcon = [[UILabel alloc] init];
    [self.lbAnswerIcon setNumberOfLines:1];
    [self.lbAnswerIcon setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbAnswerIcon setTextColor:DESCCOLOR];
    [self.lbAnswerIcon setText:@"0个答案"];
    [self.lbAnswerIcon setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbAnswerIcon];
    
    self.btnAtt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAtt setTitle:@"关注" forState:(UIControlStateNormal)];
    [self.btnAtt setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnAtt setBackgroundColor:MAINCOLOR];
    [[self.btnAtt titleLabel] setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.btnAtt setTag:1];
    [self.btnAtt setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnAtt addTarget:self action:@selector(btnAttClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAtt];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
    
}
-(void)setViewFrame
{
    self.cellW = APP_FRAME_WIDTH;
    
    CGFloat imgW = 14;
    CGFloat imgH = 10;
    [self.imgAttIcon setFrame:CGRectMake(self.space, self.cellH/2-imgW/2, imgW, imgH)];
    
    CGFloat attW = [self.lbAttIcon getLabelWidthWithMinWidth:0];
    [self.lbAttIcon setFrame:CGRectMake(self.imgAttIcon.x+imgW+4, self.cellH/2-self.lbMinH/2-3, attW, self.lbMinH)];
    
    [self.imgAnswerIcon setFrame:CGRectMake(self.lbAttIcon.x+attW+10, self.cellH/2-imgW/2, imgW, imgH)];
    
    CGFloat answerW = [self.lbAnswerIcon getLabelWidthWithMinWidth:0];
    [self.lbAnswerIcon setFrame:CGRectMake(self.imgAnswerIcon.x+imgW+4, self.cellH/2-self.lbMinH/2-3, answerW, self.lbMinH)];
    
    CGFloat btnW = 55;
    CGFloat btnH = 27;
    [self.btnAtt setFrame:CGRectMake(self.cellW-btnW-self.space, self.cellH/2-btnH/2, btnW, btnH)];
}
-(void)btnAttClick:(UIButton *)sender
{
    if (self.onAttentionClick) {
        self.onAttentionClick(self.model);
    }
}
-(void)setIsAttState
{
    if (self.model.isAtt) {
        [self.btnAtt setTitle:@"已关注" forState:(UIControlStateNormal)];
        [self.btnAtt setBackgroundColor:RGBCOLOR(201, 201, 201)];
    } else {
        [self.btnAtt setTitle:@"关注" forState:(UIControlStateNormal)];
        [self.btnAtt setBackgroundColor:MAINCOLOR];
    }
}
-(void)setCellDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    if (model) {
        [self.lbAttIcon setText:[NSString stringWithFormat:@"%ld个关注",model.attCount]];
        [self.lbAnswerIcon setText:[NSString stringWithFormat:@"%ld个答案",model.answerCount]];
    }
    [self setIsAttState];
    [self setViewFrame];
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbAttIcon);
    OBJC_RELEASE(_lbAnswerIcon);
    OBJC_RELEASE(_imgAttIcon);
    OBJC_RELEASE(_imgAnswerIcon);
    OBJC_RELEASE(_btnAtt);
    OBJC_RELEASE(_viewLine);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

@end
