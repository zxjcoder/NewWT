//
//  ZPracticePayInfoTableView.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticePayInfoTableView.h"
#import "ZPracticePayInfoTVC.h"
#import "ZPracticePayItemTVC.h"

@interface ZPracticePayInfoTableView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZPracticePayInfoTVC *tvInfo;
@property (strong, nonatomic) ZPracticePayItemTVC *tvSpeaker;
@property (strong, nonatomic) ZPracticePayItemTVC *tvPractice;

@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZPracticePayInfoTableView

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
    
    self.tvInfo = [[ZPracticePayInfoTVC alloc] initWithReuseIdentifier:@"tvInfo"];
    self.tvSpeaker = [[ZPracticePayItemTVC alloc] initWithReuseIdentifier:@"tvSpeaker" type:(ZPracticePayItemTVCTypeSpeaker)];
    self.tvPractice = [[ZPracticePayItemTVC alloc] initWithReuseIdentifier:@"tvPractice" type:(ZPracticePayItemTVCTypePractice)];
    
    self.arrayMain = @[self.tvInfo,
                       self.tvSpeaker,
                       self.tvPractice];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    [self setViewDataWithModel:nil];
    
    ZWEAKSELF
    [self setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self.tvInfo setCellDataWithModel:model];
    [self.tvSpeaker setCellDataWithModel:model];
    [self.tvPractice setCellDataWithModel:model];
    
    [self reloadData];
}

-(void)dealloc
{
    OBJC_RELEASE(_tvInfo);
    OBJC_RELEASE(_tvSpeaker);
    OBJC_RELEASE(_tvPractice);
    OBJC_RELEASE(_arrayMain);
    self.dataSource = nil;
    self.delegate = nil;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.arrayMain objectAtIndex:indexPath.row] getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrayMain objectAtIndex:indexPath.row];
}

@end
