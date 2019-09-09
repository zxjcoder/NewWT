//
//  ZMyUserInfoTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyUserInfoTVC.h"

@interface ZMyUserInfoTVC()//<SWTableViewCellDelegate>

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UILabel *lbSign;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelUserBase *model;

//@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyUserInfoTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultPhoto];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSign];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgS = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, kSize15, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat lbX = self.imgPhoto.x+imgS+self.space;
    CGFloat lbW = self.cellW-lbX-self.space;
    [self.lbNickName setFrame:CGRectMake(lbX, kSize13, lbW, self.lbH)];
    
    [self.lbSign setFrame:CGRectMake(lbX, self.lbNickName.y+self.lbNickName.height+kSize5, lbW, self.lbMinH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}
//-(NSArray *)deleteButtons
//{
//    NSMutableArray *deleteUtilityButtons = [NSMutableArray array];
//    [deleteUtilityButtons sw_addUtilityButtonWithColor:DELECOLOR title:kDelete];
//    return deleteUtilityButtons;
//}
//-(NSArray *)attButtons
//{
//    NSMutableArray *attUtilityButtons = [NSMutableArray array];
//    [attUtilityButtons sw_addUtilityButtonWithColor:DELECOLOR title:kCancelAttention];
//    return attUtilityButtons;
//}
-(void)setCellDataWithModel:(ModelUserBase *)model
{
    [self setModel:model];
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.head_img];
        [self.lbNickName setText:model.nickname];
        [self.lbSign setText:model.sign];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_viewL);
//    OBJC_RELEASE(_onDeleteClick);
    OBJC_RELEASE(_model);
    [super setViewNil];
}
//-(void)setViewIsDelete:(BOOL)isDel
//{
//    [self setIsDelete:isDel];
//}
-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 70;
}
+(CGFloat)getH
{
    return 70;
}

//#pragma mark - SWTableViewCellDelegate
//
//-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
//{
//    switch (index) {
//        case 0://删除
//        {
//            if (self.onDeleteClick) {
//                self.onDeleteClick(self.model, self);
//            }
//            [cell hideUtilityButtonsAnimated:YES];
//            break;
//        }
//    }
//}
//
//- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
//{
//    return YES;
//}
//
//- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
//{
//    return self.isDelete;
//}

@end
