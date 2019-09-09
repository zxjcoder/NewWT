//
//  ZFoundTableView.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZFoundTableView.h"
#import "ZFoundPhotoViewTVC.h"
#import "ZFoundPracticeTypeTVC.h"

@interface ZFoundTableView()<UITableViewDelegate, UITableViewDataSource>

///用户头像
@property (strong, nonatomic) ZFoundPhotoViewTVC *tvcPhoto;
///实务分类
@property (strong, nonatomic) ZFoundPracticeTypeTVC *tvcPractice;
///数据集合
@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZFoundTableView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
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
    
    ZWEAKSELF
    self.tvcPhoto = [[ZFoundPhotoViewTVC alloc] initWithReuseIdentifier:@"tvcPhoto"];
    [self.tvcPhoto setOnPhotoClick:^{
        if (weakSelf.onUserLoginClick) {
            weakSelf.onUserLoginClick();
        }
    }];
    self.tvcPractice = [[ZFoundPracticeTypeTVC alloc] initWithReuseIdentifier:@"tvcPractice"];
    [self.tvcPractice setOnPracticeTypeClick:^(ModelPracticeType *model) {
        if (weakSelf.onPracticeTypeClick) {
            weakSelf.onPracticeTypeClick(model);
        }
    }];
    self.arrMain = @[self.tvcPhoto, self.tvcPractice];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
}

///设置用户信息
-(void)setViewDataWithModel:(ModelUser *)model
{
    [self.tvcPhoto setCellDataWithModel:model];
}
///设置实务分类数据集合
-(void)setViewDataWithArray:(NSArray *)arrResult
{
    [self.tvcPractice setCellDataWithArray:arrResult];
    
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onUserLoginClick);
    OBJC_RELEASE(_onPracticeTypeClick);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(ZBaseTVC*)[self.arrMain objectAtIndex:indexPath.row] getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrMain objectAtIndex:indexPath.row];
}

@end
