//
//  ZQuestionRlationTagView.m
//  PlaneCircle
//
//  Created by Daniel on 8/4/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionRlationTagView.h"
#import "ZImageView.h"
#import "ClassCategory.h"

@interface ZQuestionRlationTagView()

@property (strong, nonatomic) UIView *viewMain;

@property (strong, nonatomic) ZImageView *imgLogo;

@property (strong, nonatomic) UILabel *lbTagName;

@property (strong, nonatomic) UIView *viewLine1;
@property (strong, nonatomic) UIView *viewLine2;

@property (strong, nonatomic) ModelTag *model;

@end

@implementation ZQuestionRlationTagView

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
    [self.viewMain setUserInteractionEnabled:YES];
    [self addSubview:self.viewMain];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.viewMain addGestureRecognizer:viewTap];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.imgLogo setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgLogo];
    
    self.lbTagName = [[UILabel alloc] init];
    [self.lbTagName setTextColor:BLACKCOLOR];
    [self.lbTagName setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTagName setUserInteractionEnabled:NO];
    [self.lbTagName setNumberOfLines:1];
    [self.lbTagName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTagName];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewLine1 setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewLine2 setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.viewLine2];
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
    [self.viewMain setFrame:self.bounds];
    
    CGFloat logoSize = 35;
    [self.imgLogo setFrame:CGRectMake(kSize14, kSize14, logoSize, logoSize)];
    [self.imgLogo setViewRound];
    
    CGFloat tagX = self.imgLogo.x+logoSize+kSize13;
    CGFloat tagW = self.width-tagX-kSize14;
    [self.lbTagName setFrame:CGRectMake(tagX, self.height/2-30/2, tagW, 30)];
    
    [self.viewLine1 setFrame:CGRectMake(0, 0, self.width, kSize1)];
    [self.viewLine2 setFrame:CGRectMake(0, self.height-kSize1, self.width, kSize1)];
}

-(void)dealloc
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_lbTagName);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_viewMain);
}

-(void)setViewDataWithModel:(ModelTag *)model
{
    [self setModel:model];
    if (model) {
        [self.lbTagName setText:model.tagName];
        [self.imgLogo setImageURLStr:model.tagLogo placeImage:[SkinManager getImageWithName:@"new_user_photo"]];
    }
    [self setViewFrame];
}

+(CGFloat)getViewH
{
    return 65;
}


@end
