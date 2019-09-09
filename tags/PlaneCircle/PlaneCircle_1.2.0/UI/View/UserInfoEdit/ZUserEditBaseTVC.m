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
{
    NSString *_lastText;
    NSString *_lastInputText;
}

@property (strong, nonatomic) UIView *viewLine;

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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.textField = [[ZTextField alloc] init];
    [self.textField setDelegate:self];
    [self.textField setPlaceholder:@"未填写"];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setTextAlignment:(NSTextAlignmentRight)];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.textField];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lbTitle setFrame:CGRectMake(self.space, self.cellH/2-self.lbH/2, self.leftW, self.lbH)];
    
    [self.textField setFrame:CGRectMake(self.rightX, 2, self.cellW-self.rightX-self.space, 41)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(NSString *)getText
{
    return self.textField.text;
}

-(void)setViewNil
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_textField);
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

#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(NSNotification *)sender
{
    if (![_lastText isEqualToString:self.textField.text.toTrim]) {
        _lastText = self.textField.text.toTrim;
        
        if ([Utils isContainsEmoji:self.textField.text.toTrim]) {
            [self.textField setText:[self.textField.text stringByReplacingOccurrencesOfString:_lastText withString:kEmpty]];
            return;
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

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


@end
