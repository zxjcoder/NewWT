//
//  ZPracticeDetailButtonView.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailButtonView.h"
#import "ClassCategory.h"

@interface ZPracticeDetailButtonView()

///底部
@property (strong, nonatomic) UIView *viewBottom;
///文本
@property (strong, nonatomic) UIButton *imgText;
///PPT
@property (strong, nonatomic) UIButton *imgPPT;
///收藏
@property (strong, nonatomic) UIButton *btnCollection;
///收藏
@property (strong, nonatomic) UILabel *lbCollection;
///赞
@property (strong, nonatomic) UIButton *btnPraise;
///赞
@property (strong, nonatomic) UILabel *lbPraise;
///数据对象
@property (strong, nonatomic) ModelPractice *model;
///是否显示分割线
@property (assign, nonatomic) BOOL showLine;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZPracticeDetailButtonView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.viewBottom = [[UIView alloc] init];
    [self.viewBottom setBackgroundColor:CLEARCOLOR];
    [self.viewBottom setUserInteractionEnabled:YES];
    [self addSubview:self.viewBottom];
    
    self.imgText = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.imgText setImage:[SkinManager getImageWithName:@"p_txt_icon"] forState:(UIControlStateNormal)];
    [self.imgText setImageEdgeInsets:(UIEdgeInsetsMake(2, 2, 2, 2))];
    [self.imgText addTarget:self action:@selector(btnTextClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.imgText setTitle:@"文本" forState:(UIControlStateNormal)];
    [self.imgText setTitle:@"文本" forState:(UIControlStateHighlighted)];
    [self.imgText setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.imgText setTitleColor:MAINCOLOR forState:(UIControlStateHighlighted)];
    [[self.imgText titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.imgText setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 0))];
    [self.viewBottom addSubview:self.imgText];
    
    self.imgPPT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.imgPPT setImage:[SkinManager getImageWithName:@"p_ppt_icon"] forState:(UIControlStateNormal)];
    [self.imgPPT setImageEdgeInsets:(UIEdgeInsetsMake(2, 2, 2, 2))];
    [self.imgPPT addTarget:self action:@selector(btnPPTClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.imgPPT setTitle:@"PPT" forState:(UIControlStateNormal)];
    [self.imgPPT setTitle:@"PPT" forState:(UIControlStateHighlighted)];
    [self.imgPPT setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.imgPPT setTitleColor:MAINCOLOR forState:(UIControlStateHighlighted)];
    [[self.imgPPT titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.imgPPT setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 0))];
    [self.viewBottom addSubview:self.imgPPT];
    
    self.btnCollection = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCollection setImage:[SkinManager getImageWithName:@"shiwu_icon_collection_"] forState:(UIControlStateNormal)];
    [self.btnCollection setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnCollection addTarget:self action:@selector(btnCollectionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBottom addSubview:self.btnCollection];
    
    self.lbCollection = [[UILabel alloc] init];
    [self.lbCollection setTextColor:MAINCOLOR];
    [self.lbCollection setText:@"0"];
    [self.lbCollection setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbCollection setNumberOfLines:1];
    [self.lbCollection setTextAlignment:(NSTextAlignmentLeft)];
    [self.viewBottom addSubview:self.lbCollection];
    
    self.btnPraise = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPraise setImage:[SkinManager getImageWithName:@"shiwu_icon_follow"] forState:(UIControlStateNormal)];
    [self.btnPraise setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnPraise addTarget:self action:@selector(btnPraiseClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBottom addSubview:self.btnPraise];
    
    self.lbPraise = [[UILabel alloc] init];
    [self.lbPraise setTextColor:MAINCOLOR];
    [self.lbPraise setText:@"0"];
    [self.lbPraise setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextAlignment:(NSTextAlignmentLeft)];
    [self.viewBottom addSubview:self.lbPraise];
    
    self.showLine = YES;
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self addSubview:self.viewLine];
}

-(void)btnTextClick:(UIButton *)sender
{
    if (self.onTextClick) {
        self.onTextClick();
    }
}

-(void)btnPPTClick:(UIButton *)sender
{
    if (self.onPPTClick) {
        self.onPPTClick();
    }
}

-(void)btnCollectionClick:(UIButton *)sender
{
    if (self.onCollectionClick) {
        self.onCollectionClick();
    }
}

