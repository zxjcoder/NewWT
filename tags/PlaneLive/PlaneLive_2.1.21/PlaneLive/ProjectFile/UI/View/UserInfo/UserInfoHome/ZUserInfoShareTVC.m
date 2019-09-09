//
//  ZUserInfoShareTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoShareTVC.h"
#import "ZUserInfoShareButton.h"

@interface ZUserInfoShareTVC()

///同意
@property (strong, nonatomic) ZUserInfoShareButton *btnAgree;
///分享
@property (strong, nonatomic) ZUserInfoShareButton *btnShare;
///收藏
@property (strong, nonatomic) ZUserInfoShareButton *btnCollection;

@end

@implementation ZUserInfoShareTVC

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
    
    self.cellH = [ZUserInfoShareTVC getH];
    
    CGFloat space = 15;
    CGFloat btnW = (self.cellW-space*2)/3;
    CGFloat btnH = 55;
    CGFloat btnY = 0;
    
    self.btnAgree = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(space, btnY, btnW, btnH)];
    [self.btnAgree setViewDataWithTitle:kTheAnswerIsAgreed imageName:@"mine_agreenum_icon" count:0];
    [self.viewMain addSubview:self.btnAgree];
    
    self.btnShare = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(self.cellW/2-btnW/2, btnY, btnW, btnH)];
    [self.btnShare setViewDataWithTitle:kTheAnswerIsShared imageName:@"mine_sharenum_icon" count:0];
    [self.viewMain addSubview:self.btnShare];
    
    self.btnCollection = [[ZUserInfoShareButton alloc] initWithFrame:CGRectMake(self.cellW-btnW-space, btnY, btnW, btnH)];
    [self.btnCollection setViewDataWithTitle:kTheAnswerIsCollected imageName:@"mine_collectionnum_icon" count:0];
    [self.viewMain addSubview:self.btnCollection];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.btnAgree setViewDataWithTitle:kTheAnswerIsAgreed imageName:@"mine_agreenum_icon" count:model.myAnswerAgreeCount];
    
    [self.btnShare setViewDataWithTitle:kTheAnswerIsShared imageName:@"mine_sharenum_icon" count:model.myAnswerShareCount];
    
    [self.btnCollection setViewDataWithTitle:kTheAnswerIsCollected imageName:@"mine_collectionnum_icon"  count:model.myAnswerCollectCount];
    
    return self.cellH;
}
-(void)dealloc
{
    OBJC_RELEASE(_btnAgree);
    OBJC_RELEASE(_btnShare);
    OBJC_RELEASE(_btnCollection);
    [super setViewNil];
}
+(CGFloat)getH
{
    return 55;
}

@end
