//
//  ZMyTopicTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyTopicTVC.h"

@interface ZMyTopicTVC()//<SWTableViewCellDelegate>

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbTagName;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelTag *model;

@end

@implementation ZMyTopicTVC

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
    
    self.lbTagName = [[UILabel alloc] init];
    [self.lbTagName setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTagName setTextColor:BLACKCOLOR];
    [self.lbTagName setNumberOfLines:1];
    [self.lbTagName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTagName];
    
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
    CGFloat lbY = self.cellH/2-self.lbH/2;
    [self.lbTagName setFrame:CGRectMake(lbX, lbY, lbW, self.lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithModel:(ModelTag *)model
{
    [self setModel:model];
    if (model) {
        [self.imgPhoto setPhotoURLStr:model.tagLogo];
        [self.lbTagName setText:model.tagName];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTagName);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_model);
    [super setViewNil];
}

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
