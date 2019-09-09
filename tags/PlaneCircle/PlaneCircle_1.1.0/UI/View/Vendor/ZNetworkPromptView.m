//
//  ZNetworkPromptView.m
//  PlaneCircle
//
//  Created by Daniel on 8/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZNetworkPromptView.h"

@interface ZNetworkPromptView()

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UILabel *lbContent;

@end

static ZNetworkPromptView *networkPromptView;

@implementation ZNetworkPromptView

+(ZNetworkPromptView *)shareNetworkPromptView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkPromptView = [[ZNetworkPromptView alloc] init];
    });
    return networkPromptView;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:CLEARCOLOR];
}

-(void)createContentView
{
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, APP_NAVIGATION_HEIGHT, APP_FRAME_WIDTH, 45)];
    [self.viewContent setBackgroundColor:RGBCOLOR(254, 223, 224)];
    [self addSubview:self.viewContent];
}

-(void)createContentLabel
{
    self.lbContent = [[UILabel alloc] initWithFrame:CGRectMake(kSize15, self.viewContent.height/2-25/2, APP_FRAME_WIDTH, 25)];
    [self.lbContent setText:@"当前网络不可用，请检查你的网络设置"];
    [self.lbContent setTextColor:BLACKCOLOR];
    [self.lbContent setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:1];
    [self addSubview:self.lbContent];
}

///显示
-(void)show
{
  
}
///隐藏
-(void)dismiss
{
    
}

@end
