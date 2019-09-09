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
///撤销事件
@property (copy, nonatomic) void(^onRevokeChange)(NSRange range, NSInteger inputLength);
///文本内容编辑
@property (copy, nonatomic) void(^onTextEditing)(NSString *text, NSRange range, NSInteger inputLength);
///内容高度监听
@property (copy, nonatomic) void(^onViewHeightChange)(CGFloat viewH);

///发布
@property (copy, nonatomic) void(^onPublishClick)(NSString *content);

///设置输入内容
-(void)setTextWithString:(NSString *)text;
///获取输入内容
-(NSString *)getContentText;

///设置坐标
-(void)setViewFrame:(CGRect)frame;

///设置按钮状态
-(void)setButtonState:(BOOL)isCommenting;

///发布成功
-(void)setPublishSuccess;

@end
