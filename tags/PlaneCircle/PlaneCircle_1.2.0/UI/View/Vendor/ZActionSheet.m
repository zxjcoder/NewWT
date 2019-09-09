//
//  ActionSheet.m
//  Product
//
//  Created by Daniel on 15/8/3.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import "ZActionSheet.h"
#import "ClassCategory.h"

//各种颜色样式
#define CANCEL_BUTTON_COLOR                     [UIColor whiteColor]
#define BUTTON_TEXT_COLOR                       RGBCOLOR(67, 67, 67)
#define CLEARBUTTON_TEXT_COLOR                  MAINCOLOR
#define DESTRUCTIVE_BUTTON_COLOR                [UIColor whiteColor]
#define OTHER_BUTTON_COLOR                      [UIColor whiteColor]
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define CORNER_RADIUS                           0
//背景区域设置
#define BACKGROUNDVIEW_INTERVAL_WIDTH           0
#define BACKGROUNDVIEW_WIDTH                    (APP_FRAME_WIDTH-BACKGROUNDVIEW_INTERVAL_WIDTH*2)
//按钮部分间隔
#define BUTTON_INTERVAL_HEIGHT                  0
#define BUTTON_HEIGHT                           50
#define BUTTON_INTERVAL_WIDTH                   0
#define BUTTON_WIDTH                            (BACKGROUNDVIEW_WIDTH-BUTTON_INTERVAL_WIDTH*2)
#define BUTTONTITLE_FONT                        [UIFont systemFontOfSize:15]
#define BUTTONTITLE_BOLDFONT                    [UIFont boldSystemFontOfSize:15]
#define BUTTON_BORDER_WIDTH                     0.5f
#define BUTTON_BORDER_COLOR                     [UIColor colorWithRed:222/255.00f green:222/255.00f blue:222/255.00f alpha:0.8].CGColor
//标题部分间隔
#define TITLE_INTERVAL_HEIGHT                   0
#define TITLE_HEIGHT                            50
#define TITLE_INTERVAL_WIDTH                    BUTTON_INTERVAL_WIDTH
#define TITLE_WIDTH                             BUTTON_WIDTH
#define TITLE_FONT                              [UIFont systemFontOfSize:14]
#define SHADOW_OFFSET                           CGSizeMake(0, 0.8f)
#define TITLE_NUMBER_LINES                      2
//边框幅度
#define GroundViewRound                         0
//动画时间
#define ANIMATE_DURATION                        0.25f

@interface ZActionSheet ()

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) NSString *actionTitle;
@property (nonatomic,assign) NSInteger postionIndexNumber;
@property (nonatomic,assign) BOOL isHadTitle;
@property (nonatomic,assign) BOOL isHadDestructionButton;
@property (nonatomic,assign) BOOL isHadOtherButton;
@property (nonatomic,assign) BOOL isHadCancelButton;
@property (nonatomic,assign) CGFloat ActionSheetHeight;

@property (nonatomic,assign) id<ZActionSheetDelegate>delegate;

@end

@interface ZActionSheet()<UIActionSheetDelegate>
{
    UIActionSheet *_actionSheet;
}

@end

@implementation ZActionSheet

-(void)dealloc
{
    self.delegate = nil;
    OBJC_RELEASE(_backGroundView);
    OBJC_RELEASE(_actionTitle);
}

