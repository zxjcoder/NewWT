//
//  ZFoundCardView.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/10.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZFoundCardView.h"

@interface ZFoundCardView()

@property (strong, nonatomic) UIView *viewContent;
@property (strong, nonatomic) ZImageView *imgType;
@property (strong, nonatomic) UIImageView *imgLine;
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UILabel *lbPractice1;
@property (strong, nonatomic) UILabel *lbPractice2;
@property (strong, nonatomic) UIButton *btnPlay;
@property (strong, nonatomic) ModelPracticeType *model;

@end

@implementation ZFoundCardView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
        [self setViewChangeFrame:frame];
    }
    return self;
}
-(void)innerInit
{
    [self setViewRound:kVIEW_ROUND_SIZE borderWidth:1 borderColor:RGBCOLOR(225, 225, 225)];
    
    self.viewContent = [[UIView alloc] initWithFrame:self.bounds];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setUserInteractionEnabled:YES];
    [self addSubview:self.viewContent];
    
    self.imgType = [[ZImageView alloc] initWithImage:[SkinManager getDefaultImage]];
    [self.imgType setUserInteractionEnabled:NO];
    [self.viewContent addSubview:self.imgType];
    
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setUserInteractionEnabled:NO];
    [self.viewContent addSubview:self.imgLine];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbPractice1 = [[UILabel alloc] init];
    [self.lbPractice1 setTextColor:DESCCOLOR];
    [self.lbPractice1 setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbPractice1 setNumberOfLines:1];
    [self.lbPractice1 setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbPractice1 setTextAlignment:(NSTextAlignmentLeft)];
    [self.viewContent addSubview:self.lbPractice1];
    
    self.lbPractice2 = [[UILabel alloc] init];
    [self.lbPractice2 setTextColor:DESCCOLOR];
    [self.lbPractice2 setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbPractice2 setNumberOfLines:1];
    [self.lbPractice2 setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbPractice2 setTextAlignment:(NSTextAlignmentLeft)];
    [self.viewContent addSubview:self.lbPractice2];
    
    self.btnPlay = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPlay setTitle:kPlay forState:(UIControlStateNormal)];
    [self.btnPlay setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnPlay setViewRound:15 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnPlay titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnPlay addTarget:self action:@selector(btnPlayClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnPlay];
}
-(void)btnPlayClick
{
    if (self.onPracticeTypeClick) {
        self.onPracticeTypeClick(self.model);
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_btnPlay);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgType);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbPractice1);
    OBJC_RELEASE(_lbPractice2);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_onPracticeTypeClick);
}
#define kZFoundCardViewImageViewDefaultSize 60
#define kZFoundCardViewButtonDefaultWidth 95
#define kZFoundCardViewButtonDefaultHeight 30
-(void)setViewChangeFrame:(CGRect)frame
{
    [self setFrame:frame];
    [self.viewContent setFrame:self.bounds];
    
    CGFloat viewW = frame.size.width;
    CGFloat space = viewW/kZFoundCardViewDefaultWidth;
    CGFloat imgSize = kZFoundCardViewImageViewDefaultSize*space;
    CGFloat imgX = viewW/2-imgSize/2;
    CGFloat lineSpace1 = 20*space;
    CGFloat lineSpace2 = 10*space;
    [self.imgType setFrame:CGRectMake(imgX, lineSpace1, imgSize, imgSize)];
    [self.imgType setViewRoundNoBorder];
    
    [self.lbTitle setFrame:CGRectMake(0, self.imgType.y+self.imgType.height+lineSpace2, viewW, 18)];
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.lbTitle.y+self.lbTitle.height+lineSpace2, viewW-kSizeSpace*2, kLineHeight)];
    
    [self.lbPractice1 setFrame:CGRectMake(kSizeSpace, self.imgLine.y+self.imgLine.height+lineSpace1, viewW-kSizeSpace*2, 18)];
    [self.lbPractice2 setFrame:CGRectMake(kSizeSpace, self.lbPractice1.y+self.lbPractice1.height+5, viewW-kSizeSpace*2, 18)];
    CGFloat btnW = kZFoundCardViewButtonDefaultWidth*space;
    CGFloat btnH = kZFoundCardViewButtonDefaultHeight*space;
    CGFloat btnX = viewW/2-btnW/2;
    CGFloat btnY = frame.size.height-23*space-btnH;
    [self.btnPlay setEnabled:viewW == kZFoundCardViewDefaultWidth];
    [self.btnPlay setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
}
///设置数据对象
-(void)setViewDataWithModel:(ModelPracticeType *)model
{
    [self setModel:model];
    
    [self.imgType setImageURLStr:model.spe_img];
    [self.lbTitle setText:model.type];
    
    [self.lbPractice1 setHidden:YES];
    [self.lbPractice2 setHidden:YES];
    if (model.arrPractice.count > 1) {
        ModelPractice *modelP1 = [model.arrPractice firstObject];
        ModelPractice *modelP2 = [model.arrPractice objectAtIndex:1];
        if (modelP1) {
            [self.lbPractice1 setHidden:NO];
            [self.lbPractice1 setText:[NSString stringWithFormat:@"1.%@", modelP1.title]];
        }
        if (modelP2) {
            [self.lbPractice2 setHidden:NO];
            [self.lbPractice2 setText:[NSString stringWithFormat:@"2.%@", modelP2.title]];
        }
    } else if (model.arrPractice.count == 1) {
        ModelPractice *modelP = [model.arrPractice firstObject];
        if (modelP) {
            [self.lbPractice1 setHidden:NO];
            [self.lbPractice1 setText:[NSString stringWithFormat:@"1.%@", modelP.title]];
        }
    }
}

@end
