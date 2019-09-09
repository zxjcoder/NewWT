//
//  ZFeekBackContentTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackContentTVC.h"
#import "ZTextView.h"

@interface ZFeekBackContentTVC()

@property (strong, nonatomic) ZLabel *lbCount;
@property (strong, nonatomic) ZTextView *textView;

@end

@implementation ZFeekBackContentTVC

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
    self.cellH = [ZFeekBackContentTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    ZLabel *lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(self.space, 13, 200, self.lbMinH))];
    [lbTitle setText:@"图文反馈"];
    [lbTitle setTextColor:COLORTEXT3];
    [lbTitle setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:lbTitle];
    
    ZView *viewText = [[ZView alloc] initWithFrame:CGRectMake(self.space, lbTitle.y+lbTitle.height+13, self.cellW-self.space*2, 140)];
    [viewText setBackgroundColor:COLORVIEWBACKCOLOR2];
    [[viewText layer] setMasksToBounds:true];
    [viewText setViewRound:4 borderWidth:1 borderColor:COLORVIEWBACKCOLOR3];
    [self.viewMain addSubview:viewText];
    
    self.lbCount = [[ZLabel alloc] initWithFrame:(CGRectMake(viewText.width-115, viewText.height-22, 100, 18))];
    [self.lbCount setTextColor:COLORTEXT3];
    [self.lbCount setText:[NSString stringWithFormat:@"%d", kFeedbackContentMaxLength]];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbCount setTextAlignment:(NSTextAlignmentRight)];
    [viewText addSubview:self.lbCount];
    
    self.textView = [[ZTextView alloc] initWithFrame:(CGRectMake(15, 15, viewText.width-30, 100))];
    [self.textView setPlaceholderText:@"请输入反馈的内容"];
    [self.textView setMaxLength:kFeedbackContentMaxLength];
    [self.textView setTextColor:COLORTEXT3];
    [self.textView setBackgroundColor:CLEARCOLOR];
    ZWEAKSELF
    [self.textView setOnTextDidChange:^(NSString *text, NSRange range) {
        [weakSelf setTextCount:text.length];
    }];
    [self.textView setOnBeginEditText:^{
        if (weakSelf.onBeginEditText) {
            weakSelf.onBeginEditText();
        }
    }];
    [viewText addSubview:self.textView];
}
-(NSString *)getText
{
    return self.textView.text;
}
-(void)setTextCount:(NSInteger)length
{
    NSInteger textlength = kFeedbackContentMaxLength - length;
    [self.lbCount setText:[NSString stringWithFormat:@"%d", textlength]];
}
-(void)setText:(NSString *)text
{
    [self.textView setText:text];
    [self setTextCount:text.length];
}
+(CGFloat)getH
{
    return 190;
}

@end
