//
//  ZUserProfileAttentionTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserProfileAttentionTVC.h"

@interface ZUserProfileAttentionTVC()

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserProfileAttentionTVC

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
    
    self.cellH = [ZUserProfileAttentionTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    [self setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    self.imgIcon = [[UIImageView alloc] init];
    [self.imgIcon setImage:[SkinManager getImageWithName:@"wode_icon_guanzhu"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setText:kAttention];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.imgIcon setFrame:CGRectMake(self.space, self.cellH/2-18/2, 18, 18)];
    
    [self.lbTitle setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width+kSize13, self.cellH/2-self.lbH/2, self.cellW, self.lbH)];
    
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [super setCellDataWithModel:model];

    [self.lbTitle setText:kAttention];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(NSString *)getTitleText
{
    return self.lbTitle.text;
}
-(void)setHiddenLine
{
    [self.imgLine setHidden:YES];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLine);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

@end
