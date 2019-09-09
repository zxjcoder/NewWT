//
//  ZTopicHeaderView.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicHeaderView.h"
#import "ZImageView.h"
#import "ClassCategory.h"

@interface ZTopicHeaderView()

@property (strong, nonatomic) UIView *viewMain;

@property (strong, nonatomic) ZImageView *imgLogo;

@property (strong, nonatomic) UILabel *lbTagName;

@property (strong, nonatomic) UILabel *lbAttCount;

@property (strong, nonatomic) UIButton *btnAtt;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) ModelTag *model;

@end

@implementation ZTopicHeaderView

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

-(void)innerInit
{
    self.viewMain = [[UIView alloc] init];
    [self.viewMain setBackgroundColor:WHITECOLOR];
    [self.viewMain setUserInteractionEnabled:YES];
    [self addSubview:self.viewMain];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.imgLogo setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.imgLogo];
    
    self.lbTagName = [[UILabel alloc] init];
    [self.lbTagName setTextColor:MAINCOLOR];
    [self.lbTagName setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTagName setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbTagName];
    
    self.lbAttCount = [[UILabel alloc] init];
    [self.lbAttCount setTextColor:DESCCOLOR];
    [self.lbAttCount setText:[NSString stringWithFormat:kAttentionToNumber, 0]];
    [self.lbAttCount setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbAttCount setUserInteractionEnabled:NO];
    [self.viewMain addSubview:self.lbAttCount];
    
    self.btnAtt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAtt setTitle:kAttention forState:(UIControlStateNormal)];
    [self.btnAtt setBackgroundColor:MAINCOLOR];
    [self.btnAtt setUserInteractionEnabled:YES];
    [self.btnAtt setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [[self.btnAtt titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnAtt addTarget:self action:@selector(btnAttClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAtt];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self setViewFrame];
}

-(void)dealloc
{
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_lbTagName);
    OBJC_RELEASE(_lbAttCount);
    OBJC_RELEASE(_btnAtt);
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_onAttentionClick);
}

-(void)btnAttClick
{
    [self setAttStatusChange];
    if (self.onAttentionClick) {
        ModelTag *modelT = [[ModelTag alloc] init];
        [modelT setTagId:self.model.tagId];
        [modelT setTagName:self.model.tagName];
        [modelT setTagLogo:self.model.tagLogo];
        [modelT setIsAtt:self.model.isAtt];
        self.onAttentionClick(modelT);
    }
}

-(void)setViewFrame
{
    CGFloat viewW = APP_FRAME_WIDTH;
    CGFloat viewH = 70;
    
    [self.viewMain setFrame:CGRectMake(0, 0, viewW, 75)];
    
    CGFloat logoSize = 50;
    [self.imgLogo setFrame:CGRectMake(10, 10, logoSize, logoSize)];
    [self.imgLogo setViewRound];
    
    CGFloat btnW = 55;
    CGFloat btnH = 27;
    CGFloat tagX = self.imgLogo.x+logoSize+10;
    CGFloat tagW = viewW-tagX-btnW-20;
    [self.lbTagName setFrame:CGRectMake(tagX, 12, tagW, 25)];
    [self.lbAttCount setFrame:CGRectMake(tagX, self.lbTagName.y+self.lbTagName.height, tagW , 20)];
    
    [self.btnAtt setFrame:CGRectMake(viewW-btnW-20, viewH/2-btnH/2, btnW, btnH)];
    
    [self.viewLine setFrame:CGRectMake(0, self.viewMain.height-5, viewW, 5)];
}
-(void)setAttStatusChange
{
    if (self.model.isAtt) {
        [self.btnAtt setBackgroundColor:RGBCOLOR(201, 201, 201)];
        [self.btnAtt setTitle:kAlreadyAttention forState:(UIControlStateNormal)];
    } else {
        [self.btnAtt setBackgroundColor:MAINCOLOR];
        [self.btnAtt setTitle:kAttention forState:(UIControlStateNormal)];
    }
}
-(void)setViewDataWithModel:(ModelTag *)model
{
    [self setModel:model];
    if (model) {
        [self.imgLogo setPhotoURLStr:model.tagLogo placeImage:[SkinManager getImageWithName:@"new_user_photo"]];
        [self.lbTagName setText:model.tagName];
        [self.lbAttCount setText:[NSString stringWithFormat:kAttentionToNumber, (long)model.attCount]];
        [self setAttStatusChange];
    }
}

+(CGFloat)getViewH
{
    return 75;
}

@end
