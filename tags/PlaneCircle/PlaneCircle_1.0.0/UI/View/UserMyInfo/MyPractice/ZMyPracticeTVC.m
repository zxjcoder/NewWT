//
//  ZMyPracticeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyPracticeTVC.h"

@interface ZMyPracticeTVC()<SWTableViewCellDelegate>

@property (strong, nonatomic) ZImageView *imgLogo;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelCollection *model;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyPracticeTVC

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
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewMain addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
    
    [self setDelegate:self];
    [self setRightUtilityButtons:[self deleteButtons]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgS = 50;
    [self.imgLogo setFrame:CGRectMake(self.space, self.space, imgS, imgS)];
    [self.imgLogo setViewRound];
    
    CGFloat lbX = self.imgLogo.x+imgS+self.space;
    CGFloat lbW = self.cellW-lbX-self.space;
    [self.lbTitle setFrame:CGRectMake(lbX, self.cellH/2-self.lbH/2, lbW, self.lbH)];
    CGFloat lbH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (lbH > self.lbH) {
        lbH = 40;
    }
    [self.lbTitle setFrame:CGRectMake(lbX, self.cellH/2-lbH/2, lbW, lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}
-(NSArray *)deleteButtons
{
    NSMutableArray *deleteUtilityButtons = [NSMutableArray array];
    [deleteUtilityButtons sw_addUtilityButtonWithColor:DELECOLOR title:@"取消收藏"];
    return deleteUtilityButtons;
}
-(void)setCellDataWithModel:(ModelCollection *)model
{
    [self setModel:model];
    if (model) {
        [self.lbTitle setText:model.title];
        [self.imgLogo setImageURLStr:model.img placeImage:[SkinManager getImageWithName:@"mymark_icon_book"]];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_onDeleteClick);
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

#pragma mark - SWTableViewCellDelegate

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0://删除
        {
            if (self.onDeleteClick) {
                self.onDeleteClick(self.model, self.tag);
            }
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    return self.isDelete;
}

@end
