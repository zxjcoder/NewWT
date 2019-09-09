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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.textField = [[ZTextField alloc] init];
    [self.textField setPlaceholder:kNotFilled];
    [self.textField setClearButtonMode:UITextFieldViewModeNever];
    [self.textField setTextAlignment:(NSTextAlignmentRight)];
    [self.textField setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.textField];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
    
    ZWEAKSELF
    [self.textField setOnBeginEditText:^{
        if (weakSelf.onBeginEdit) {
            weakSelf.onBeginEdit();
        }
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, self.leftW, self.lbH)];
    
    [self.textField setViewFrame:CGRectMake(self.rightX, 2, self.cellW-self.rightX-self.space, 41)];
    
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-self.lineH, self.cellW-self.space*2, self.lineH)];
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
-(NSString *)getText
{
    return self.textField.text;
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
    return 45;
}

@end