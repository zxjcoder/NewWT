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
    
    self.cellH = [ZQuestionDetailAttTVC getH];
    
    self.imgAttIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"circle_att_count_icon"]];
    [self.viewMain addSubview:self.imgAttIcon];
    
    self.imgAnswerIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"circle_answer_count_icon"]];
    [self.viewMain addSubview:self.imgAnswerIcon];
    
    self.lbAttIcon = [[UILabel alloc] init];
    [self.lbAttIcon setNumberOfLines:1];
    [self.lbAttIcon setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbAttIcon setTextColor:BLACKCOLOR1];
    [self.lbAttIcon setText:[NSString stringWithFormat:kAttentionToNumber, 0]];
    [self.lbAttIcon setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbAttIcon];
    
    self.lbAnswerIcon = [[UILabel alloc] init];
    [self.lbAnswerIcon setNumberOfLines:1];
    [self.lbAnswerIcon setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbAnswerIcon setTextColor:BLACKCOLOR1];
    [self.lbAnswerIcon setText:[NSString stringWithFormat:kAnswerToNumber, 0]];
    [self.lbAnswerIcon setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbAnswerIcon];
    
    self.btnAtt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAtt setTitle:kAttention forState:(UIControlStateNormal)];
    [self.btnAtt setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnAtt setBackgroundColor:MAINCOLOR];
    [[self.btnAtt titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
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
    CGFloat imgW = 14;
    CGFloat imgH = 14;
    CGFloat imgY = kSize8;
    CGFloat lbY = kSize8;
    CGFloat lbH = self.lbMinH;
    [self.imgAttIcon setFrame:CGRectMake(self.space, imgY, imgW, imgH)];
    
    CGFloat attW = [self.lbAttIcon getLabelWidthWithMinWidth:0];
    [self.lbAttIcon setFrame:CGRectMake(self.imgAttIcon.x+imgW+kSize5, lbY, attW, lbH)];
    
    [self.imgAnswerIcon setFrame:CGRectMake(self.lbAttIcon.x+attW+kSize10, imgY, imgW, imgH)];
    
    CGFloat answerW = [self.lbAnswerIcon getLabelWidthWithMinWidth:0];
    [self.lbAnswerIcon setFrame:CGRectMake(self.imgAnswerIcon.x+imgW+kSize5, lbY, answerW, lbH)];
    
    CGFloat btnW = 50;
    CGFloat btnH = 25;
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
        [self.btnAtt setTitle:kAlreadyAttention forState:(UIControlStateNormal)];
        [self.btnAtt setBackgroundColor:RGBCOLOR(201, 201, 201)];
    } else {
        [self.btnAtt setTitle:kAttention forState:(UIControlStateNormal)];
        [self.btnAtt setBackgroundColor:MAINCOLOR];
    }
}
-(CGFloat)setCellDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    if (model) {
        [self.lbAttIcon setText:[NSString stringWithFormat:kAttentionToNumber, (long)model.attCount]];
        [self.lbAnswerIcon setText:[NSString stringWithFormat:kAnswerToNumber, (long)model.answerCount]];
    }
    [self setIsAttState];
    
    [self setViewFrame];
    
    return self.cellH;
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

+(CGFloat)getH
{
    return 35;
}

@end
