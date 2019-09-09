//
//  ZAnswerDetailTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailTableView.h"
#import "ZAnswerDetailCommentTVC.h"
#import "ZAnswerDetailCommentView.h"
#import "ZAnswerDetailContentTVC.h"
#import "ZAnswerDetailUserTVC.h"
#import "ZAnswerDetailQuestionTVC.h"
#import "ZAnswerDetailUserView.h"

@interface ZAnswerDetailTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///问题标题
@property (strong, nonatomic) ZAnswerDetailQuestionTVC *tvcQuestion;
///问题
@property (strong, nonatomic) ZView *viewQuestion;
///回答者基本信息
//@property (strong, nonatomic) ZAnswerDetailUserTVC *tvcUser;
///回答者基本信息
@property (strong, nonatomic) ZAnswerDetailUserView *viewUser;
///回答内容
@property (strong, nonatomic) ZAnswerDetailContentTVC *tvcContent;
///评论顶部
@property (strong, nonatomic) ZAnswerDetailCommentView *viewCommentHeader;
///用于计算高度
@property (strong, nonatomic) ZAnswerDetailCommentTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) NSMutableDictionary *dicDefaultH;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@property (strong, nonatomic) ModelAnswerComment *modelDefaultComment;

@end

@implementation ZAnswerDetailTableView

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

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.arrMain = [NSMutableArray array];
    self.dicDefaultH = [NSMutableDictionary dictionary];
    
    self.tvcItem = [[ZAnswerDetailCommentTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    self.tvcQuestion = [[ZAnswerDetailQuestionTVC alloc] initWithReuseIdentifier:@"tvcQuestion"];
    
    self.viewQuestion = [[ZView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 0.01)];
    
    ZWEAKSELF
    self.viewUser = [[ZAnswerDetailUserView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZAnswerDetailUserView getH])];
    [self.viewUser setOnAgreeClick:^(ModelAnswerBase *model) {
        if (weakSelf.onAgreeClick) {
            weakSelf.onAgreeClick(model);
        }
    }];
    [self.viewUser setOnImagePhotoClick:^(ModelAnswerBase *model) {
        if (weakSelf.onImagePhotoClick) {
            weakSelf.onImagePhotoClick(model);
        }
    }];
    
    self.tvcContent = [[ZAnswerDetailContentTVC alloc] initWithReuseIdentifier:@"tvcContent"];
    [self.tvcContent setOnImageClick:^(UIImage *image, NSURL *imageUrl, NSInteger currentIndex, NSArray *arrImageUrl, CGSize size) {
        if (weakSelf.onImageClick) {
            weakSelf.onImageClick(image, imageUrl, currentIndex, arrImageUrl, size);
        }
    }];
    self.viewCommentHeader = [[ZAnswerDetailCommentView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 35)];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setSectionFooterHeight:0.01];
    [self setTableFooterView:nil];
    
    [self.tvcContent setOnRefreshTVC:^{
        dispatch_async(dispatch_get_main_queue(), ^ {
            [weakSelf reloadData];
        });
    }];
    
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    [self.tvcQuestion setCellDataWithModel:model];
    [self.viewUser setCellDataWithModel:model];
    [self.tvcContent setCellDataWithModel:model];
    [self.viewCommentHeader setViewDataWithModel:model];
}
///设置答案评论数据源
-(void)setViewDataWithCommentModel:(ModelAnswerComment *)model
{
    model.status = 1;
    [self setModelDefaultComment:model];
}
///添加一个新的评论对象
-(void)addViewAnswerComment:(ModelAnswerComment *)model
{
    self.modelAB.commentCount += 1;
    [self.viewCommentHeader setViewDataWithModel:self.modelAB];
    [self.arrMain insertObject:model atIndex:0];
    
    [self reloadData];
}
///删除一个自己的评论对象
-(void)deleteViewAnswerComment:(ModelAnswerComment *)model
{
    self.modelAB.commentCount -= 1;
    if (self.modelAB.commentCount < 0) {
        self.modelAB.commentCount = 0;
    }
    [self.viewCommentHeader setViewDataWithModel:self.modelAB];
    NSInteger row = 0;
    for (ModelAnswerComment *modelAC in self.arrMain) {
        if ([modelAC.ids isEqualToString:model.ids]) {
            [self.arrMain removeObjectAtIndex:row];
            break;
        }
        row++;
    }
    [self reloadData];
}
///添加一个新的回复对象
-(void)addViewCommentReply:(ModelCommentReply *)model
{
    NSMutableArray *arr = [NSMutableArray array];
    for (ModelAnswerComment *modelAC in self.arrMain) {
        if ([modelAC.ids isEqualToString:model.commentId]) {
            if (modelAC.arrReply.count > 0) {
                NSMutableArray *arrReply = [NSMutableArray arrayWithArray:modelAC.arrReply];
                [arrReply insertObject:model atIndex:0];
                modelAC.arrReply = [NSArray arrayWithArray:arrReply];
            } else {
                modelAC.arrReply = [NSArray arrayWithObject:model];
            }
        }
        [arr addObject:modelAC];;
    }
    [self.arrMain removeAllObjects];
    [self.arrMain addObjectsFromArray:arr];
    [self reloadData];
}
///删除一个自己回复的对象
-(void)deleteViewCommentReply:(ModelCommentReply *)model
{
    NSMutableArray *arr = [NSMutableArray array];
    for (ModelAnswerComment *modelAC in self.arrMain) {
        ///删除的那个评论
        if ([modelAC.ids isEqualToString:model.commentId]) {
            if (modelAC.arrReply && [modelAC.arrReply isKindOfClass:[NSArray class]] &&modelAC.arrReply.count > 0) {
                NSMutableArray *arrReply = [NSMutableArray arrayWithArray:modelAC.arrReply];
                NSInteger row = 0;
                for (ModelCommentReply *modelCR in modelAC.arrReply) {
                    if ([modelCR.ids isEqualToString:model.ids]) {
                        [arrReply removeObjectAtIndex:row];
                        break;
                    }
                    row++;
                }
                modelAC.arrReply = [NSArray arrayWithArray:arrReply];
            }
        }
        [arr addObject:modelAC];;
    }
    [self.arrMain removeAllObjects];
    [self.arrMain addObjectsFromArray:arr];
    [self reloadData];
}
///指定滑动到某个CELL
-(void)setViewScrollToRowAtRow:(NSInteger)row
{
    if (row < 0) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
    } else {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:2] atScrollPosition:(UITableViewScrollPositionBottom) animated:NO];
    }
}
///设置数据集合
-(void)setViewDataWithCommentArray:(NSArray *)arrComment modelAnswer:(ModelAnswerBase *)modelAnswer modelDefaultComment:(ModelAnswerComment *)modelDefaultComment isHeader:(BOOL)isHeader
{
    [self setViewDataWithCommentArray:arrComment modelAnswer:modelAnswer modelDefaultComment:modelDefaultComment isHeader:isHeader isScrollToRow:YES];
}
///设置数据集合
-(void)setViewDataWithCommentArray:(NSArray *)arrComment modelAnswer:(ModelAnswerBase *)modelAnswer modelDefaultComment:(ModelAnswerComment *)modelDefaultComment isHeader:(BOOL)isHeader  isScrollToRow:(BOOL)isScrollToRow
{
    @synchronized (self) {
        if (modelAnswer) {
            [self setViewDataWithModel:modelAnswer];
        }
        BOOL isInsertFirst = NO;
        NSInteger defaultRow = 0;
        if (isHeader) {
            [self.dicDefaultH removeAllObjects];
            [self.arrMain removeAllObjects];
            if (modelDefaultComment) {
                modelDefaultComment.status = 1;
                [self setModelDefaultComment:modelDefaultComment];
                int row = 0;
                for (ModelAnswerComment *modelAC in arrComment) {
                    if ([modelAC.ids isEqualToString:modelDefaultComment.ids]) {
                        modelAC.status = 1;
                        isInsertFirst = NO;
                        defaultRow = row;
                        break;
                    }
                    row++;
                    isInsertFirst = YES;
                }
            }
        }
        if (isInsertFirst) {
            [self.arrMain addObject:modelDefaultComment];
        }
        [self.arrMain addObjectsFromArray:arrComment];
        
        __weak typeof(self) weakSelf = self;
        if (arrComment.count >= kPAGE_MAXCOUNT) {
            [self addRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self removeRefreshFooter];
        }
        [self reloadData];
        
        if (isScrollToRow && modelDefaultComment && modelDefaultComment.ids.length > 0) {
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:defaultRow inSection:2] atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
        }
    }
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_modelAB);
    OBJC_RELEASE(_dicDefaultH);
    OBJC_RELEASE(_viewCommentHeader);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_viewUser);
    OBJC_RELEASE(_viewQuestion);
    OBJC_RELEASE(_tvcContent);
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.arrMain.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.viewQuestion.height;
            break;
        case 1:
            return self.viewUser.height;
        default:
            break;
    }
    return self.viewCommentHeader.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.viewQuestion;
            break;
        case 1:
            return self.viewUser;
        default:
            break;
    }
    return self.viewCommentHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return self.tvcQuestion.getH;
            break;
        case 1:
            return self.tvcContent.getH;
            break;
        default:
            break;
    }
    ModelAnswerComment *model = [self.arrMain objectAtIndex:indexPath.row];
    NSDictionary *dicValue = [self.dicDefaultH objectForKey:[NSString stringWithFormat:@"key%@",model.ids]];
    if (dicValue && [dicValue isKindOfClass:[NSDictionary class]]) {
        BOOL isCommentDefaultH = [[dicValue objectForKey:@"comment"] boolValue];
        BOOL isReplyDefaultH = [[dicValue objectForKey:@"reply"] boolValue];
        [self.tvcItem setCellIsCommentDefaultH:isCommentDefaultH];
        [self.tvcItem setCellIsReplyDefaultH:isReplyDefaultH];
    } else {
        [self.tvcItem setCellIsCommentDefaultH:YES];
        [self.tvcItem setCellIsReplyDefaultH:YES];
    }
    CGFloat row = [self.tvcItem getHWithModel:model];
    return row;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return self.tvcQuestion;
            break;
        case 1:
            return self.tvcContent;
            break;
        default:
            break;
    }
    static NSString *cellid = @"tvcellid";
    ZAnswerDetailCommentTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZAnswerDetailCommentTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    ModelAnswerComment *model = [self.arrMain objectAtIndex:indexPath.row];
    NSDictionary *dicValue = [self.dicDefaultH objectForKey:[NSString stringWithFormat:@"key%@",model.ids]];
    if (dicValue && [dicValue isKindOfClass:[NSDictionary class]]) {
        BOOL isCommentDefaultH = [[dicValue objectForKey:@"comment"] boolValue];
        BOOL isReplyDefaultH = [[dicValue objectForKey:@"reply"] boolValue];
        [cell setCellIsCommentDefaultH:isCommentDefaultH];
        [cell setCellIsReplyDefaultH:isReplyDefaultH];
    } else {
        [cell setCellIsCommentDefaultH:YES];
        [cell setCellIsReplyDefaultH:YES];
    }
    [cell setCellDataWithModel:model];
    __weak typeof(self) weakSelf = self;
    [cell setOnUserClick:^(ModelUserBase *model) {
        if (weakSelf.onCommentPhotoClick) {
            weakSelf.onCommentPhotoClick(model);
        }
    }];
    [cell setOnReplyClick:^(ModelCommentReply *model, NSInteger row) {
        if (weakSelf.onReplyClick) {
            weakSelf.onReplyClick(model, row);
        }
    }];
    [cell setOnCommentClick:^(ModelAnswerComment *model, NSInteger row) {
        if (weakSelf.onCommentClick) {
            weakSelf.onCommentClick(model, row);
        }
    }];
    [cell setOnRowHeightChange:^(ModelAnswerComment *model, BOOL isCommentDefaultH, BOOL isReplyDefaultH) {
        NSDictionary *dicValue = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithBool:isCommentDefaultH],[NSNumber numberWithBool:isReplyDefaultH]] forKeys:@[@"comment",@"reply"]];
        [weakSelf.dicDefaultH setObject:dicValue forKey:[NSString stringWithFormat:@"key%@",model.ids]];
        GCDMainBlock(^{
            [weakSelf reloadData];
        })
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.onQuestionClick) {
                    self.onQuestionClick(self.modelAB);
                }
                break;
            }
            default: break;
        }
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onOffsetChange) {
        self.onOffsetChange(scrollView.contentOffset.y);
    }
}

@end
