//
//  ZMyQuestionTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyQuestionTVC.h"

@interface ZMyQuestionTVC()<SWTableViewCellDelegate>

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///回答内容
@property (strong, nonatomic) UILabel *lbContent;

///实体对象
@property (strong, nonatomic) ModelQuestionDetail *model;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyQuestionTVC

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
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR2];
    [self.lbContent setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:1];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self setDelegate:self];
    [self setRightUtilityButtons:[self deleteButtons]];
}
-(NSArray *)deleteButtons
{
    NSMutableArray *deleteUtilityButtons = [NSMutableArray array];
    [deleteUtilityButtons sw_addUtilityButtonWithColor:DELECOLOR title:kDelete];
    return deleteUtilityButtons;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //右边区域
    CGFloat rightX = self.space;
    CGFloat rightW = self.cellW - rightX - self.space;
    
    ///内容为空
    [self.lbContent setHidden:self.lbContent.text.length == 0];
    if (self.lbContent.text.length == 0) {
        //标题
        CGRect titleFrame = CGRectMake(rightX, self.space, rightW, self.lbH);
        [self.lbTitle setFrame:titleFrame];
        if (self.lbTitle.text.length > 0) {
            CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
            if (titleH > self.lbH) {titleH=40;}
            titleFrame.size.height = titleH;
        }
        titleFrame.origin.y = self.cellH/2-titleFrame.size.height/2;
        [self.lbTitle setFrame:titleFrame];
    } else {///内容不为空
        //标题
        CGRect titleFrame = CGRectMake(rightX, self.space, rightW, self.lbH);
        [self.lbTitle setFrame:titleFrame];
        if (self.lbTitle.text.length > 0) {
            CGRect contentFrame = CGRectMake(rightX, self.lbTitle.y+self.lbTitle.height, rightW, self.lbMinH);
            CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
            if (titleH > self.lbH) {
                titleFrame.size.height = 40;
                [self.lbTitle setFrame:titleFrame];
                contentFrame.origin.y = self.lbTitle.y+self.lbTitle.height+3;
            } else {
                titleFrame.origin.y = self.space+5;
                [self.lbTitle setFrame:titleFrame];
                contentFrame.origin.y = self.lbTitle.y+self.lbTitle.height+10;
            }
            //内容
            [self.lbContent setFrame:contentFrame];
        } else {
            //内容
            [self.lbContent setFrame:CGRectMake(rightX, self.cellH/2-self.lbMinH/2, rightW, self.lbMinH)];
        }
    }
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(void)imgPhotoTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onImagePhotoClick) {
            self.onImagePhotoClick(self.model);
        }
    }
}

-(void)setCellDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    if (model) {
        [self.lbTitle setText:model.title];
        [self.lbContent setText:model.qContent];
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_onDeleteClick);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_onImagePhotoClick);
    OBJC_RELEASE(_viewLine);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self setIsDelete:isDel];
}
-(CGFloat)getH
{
    return 85;
}
+(CGFloat)getH
{
    return 85;
}

#pragma mark - SWTableViewCellDelegate

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0://删除
        {
            if (self.onDeleteClick) {
                self.onDeleteClick(self.model,self);
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
