//
//  ZUserEditPhotoTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditPhotoTVC.h"
#import "ZTextField.h"

@interface ZUserEditPhotoTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;
@property (strong, nonatomic) ZImageView *imgIcon;
@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZLabel *lbNickName;
@property (strong, nonatomic) ZLabel *lbSign;
@property (strong, nonatomic) ZTextField *textNickName;
@property (strong, nonatomic) ZTextField *textSign;
@property (strong, nonatomic) UIImageView *imageLine;

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
    self.space = 20;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    CGFloat imageSize = 62;
    self.imgPhoto.frame = CGRectMake(self.space, self.cellH / 2 - imageSize / 2, imageSize, imageSize);
    [self.imgPhoto setViewRound];
    
    self.imgIcon = [[ZImageView alloc] init];
    [self.imgIcon setUserInteractionEnabled:false];
    self.imgIcon.frame = CGRectMake(self.imgPhoto.x + self.imgPhoto.width - 20, self.imgPhoto.y + self.imgPhoto.height - 20, 20, 20);
    [self.viewMain addSubview:self.imgIcon];
    
    [self.viewMain sendSubviewToBack:self.imgPhoto];
    
    CGFloat contentX = self.imgPhoto.x + self.imgPhoto.width + 15;
    CGFloat contentW = self.cellW - contentX - self.space;
    self.viewContent = [[ZView alloc] initWithFrame:(CGRectMake(contentX, 15, contentW, self.cellH - 30))];
    [self.viewMain addSubview:self.viewContent];
    
    self.lbNickName = [[ZLabel alloc] initWithFrame:(CGRectMake(0, 0, contentW, self.lbH))];
    [self.lbNickName setTextColor:COLORTEXT3];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewContent addSubview:self.lbNickName];
    
    self.textNickName = [[ZTextField alloc] initWithFrame:(CGRectMake(0, self.lbNickName.y + self.lbNickName.height + 5, contentW, 30))];
    [self.textNickName setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.textNickName setTextColor:COLORTEXT3];
    [self.textNickName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textNickName setTextAlignment:(NSTextAlignmentLeft)];
    [self.viewContent addSubview:self.textNickName];
    
    self.imageLine = [UIImageView getDLineView];
    self.imageLine.frame = CGRectMake(0, self.viewContent.height / 2, self.viewContent.width, kLineHeight);
    [self.viewContent addSubview:self.imageLine];
    
    self.lbSign = [[ZLabel alloc] initWithFrame:(CGRectMake(0, self.imageLine.y + 10, contentW, self.lbH))];
    [self.lbSign setTextColor:COLORTEXT3];
    [self.lbSign setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewContent addSubview:self.lbSign];
    
    self.textSign = [[ZTextField alloc] initWithFrame:(CGRectMake(0, self.lbSign.y + self.lbSign.height + 5, contentW, 30))];
    [self.textSign setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.textSign setTextColor:COLORTEXT3];
    [self.textSign setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textSign setTextAlignment:(NSTextAlignmentLeft)];
    [self.viewContent addSubview:self.textSign];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textSign setViewFrame:CGRectMake(0, self.lbSign.y + self.lbSign.height + 5, self.viewContent.width, 30)];
    [self.textNickName setViewFrame:CGRectMake(0, self.lbNickName.y + self.lbNickName.height + 5,  self.lbNickName.width, 30)];
    
    self.imgIcon.image = [SkinManager getImageWithName:@"camera"];
    [self.lbSign setText:kSign];
    [self.lbNickName setText:@"昵称"];
    [self.textNickName setPlaceholder:@"请输入昵称"];
    [self.textSign setPlaceholder:@"请简单介绍一下自己"];
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
    self.textNickName.text = model.nickname;
    self.textSign.text = model.sign;
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    [super setViewNil];
}
///获取个性签名
-(NSString *)getNickName
{
    return self.textNickName.text;
}
///获取个性签名
-(NSString *)getSign
{
    return self.textSign.text;
}
-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 140;
}

@end
