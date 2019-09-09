//
//  ZLoginAccountTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginAccountTVC.h"
#import "Utils.h"
#import "ZTextField.h"

@interface ZLoginAccountTVC()

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) ZTextField *textAccount;

@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZLoginAccountTVC

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
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_account"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.textAccount = [[ZTextField alloc] init];
    [self.textAccount setTextFieldIndex:ZTextFieldIndexLoginAccount];
    [self.textAccount setKeyboardType:(UIKeyboardTypePhonePad)];
    [self.textAccount setPlaceholder:kPleaseEnterPhone];
    ZWEAKSELF
    [self.textAccount setOnEndEditText:^(NSString *text) {
        if (weakSelf.onBeginEditText) {
            weakSelf.onBeginEditText();
        }
    }];
    [self.textAccount setBorderStyle:(UITextBorderStyleNone)];
    [self.textAccount setClearButtonMode:(UITextFieldViewModeWhileEditing)];
    [self.textAccount setMaxLength:kNumberPhomeMaxLength];
    [self.viewMain addSubview:self.textAccount];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat spaceX = 40;
    CGFloat imgSize = 13;
    [self.imgIcon setFrame:CGRectMake(spaceX, self.cellH/2-imgSize/2, imgSize, imgSize)];
    CGFloat textH = 35;
    CGFloat textX = self.imgIcon.x+self.imgIcon.width+10;
    CGFloat textW = self.cellW-textX-spaceX;
    [self.textAccount setViewFrame:CGRectMake(textX, self.cellH/2-textH/2, textW, textH)];
    
    [self.viewLine setFrame:CGRectMake(spaceX, self.cellH-self.lineH, self.cellW-spaceX*2, self.lineH)];
}

-(void)setText:(NSString *)text
{
    [self.textAccount setText:text];
}
-(NSString *)getText
{
    return [self.textAccount text];
}

-(void)setViewNil
{
    OBJC_RELEASE(_textAccount);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_viewLine);
    
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
