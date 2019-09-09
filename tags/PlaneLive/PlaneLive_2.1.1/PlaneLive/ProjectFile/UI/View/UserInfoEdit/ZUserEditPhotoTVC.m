//
//  ZUserEditPhotoTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditPhotoTVC.h"

@interface ZUserEditPhotoTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@end

@implementation ZUserEditPhotoTVC

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
    
    self.cellH = [ZUserEditPhotoTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.imgPhoto = [[ZImageView alloc] initWithImage:[SkinManager getDefaultPhoto]];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 80;
    [self.imgPhoto setFrame:CGRectMake(self.cellW/2-imgSize/2, 25, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
}

-(void)imgPhotoTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPhotoClick) {
            self.onPhotoClick();
        }
    }
}

-(void)setUserPhoto:(NSData *)dataPhoto
{
    [self.imgPhoto setImage:[UIImage imageWithData:dataPhoto]];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.imgPhoto setPhotoURLStr:model.head_img];
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 125;
}

@end