- (id)initWithTitle:(NSString *)title delegate:(id<ZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;
{
    self = [super init];
    if (self) {
        
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        [self creatButtonsWithTitle:title cancelButtonTitle:cancelButtonTitle destructionButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitlesArray];
        
    }
    return self;
}

///图片选择
- (id)initWithPictureSelectionDelegate:(id<ZActionSheetDelegate>)delegate
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        [self creatButtonsWithCancelButtonTitle:kCancel otherButtonTitles:@[kCAlbum,kCPhotograph] otherButtonIcons:@[@"icon_tuku",@"icon_paizhao"]];
        
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

#pragma mark - CreatButtonAndTitle
///初始化图片选择按钮的对象
- (void)creatButtonsWithCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray otherButtonIcons:(NSArray *)otherButtonIconsArray
{
    //初始化
    self.isHadTitle = NO;
    self.isHadDestructionButton = NO;
    self.isHadOtherButton = NO;
    self.isHadCancelButton = NO;
    
    //初始化ACtionView的高度为0
    self.ActionSheetHeight = 0;
    
    //初始化IndexNumber为0;
    self.postionIndexNumber = 0;
    
    //生成ActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(BACKGROUNDVIEW_INTERVAL_WIDTH, APP_FRAME_HEIGHT, BACKGROUNDVIEW_WIDTH, 0)];
    self.backGroundView.backgroundColor = [UIColor clearColor];
    [[self.backGroundView layer] setMasksToBounds:YES];
    [self.backGroundView setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
    
    //给ActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backGroundView];
    
    if (otherButtonTitlesArray) {
        if (otherButtonTitlesArray.count > 0) {
            self.isHadOtherButton = YES;
            
            //当无title与destructionButton时
            if (self.isHadTitle == NO && self.isHadDestructionButton == NO) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] icon:[otherButtonIconsArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.postionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else{
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                    
                    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(otherButton.x, otherButton.y, otherButton.width, 10)];
                    [viewTop setUserInteractionEnabled:NO];
                    [viewTop setBackgroundColor:otherButton.backgroundColor];
                    [self.backGroundView addSubview:viewTop];
                    
                    self.postionIndexNumber++;
                    if (i==(otherButtonTitlesArray.count-1)) {
                        [otherButton setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
                    }
                }
            }
            
            //当有title或destructionButton时
            if (self.isHadTitle == YES || self.isHadDestructionButton == YES) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.postionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    [otherButton setFrame:CGRectMake(otherButton.frame.origin.x, self.ActionSheetHeight, otherButton.frame.size.width, otherButton.frame.size.height)];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else{
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                    
                    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(otherButton.x, otherButton.y, otherButton.width, 10)];
                    [viewTop setUserInteractionEnabled:NO];
                    [viewTop setBackgroundColor:otherButton.backgroundColor];
                    [self.backGroundView addSubview:viewTop];
                    
                    self.postionIndexNumber++;
                    if (i==(otherButtonTitlesArray.count-1)) {
                        //                        [otherButton setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
                    }
                }
            }
        }
    }
    
    if (cancelButtonTitle) {
        self.isHadCancelButton = YES;
        
        UIButton *cancelButton = [self creatCancelButtonWith:cancelButtonTitle];
        
        cancelButton.tag = self.postionIndexNumber;
        [cancelButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        //当没title destructionButton otherbuttons时
        if (self.isHadTitle == NO && self.isHadDestructionButton == NO && self.isHadOtherButton == NO) {
            self.ActionSheetHeight = self.ActionSheetHeight + cancelButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
        }
        
        //当有title或destructionButton或otherbuttons时
        if (self.isHadTitle == YES || self.isHadDestructionButton == YES || self.isHadOtherButton == YES) {
            [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, self.ActionSheetHeight, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            self.ActionSheetHeight = self.ActionSheetHeight + cancelButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;
        }
        //        [cancelButton setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
        [self.backGroundView addSubview:cancelButton];
        
        self.postionIndexNumber++;
    }
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [ws.backGroundView setFrame:CGRectMake(BACKGROUNDVIEW_INTERVAL_WIDTH, APP_FRAME_HEIGHT-ws.ActionSheetHeight, BACKGROUNDVIEW_WIDTH, ws.ActionSheetHeight)];
    } completion:^(BOOL finished) {
        
    }];
}
///初始化普通按钮的对象
- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructionButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray
{
    //初始化
    self.isHadTitle = NO;
    self.isHadDestructionButton = NO;
    self.isHadOtherButton = NO;
    self.isHadCancelButton = NO;
    
    //初始化ACtionView的高度为0
    self.ActionSheetHeight = 0;
    
    //初始化IndexNumber为0;
    self.postionIndexNumber = 0;
    
    //生成ActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(BACKGROUNDVIEW_INTERVAL_WIDTH, APP_FRAME_HEIGHT, BACKGROUNDVIEW_WIDTH, 0)];
    self.backGroundView.backgroundColor = [UIColor clearColor];
    [[self.backGroundView layer] setMasksToBounds:YES];
    [self.backGroundView setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
    
    //给ActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backGroundView];
    
    if (title.length>0) {
        self.isHadTitle = YES;
        UILabel *titleLabel = [self creatTitleLabelWith:title];
        self.ActionSheetHeight = self.ActionSheetHeight + 2*TITLE_INTERVAL_HEIGHT+TITLE_HEIGHT;
        [self.backGroundView addSubview:titleLabel];
    }
    
    if (destructiveButtonTitle) {
        self.isHadDestructionButton = YES;
        
        UIButton *destructiveButton = [self creatDestructiveButtonWith:destructiveButtonTitle];
        destructiveButton.tag = self.postionIndexNumber;
        [destructiveButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isHadTitle == YES) {
            //当有title时
            [destructiveButton setFrame:CGRectMake(destructiveButton.frame.origin.x, self.ActionSheetHeight, destructiveButton.frame.size.width, destructiveButton.frame.size.height)];
            
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0) {
                self.ActionSheetHeight = self.ActionSheetHeight + destructiveButton.frame.size.height+BUTTON_INTERVAL_HEIGHT/2;
            }
            else{
                self.ActionSheetHeight = self.ActionSheetHeight + destructiveButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;
            }
        }
        else{
            //当无title时
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0) {
                self.ActionSheetHeight = self.ActionSheetHeight + destructiveButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT+(BUTTON_INTERVAL_HEIGHT/2));
            }
            else{
                self.ActionSheetHeight = self.ActionSheetHeight + destructiveButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
            }
        }
        [self.backGroundView addSubview:destructiveButton];
        
        self.postionIndexNumber++;
        if (otherButtonTitlesArray.count==0) {
//            [destructiveButton setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
        }
    }
    
    if (otherButtonTitlesArray) {
        if (otherButtonTitlesArray.count > 0) {
            self.isHadOtherButton = YES;
            
            //当无title与destructionButton时
            if (self.isHadTitle == NO && self.isHadDestructionButton == NO) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.postionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else{
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                    
                    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(otherButton.x, otherButton.y, otherButton.width, 10)];
                    [viewTop setUserInteractionEnabled:NO];
                    [viewTop setBackgroundColor:otherButton.backgroundColor];
                    [self.backGroundView addSubview:viewTop];
                    
                    self.postionIndexNumber++;
                    if (i==(otherButtonTitlesArray.count-1)) {
                        [otherButton setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
                    }
                }
            }
            
            //当有title或destructionButton时
            if (self.isHadTitle == YES || self.isHadDestructionButton == YES) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.postionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    [otherButton setFrame:CGRectMake(otherButton.frame.origin.x, self.ActionSheetHeight, otherButton.frame.size.width, otherButton.frame.size.height)];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else{
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                    
                    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(otherButton.x, otherButton.y, otherButton.width, 10)];
                    [viewTop setUserInteractionEnabled:NO];
                    [viewTop setBackgroundColor:otherButton.backgroundColor];
                    [self.backGroundView addSubview:viewTop];
                    
                    self.postionIndexNumber++;
                    if (i==(otherButtonTitlesArray.count-1)) {
//                        [otherButton setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
                    }
                }
            }
        }
    }
    
    if (cancelButtonTitle) {
        self.isHadCancelButton = YES;
        
        UIButton *cancelButton = [self creatCancelButtonWith:cancelButtonTitle];
        
        cancelButton.tag = self.postionIndexNumber;
        [cancelButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        //当没title destructionButton otherbuttons时
        if (self.isHadTitle == NO && self.isHadDestructionButton == NO && self.isHadOtherButton == NO) {
            self.ActionSheetHeight = self.ActionSheetHeight + cancelButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
        }
        
        //当有title或destructionButton或otherbuttons时
        if (self.isHadTitle == YES || self.isHadDestructionButton == YES || self.isHadOtherButton == YES) {
            [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, self.ActionSheetHeight, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            self.ActionSheetHeight = self.ActionSheetHeight + cancelButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;
        }
//        [cancelButton setViewRound:GroundViewRound borderWidth:0 borderColor:CLEARCOLOR];
        [self.backGroundView addSubview:cancelButton];
        
        self.postionIndexNumber++;
    }
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [ws.backGroundView setFrame:CGRectMake(BACKGROUNDVIEW_INTERVAL_WIDTH, APP_FRAME_HEIGHT-ws.ActionSheetHeight, BACKGROUNDVIEW_WIDTH, ws.ActionSheetHeight)];
    } completion:^(BOOL finished) {
        
    }];
}
///创建标题
- (UILabel *)creatTitleLabelWith:(NSString *)title
{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_INTERVAL_WIDTH, TITLE_INTERVAL_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.shadowColor = [UIColor blackColor];
    titlelabel.shadowOffset = SHADOW_OFFSET;
    titlelabel.font = TITLE_FONT;
    titlelabel.text = title;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.numberOfLines = TITLE_NUMBER_LINES;
    return titlelabel;
}
///创建优先级高的按钮
- (UIButton *)creatDestructiveButtonWith:(NSString *)destructiveButtonTitle
{
    UIButton *destructiveButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    destructiveButton.layer.masksToBounds = YES;
    destructiveButton.layer.cornerRadius = CORNER_RADIUS;
    
    destructiveButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    destructiveButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    destructiveButton.backgroundColor = DESTRUCTIVE_BUTTON_COLOR;
    [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
    destructiveButton.titleLabel.font = BUTTONTITLE_FONT;
    
    [destructiveButton setTitleColor:BUTTON_TEXT_COLOR forState:UIControlStateNormal];
    [destructiveButton setTitleColor:BUTTON_TEXT_COLOR forState:UIControlStateHighlighted];
    return destructiveButton;
}
///创建带图片的普通按钮
- (UIButton *)creatOtherButtonWith:(NSString *)otherButtonTitle icon:(NSString *)icon withPostion:(NSInteger )postionIndex
{
    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT + (postionIndex*(BUTTON_HEIGHT+(BUTTON_INTERVAL_HEIGHT/2))), BUTTON_WIDTH, BUTTON_HEIGHT)];
    otherButton.layer.masksToBounds = YES;
    otherButton.layer.cornerRadius = CORNER_RADIUS;
    
    otherButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    otherButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    otherButton.backgroundColor = OTHER_BUTTON_COLOR;
    [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    otherButton.titleLabel.font = BUTTONTITLE_FONT;
    [otherButton setImage:[UIImage imageNamed:icon] forState:(UIControlStateNormal)];
    [otherButton setImage:[UIImage imageNamed:icon] forState:(UIControlStateHighlighted)];
    [otherButton setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 20))];
    [otherButton setTitleColor:BUTTON_TEXT_COLOR forState:UIControlStateNormal];
    [otherButton setTitleColor:BUTTON_TEXT_COLOR forState:UIControlStateHighlighted];
    return otherButton;
}
///创建没图片的普通按钮
- (UIButton *)creatOtherButtonWith:(NSString *)otherButtonTitle withPostion:(NSInteger )postionIndex
{
    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT + (postionIndex*(BUTTON_HEIGHT+(BUTTON_INTERVAL_HEIGHT/2))), BUTTON_WIDTH, BUTTON_HEIGHT)];
    otherButton.layer.masksToBounds = YES;
    otherButton.layer.cornerRadius = CORNER_RADIUS;
    
    otherButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    otherButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    otherButton.backgroundColor = OTHER_BUTTON_COLOR;
    [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    otherButton.titleLabel.font = BUTTONTITLE_FONT;
    [otherButton setTitleColor:BUTTON_TEXT_COLOR forState:UIControlStateNormal];
    [otherButton setTitleColor:BUTTON_TEXT_COLOR forState:UIControlStateHighlighted];
    return otherButton;
}
///创建取消按钮
- (UIButton *)creatCancelButtonWith:(NSString *)cancelButtonTitle
{
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = CORNER_RADIUS;
    
    cancelButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    cancelButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    cancelButton.backgroundColor = CANCEL_BUTTON_COLOR;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = BUTTONTITLE_BOLDFONT;
    [cancelButton setTitleColor:CLEARBUTTON_TEXT_COLOR forState:UIControlStateNormal];
    [cancelButton setTitleColor:CLEARBUTTON_TEXT_COLOR forState:UIControlStateHighlighted];
    return cancelButton;
}
///按钮点击事件
- (void)clickOnButtonWith:(UIButton *)button
{
    if (self.isHadDestructionButton == YES) {
        if (self.delegate) {
            if (button.tag == 0) {
                if ([self.delegate respondsToSelector:@selector(actionSheetDidClickOnDestructiveButton)] == YES){
                    [self.delegate actionSheetDidClickOnDestructiveButton];
                }
            }
        }
    }
    
    if (self.isHadCancelButton == YES) {
        if (self.delegate) {
            if (button.tag == self.postionIndexNumber-1) {
                if ([self.delegate respondsToSelector:@selector(actionSheetDidClickOnCancelButton)] == YES) {
                    [self.delegate actionSheetDidClickOnCancelButton];
                }
            }
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(actionSheet:didButtonClickWithIndex:)] == YES) {
            [self.delegate actionSheet:self didButtonClickWithIndex:button.tag];
        }
    }
    
    [self tappedCancel];
}

- (void)tappedCancel
{
    if ([self.delegate respondsToSelector:@selector(actionSheetDidClickOnCancelButton)] == YES) {
        [self.delegate actionSheetDidClickOnCancelButton];
    }
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [ws.backGroundView setFrame:CGRectMake(BACKGROUNDVIEW_INTERVAL_WIDTH, APP_FRAME_HEIGHT, BACKGROUNDVIEW_WIDTH, 0)];
        ws.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [ws removeFromSuperview];
        }
    }];
}

- (void)tappedBackGroundView
{
    
}

@end
