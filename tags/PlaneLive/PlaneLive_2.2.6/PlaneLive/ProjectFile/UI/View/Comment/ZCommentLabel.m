//
//  ZCommentLabel.m
//  PlaneCircle
//
//  Created by Daniel on 9/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCommentLabel.h"
#import "ClassCategory.h"
#import "ZCalculateLabel.h"
#import "ZFont.h"
#import "TYAttributedLabel.h"
#import "Utils.h"

@interface ZCommentLabel()<TYAttributedLabelDelegate>

///回复内容或评论内容
@property (strong, nonatomic) TYAttributedLabel *lbContent;
///回复内容或评论内容用于计算高度
@property (strong, nonatomic) TYAttributedLabel *lbCalculation;

@property (assign, nonatomic) CGFloat viewHeight;

@property (assign, nonatomic) CGFloat lbHeight;
///数据源
@property (strong, nonatomic) ModelCommentReply *modelCR;

@end

@implementation ZCommentLabel

///初始化对象
-(id)initWithFrame:(CGRect)frame modelReply:(ModelCommentReply *)modelReply
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setModelCR:modelReply];
        
        [self innerInitWithFrame];
    }
    return self;
}

///初始化对象
-(id)initWithCalculation
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}
///设置坐标
-(void)setLabelFrame:(CGRect)frame
{
    [self setFrame:frame];
}
///设置数据源
-(void)setLabelData:(ModelCommentReply *)model
{
    [self setModelCR:model];
    
    CGRect contentFrame = CGRectMake(kSize13, 0, self.width-kSize13*2, self.lbHeight);
    [self.lbCalculation setFrame:contentFrame];
    
    if ([self.modelCR.parent_id integerValue] > 0) {
        [self.lbCalculation setText:[NSString stringWithFormat:@"%@%@%@: %@", self.modelCR.hnickname, kReply, self.modelCR.nickname, self.modelCR.content]];
    } else {
        [self.lbCalculation setText:[NSString stringWithFormat:@"%@: %@", self.modelCR.hnickname, self.modelCR.content]];
    }
    [self.lbCalculation sizeToFit];
    
    self.viewHeight = self.lbCalculation.y+self.lbCalculation.height;
}
-(void)innerInit
{
    self.viewHeight = 24;
    self.lbHeight = 20;
    
    if (!self.lbCalculation) {
        self.lbCalculation = [[TYAttributedLabel alloc] init];
        [self.lbCalculation setUserInteractionEnabled:YES];
        [self.lbCalculation setBackgroundColor:CLEARCOLOR];
        [self.lbCalculation setTextColor:BLACKCOLOR1];
        [self.lbCalculation setLinkColor:NICKNAMECOLOR];
        [self.lbCalculation setLinesSpacing:2];
        [self.lbCalculation setHighlightedLinkColor:NICKNAMECOLOR];
        [self.lbCalculation setHighlightedLinkBackgroundColor:RGBCOLOR(227, 226, 226)];
        [self.lbCalculation setHighlightedLinkBackgroundRadius:2];
        [self addSubview:self.lbCalculation];
    }
    [self setCellFontSize];
}
-(void)innerInitWithFrame
{
    self.viewHeight = 20;
    self.lbHeight = 20;
    
    [self setBackgroundColor:CLEARCOLOR];
    [self setUserInteractionEnabled:YES];
    if (!self.lbContent) {
        self.lbContent = [[TYAttributedLabel alloc] init];
        [self.lbContent setUserInteractionEnabled:YES];
        [self.lbContent setBackgroundColor:CLEARCOLOR];
        [self.lbContent setTextColor:BLACKCOLOR1];
        [self.lbContent setLinkColor:NICKNAMECOLOR];
        [self.lbContent setLinesSpacing:2];
        [self.lbContent setHighlightedLinkColor:NICKNAMECOLOR];
        [self.lbContent setHighlightedLinkBackgroundColor:RGBCOLOR(227, 226, 226)];
        [self.lbContent setHighlightedLinkBackgroundRadius:2];
        [self.lbContent setDelegate:self];
        [self addSubview:self.lbContent];
        
        UITapGestureRecognizer *backViewClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewClick:)];
        [self.lbContent addGestureRecognizer:backViewClick];
        
        UILongPressGestureRecognizer *backViewLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backViewLongPress:)];
        [self.lbContent addGestureRecognizer:backViewLongPress];
    }
    [self setCellFontSize];
    
    [self setViewFrame];
}
///设置坐标
-(void)setViewFrame
{
    CGRect contentFrame = CGRectMake(kSize13, 0, self.width-kSize13*2, self.lbHeight);
    [self.lbContent setFrame:contentFrame];
    
    if ([self.modelCR.parent_id integerValue] > 0) {
        [self.lbContent appendLinkWithText:self.modelCR.hnickname linkFont:self.lbContent.font linkColor:NICKNAMECOLOR underLineStyle:kCTUnderlineStyleNone linkData:self.modelCR.hnickname];
        [self.lbContent appendText:kReply];
        [self.lbContent appendLinkWithText:[NSString stringWithFormat:@"%@: ",self.modelCR.nickname] linkFont:self.lbContent.font linkColor:NICKNAMECOLOR underLineStyle:kCTUnderlineStyleNone linkData:self.modelCR.nickname];
    } else {
         [self.lbContent appendLinkWithText:[NSString stringWithFormat:@"%@: ",self.modelCR.hnickname] linkFont:self.lbContent.font linkColor:NICKNAMECOLOR underLineStyle:kCTUnderlineStyleNone linkData:self.modelCR.hnickname];
    }
    [self.lbContent appendText:self.modelCR.content];
    
    [self.lbContent sizeToFit];
    
    self.viewHeight = self.lbContent.y+self.lbContent.height;
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    CGFloat fontSize = [[AppSetting getFontSize] floatValue];
    [self.lbContent setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(fontSize)]];
    [self.lbCalculation setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(fontSize)]];
}
-(void)btnBackClick
{
    [self setBackgroundColor:CLEARCOLOR];
    if (self.onContentClick) {
        self.onContentClick(self.modelCR);
    }
}
-(void)btnBackUp
{
    [self setBackgroundColor:CLEARCOLOR];
}
-(void)btnBackDown
{
    [self setBackgroundColor:RGBCOLOR(227, 226, 226)];
}
///背景按钮
-(void)backViewClick:(UIGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateEnded:
            [self btnBackClick];
            break;
        case UIGestureRecognizerStateBegan:
            [self btnBackDown];
            break;
        default:
            [self btnBackDown];
            break;
    }
}
///背景按钮
-(void)backViewLongPress:(UIGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateEnded:
            [self btnBackUp];
            break;
        default:
            [self btnBackDown];
            break;
    }
}
///获取View高度
-(CGFloat)getViewH
{
    return self.viewHeight;
}

