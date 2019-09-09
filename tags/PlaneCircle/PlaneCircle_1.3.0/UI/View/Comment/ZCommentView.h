//
//  ZCommentView.h
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCommentView : UIView

///文本开始编辑
@property (copy, nonatomic) void(^onBeginEditText)();
///文本还行
@property (copy, nonatomic) void(^onReturnText)();
///撤销事件
@property (copy, nonatomic) void(^onRevokeChange)(NSString *text, NSRange range);
///文本内容编辑
@property (copy, nonatomic) void(^onTextEditing)(NSString *text, NSRange range);
///内容高度监听
@property (copy, nonatomic) void(^onViewHeightChange)(CGFloat viewH);

///发布
@property (copy, nonatomic) void(^onPublishClick)(NSString *content);

///设置输入内容
-(void)setTextWithString:(NSString *)text;
///获取输入内容
-(NSString *)getContentText;

///设置输入描述内容
-(void)setPlaceholderText:(NSString *)text;
///设置输入描述内容
-(void)setPlaceholderDefaultText;
///设置按钮文字
-(void)setPublishText:(NSString *)text;
///设置按钮文字
-(void)setPublishDefaultText;

///显示键盘
-(void)setKeyboardShow;
///隐藏键盘
-(void)setKeyboardHidden;

///设置输入最大值
-(void)setMaxInputLength:(int)length;

///设置坐标
-(void)setViewFrame:(CGRect)frame;

///设置按钮状态
-(void)setButtonState:(BOOL)isCommenting;

///发布成功
-(void)setPublishSuccess;

@end
