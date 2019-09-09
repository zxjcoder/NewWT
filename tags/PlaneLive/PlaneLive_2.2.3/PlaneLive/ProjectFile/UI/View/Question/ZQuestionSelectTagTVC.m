//
//  ZQuestionSelectTagTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionSelectTagTVC.h"

@interface ZQuestionSelectTagTVC()

@property (strong, nonatomic) ZImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIButton *btnCheck;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) ModelTag *model;

@end

@implementation ZQuestionSelectTagTVC

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
    
    self.cellH = [ZQuestionSelectTagTVC getH];
    
    self.imgIcon = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"new_user_photo"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.btnCheck = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_normal"] forState:(UIControlStateNormal)];
    [self.btnCheck setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnCheck addTarget:self action:@selector(btnCheckClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnCheck];
 
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)btnCheckClick:(UIButton *)sender
{
    if (self.onCheckClick) {
        self.onCheckClick(self,self.model);
    }
}

-(void)setTVCCheckTag:(BOOL)isCheck
{
    self.model.isCheck = isCheck;
    if (isCheck) {
        [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_select"] forState:(UIControlStateNormal)];
    } else {
        [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_normal"] forState:(UIControlStateNormal)];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 37;
    [self.imgIcon setFrame:CGRectMake(self.space, kSize10, imgSize, imgSize)];
    [self.imgIcon setViewRound];
    
    CGFloat lbX = self.imgIcon.x+imgSize+self.space;
    CGFloat btnW = 40;
    CGFloat lbW = self.cellW-lbX-btnW-self.space;
    [self.lbTitle setFrame:CGRectMake(lbX, self.cellH/2-self.lbH/2, lbW, self.lbH)];
    [self.btnCheck setFrame:CGRectMake(self.cellW-self.space-btnW, self.cellH/2-btnW/2, btnW, btnW)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(CGFloat)setCellDataWithModel:(ModelTag *)model
{
    [self setModel:model];
    if (model) {
        [self.imgIcon setPhotoURLStr:model.tagLogo placeImage:[SkinManager getImageWithName:@"new_user_photo"]];
        [self.lbTitle setText:model.tagName];
        if (model.isCheck) {
            [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_select"] forState:(UIControlStateNormal)];
        } else {
            [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_normal"] forState:(UIControlStateNormal)];
        }
    }
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_btnCheck);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_onCheckClick);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 37+20;
}

@end
