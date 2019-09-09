//
//  ZUserEditHeaderTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/5/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditHeaderTVC.h"
#import "Utils.h"

@interface ZUserEditHeaderTVC()<UITextFieldDelegate,UITextViewDelegate>
{
    NSString *_lastText;
    NSString *_lastInputText;
}
@property (strong, nonatomic) NSString *lastViewText;

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbEdit;

@property (strong, nonatomic) UIView *viewLine1;

@property (strong, nonatomic) UITextField *textNickName;

@property (strong, nonatomic) UIView *viewLine2;

@property (strong, nonatomic) UITextView *textSign;
@property (strong, nonatomic) UILabel *lbSignPlaceholder;

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
    [self.lbEdit setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbEdit setText:@"编辑"];
    [self.lbEdit setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbEdit setTextColor:BLACKCOLOR1];
    [self.viewMain addSubview:self.lbEdit];
    
    self.textNickName = [[UITextField alloc] init];
    [self.textNickName setDelegate:self];
    [self.textNickName setReturnKeyType:(UIReturnKeyDone)];
    [self.textNickName setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textNickName setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textNickName setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.textNickName setPlaceholder:@"昵称[1-12]的字母,数字,汉字"];
    [self.viewMain addSubview:self.textNickName];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine1];
    
    self.textSign = [[UITextView alloc] init];
    [self.textSign setReturnKeyType:(UIReturnKeyDone)];
    [self.textSign setDelegate:self];
    [self.textSign setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textSign setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.viewMain addSubview:self.textSign];
    
    self.lbSignPlaceholder = [[UILabel alloc] init];
    [self.lbSignPlaceholder setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbSignPlaceholder setBackgroundColor:[UIColor clearColor]];
    [self.lbSignPlaceholder setNumberOfLines:1];
    [self.lbSignPlaceholder setText:@"个性签名[<=30]字符"];
    [self.lbSignPlaceholder setUserInteractionEnabled:NO];
    [self.lbSignPlaceholder setTextColor:RGBCOLOR(169, 169, 169)];
    [self.lbSignPlaceholder setHidden:YES];
    [self.lbSignPlaceholder setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.textSign addSubview:self.lbSignPlaceholder];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
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
    [self.textNickName setFrame:CGRectMake(rightX, 10, rightW, 40)];
    
    [self.viewLine1 setFrame:CGRectMake(rightX, self.textNickName.y+self.textNickName.height+2, rightW, self.lineH*2)];
    
    [self.textSign setFrame:CGRectMake(rightX, self.viewLine1.y+self.viewLine1.height+10, rightW, 50)];
    [self.lbSignPlaceholder setFrame:CGRectMake(5, 3, self.textSign.width-10, 20)];
    [self.lbSignPlaceholder setHidden:self.textSign.text.length!=0];
    
    [self.viewLine2 setFrame:CGRectMake(rightX, self.textSign.y+self.textSign.height+2, rightW, self.lineH*2)];
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
    return self.textNickName.text;
}

-(NSString *)getSign
{
    return self.textSign.text;
}

-(void)setUserPhoto:(NSData *)dataPhoto
{
    [self.imgPhoto setImage:[UIImage imageWithData:dataPhoto]];
}

-(void)setCellDataWithModel:(ModelUser *)model
{
    [self.textNickName setText:model.nickname];
    [self.textSign setText:model.sign];
    [self.lbSignPlaceholder setHidden:self.textSign.text.length!=0];
    [self.imgPhoto setPhotoURLStr:model.head_img];
}

-(void)setViewNil
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    OBJC_RELEASE(_lbEdit);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_textSign);
    OBJC_RELEASE(_textNickName);
    OBJC_RELEASE(_lbSignPlaceholder);
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

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.onBeginEdit) {
        self.onBeginEdit();
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)textFieldDidChange:(NSNotification *)sender
{
    if (![_lastText isEqualToString:self.textNickName.text.toTrim]) {
        _lastText = self.textNickName.text.toTrim;
        
        if ([Utils isContainsEmoji:self.textNickName.text.toTrim]) {
            [self.textNickName setText:[self.textNickName.text stringByReplacingOccurrencesOfString:_lastText withString:kEmpty]];
            return;
        }
    }
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _lastInputText = text;
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.onBeginEdit) {
        self.onBeginEdit();
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (![self.lastViewText isEqualToString:textView.text.toTrim]) {
        [self setLastViewText:textView.text.toTrim];
        
        if ([Utils isContainsEmoji:textView.text.toTrim]) {
            [textView setText:[textView.text stringByReplacingOccurrencesOfString:_lastInputText withString:kEmpty]];
            return;
        }
    }
    [self.lbSignPlaceholder setHidden:textView.text.toTrim.length!=0];
}

@end
