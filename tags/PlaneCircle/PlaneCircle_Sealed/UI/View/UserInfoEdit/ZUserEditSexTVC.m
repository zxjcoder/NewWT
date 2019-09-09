//
//  ZUserEditSexTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditSexTVC.h"

@interface ZUserEditSexTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIButton *btnSex1;

@property (strong, nonatomic) UIButton *btnSex2;

@property (strong, nonatomic) UIView *viewLine;

@property (assign, nonatomic) WTSexType sexType;

@end

@implementation ZUserEditSexTVC

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
    
    self.cellH = self.getH;
    
    [self setSexType:(WTSexTypeNone)];
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:kCGender];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.btnSex1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSex1 setTag:10];
    [self.btnSex1 setTitle:kCMale forState:(UIControlStateNormal)];
    [self.btnSex1 setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [self.btnSex1 setImage:[SkinManager getImageWithName:@"user_sex_select1"] forState:(UIControlStateNormal)];
    [self.btnSex1 setImageEdgeInsets:(UIEdgeInsetsMake(1, 1, 1, 1))];
    [self.btnSex1 setTitleEdgeInsets:(UIEdgeInsetsMake(0, 12, 0, 0))];
    [self.btnSex1 addTarget:self action:@selector(btnSexClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnSex1];
    
    self.btnSex2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSex2 setTag:11];
    [self.btnSex2 setTitle:kCFemale forState:(UIControlStateNormal)];
    [self.btnSex2 setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [self.btnSex2 setImage:[SkinManager getImageWithName:@"user_sex_select1"] forState:(UIControlStateNormal)];
    [self.btnSex2 setImageEdgeInsets:(UIEdgeInsetsMake(1, 1, 1, 1))];
    [self.btnSex2 setTitleEdgeInsets:(UIEdgeInsetsMake(0, 12, 0, 0))];
    [self.btnSex2 addTarget:self action:@selector(btnSexClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnSex2];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.space+1, self.leftW, self.lbH)];
    
    CGFloat btnW = 50;
    [self.btnSex1 setFrame:CGRectMake(self.cellW-btnW*2-self.space, 5, btnW, 35)];
    [self.btnSex2 setFrame:CGRectMake(self.cellW-btnW-self.space, 5, btnW, 35)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)btnSexClick:(UIButton *)sender
{
    if (sender.tag == 10) {
        [self setSexType:(WTSexTypeMale)];
        [self.btnSex1 setImage:[SkinManager getImageWithName:@"user_sex_select2"] forState:(UIControlStateNormal)];
        [self.btnSex2 setImage:[SkinManager getImageWithName:@"user_sex_select1"] forState:(UIControlStateNormal)];
    } else {
        [self setSexType:(WTSexTypeFeMale)];
        [self.btnSex1 setImage:[SkinManager getImageWithName:@"user_sex_select1"] forState:(UIControlStateNormal)];
        [self.btnSex2 setImage:[SkinManager getImageWithName:@"user_sex_select2"] forState:(UIControlStateNormal)];
    }
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    switch (model.sex) {
        case WTSexTypeNone:
        {
            [self setSexType:(WTSexTypeNone)];
            [self.btnSex1 setImage:[SkinManager getImageWithName:@"user_sex_select1"] forState:(UIControlStateNormal)];
            [self.btnSex2 setImage:[SkinManager getImageWithName:@"user_sex_select1"] forState:(UIControlStateNormal)];
            break;
        }
        case WTSexTypeMale:
        {
            [self setSexType:(WTSexTypeMale)];
            [self.btnSex1 setImage:[SkinManager getImageWithName:@"user_sex_select2"] forState:(UIControlStateNormal)];
            [self.btnSex2 setImage:[SkinManager getImageWithName:@"user_sex_select1"] forState:(UIControlStateNormal)];
            break;
        }
        case WTSexTypeFeMale:
        {
            [self setSexType:(WTSexTypeFeMale)];
            [self.btnSex1 setImage:[SkinManager getImageWithName:@"user_sex_select1"] forState:(UIControlStateNormal)];
            [self.btnSex2 setImage:[SkinManager getImageWithName:@"user_sex_select2"] forState:(UIControlStateNormal)];
            break;
        }
        default: break;
    }
}

-(WTSexType)getSelectSexType
{
    return self.sexType;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_btnSex1);
    OBJC_RELEASE(_btnSex2);
    OBJC_RELEASE(_viewLine);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 45;
}
+(CGFloat)getH
{
    return 45;
}

@end
