//
//  ZPracticeDetailDescTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailDescTVC.h"
#import "Utils.h"
#import "AppSetting.h"

@interface ZPracticeDetailDescTVC()

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///内容
@property (strong, nonatomic) UILabel *lbContent;
///底部
@property (strong, nonatomic) UIView *viewBottom;
///分割线
@property (strong, nonatomic) UIView *viewLine;
///文本
@property (strong, nonatomic) UIButton *imgText;
///PPT
@property (strong, nonatomic) UIButton *imgPPT;
/////文本
//@property (strong, nonatomic) UILabel *lbText;
/////PPT
//@property (strong, nonatomic) UILabel *lbPPT;
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

@end

@implementation ZPracticeDetailDescTVC

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
    
    self.cellH = 50;
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setText:@"实务简介:"];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:0];
    [self.viewMain addSubview:self.lbContent];
    
    self.viewBottom = [[UIView alloc] init];
    [self.viewBottom setBackgroundColor:CLEARCOLOR];
    [self.viewBottom setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewBottom];
    
    self.imgText = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.imgText setImage:[SkinManager getImageWithName:@"p_txt_icon"] forState:(UIControlStateNormal)];
    [self.imgText setImageEdgeInsets:(UIEdgeInsetsMake(2, 2, 2, 2))];
    [self.imgText addTarget:self action:@selector(btnTextClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.imgText setTitle:@"文本" forState:(UIControlStateNormal)];
    [self.imgText setTitle:@"文本" forState:(UIControlStateHighlighted)];
    [self.imgText setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.imgText setTitleColor:MAINCOLOR forState:(UIControlStateHighlighted)];
    [[self.imgText titleLabel] setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
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
    [[self.imgPPT titleLabel] setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.imgPPT setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 0))];
    [self.viewBottom addSubview:self.imgPPT];
    
//    self.lbText = [[UILabel alloc] init];
//    [self.lbText setTextColor:MAINCOLOR];
//    [self.lbText setText:@"文本"];
//    [self.lbText setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
//    [self.lbText setNumberOfLines:1];
//    [self.viewBottom addSubview:self.lbText];
//    
//    self.lbPPT = [[UILabel alloc] init];
//    [self.lbPPT setTextColor:MAINCOLOR];
//    [self.lbPPT setText:@"PPT"];
//    [self.lbPPT setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
//    [self.lbPPT setNumberOfLines:1];
//    [self.viewBottom addSubview:self.lbPPT];
    
    self.btnCollection = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCollection setImage:[SkinManager getImageWithName:@"shiwu_icon_collection_"] forState:(UIControlStateNormal)];
    [self.btnCollection setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnCollection addTarget:self action:@selector(btnCollectionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBottom addSubview:self.btnCollection];
    
    self.lbCollection = [[UILabel alloc] init];
    [self.lbCollection setTextColor:MAINCOLOR];
    [self.lbCollection setText:@"0"];
    [self.lbCollection setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbCollection setNumberOfLines:1];
    [self.lbCollection setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewBottom addSubview:self.lbCollection];
    
    self.btnPraise = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPraise setImage:[SkinManager getImageWithName:@"shiwu_icon_follow"] forState:(UIControlStateNormal)];
    [self.btnPraise setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnPraise addTarget:self action:@selector(btnPraiseClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBottom addSubview:self.btnPraise];
    
    self.lbPraise = [[UILabel alloc] init];
    [self.lbPraise setTextColor:MAINCOLOR];
    [self.lbPraise setText:@"0"];
    [self.lbPraise setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewBottom addSubview:self.lbPraise];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
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
    CGFloat space = 12;
    [self.lbTitle setFrame:CGRectMake(self.space, 8, self.cellW, self.lbH)];
    
    CGRect contentFrame = CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+space, self.cellW-self.space*2, self.lbMinH);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    contentFrame.size.height = contentH;
    [self.lbContent setFrame:contentFrame];
    
     CGFloat btnH = 40;
    
    [self.viewBottom setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height+space, self.cellW, btnH)];
    [self.viewLine setFrame:CGRectMake(0, self.viewBottom.y+self.viewBottom.height, self.cellW, self.lineMaxH)];
    
    CGFloat lbH = 25;
    CGFloat lbY = btnH/2-lbH/2;
    CGFloat btnW = 65;
    [self.imgText setFrame:CGRectMake(kSize5, 0, btnW, btnH)];
//    [self.lbText setFrame:CGRectMake(self.imgText.x+self.imgText.width, lbY, 0, lbH)];
//    CGFloat textW = [self.lbText getLabelWidthWithMinWidth:0];
//    [self.lbText setFrame:CGRectMake(self.lbText.x, self.lbText.y, textW, self.lbText.height)];
    
    [self.imgPPT setFrame:CGRectMake(self.imgText.x+self.imgText.width, 0, btnW, btnH)];
//    [self.lbPPT setFrame:CGRectMake(self.imgPPT.x+self.imgPPT.width, lbY, 0, lbH)];
//    CGFloat pptW = [self.lbPPT getLabelWidthWithMinWidth:0];
//    [self.lbPPT setFrame:CGRectMake(self.lbPPT.x, self.lbPPT.y, pptW, self.lbPPT.height)];
    
    CGFloat lbCountY = lbY+2;
    [self.lbPraise setFrame:CGRectMake(self.cellW-17, lbCountY, 10, lbH)];
    CGFloat praiseW = [self.lbPraise getLabelWidthWithMinWidth:10];
    [self.lbPraise setFrame:CGRectMake(self.cellW-7-praiseW, lbCountY, praiseW, lbH)];
    [self.btnPraise setFrame:CGRectMake(self.lbPraise.x-btnH+5, 0, btnH, btnH)];
    
    [self.lbCollection setFrame:CGRectMake(self.btnPraise.x-5, lbCountY, 10, lbH)];
    CGFloat collectionW = [self.lbCollection getLabelWidthWithMinWidth:10];
    [self.lbCollection setFrame:CGRectMake(self.btnPraise.x-5-collectionW, lbCountY, collectionW, lbH)];
    [self.btnCollection setFrame:CGRectMake(self.lbCollection.x-btnH+5, 0, btnH, btnH)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    if (model) {
        [self.lbContent setAttributedText:[[NSMutableAttributedString alloc] initWithString:model.share_content]];
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
        if (model.applauds > kNumberMaxCount) {
            [self.lbPraise setText:[NSString stringWithFormat:@"%d",kNumberMaxCount]];
        } else {
            [self.lbPraise setText:[NSString stringWithFormat:@"%ld",model.applauds]];
        }
        if (model.ccount > kNumberMaxCount) {
            [self.lbCollection setText:[NSString stringWithFormat:@"%d",kNumberMaxCount]];
        } else {
            [self.lbCollection setText:[NSString stringWithFormat:@"%ld",model.ccount]];
        }
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

-(void)setViewNil
{
    OBJC_RELEASE(_imgText);
    OBJC_RELEASE(_imgPPT);
    OBJC_RELEASE(_btnPraise);
    OBJC_RELEASE(_btnCollection);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbPraise);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_lbCollection);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewBottom);
    OBJC_RELEASE(_onTextClick);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_onPraiseClick);
    OBJC_RELEASE(_onCollectionClick);
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

@end