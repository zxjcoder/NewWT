//
//  ZTextView.h
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTextView : UITextView

///文本开始编辑
@property (copy, nonatomic) void(^onBeginEditText)();
///文本结束编辑
@property (copy, nonatomic) void(^onEndEditText)(NSRange range);
///撤销事件
@property (copy, nonatomic) void(^onRevokeChange)(NSRange range, int inputLength);
///文本内容编辑
@property (copy, nonatomic) void(^onTextDidChange)(NSString *text, NSRange range, int inputLength);
///内容高度监听
@property (copy, nonatomic) void(^onContentHeightChange)(CGFloat height);

///设置提示内容
-(void)setPlaceholderText:(NSString *)text;

///设置是否允许换行
-(void)setIsInputNewLine:(BOOL)isNewLine;

///设置内容
-(void)setViewText:(NSString *)text;
///设置最后一次内容
-(void)setViewLastText:(NSString *)text;

@end
