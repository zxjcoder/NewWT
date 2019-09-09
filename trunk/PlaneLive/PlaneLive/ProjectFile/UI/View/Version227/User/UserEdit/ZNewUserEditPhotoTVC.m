//
//  ZNewUserEditPhotoTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditPhotoTVC.h"

@interface ZNewUserEditPhotoTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) UIImageView *imageLine;

@end

@implementation ZNewUserEditPhotoTVC

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
    
    self.cellH = [ZNewUserEditPhotoTVC getH];
    self.space = 20;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(self.space, self.cellH/2-12, 80, 24))];
    [self.lbTitle setText:@"头像"];
    [self.lbTitle setTextColor:COLORTEXT3];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    CGFloat imageSize = 32;
    CGRect photoFrame = CGRectMake(self.cellW-self.space-imageSize, self.cellH / 2 - imageSize / 2, imageSize, imageSize);
    self.imgPhoto = [[ZImageView alloc] initWithFrame:photoFrame];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.imgPhoto setViewRound];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.imageLine = [UIImageView getDLineView];
    self.imageLine.frame = CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight);
    [self.viewMain addSubview:self.imageLine];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    [self.viewMain setFrame:[self getMainFrame]];
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
    [self.imgPhoto setPhotoURLStr:model.head_img placeImage:[SkinManager getDefaultPhoto]];
    
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
    return 60;
}

@end
