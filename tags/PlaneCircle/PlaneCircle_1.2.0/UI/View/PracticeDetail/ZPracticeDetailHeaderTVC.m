//
//  ZPracticeDetailHeaderTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailHeaderTVC.h"
#import "Utils.h"
#import "AppSetting.h"

@interface ZPracticeDetailHeaderTVC()

///背景
@property (strong, nonatomic) ZImageView *imgBG;
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
///文本
@property (strong, nonatomic) UILabel *lbText;
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

@implementation ZPracticeDetailHeaderTVC

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
    
    self.cellH = 100;
    
    self.imgBG = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_headerbg_default"]];
    [self.imgBG setContentMode:UIViewContentModeScaleToFill];
    [self.imgBG setClipsToBounds:YES];
    [self.imgBG setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgBG];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:RGBCOLOR(250,155,77)];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setText:@"实务简介:"];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:WHITECOLOR];
    [self.lbContent setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:0];
    [self.viewMain addSubview:self.lbContent];
    
    self.viewBottom = [[UIView alloc] init];
    [self.viewBottom setBackgroundColor:CLEARCOLOR];
    [self.viewBottom setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewBottom];
    
    self.imgText = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.imgText setImage:[SkinManager getImageWithName:@"p_txt_icon"] forState:(UIControlStateNormal)];
    [self.imgText setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.imgText addTarget:self action:@selector(btnTextClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBottom addSubview:self.imgText];
    
    self.lbText = [[UILabel alloc] init];
    [self.lbText setTextColor:RGBCOLOR(250,155,77)];
    [self.lbText setText:@"文本"];
    [self.lbText setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbText setNumberOfLines:1];
    [self.viewBottom addSubview:self.lbText];
    
    self.btnCollection = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCollection setImage:[SkinManager getImageWithName:@"p_collection_nomarl"] forState:(UIControlStateNormal)];
    [self.btnCollection setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnCollection addTarget:self action:@selector(btnCollectionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBottom addSubview:self.btnCollection];
    
    self.lbCollection = [[UILabel alloc] init];
    [self.lbCollection setTextColor:RGBCOLOR(250,155,77)];
    [self.lbCollection setText:@"0"];
    [self.lbCollection setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbCollection setNumberOfLines:1];
    [self.lbCollection setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewBottom addSubview:self.lbCollection];
    
    self.btnPraise = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPraise setImage:[SkinManager getImageWithName:@"p_follow_nomarl"] forState:(UIControlStateNormal)];
    [self.btnPraise setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnPraise addTarget:self action:@selector(btnPraiseClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBottom addSubview:self.btnPraise];
    
    self.lbPraise = [[UILabel alloc] init];
    [self.lbPraise setTextColor:RGBCOLOR(250,155,77)];
    [self.lbPraise setText:@"0"];
    [self.lbPraise setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewBottom addSubview:self.lbPraise];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self.viewMain sendSubviewToBack:self.imgBG];
}

-(void)btnTextClick:(UIButton *)sender
{
    if (self.onTextClick) {
        self.onTextClick();
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
    CGFloat space = 15;
    [self.lbTitle setFrame:CGRectMake(15, 74, self.cellW, self.lbH)];
    
    CGRect contentFrame = CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+space, self.cellW-self.space*2, self.lbMinH);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    contentFrame.size.height = contentH;
    [self.lbContent setFrame:contentFrame];
    
    CGFloat btnS = 40;
    
    [self.viewBottom setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height+space, self.cellW, btnS)];
    [self.viewLine setFrame:CGRectMake(0, self.viewBottom.y+self.viewBottom.height, self.cellW, self.lineMaxH)];
    
    CGFloat lbH = 25;
    CGFloat lbY = btnS/2-lbH/2;
    [self.imgText setFrame:CGRectMake(5, 0, btnS, btnS)];
    [self.lbText setFrame:CGRectMake(self.imgText.x+self.imgText.width-5, lbY, 50, lbH)];
    
    CGFloat lbCountY = lbY+2;
    [self.lbPraise setFrame:CGRectMake(self.cellW-17, lbCountY, 10, lbH)];
    CGFloat praiseW = [self.lbPraise getLabelWidthWithMinWidth:10];
    [self.lbPraise setFrame:CGRectMake(self.cellW-7-praiseW, lbCountY, praiseW, lbH)];
    [self.btnPraise setFrame:CGRectMake(self.lbPraise.x-btnS+5, 0, btnS, btnS)];
    
    [self.lbCollection setFrame:CGRectMake(self.btnPraise.x-5, lbCountY, 10, lbH)];
    CGFloat collectionW = [self.lbCollection getLabelWidthWithMinWidth:10];
    [self.lbCollection setFrame:CGRectMake(self.btnPraise.x-5-collectionW, lbCountY, collectionW, lbH)];
    [self.btnCollection setFrame:CGRectMake(self.lbCollection.x-btnS+5, 0, btnS, btnS)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    
    [self.imgBG setFrame:CGRectMake(0, 0, self.cellW, self.viewLine.y)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    /*
    if (self.model.bkimg && ![self.model.bkimg isKindOfClass:[NSNull class]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *filePath = [[AppSetting getRecvFilePath] stringByAppendingPathComponent:[Utils stringMD5:self.model.bkimg]];
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.bkimg]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                imgData = [NSData dataWithContentsOfFile:filePath];
            } else {
                imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.bkimg]];
            }
            if (imgData) {
                UIImage *img = [UIImage imageWithData:imgData];
                [Utils writeImage:img toFileAtPath:filePath];
                if (img) {
                    UIImage *image = [Utils blurryImage:img size:CGSizeMake(self.cellW, self.cellH) withBlurLevel:5];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                                [self.imgBG setImage:image];
                            }];
                        });
                    }
                }
            }
        });
    }*/
}

-(void)setCellDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    if (model) {
        [self.lbContent setAttributedText:[[NSMutableAttributedString alloc] initWithString:model.share_content]];
        if (model.isPraise) {
            [self.btnPraise setImage:[SkinManager getImageWithName:@"p_followed_click"] forState:(UIControlStateNormal)];
        } else {
            [self.btnPraise setImage:[SkinManager getImageWithName:@"p_follow_nomarl"] forState:(UIControlStateNormal)];
        }
        if (model.isCollection) {
            [self.btnCollection setImage:[SkinManager getImageWithName:@"p_collection_click"] forState:(UIControlStateNormal)];
        } else {
            [self.btnCollection setImage:[SkinManager getImageWithName:@"p_collection_nomarl"] forState:(UIControlStateNormal)];
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
    }
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgBG);
    OBJC_RELEASE(_imgText);
    OBJC_RELEASE(_btnPraise);
    OBJC_RELEASE(_btnCollection);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbText);
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
