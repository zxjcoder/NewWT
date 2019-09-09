//
//  ZUserInfoQuestionView.m
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZUserInfoQuestionView.h"
#import "ZUserInfoQuestionButton.h"

@interface ZUserInfoQuestionView()

@property (strong, nonatomic) ZUserInfoQuestionButton *btnQuestion;
@property (strong, nonatomic) ZUserInfoQuestionButton *btnFans;
@property (strong, nonatomic) ZUserInfoQuestionButton *btnAnswer;
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserInfoQuestionView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    CGFloat btnW = 80;
    CGFloat space = (self.width-btnW*3)/4;;
    CGFloat btnH = 80;
    CGFloat btnY = 2;
    
    self.btnQuestion = [[ZUserInfoQuestionButton alloc] initWithFrame:CGRectMake(space, btnY, btnW, btnH)];
    [self.btnQuestion setViewDataWithTitle:kQuestion maxCount:0 minCount:0];
    [self.btnQuestion addTarget:self action:@selector(btnQuestionClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnQuestion];
    
    self.btnFans = [[ZUserInfoQuestionButton alloc] initWithFrame:CGRectMake(self.width/2-btnW/2, btnY, btnW, btnH)];
    [self.btnFans setViewDataWithTitle:kFans maxCount:0 minCount:0];
    [self.btnFans addTarget:self action:@selector(btnFansClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnFans];
    
    self.btnAnswer = [[ZUserInfoQuestionButton alloc] initWithFrame:CGRectMake(self.width-btnW-space, btnY, btnW, btnH)];
    [self.btnAnswer setViewDataWithTitle:kWaitAnswer maxCount:0 minCount:0];
    [self.btnAnswer addTarget:self action:@selector(btnAnswerClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnAnswer];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.height-kLineMaxHeight, self.width, kLineMaxHeight)];
    [self addSubview:self.imgLine];
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

-(void)setViewDataWithModel:(ModelUser *)model
{
    [self.btnQuestion setViewDataWithTitle:kQuestion maxCount:model.myQuesCount minCount:model.myQuesNewCount];
    [self.btnFans setViewDataWithTitle:kFans maxCount:model.myFunsCount minCount:0];
    [self.btnAnswer setViewDataWithTitle:kWaitAnswer maxCount:model.myWaitAnsCount minCount:model.myWaitNewAns];
}
-(void)dealloc
{
    OBJC_RELEASE(_btnFans);
    OBJC_RELEASE(_btnAnswer);
    OBJC_RELEASE(_btnQuestion);
    OBJC_RELEASE(_onFansClick);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_onQuestionClick);
}
+(CGFloat)getH
{
    return 85;
}

@end
