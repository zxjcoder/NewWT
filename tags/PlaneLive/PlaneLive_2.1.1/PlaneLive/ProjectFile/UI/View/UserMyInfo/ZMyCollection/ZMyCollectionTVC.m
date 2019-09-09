//
//  ZMyCollectionTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionTVC.h"

@interface ZMyCollectionTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbName;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelCollection *model;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyCollectionTVC

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
    [self.imgPhoto setImageName:@"mymark_icon_human"];
//    [self.imgPhoto setViewRound:3 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbName = [[UILabel alloc] init];
    [self.lbName setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbName setTextColor:BLACKCOLOR1];
    [self.lbName setNumberOfLines:2];
    [self.lbName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbName];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
    
//    [self setDelegate:self];
//    [self setRightUtilityButtons:[self deleteButtons]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgS = 50;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat lbX = self.imgPhoto.x+imgS+self.space;
    CGFloat lbW = self.cellW-lbX-self.space;
    [self.lbName setFrame:CGRectMake(lbX, self.cellH/2-self.lbH/2, lbW, self.lbH)];
    CGFloat lbH = [self.lbName getLabelHeightWithMinHeight:self.lbH];
    if (lbH > self.lbH) {
        lbH = 40;
    }
    [self.lbName setFrame:CGRectMake(lbX, self.cellH/2-lbH/2, lbW, lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}
//-(NSArray *)deleteButtons
//{
//    NSMutableArray *deleteUtilityButtons = [NSMutableArray array];
//    [deleteUtilityButtons sw_addUtilityButtonWithColor:DELECOLOR title:@"取消收藏"];
//    return deleteUtilityButtons;
//}
-(CGFloat)setCellDataWithModel:(ModelCollection *)model
{
    [self setModel:model];
    if (model) {
        [self.lbName setText:model.title];
        switch ([model.type integerValue]) {
            case 0:
                [self.lbName setText:@"律师事务所业绩清单"];
                [self.imgPhoto setImageURLStr:model.img placeImage:[SkinManager getImageWithName:@"mymark_icon_rank"]];
                break;
            case 1:
                [self.lbName setText:@"会计事务所业绩清单"];
                [self.imgPhoto setImageURLStr:model.img placeImage:[SkinManager getImageWithName:@"mymark_icon_rank"]];
                break;
            case 2:
                [self.lbName setText:@"证券公司业绩清单"];
                [self.imgPhoto setImageURLStr:model.img placeImage:[SkinManager getImageWithName:@"mymark_icon_rank"]];
                break;
            case 3:
                [self.imgPhoto setImageURLStr:model.img placeImage:[SkinManager getImageWithName:@"mymark_icon_book"]];
                break;
            case 4:
                [self.imgPhoto setPhotoURLStr:model.img placeImage:[SkinManager getImageWithName:@"mymark_icon_human"]];
                break;
            case 5:
                [self.imgPhoto setImageURLStr:model.img placeImage:[SkinManager getImageWithName:@"mymark_icon_organization"]];
                break;
            default: break;
        }
    }
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbName);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_model);
    [super setViewNil];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self setIsDelete:isDel];
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
//                self.onDeleteClick(self.model, self.tag);
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
