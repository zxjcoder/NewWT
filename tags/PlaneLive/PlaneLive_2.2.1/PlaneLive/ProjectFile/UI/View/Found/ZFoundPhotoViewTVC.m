//
//  ZFoundPhotoViewTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZFoundPhotoViewTVC.h"

@interface ZFoundPhotoViewTVC()

@property (strong ,nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) ZLabel *lbNickName;

@property (strong, nonatomic) ZLabel *lbDesc;

@end

@implementation ZFoundPhotoViewTVC

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
    
    self.cellH = [ZFoundPhotoViewTVC getH];
 
    CGFloat topH = 25;
    CGFloat imgSize = 115;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(self.cellW/2-imgSize/2, topH, imgSize, imgSize)];
    [[self.imgPhoto layer] setMasksToBounds:YES];
    [self.imgPhoto setViewRoundNoBorder];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imagePhotoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePhotoClick:)];
    [self.imgPhoto addGestureRecognizer:imagePhotoClick];
    
    self.lbNickName = [[ZLabel alloc] initWithFrame:CGRectMake(0, self.imgPhoto.y+self.imgPhoto.height+15, self.cellW, self.lbH)];
    [self.lbNickName setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbNickName setText:kLoginWithSurprise];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:CGRectMake(0, self.lbNickName.y+self.lbNickName.height+kSize5, self.cellW, self.lbH)];
    [self.lbDesc setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setNumberOfLines:1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbDesc];
}

-(void)imagePhotoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPhotoClick) {
            self.onPhotoClick();
        }
    }
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    if (model) {
        [self.lbNickName setText:model.nickname];
        [self.imgPhoto setPhotoURLStr:model.head_img];
    } else {
        [self.lbNickName setText:kLoginWithSurprise];
        [self.imgPhoto setDefaultPhoto];
    }
    NSString *timeSlot = [[NSDate date] toTimeSlot];
    [self.lbDesc setText:[NSString stringWithFormat:@"%@，%@", timeSlot, kListenToSomePractice]];
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbNickName);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return 220;
}

@end
