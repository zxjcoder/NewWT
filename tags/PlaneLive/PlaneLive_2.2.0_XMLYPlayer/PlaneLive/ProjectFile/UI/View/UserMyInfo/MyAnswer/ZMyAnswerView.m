//
//  ZMyAnswerView.m
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAnswerView.h"
#import "ClassCategory.h"

#import "ZMyAnswerTableView.h"

@interface ZMyAnswerView()

@property (strong, nonatomic) ZMyAnswerTableView *tvAnswer;

@end

@implementation ZMyAnswerView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

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
    ZWEAKSELF
    self.tvAnswer = [[ZMyAnswerTableView alloc] initWithFrame:self.bounds];
    [self.tvAnswer setOnQuestionClick:^(ModelQuestionBase *model) {
        if (weakSelf.onQuestionRowClick) {
            weakSelf.onQuestionRowClick(model);
        }
    }];
    [self.tvAnswer setOnAnswerClick:^(ModelAnswerBase *model) {
        if (weakSelf.onAnswerRowClick) {
            weakSelf.onAnswerRowClick(model);
        }
    }];
    [self.tvAnswer setOnImagePhotoClick:^(ModelUserBase *model) {
        if (weakSelf.onImagePhotoClick) {
            weakSelf.onImagePhotoClick(model);
        }
    }];
    [self.tvAnswer setOnDeleteClick:^(ModelQuestionMyAnswer *model) {
        if (weakSelf.onDeleteAnswerClick) {
            weakSelf.onDeleteAnswerClick(model);
        }
    }];
    [self.tvAnswer setOnRefreshHeader:^{
        if (weakSelf.onRefreshAnswerHeader) {
            weakSelf.onRefreshAnswerHeader();
        }
    }];
    [self.tvAnswer setOnRefreshFooter:^{
        if (weakSelf.onRefreshAnswerFooter) {
            weakSelf.onRefreshAnswerFooter();
        }
    }];
    [self.tvAnswer setOnPageNumChange:^(int pageNum) {
        if (weakSelf.onAnswerPageNumChange) {
            weakSelf.onAnswerPageNumChange(pageNum);
        }
    }];
    [self.tvAnswer setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundAnswerClick) {
            weakSelf.onBackgroundAnswerClick(state);
        }
    }];
    [self addSubview:self.tvAnswer];
}
-(void)dealloc
{
    OBJC_RELEASE(_tvAnswer);
    
    OBJC_RELEASE(_onAnswerRowClick);
    OBJC_RELEASE(_onDeleteAnswerClick);
    OBJC_RELEASE(_onRefreshAnswerFooter);
    OBJC_RELEASE(_onRefreshAnswerHeader);
    
}

-(void)setViewIsDelete:(BOOL)isDel
{
    [self.tvAnswer setViewIsDelete:isDel];
}
-(void)setViewAnswerWithDictionary:(NSDictionary *)dic
{
    [self.tvAnswer setViewDataWithDictionary:dic];
}
-(void)setAnswerBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvAnswer setBackgroundViewWithState:backState];
}
-(void)endRefreshAnswerHeader
{
    [self.tvAnswer endRefreshHeader];
}
-(void)endRefreshAnswerFooter
{
    [self.tvAnswer endRefreshFooter];
}

@end
