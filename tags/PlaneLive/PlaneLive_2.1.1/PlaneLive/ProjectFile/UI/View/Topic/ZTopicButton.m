//
//  ZTopicButton.m
//  PlaneCircle
//
//  Created by Daniel on 7/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicButton.h"
#import "ZImageView.h"
#import "ClassCategory.h"

@interface ZTopicButton()

///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///关注图片
@property (strong, nonatomic) UIImageView *imgAtt;

@end

@implementation ZTopicButton

-(id)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, [ZTopicButton getBtnW], 75)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    self.imgLogo = [[ZImageView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.width-10)];
    [self.imgLogo setViewRound];
    [self.imgLogo setUserInteractionEnabled:NO];
    [self addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setUserInteractionEnabled:NO];
    
    [self addSubview:self.lbTitle];
    
    self.imgAtt = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-15, 2, 15, 15)];
    [self.imgAtt setImage:[SkinManager getImageWithName:@"icon_topic_chosen"]];
    [self.imgAtt setUserInteractionEnabled:NO];
    [self.imgAtt setViewRoundNoBorder];
    [self.imgAtt setHidden:YES];
    [self addSubview:self.imgAtt];
    
    [self bringSubviewToFront:self.imgAtt];
}

-(void)setButtonModel:(ModelTag *)model
{
    [self setModelT:model];
    if (model) {
        [self.lbTitle setText:self.modelT.tagName];
        
        [self.imgLogo setImageURLStr:self.modelT.tagLogo placeImage:[SkinManager getDefaultImage]];
        
        [self.imgAtt setHidden:model.isCollection==0];
    }
}

+(CGFloat)getBtnW
{
    return 60;
}

-(void)dealloc
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgAtt);
    OBJC_RELEASE(_modelT);
}

@end
