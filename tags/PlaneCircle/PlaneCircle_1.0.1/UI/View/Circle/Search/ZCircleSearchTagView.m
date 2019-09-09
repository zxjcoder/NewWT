//
//  ZCircleSearchTagView.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchTagView.h"
#import "ZImageView.h"
#import "ClassCategory.h"

@interface ZCircleSearchTagView()

@property (strong, nonatomic) UIView *viewMain;

@property (strong, nonatomic) ZImageView *imgLogo;

@property (strong, nonatomic) UIView *viewTagName;
@property (strong, nonatomic) UILabel *lbTagName;

//@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) UIImageView *imgGo;

@property (strong, nonatomic) ModelTag *model;

@end

@implementation ZCircleSearchTagView

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
    self.viewMain = [[UIView alloc] init];
    [self.viewMain setBackgroundColor:WHITECOLOR];
    [self.viewMain setUserInteractionEnabled:NO];
    [self addSubview:self.viewMain];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self addGestureRecognizer:viewTap];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.imgLogo setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgLogo];
    
    self.viewTagName = [[UIView alloc] init];
    [self.viewTagName setBackgroundColor:RGBCOLOR(235, 102, 100)];
    [self.viewTagName setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewTagName setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.viewTagName];
    
    self.lbTagName = [[UILabel alloc] init];
    [self.lbTagName setTextColor:WHITECOLOR];
    [self.lbTagName setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTagName setUserInteractionEnabled:NO];
    [self.lbTagName setNumberOfLines:1];
    [self.lbTagName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewTagName addSubview:self.lbTagName];
    
//    self.lbDesc = [[UILabel alloc] init];
//    [self.lbDesc setTextColor:DESCCOLOR];
//    [self.lbDesc setText:@"进入话题"];
//    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
//    [self.lbDesc setTextAlignment:(NSTextAlignmentRight)];
//    [self.lbDesc setUserInteractionEnabled:NO];
//    [self.viewMain addSubview:self.lbDesc];
    
    self.imgGo = [[UIImageView alloc] init];
    [self.imgGo setImage:[SkinManager getImageWithName:@"wode_btn_enter_s"]];
    [self.imgGo setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgGo];
}

-(void)viewTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onSearchTagClick) {
            self.onSearchTagClick(self.model);
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat logoSize = 45;
    [self.imgLogo setFrame:CGRectMake(10, 15, logoSize, logoSize)];
    [self.imgLogo setViewRound];
    
    [self.imgGo setFrame:CGRectMake(self.width-15-10, self.height/2-15/2, 8, 15)];
    
//    [self.lbDesc setFrame:CGRectMake(self.imgGo.x-70, self.height/2-12, 60, 24)];
    
    CGFloat tagW = [self.lbTagName getLabelWidthWithMinWidth:0];
    CGFloat tagMaxW = (self.imgGo.x-self.imgLogo.x-logoSize-20);
    if (tagW > tagMaxW) {
        tagW = tagMaxW;
    } else {
        tagW = tagW+10;
    }
    [self.viewTagName setFrame:CGRectMake(self.imgLogo.x+logoSize+10, self.height/2-30/2, tagW, 30)];
    [self.lbTagName setFrame:CGRectMake(5, 0, self.viewTagName.width-10, 30)];
}

-(void)dealloc
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_imgGo);
    OBJC_RELEASE(_lbTagName);
}

-(void)setViewDataWithModel:(ModelTag *)model
{
    [self setModel:model];
    if (model) {
        [self.imgLogo setImageURLStr:model.tagLogo placeImage:[SkinManager getImageWithName:@"new_user_photo"]];
        [self.lbTagName setText:model.tagName];
    }
    [self setViewFrame];
}

+(CGFloat)getViewH
{
    return 75;
}

@end
