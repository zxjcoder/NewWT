//
//  ZNewUserEditBaseTVC.m
//  PlaneLive
//
//  Created by WT on 28/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewUserEditBaseTVC.h"
#import "Utils.h"

@interface ZNewUserEditBaseTVC()

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZNewUserEditBaseTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItemBase];
    }
    return self;
}

-(void)innerInitItemBase
{
    [super innerInit];
    
    self.cellH = [ZNewUserEditBaseTVC getH];
    self.space = 20;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, self.leftW, self.lbH)];
    [self.lbTitle setTextColor:COLORTEXT3];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.textField = [[ZTextField alloc] initWithFrame:CGRectMake(self.rightX, self.cellH/2-20, self.arrowX-self.rightX-5, 40)];
    [self.textField setTextColor:COLORTEXT1];
    [self.textField setIsShowLine:false];
    [self.textField setClearButtonMode:UITextFieldViewModeNever];
    [self.textField setTextAlignment:(NSTextAlignmentRight)];
    [self.textField setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.textField];
    
    ZWEAKSELF
    [self.textField setOnBeginEditText:^{
        if (weakSelf.onBeginEdit) {
            weakSelf.onBeginEdit();
        }
    }];
    
    [self.textField setPlaceholder:@"请输入"];
    
    [self setImageAccessoryView];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight)];
    [self.viewMain addSubview:self.imgLine];
    
    [self.viewMain setFrame:[self getMainFrame]];
}
-(void)setLineHidden
{
    [self.imgLine setHidden:true];
}
-(void)setCellDataWithText:(NSString *)text
{
    [self.textField setText:text];
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
    return 50;
}

@end
