//
//  ZUserInfoQuestionTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoQuestionTVC.h"
#import "ZUserInfoQuestionButton.h"

@interface ZUserInfoQuestionTVC()

@property (strong, nonatomic) ZUserInfoQuestionButton *btnQuestion;

@property (strong, nonatomic) ZUserInfoQuestionButton *btnFans;

@property (strong, nonatomic) ZUserInfoQuestionButton *btnAnswer;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserInfoQuestionTVC

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.cellH = [ZUserInfoQuestionTVC getH];
    
    CGFloat space = 25;
    CGFloat btnW = 80;
    CGFloat btnH = 80;
    CGFloat btnY = 5;
    
    self.btnQuestion = [[ZUserInfoQuestionButton alloc] initWithFrame:CGRectMake(space, btnY, btnW, btnH)];
    [self.btnQuestion setViewDataWithTitle:kQuestion maxCount:0 minCount:0];
    [self.btnQuestion addTarget:self action:@selector(btnQuestionClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnQuestion];
    
    self.btnFans = [[ZUserInfoQuestionButton alloc] initWithFrame:CGRectMake(self.cellW/2-btnW/2, btnY, btnW, btnH)];
    [self.btnFans setViewDataWithTitle:kFans maxCount:0 minCount:0];
    [self.btnFans addTarget:self action:@selector(btnFansClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnFans];
    
    self.btnAnswer = [[ZUserInfoQuestionButton alloc] initWithFrame:CGRectMake(self.cellW-btnW-space, btnY, btnW, btnH)];
    [self.btnAnswer setViewDataWithTitle:kWaitAnswer maxCount:0 minCount:0];
    [self.btnAnswer addTarget:self action:@selector(btnAnswerClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAnswer];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
    [self.viewMain addSubview:self.imgLine];
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

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.btnQuestion setViewDataWithTitle:kQuestion maxCount:model.myQuesCount minCount:model.myQuesNewCount];
    
    [self.btnFans setViewDataWithTitle:kFans maxCount:model.myFunsCount minCount:0];
    
    [self.btnAnswer setViewDataWithTitle:kWaitAnswer maxCount:model.myWaitAnsCount minCount:model.myWaitNewAns];
    
    return self.cellH;
}
-(void)dealloc
{
    OBJC_RELEASE(_btnFans);
    OBJC_RELEASE(_btnAnswer);
    OBJC_RELEASE(_btnQuestion);
    OBJC_RELEASE(_onFansClick);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_onQuestionClick);
    [super setViewNil];
}
+(CGFloat)getH
{
    return 90;
}

@end
