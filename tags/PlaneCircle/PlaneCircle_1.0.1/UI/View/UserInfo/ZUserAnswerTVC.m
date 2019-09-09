//
//  ZUserAnswerTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserAnswerTVC.h"

@interface ZUserAnswerTVC()

@property (strong, nonatomic) UIView *viewAgree;
@property (strong, nonatomic) UIImageView *imgAgree;
@property (strong, nonatomic) UILabel *lbAgreeTitle;
@property (strong, nonatomic) UILabel *lbAgreeCount;

@property (strong, nonatomic) UIView *viewShare;
@property (strong, nonatomic) UIImageView *imgShare;
@property (strong, nonatomic) UILabel *lbShareTitle;
@property (strong, nonatomic) UILabel *lbShareCount;

@property (strong, nonatomic) UIView *viewCollection;
@property (strong, nonatomic) UIImageView *imgCollection;
@property (strong, nonatomic) UILabel *lbCollectionTitle;
@property (strong, nonatomic) UILabel *lbCollectionCount;

@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZUserAnswerTVC

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
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(void)setViewNil
{
    
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
