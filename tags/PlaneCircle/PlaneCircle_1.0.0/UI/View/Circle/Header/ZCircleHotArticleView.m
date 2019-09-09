//
//  ZCircleHotArticleView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleHotArticleView.h"
#import "ZImageView.h"
#import "ClassCategory.h"

@interface ZCircleHotArticleView()

@property (strong, nonatomic) UIView *viewMain;

@property (strong, nonatomic) UIImageView *imgHot;

@property (strong, nonatomic) UILabel *lbHot;

@property (strong, nonatomic) ZImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) ModelHotArticle *modelHA;

@end

@implementation ZCircleHotArticleView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    
    self.viewMain = [[UIView alloc] init];
    [self.viewMain setBackgroundColor:WHITECOLOR];
    [self.viewMain setUserInteractionEnabled:YES];
    [self addSubview:self.viewMain];
    
    self.imgIcon = [[ZImageView alloc] init];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgIcon];
    
    self.imgHot = [[UIImageView alloc] init];
    [self.imgHot setImage:[SkinManager getImageWithName:@"bg_news"]];
    [self.imgHot setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgHot];
    
    self.lbHot = [[UILabel alloc] init];
    [self.lbHot setText:@"新闻"];
    [self.lbHot setTextColor:WHITECOLOR];
    [self.lbHot setUserInteractionEnabled:NO];
    [self.lbHot setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbHot];
    
    [self.viewMain sendSubviewToBack:self.imgIcon];
    [self.viewMain bringSubviewToFront:self.lbHot];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setNumberOfLines:2];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbDesc setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbDesc];
    
    UITapGestureRecognizer *viewMainTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMainTap:)];
    [self.viewMain addGestureRecognizer:viewMainTap];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = 5;
    [self.viewMain setFrame:CGRectMake(0, 5, self.width, self.height-10)];
    
    CGFloat imgSize = self.viewMain.height-space-space;
    [self.imgHot setFrame:CGRectMake(space, space, imgSize, 22)];
    [self.lbHot setFrame:CGRectMake(space+5, space, imgSize, 22)];
    [self.imgIcon setFrame:CGRectMake(space, space, imgSize, imgSize)];
    
    CGFloat lbX = self.imgIcon.x+self.imgIcon.width+space;
    CGFloat lbW = self.width-space-lbX;
    
    [self.lbTitle setFrame:CGRectMake(lbX, space, lbW, 40)];
    
    [self.lbDesc setFrame:CGRectMake(lbX, space+imgSize/2+3, lbW, 35)];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbHot);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgHot);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_modelHA);
}

-(void)viewMainTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onHotArticleViewClick) {
            self.onHotArticleViewClick(self.modelHA);
        }
    }
}

-(void)setViewDataWithModel:(ModelHotArticle *)model
{
    [self setModelHA:model];
    
    if (model) {
        [self.imgIcon setImageURLStr:model.imageUrl];
        [self.lbTitle setText:model.title];
        [self.lbDesc setText:model.desc];
    }
}

@end
