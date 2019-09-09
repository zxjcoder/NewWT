//
//  ZMyCommentReplyView.m
//  PlaneCircle
//
//  Created by Daniel on 8/30/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCommentReplyView.h"
#import "ClassCategory.h"

#import "ZMyCommentReplyTableView.h"

@interface ZMyCommentReplyView()

@property (strong, nonatomic) ZMyCommentReplyTableView *tvComment;

@end

@implementation ZMyCommentReplyView

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
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    
    __weak typeof(self) weakSelf = self;
    self.tvComment = [[ZMyCommentReplyTableView alloc] init];
    [self.tvComment setOnCommentClick:^(ModelAnswerBase *model, ModelAnswerComment *modelAC) {
        if (weakSelf.onCommentRowClick) {
            weakSelf.onCommentRowClick(model, modelAC);
        }
    }];
    [self.tvComment setOnAnswerClick:^(ModelAnswerBase *model) {
        if (weakSelf.onAnswerRowClick) {
            weakSelf.onAnswerRowClick(model);
        }
    }];
    [self.tvComment setOnRefreshHeader:^{
        if (weakSelf.onRefreshCommentHeader) {
            weakSelf.onRefreshCommentHeader();
        }
    }];
    [self.tvComment setOnRefreshFooter:^{
        if (weakSelf.onRefreshCommentFooter) {
            weakSelf.onRefreshCommentFooter();
        }
    }];
    [self.tvComment setOnBackgroundClick:^(ZBackgroundState state) {
        if (weakSelf.onBackgroundCommentClick) {
            weakSelf.onBackgroundCommentClick(state);
        }
    }];
    [self.tvComment setOnUserInfoClick:^(ModelUserBase *model) {
        if (weakSelf.onUserInfoClick) {
            weakSelf.onUserInfoClick(model);
        }
    }];
    [self addSubview:self.tvComment];
}
-(void)dealloc
{
    OBJC_RELEASE(_tvComment);
    
    OBJC_RELEASE(_onAnswerRowClick);
    
    OBJC_RELEASE(_onCommentRowClick);
    OBJC_RELEASE(_onUserInfoClick);
    
    OBJC_RELEASE(_onRefreshCommentFooter);
    OBJC_RELEASE(_onRefreshCommentHeader);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tvComment setFrame:self.bounds];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self.tvComment setViewIsDelete:isDel];
}

-(void)setViewCommentWithDictionary:(NSDictionary *)dic
{
    [self.tvComment setViewDataWithDictionary:dic];
}
-(void)setCommentBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.tvComment setBackgroundViewWithState:backState];
}

-(void)endRefreshCommentHeader
{
    [self.tvComment endRefreshHeader];
}
-(void)endRefreshCommentFooter
{
    [self.tvComment endRefreshFooter];
}

@end