-(void)btnPraiseClick:(UIButton *)sender
{
    if (self.onPraiseClick) {
        self.onPraiseClick();
    }
}

-(void)setViewFrame
{
    CGFloat btnH = 40;
    CGFloat viewW = APP_FRAME_WIDTH;
    [self.viewBottom setFrame:CGRectMake(0, 5, viewW, btnH)];
    if (self.showLine) {
        [self.viewLine setHidden:NO];
        [self.viewLine setFrame:CGRectMake(0, self.viewBottom.y+self.viewBottom.height+5, self.width, 5)];
    } else {
        [self.viewLine setHidden:YES];
        [self.viewLine setFrame:CGRectZero];
    }
    CGFloat lbH = 25;
    CGFloat lbY = btnH/2-lbH/2;
    CGFloat btnW = 65;
    ///文本
    [self.imgText setFrame:CGRectMake(kSize5, 0, btnW, btnH)];
    ///PPT
    [self.imgPPT setFrame:CGRectMake(self.imgText.x+self.imgText.width, 0, btnW, btnH)];
    
    ///点赞数量
    CGFloat lbCountY = lbY+2;
    CGRect praiseFrame = CGRectMake(viewW-kSize10-kSize5, lbCountY, kSize5, lbH);
    [self.lbPraise setFrame:praiseFrame];
    praiseFrame.size.width = [self.lbPraise getLabelWidthWithMinWidth:kSize5];
    praiseFrame.origin.x = viewW-praiseFrame.size.width-kSize10;
    [self.lbPraise setFrame:praiseFrame];
    ///点赞按钮
    [self.btnPraise setFrame:CGRectMake(self.lbPraise.x-btnH+kSize5, 0, btnH, btnH)];
    
    ///收藏数量
    CGRect collectionFrame = CGRectMake(self.btnPraise.x-kSize3-kSize5, lbCountY, kSize5, lbH);
    [self.lbCollection setFrame:collectionFrame];
    collectionFrame.size.width = [self.lbCollection getLabelWidthWithMinWidth:kSize5];
    collectionFrame.origin.x = self.btnPraise.x-collectionFrame.size.width-kSize3;
    [self.lbCollection setFrame:collectionFrame];
    ///收藏按钮
    [self.btnCollection setFrame:CGRectMake(self.lbCollection.x-btnH+kSize5, 0, btnH, btnH)];
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    if (model) {
        if (model.isPraise) {
            [self.btnPraise setImage:[SkinManager getImageWithName:@"shiwu_icon_follow_pressed"] forState:(UIControlStateNormal)];
        } else {
            [self.btnPraise setImage:[SkinManager getImageWithName:@"shiwu_icon_follow"] forState:(UIControlStateNormal)];
        }
        if (model.isCollection) {
            [self.btnCollection setImage:[SkinManager getImageWithName:@"shiwu_iconcollection_pressed"] forState:(UIControlStateNormal)];
        } else {
            [self.btnCollection setImage:[SkinManager getImageWithName:@"shiwu_icon_collection_"] forState:(UIControlStateNormal)];
        }
        [self.lbPraise setText:[NSString stringWithFormat:@"%ld",model.applauds]];
        [self.lbCollection setText:[NSString stringWithFormat:@"%ld",model.ccount]];
        ///隐藏文本按钮
        [self.imgText setHidden:model.showText==1];
        ///隐藏PPT按钮
        if (model.showText == 0) {
            [self.imgPPT setHidden:model.arrImage.count==0];
        } else {
            [self.imgPPT setHidden:YES];
        }
    }
    [self setViewFrame];
}

-(void)setIsShowLine:(BOOL)isShow
{
    [self setShowLine:isShow];
}

+(CGFloat)getViewH
{
    return 50;
}

+(CGFloat)getViewLineH
{
    return 55;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgText);
    OBJC_RELEASE(_imgPPT);
    OBJC_RELEASE(_btnPraise);
    OBJC_RELEASE(_btnCollection);
    OBJC_RELEASE(_lbPraise);
    OBJC_RELEASE(_lbCollection);
    OBJC_RELEASE(_viewBottom);
    OBJC_RELEASE(_onTextClick);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_onPraiseClick);
    OBJC_RELEASE(_onCollectionClick);
}

-(void)dealloc
{
    [self setViewNil];
}

@end
