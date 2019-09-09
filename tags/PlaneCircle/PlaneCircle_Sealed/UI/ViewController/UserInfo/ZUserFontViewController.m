//
//  ZUserFontViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserFontViewController.h"

@interface ZUserFontViewController ()

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///内容区域
@property (strong, nonatomic) UIView *viewContent;
///内容
@property (strong, nonatomic) UILabel *lbContent;
///功能区域
@property (strong, nonatomic) UIView *viewOper;
///选中线
@property (strong, nonatomic) UIView *viewLine;
///最小
@property (strong, nonatomic) UIButton *btnMin;
///标准
@property (strong, nonatomic) UIButton *btnDefault;
///中等
@property (strong, nonatomic) UIButton *btnMiddle;
///大
@property (strong, nonatomic) UIButton *btnBig;
///特大
@property (strong, nonatomic) UIButton *btnLarge;
///字体大小
@property (assign, nonatomic) CGFloat fontSize;
///线的位置
@property (assign, nonatomic) CGRect lineFrame;

@end

@implementation ZUserFontViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kFontSize];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:kDone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_btnBig);
    OBJC_RELEASE(_btnMin);
    OBJC_RELEASE(_btnLarge);
    OBJC_RELEASE(_btnMiddle);
    OBJC_RELEASE(_btnDefault);
    OBJC_RELEASE(_viewOper);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.view setBackgroundColor:VIEW_BACKCOLOR2];
    
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:kSettingFontSize];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:self.fontSize]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.view addSubview:self.lbTitle];
    
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(30, self.view.height/2, self.view.width-60, 40)];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent.layer setMasksToBounds:YES];
    [self.viewContent setViewRoundWithNoBorder];
    [self.view addSubview:self.viewContent];
    
    self.lbContent = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.viewContent.width-40, 20)];
    [self.lbContent setText:kSettingFontSizeDescContent];
    [self.lbContent setFont:[ZFont systemFontOfSize:self.fontSize]];
    [self.lbContent setNumberOfLines:0];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.viewContent addSubview:self.lbContent];
    
    [self setContentFrame];
    
    CGFloat operH = 40;
    self.viewOper = [[UIView alloc] initWithFrame:CGRectMake(0, APP_FRAME_HEIGHT-operH, self.view.width, operH)];
    [self.viewOper setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.viewOper];
    
    CGFloat btnW = self.view.width/5;
    CGFloat lineX = btnW;
    self.lineFrame = CGRectMake(lineX, 0, btnW, 3);
    self.viewLine = [[UIView alloc] initWithFrame:self.lineFrame];
    [self.viewLine setBackgroundColor:MAINCOLOR];
    [self.viewOper addSubview:self.viewLine];
    
    self.btnMin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMin setTitle:kSmall forState:(UIControlStateNormal)];
    [self.btnMin setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [[self.btnMin titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnMin setTag:1];
    [self.btnMin setFrame:CGRectMake(0, 5, btnW, operH-5)];
    [self.btnMin addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewOper addSubview:self.btnMin];
    
    self.btnDefault = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDefault setTitle:kStandard forState:(UIControlStateNormal)];
    [self.btnDefault setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [[self.btnDefault titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnDefault setTag:2];
    [self.btnDefault setFrame:CGRectMake(btnW, 5, btnW, operH-5)];
    [self.btnDefault addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewOper addSubview:self.btnDefault];
    
    self.btnMiddle = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMiddle setTitle:kSecondary forState:(UIControlStateNormal)];
    [self.btnMiddle setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [[self.btnMiddle titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnMiddle setTag:3];
    [self.btnMiddle setFrame:CGRectMake(btnW*2, 5, btnW, operH-5)];
    [self.btnMiddle addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewOper addSubview:self.btnMiddle];
    
    self.btnBig = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnBig setTitle:kLarge forState:(UIControlStateNormal)];
    [self.btnBig setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [[self.btnBig titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnBig setTag:4];
    [self.btnBig setFrame:CGRectMake(btnW*3, 5, btnW, operH-5)];
    [self.btnBig addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewOper addSubview:self.btnBig];
    
    self.btnLarge = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnLarge setTitle:kExtremely forState:(UIControlStateNormal)];
    [self.btnLarge setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [[self.btnLarge titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.btnLarge setTag:5];
    [self.btnLarge setFrame:CGRectMake(btnW*4, 5, btnW, operH-5)];
    [self.btnLarge addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewOper addSubview:self.btnLarge];
    
    switch ((int)self.fontSize) {
        case kFont_Set_Min_Size://小
            [self setItemDefault:self.btnMin.tag width:self.btnMin.width];
            break;
        case kFont_Set_Default_Size://标准
            [self setItemDefault:self.btnDefault.tag width:self.btnDefault.width];
            break;
        case kFont_Set_Middle_Size://中等
            [self setItemDefault:self.btnMiddle.tag width:self.btnMiddle.width];
            break;
        case kFont_Set_Big_Size://大
            [self setItemDefault:self.btnBig.tag width:self.btnBig.width];
            break;
        case kFont_Set_Large_Size://极大
            [self setItemDefault:self.btnLarge.tag width:self.btnLarge.width];
            break;
        default: break;
    }
}

-(void)setContentFrame
{
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:20];
    CGRect contentFrame = self.lbContent.frame;
    contentFrame.size.height = contentH;
    [self.lbContent setFrame:contentFrame];
    
    CGFloat contentY = (APP_FRAME_HEIGHT)/2-(contentH+20)/2;
    [self.viewContent setFrame:CGRectMake(self.viewContent.x, contentY, self.viewContent.width, contentH+20)];
    
    [self.lbTitle setFrame:CGRectMake(0, contentY-35, self.view.width, 25)];
}

- (void)btnItemClick:(UIButton *)sender
{
    [self setItemDefault:sender.tag width:sender.width];
}

-(void)setItemDefault:(NSInteger)tag width:(CGFloat)width
{
    switch (tag) {
        case 1://小
            self.fontSize = kFont_Set_Min_Size;
            break;
        case 2://标准
            self.fontSize = kFont_Set_Default_Size;
            break;
        case 3://中等
            self.fontSize = kFont_Set_Middle_Size;
            break;
        case 4://大
            self.fontSize = kFont_Set_Big_Size;
            break;
        case 5://极大
            self.fontSize = kFont_Set_Large_Size;
            break;
        default: break;
    }
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:self.fontSize]];
    [self.lbContent setFont:[ZFont systemFontOfSize:self.fontSize]];
    [self setContentFrame];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        CGRect lineFrame = self.lineFrame;
        lineFrame.origin.x = width*(tag-1);
        [self.viewLine setFrame:lineFrame];
    }];
}

-(void)btnRightClick
{
    NSString *fontSize = [AppSetting getFontSize];
    if (self.fontSize != [fontSize floatValue]) {
        fontSize = [NSString stringWithFormat:@"%d",(int)self.fontSize];
        [AppSetting setFontSize:fontSize];
        [AppSetting save];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZFontSizeChangeNotification object:fontSize];
    }
    [ZProgressHUD showSuccess:kSettingFontSizeSuccess];
}

@end
