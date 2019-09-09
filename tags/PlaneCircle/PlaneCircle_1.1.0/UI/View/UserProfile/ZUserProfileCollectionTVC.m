//
//  ZUserProfileCollectionTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserProfileCollectionTVC.h"

@interface ZUserProfileCollectionTVC()

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIView *viewL;

@end

@implementation ZUserProfileCollectionTVC

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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    self.imgIcon = [[UIImageView alloc] init];
    [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_shoucang"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setText:@"他的收藏"];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgIcon setFrame:CGRectMake(self.space, self.cellH/2-18/2, 18, 18)];
    
    [self.lbTitle setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width+kSize13, self.cellH/2-self.lbH/2, self.cellW, self.lbH)];
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    [super setCellDataWithModel:model];
    switch (model.sex) {
        case WTSexTypeFeMale:
            [self.lbTitle setText:@"她的收藏"];
            break;
        default:
            [self.lbTitle setText:@"他的收藏"];
            break;
    }
}

-(NSString *)getTitleText
{
    return self.lbTitle.text;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewL);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

@end
