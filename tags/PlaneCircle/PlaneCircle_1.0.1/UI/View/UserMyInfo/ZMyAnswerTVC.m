//
//  ZMyAnswerTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAnswerTVC.h"

@interface ZMyAnswerTVC()<SWTableViewCellDelegate>

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbContent;

@property (strong, nonatomic) UILabel *lbCount;

@property (strong, nonatomic) UIView *viewL1;
@property (strong, nonatomic) UIView *viewL2;

@property (strong, nonatomic) ModelQuestionMyAnswer *model;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyAnswerTVC

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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR2];
    [self.lbContent setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:2];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setTextColor:MAINCOLOR];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [[self.lbCount layer] setMasksToBounds:YES];
    [self.lbCount setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.lbCount];
    
    self.viewL1 = [[UIView alloc] init];
    [self.viewL1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL1];
    
    self.viewL2 = [[UIView alloc] init];
    [self.viewL2 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewL2];
    
    [self setDelegate:self];
    [self setRightUtilityButtons:[self deleteButtons]];
}
-(NSArray *)deleteButtons
{
    NSMutableArray *deleteUtilityButtons = [NSMutableArray array];
    [deleteUtilityButtons sw_addUtilityButtonWithColor:DELECOLOR title:kDelete];
    return deleteUtilityButtons;
}

-(void)setViewFrame
{
    CGRect titleFrame = CGRectMake(self.space, 8, self.cellW-self.space*2, 0);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (titleH > self.lbH) {
        titleH=42;
    }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    [self.viewL1 setFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+5, self.cellW, self.lineH)];
    
    CGRect contentFrame = CGRectMake(self.space, self.viewL1.y+self.viewL1.height+8, self.cellW-self.space*2-30, 0);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    if (contentH > self.lbMinH) {
        contentH=40;
    }
    contentFrame.size.height = contentH;
    [self.lbContent setFrame:contentFrame];
    
    self.cellH = self.lbContent.y+self.lbContent.height+15;
    
    CGFloat countW = [self.lbCount getLabelWidthWithMinWidth:0]+15;
    CGFloat countH = 23;
    CGFloat countX = self.cellW-self.space-countW;
    [self.lbCount setFrame:CGRectMake(countX, self.viewL1.y+(self.cellH-self.viewL1.y)/2-countH/2, countW, countH)];
    
    contentFrame.size.width = countX-self.space*2;
    [self.lbContent setFrame:contentFrame];
    
    [self.viewL2 setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelQuestionMyAnswer *)model
{
    [self setModel:model];
    
    [self setViewContent];
    
    [self setViewFrame];
}

-(void)setViewContent
{
    [self.lbTitle setText:self.model.title];
    
    NSString *content = self.model.content.imgReplacing;
    NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:content];
    
    [strAttributed addAttribute:NSFontAttributeName value:self.lbContent.font range:NSMakeRange(0, strAttributed.length)];
    [strAttributed addAttribute:NSForegroundColorAttributeName value:self.lbContent.textColor range:NSMakeRange(0, strAttributed.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
    
    [self.lbContent setAttributedText:strAttributed];
    
    [self.lbCount setText:self.model.count];
}

-(CGFloat)getHWithModel:(ModelQuestionMyAnswer *)model
{
    [self setCellDataWithModel:model];
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_viewL1);
    OBJC_RELEASE(_viewL2);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_onDeleteClick);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel
{
    [self setIsDelete:isDel];
}

#pragma mark - SWTableViewCellDelegate

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0://删除
        {
            if (self.onDeleteClick) {
                self.onDeleteClick(self.model, self);
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
