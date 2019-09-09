//
//  ZUserEditBaseTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditBaseTVC.h"
#import "Utils.h"

@interface ZUserEditBaseTVC()

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserEditBaseTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZUserEditBaseTVC getH];
    self.space = 20;
   
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.textField = [[ZTextField alloc] init];
    [self.textField setTextColor:COLORTEXT3];
    [self.textField setClearButtonMode:UITextFieldViewModeNever];
    [self.textField setTextAlignment:(NSTextAlignmentLeft)];
    [self.textField setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.textField];
    
    ZWEAKSELF
    [self.textField setOnBeginEditText:^{
        if (weakSelf.onBeginEdit) {
            weakSelf.onBeginEdit();
        }
    }];
    
    [self.textField setPlaceholder:@"请填写"];
    
    [self setImageAccessoryView];
   
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, self.leftW, self.lbH)];
    [self.textField setViewFrame:CGRectMake(self.rightX, self.cellH/2-20, self.cellW-self.rightX-self.space - self.arrowW, 40)];
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight)];
}
///获取最大输入值
-(int)getMaxTextLength
{
    return [self.textField getMaxLength];
}
///设置最大输入值
-(void)setMaxTextLength:(int)length
{
    [self.textField setMaxLength:length];
}
-(void)setCellDataWithText:(NSString *)text
{
    [self.textField setText:text];
}
-(NSString *)getText
{
    return self.textField.text;
}
-(void)setLineHidden
{
    [self.imgLine setHidden:true];
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_textField);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 48;
}

@end