-(void)dealloc
{
    OBJC_RELEASE(_modelCR);
    [_lbContent setDelegate:nil];
    OBJC_RELEASE(_lbCalculation);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_onContentClick);
    OBJC_RELEASE(_onUserClick);
}

#pragma mark - TYAttributedLabelDelegate

// 点击代理
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        TYLinkTextStorage *linekTextStorage = (TYLinkTextStorage*)textStorage;
        if ([self.modelCR.parent_id integerValue] > 0) {
            ///第一个昵称
            if ([linekTextStorage.text isEqualToString:self.modelCR.hnickname]) {
                if (self.onUserClick) {
                    ModelUserBase *modelUB = [[ModelUserBase alloc] init];
                    [modelUB setUserId:self.modelCR.user_id];
                    [modelUB setNickname:self.modelCR.hnickname];
                    self.onUserClick(modelUB);
                }
            } else {
                if (self.onUserClick) {
                    ModelUserBase *modelUB = [[ModelUserBase alloc] init];
                    [modelUB setUserId:self.modelCR.reply_user_id];
                    [modelUB setNickname:self.modelCR.nickname];
                    self.onUserClick(modelUB);
                }
            }
        } else {
            if (self.onUserClick) {
                ModelUserBase *modelUB = [[ModelUserBase alloc] init];
                [modelUB setUserId:self.modelCR.user_id];
                [modelUB setNickname:self.modelCR.hnickname];
                self.onUserClick(modelUB);
            }
        }
    }
}

@end
