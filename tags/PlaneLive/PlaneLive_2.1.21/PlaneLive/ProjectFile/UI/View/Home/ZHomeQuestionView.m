//
//  ZHomeQuestionView.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeQuestionView.h"
#import "ZHomeItemNavView.h"
#import "CCPScrollView.h"

@interface ZHomeQuestionView()

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) ZImageView *imgIcon;

@property (strong, nonatomic) CCPScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) NSArray *arrQuestion;

@end

@implementation ZHomeQuestionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.width, kZHomeItemNavViewHeight) title:kBoutiqueQuestionsAndAnswers];
    [self.viewHeader setAllButtonHidden];
    [self addSubview:self.viewHeader];
    
    CGFloat imgY = self.viewHeader.y+self.viewHeader.height+kSize5;
    CGFloat imgSize = 45;
    self.imgIcon = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"home_question"]];
    [self.imgIcon setFrame:CGRectMake(kSizeSpace, imgY, imgSize, imgSize)];
    [self addSubview:self.imgIcon];
    
    CGFloat svY = self.viewHeader.y+self.viewHeader.height+kSize5;
    CGFloat svX = self.imgIcon.x+self.imgIcon.width+kSize10;
    CGFloat svWidth = self.width-svX-kSize10;
    CGFloat svHeight = self.height-svY-kSize10-kLineMaxHeight;
    self.scrollView = [[CCPScrollView alloc] initWithFrame:CGRectMake(svX, svY, svWidth, svHeight)];
    self.scrollView.titleFont = kFont_Middle_Size;
    self.scrollView.titleColor = BLACKCOLOR1;
    self.scrollView.BGColor = WHITECOLOR;
    self.scrollView.isCanScroll = NO;
    ZWEAKSELF
    [self.scrollView clickTitleLabel:^(NSInteger index) {
        if (weakSelf.onQuestionClick) {
            if (weakSelf.arrQuestion.count > index) {
                weakSelf.onQuestionClick([weakSelf.arrQuestion objectAtIndex:index]);
            } else {
                weakSelf.onQuestionClick(nil);
            }
        }
    }];
    [self addSubview:self.scrollView];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.height-kLineMaxHeight, self.width, kLineMaxHeight)];
    [self addSubview:self.imgLine];
}

-(void)dealloc
{
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_imgIcon);
    [_scrollView removeTimer];
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_arrQuestion)
    OBJC_RELEASE(_imgLine);
}

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array
{
    [self setArrQuestion:array];
    
    NSMutableArray *arrTitle = [NSMutableArray array];
    for (ModelQuestionBoutique *modelQB in array) {
        [arrTitle addObject:modelQB.title];
    }
    self.scrollView.titleArray = [NSArray arrayWithArray:arrTitle];
}

///从新开始动画
-(void)setAnimateQuestion
{
    if (self.arrQuestion && self.arrQuestion.count > 0) {
        NSMutableArray *arrTitle = [NSMutableArray array];
        for (ModelQuestionBoutique *modelQB in self.arrQuestion) {
            [arrTitle addObject:modelQB.title];
        }
        self.scrollView.titleArray = [NSArray arrayWithArray:arrTitle];
    }
}

@end
