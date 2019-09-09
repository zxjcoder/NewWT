//
//  ZLawFirmDetailTVC.m
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmDetailTVC.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZCalculateLabel.h"
//#import "ZNewLawFirmHeaderView.h"

@interface ZLawFirmDetailTVC()

@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZImageView *imgBackground;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbDesc;

@property (strong, nonatomic) ZView *viewButton;
@property (strong, nonatomic) ZButton *btnMore;
/// 数据模型
@property (strong, nonatomic) ModelLawFirm *model;

@end

@implementation ZLawFirmDetailTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [super innerInit];
    self.cellH = [ZLawFirmDetailTVC getH];
    self.space = 20;
    CGFloat btnSize = 40;
    self.viewContent = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    [self.viewContent setBackgroundColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    self.imgBackground = [[ZImageView alloc] initWithFrame:(CGRectMake(0, 0, self.viewContent.width, self.viewContent.height-btnSize/2))];
    [self.imgBackground setImageName:@"btn_gra3"];
    [self.imgBackground setUserInteractionEnabled:false];
    [self.viewContent addSubview:self.imgBackground];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(self.space, 94, self.viewContent.width-self.space*2, 26))];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[UIFont systemFontOfSize:24]];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setUserInteractionEnabled:false];
    [self.imgBackground addSubview:self.lbTitle];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+5, self.lbTitle.width, 23))];
    [self.lbDesc setTextColor:WHITECOLOR];
    [self.lbDesc setAlpha:0.5];
    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setNumberOfLines:1];
    [self.lbDesc setUserInteractionEnabled:false];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail)];
    [self.imgBackground addSubview:self.lbDesc];
    
    self.viewButton = [[ZView alloc] initWithFrame:(CGRectMake(self.viewContent.width-self.space-btnSize, self.viewContent.height-btnSize, btnSize, btnSize))];
    [self.viewButton.layer setShadowColor:RGBCOLOR(164, 186, 201).CGColor];
    [self.viewButton.layer setShadowOffset:(CGSizeMake(0, 10))];
    [self.viewButton.layer setShadowRadius:10];
    [self.viewButton.layer setShadowOpacity:0.20];
    [self.viewButton.layer setCornerRadius:btnSize/2];
    [self.viewContent addSubview:self.viewButton];
    
    self.btnMore = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMore setBackgroundColor:WHITECOLOR];
    [[self.btnMore layer] setMasksToBounds:true];
    [self.btnMore setViewRound:btnSize/2 borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnMore setImage:[SkinManager getImageWithName:@"arrow_down02"] forState:(UIControlStateNormal)];
    [self.btnMore setImage:[SkinManager getImageWithName:@"arrow_down02"] forState:(UIControlStateHighlighted)];
    [self.btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.btnMore.frame = self.viewButton.bounds;
    [self.viewButton addSubview:self.btnMore];
    
    [self.viewContent bringSubviewToFront:self.viewButton];
}
-(void)btnMoreClick:(ZButton *)sender
{
    if (self.onShowDetailEvent) {
        self.onShowDetailEvent(self.model);
    }
}
-(void)setViewDataWithLawFirm:(ModelLawFirm *)model
{
    [self setModel:model];
    
    [self.lbTitle setText:model.title];
    [self.lbDesc setText:model.desc];
}
-(void)dealloc
{
    OBJC_RELEASE(_imgBackground);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_btnMore);
    OBJC_RELEASE(_viewContent);
}
+(CGFloat)getH
{
    return 179;
}
-(CGFloat)getH
{
    return [ZLawFirmDetailTVC getH];
}

@end
