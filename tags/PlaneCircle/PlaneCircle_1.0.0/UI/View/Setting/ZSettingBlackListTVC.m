//
//  ZSettingBlackListTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSettingBlackListTVC.h"

@interface ZSettingBlackListTVC()<SWTableViewCellDelegate>

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelUserBase *modelUser;

@end

@implementation ZSettingBlackListTVC

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
    
    [self setDelegate:self];
    [self setRightUtilityButtons:[self deleteButtons]];
    
    self.imgPhoto = [[ZImageView alloc] initWithImage:[SkinManager getDefaultPhoto]];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbNickName];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
    
    CGFloat lbX = self.imgPhoto.x+self.imgPhoto.width+self.space;
    CGFloat lbW = self.cellW-lbX-self.space;
    [self.lbNickName setFrame:CGRectMake(lbX, self.cellH/2-self.lbH/2, lbW, self.lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithModel:(ModelUserBase *)model
{
    [self setModelUser:model];
    
    [self.imgPhoto setPhotoURLStr:model.head_img];
    [self.lbNickName setText:model.nickname];
}

-(NSArray *)deleteButtons
{
    NSMutableArray *deleteUtilityButtons = [NSMutableArray array];
    
    [deleteUtilityButtons sw_addUtilityButtonWithColor:ORANGECOLOR title:@"删除"];
    
    return deleteUtilityButtons;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_modelUser);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 60;
}
+(CGFloat)getH
{
    return 60;
}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case kCellStateCenter:
        case kCellStateLeft:
        case kCellStateRight:
        {
            [cell setAccessoryType:(UITableViewCellAccessoryNone)];
            [cell setNeedsDisplay];
            break;
        }
    }
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0://移除黑名单
        {
            if (self.onRemoveClick) {
                self.onRemoveClick(self.modelUser, self.tag);
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
    return YES;
}

@end
