//
//  ZUserEditHeaderTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditHeaderTVC.h"
#import "Utils.h"
#import "ZTextView.h"
#import "ZTextField.h"

@interface ZUserEditHeaderTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbEdit;

@property (strong, nonatomic) UIView *viewLine1;

@property (strong, nonatomic) ZTextField *textField;

@property (strong, nonatomic) UIView *viewLine2;

@property (strong, nonatomic) ZTextView *textView;

@end

@implementation ZUserEditHeaderTVC

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
    
    self.imgPhoto = [[ZImageView alloc] initWithImage:[SkinManager getDefaultPhoto]];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    
    self.lbEdit = [[UILabel alloc] init];
    [self.lbEdit setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbEdit setText:@"编辑"];
    [self.lbEdit setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbEdit setTextColor:BLACKCOLOR1];
    [self.viewMain addSubview:self.lbEdit];
    
    self.textField = [[ZTextField alloc] init];
    [self.textField setMaxLength:kNumberNickNameMaxLength];
    [self.textField setPlaceholder:[NSString stringWithFormat:@"昵称[1-%d]的字母,数字,汉字",kNumberNickNameMaxLength]];
    [self.viewMain addSubview:self.textField];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine1];
    
    self.textView = [[ZTextView alloc] init];
    [self.textView setMaxLength:kNumberSignMaxLength];
    [self.textView setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.textView setPlaceholderText:[NSString stringWithFormat:@"个性签名限制%d字符以内", kNumberSignMaxLength]];
    [self.textView setIsHiddenCountLabel:YES];
    [self.viewMain addSubview:self.textView];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine2];
}

-(void)innerEvent
{
    __weak typeof(self) weakSelf = self;
    [self.textField setOnBeginEditText:^{
        if (weakSelf.onBeginEdit) {
            weakSelf.onBeginEdit();
        }
    }];
    [self.textView setOnBeginEditText:^{
        if (weakSelf.onBeginEdit) {
            weakSelf.onBeginEdit();
        }
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 60;
    [self.imgPhoto setFrame:CGRectMake(15, 25, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
    
    [self.lbEdit setFrame:CGRectMake(self.imgPhoto.x, self.imgPhoto.y+imgSize+2, imgSize, self.lbMinH)];
    
    CGFloat rightX = self.space + self.imgPhoto.x + imgSize;
    CGFloat rightW = self.cellW - rightX - self.space;
    [self.textField setViewFrame:CGRectMake(rightX, 10, rightW, 40)];
    
    [self.viewLine1 setFrame:CGRectMake(rightX, self.textField.y+self.textField.height+2, rightW, self.lineH*2)];
    
    [self.textView setViewFrame:CGRectMake(rightX, self.viewLine1.y+self.viewLine1.height+10, rightW, 50)];
    
    [self.viewLine2 setFrame:CGRectMake(rightX, self.textView.y+self.textView.height+2, rightW, self.lineH*2)];
}

-(void)imgPhotoTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPhotoClick) {
            self.onPhotoClick();
        }
    }
}

-(NSString *)getNickName
{
    return self.textField.text;
}
///获取个性签名
-(NSString *)getSign
{
    return self.textView.text;
}

///获取个性签名最大值
-(int)getMaxSignCount
{
    return [self.textField getMaxLength];
}
///获取昵称最大值
-(int)getMaxNickNameCount
{
    return [self.textView getMaxLength];
}

-(void)setUserPhoto:(NSData *)dataPhoto
{
    [self.imgPhoto setImage:[UIImage imageWithData:dataPhoto]];
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    [self.textField setText:model.nickname];
    [self.textView setText:model.sign];
    [self.imgPhoto setPhotoURLStr:model.head_img];
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbEdit);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_textField);
    OBJC_RELEASE(_textView);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 135;
}
+(CGFloat)getH
{
    return 135;
}

@end
