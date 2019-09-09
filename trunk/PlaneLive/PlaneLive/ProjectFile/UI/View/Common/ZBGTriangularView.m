//
//  ZBGTriangularView.m
//  PlaneLive
//
//  Created by WT on 21/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBGTriangularView.h"
#import "ZLabel.h"

@interface ZBGTriangularView()

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZView *viewBG;

@end

@implementation ZBGTriangularView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [self setBackgroundColor:CLEARCOLOR];
    
    self.viewBG = [[ZView alloc] initWithFrame:(CGRectMake(0, 0, self.width, self.height-4))];
    [[self.viewBG layer] setMasksToBounds:true];
    [self.viewBG setBackgroundColor:COLORTEXT1];
    [self.viewBG setUserInteractionEnabled:false];
    [self.viewBG setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewBG];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(11, 5, self.width-22, 16))];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbTitle setUserInteractionEnabled:false];
    [self.viewBG addSubview:self.lbTitle];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.viewBG setFrame:CGRectMake(0, 0, self.width, self.height-4)];
    [self.lbTitle setFrame:(CGRectMake(11, 5, self.width-22, 16))];
}
-(void)setErrorText:(NSString *)text
{
    [self.lbTitle setText:text];
    CGFloat titleW = [self.lbTitle getLabelWidthWithMinWidth:0];
    [self setFrame:(CGRectMake(self.x, self.y, 22+titleW, self.height))];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    //获取绘图的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawTriangle:context];
}
-(void)drawTriangle:(CGContextRef)context
{
    //添加绘图路径
    CGFloat startY = self.height-4;
    CGFloat startX = 12;
    CGFloat tsize = 8;
    CGContextMoveToPoint(context, startX, startY);//起始点
    CGContextAddLineToPoint(context, startX+tsize, startY); //终点
    CGContextAddLineToPoint(context, startX+tsize/2, startY+tsize/2); //终点
    CGContextAddLineToPoint(context, startX, startY); //终点
    //描边的颜色
    CGFloat redColor[4] = {44/255,50/255,65/255,1.0};
    CGContextSetStrokeColor(context, redColor);
    //填充的颜色
    CGFloat greenColor[4] = {44/255,50/255,65/255,1.0};
    CGContextSetFillColor(context, greenColor);
    //线宽
    CGContextSetLineWidth(context, 0);
    //线的连接点的类型(miter尖角、round圆角、bevel平角)
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    //绘图(设置既填充有描边)
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end
