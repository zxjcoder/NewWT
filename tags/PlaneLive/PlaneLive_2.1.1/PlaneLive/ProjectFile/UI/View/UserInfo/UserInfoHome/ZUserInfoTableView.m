//
//  ZUserInfoTableView.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoTableView.h"
#import "ZUserInfoImageTVC.h"
#import "ZUserInfoQuestionTVC.h"
#import "ZUserInfoShareTVC.h"
#import "ZUserInfoCenterTVC.h"
#import "ZUserInfoShopTVC.h"

@interface ZUserInfoTableView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZUserInfoImageTVC *tvcImage;

@property (strong, nonatomic) ZUserInfoQuestionTVC *tvcQuestion;

@property (strong, nonatomic) ZUserInfoCenterTVC *tvcCenter;

@property (strong, nonatomic) ZUserInfoShopTVC *tvcShopChat;

@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZUserInfoTableView

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
    [super innerInit];
    
    ZWEAKSELF
    self.tvcImage = [[ZUserInfoImageTVC alloc] initWithReuseIdentifier:@"tvcImage"];
    [self.tvcImage setOnUserPhotoClick:^{
        if (weakSelf.onUserPhotoClick) {
            weakSelf.onUserPhotoClick();
        }
    }];
    self.tvcQuestion = [[ZUserInfoQuestionTVC alloc] initWithReuseIdentifier:@"tvcQuestion"];
    [self.tvcQuestion setOnQuestionClick:^{
        if (weakSelf.onQuestionClick) {
            weakSelf.onQuestionClick();
        }
    }];
    [self.tvcQuestion setOnAnswerClick:^{
        if (weakSelf.onAnswerClick) {
            weakSelf.onAnswerClick();
        }
    }];
    [self.tvcQuestion setOnFansClick:^{
        if (weakSelf.onFansClick) {
            weakSelf.onFansClick();
        }
    }];
    self.tvcCenter = [[ZUserInfoCenterTVC alloc] initWithReuseIdentifier:@"tvcCenter"];
    [self.tvcCenter setOnUserInfoCenterItemClick:^(ZUserInfoCenterItemType type) {
        if (weakSelf.onUserInfoCenterItemClick) {
            weakSelf.onUserInfoCenterItemClick(type);
        }
    }];
    self.tvcShopChat = [[ZUserInfoShopTVC alloc] initWithReuseIdentifier:@"tvcShopChat"];
    [self.tvcShopChat setOnUserInfoShoppingCartItemClick:^(ZUserInfoCenterItemType type) {
        if (weakSelf.onUserInfoCenterItemClick) {
            weakSelf.onUserInfoCenterItemClick(type);
        }
    }];
    
    [self setDataSource:self];
    [self setDelegate:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
}
///设置是否审核状态
-(void)setIsAuditStatus:(BOOL)status
{
    [self.tvcCenter setIsAuditStatus:status];
}
-(void)setViewDataWithModel:(ModelUser *)model
{
    if (model) {
        self.arrayMain = @[self.tvcImage, self.tvcQuestion , self.tvcShopChat, self.tvcCenter];
     
        [self.tvcImage setCellDataWithModel:model];
        
        [self.tvcQuestion setCellDataWithModel:model];
        
        [self.tvcCenter setCellDataWithModel:model];
        
        [self.tvcShopChat setCellDataWithModel:model];
    } else {
        self.arrayMain = nil;
        [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    }
    
    [self reloadData];
}

-(void)dealloc
{
    OBJC_RELEASE(_tvcImage);
    OBJC_RELEASE(_tvcCenter);
    OBJC_RELEASE(_tvcQuestion);
    OBJC_RELEASE(_arrayMain);
    self.dataSource = nil;
    self.delegate = nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(ZBaseTVC*)[self.arrayMain objectAtIndex:indexPath.row] getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrayMain objectAtIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat imageH = self.tvcImage.getH;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.onContentOffsetY) {
        CGFloat alpha = offsetY / 124;
        if (alpha > 1) { alpha = 1; }
        else if (alpha < 0) { alpha = 0; }
        self.onContentOffsetY(alpha);
    }
    CGFloat imageW = self.tvcImage.getW;
    if (offsetY < 0) {
        CGRect imageFrame = self.tvcImage.getViewImageFrame;
        imageFrame.origin.y = offsetY;
        imageFrame.origin.x = offsetY;
        imageFrame.size.width = imageW - (offsetY*2);
        imageFrame.size.height = imageH - offsetY;
        [self.tvcImage setViewImageFrame:imageFrame];
    } else {
        CGRect imageFrame = self.tvcImage.getViewImageFrame;
        imageFrame.origin.y = 0;
        imageFrame.origin.x = 0;
        imageFrame.size.width = imageW;
        imageFrame.size.height = imageH;
        [self.tvcImage setViewImageFrame:imageFrame];
    }
}

@end
