//
//  ZShareView.m
//  PlaneCircle
//
//  Created by Daniel on 6/10/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZShareView.h"
#import "ZButton.h"
#import "ClassCategory.h"

#import <ShareSDK/ShareSDK.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"

#import "Utils.h"

@interface ZShareView()

///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;
///背景
@property (strong, nonatomic) UIView *viewBG;
///内容
@property (strong, nonatomic) UIView *viewContent;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///取消
@property (strong, nonatomic) UIButton *btnCancel;
///微信
@property (strong, nonatomic) ZButton *btnWeChat;
///朋友圈
@property (strong, nonatomic) ZButton *btnWeChatCircle;
///QQ
@property (strong, nonatomic) ZButton *btnQQ;
///QQ空间
@property (strong, nonatomic) ZButton *btnQZone;
///举报
@property (strong, nonatomic) ZButton *btnReport;
///黑名单
@property (strong, nonatomic) ZButton *btnBlackList;
///收藏
@property (strong, nonatomic) ZButton *btnCollection;
///下载
@property (strong, nonatomic) ZButton *btnDownload;
///编辑
@property (strong, nonatomic) ZButton *btnEdit;
///印象笔记
@property (strong, nonatomic) ZButton *btnYingXiang;
///有道云笔记
@property (strong, nonatomic) ZButton *btnYouDao;
///删除
@property (strong, nonatomic) ZButton *btnDelete;

@property (strong, nonatomic) UIView *viewLine1;
@property (strong, nonatomic) UIView *viewLine2;
///内容坐标
@property (assign, nonatomic) CGRect contentFrame;

///显示类型
@property (assign, nonatomic) ZShowShareType showType;

@end

@implementation ZShareView

-(id)initWithShowShareType:(ZShowShareType)showType
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self setShowType:showType];
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    [self innerBase];
    switch (self.showType) {
        case ZShowShareTypeEditA:
        {
            [self getEditAnswerBtn];
            [self getDeleteAnswerBtn];
            break;
        }
        case ZShowShareTypeEditQ:
        {
            [self getEditQuestionBtn];
            [self getDeleteQuestionBtn];
            break;
        }
        case ZShowShareTypeReport:
        {
            [self getReportBtn];
            break;
        }
        case ZShowShareTypeBlacklist:
        {
            [self getBlackListBtn];
            break;
        }
        case ZShowShareTypeDownload:
        {
            [self getDownloadBtn];
            break;
        }
        case ZShowShareTypePractice:
        {
            [self getYingXiangBtn];
            [self getYouDaoBtn];
            break;
        }
        case ZShowShareTypeCollection:
        {
            [self getCollectionBtn];
            break;
        }
        case ZShowShareTypeReportBlacklist:
        {
            [self getReportBtn];
            [self getBlackListBtn];
            break;
        }
        case ZShowShareTypeDownloadCollection:
        {
            [self getDownloadBtn];
            [self getCollectionBtn];
            break;
        }
        case ZShowShareTypePracticeCollection:
        {
            [self getYingXiangBtn];
            [self getYouDaoBtn];
            [self getCollectionBtn];
            break;
        }
        case ZShowShareTypeReportCollection:
        {
            [self getReportBtn];
            [self getCollectionBtn];
            break;
        }
        case ZShowShareTypeOnlyReportBlacklist:
        {
            [self getReportBtn];
            [self getBlackListBtn];
            break;
        }
        case ZShowShareTypeOnlyReport:
        {
            [self getReportBtn];
        }
        default:break;
    }
    [self setViewFrame];
}
-(void)innerBase
{
    [self getBgView];
    [self getContentView];
    [self getLineView];
    [self getTitleLB];
    [self getWeChatBtn];
    [self getWeChatCircleBtn];
    [self getQQBtn];
    [self getQZoneBtn];
    [self getCancelBtn];
}

-(void)getBgView
{
    self.viewBG = [[UIView alloc] init];
    [self.viewBG setBackgroundColor:BLACKCOLOR];
    [self.viewBG setAlpha:0.4f];
    [self addSubview:self.viewBG];
    
    UITapGestureRecognizer *viewBGTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTap:)];
    [self.viewBG addGestureRecognizer:viewBGTap];
}

-(void)getContentView
{
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewContent];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)getLineView
{
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine2];
}

-(void)getTitleLB
{
//    self.lbTitle = [[UILabel alloc] init];
//    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
//    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
//    [self.lbTitle setText:kShare];
//    [self.lbTitle setTextColor:MAINCOLOR];
//    [self.viewContent addSubview:self.lbTitle];
}

-(void)getWeChatBtn
{
    self.btnWeChat = [[ZButton alloc] initWithShareType:(ZShareTypeWeChat)];
    [self.btnWeChat addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnWeChat];
}

-(void)getWeChatCircleBtn
{
    self.btnWeChatCircle = [[ZButton alloc] initWithShareType:(ZShareTypeWeChatCircle)];
    [self.btnWeChatCircle addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnWeChatCircle];
}

-(void)getQQBtn
{
    self.btnQQ = [[ZButton alloc] initWithShareType:(ZShareTypeQQ)];
    [self.btnQQ addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnQQ];
}

-(void)getQZoneBtn
{
    self.btnQZone = [[ZButton alloc] initWithShareType:(ZShareTypeQZone)];
    [self.btnQZone addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnQZone];
}

-(void)getReportBtn
{
    self.btnReport = [[ZButton alloc] initWithShareType:(ZShareTypeReport)];
    [self.btnReport addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnReport];
}

-(void)getBlackListBtn
{
    self.btnBlackList = [[ZButton alloc] initWithShareType:(ZShareTypeBlackList)];
    [self.btnBlackList addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnBlackList];
}

-(void)getEditBtn
{
    self.btnEdit = [[ZButton alloc] initWithShareType:(ZShareTypeEdit)];
    [self.btnEdit addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnEdit];
}

-(void)getDeleteBtn
{
    self.btnDelete = [[ZButton alloc] initWithShareType:(ZShareTypeDelete)];
    [self.btnDelete addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnDelete];
}

-(void)getEditQuestionBtn
{
    self.btnEdit = [[ZButton alloc] initWithShareType:(ZShareTypeEditQuestion)];
    [self.btnEdit addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnEdit];
}

-(void)getDeleteQuestionBtn
{
    self.btnDelete = [[ZButton alloc] initWithShareType:(ZShareTypeDeleteQuestion)];
    [self.btnDelete addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnDelete];
}

-(void)getEditAnswerBtn
{
    self.btnEdit = [[ZButton alloc] initWithShareType:(ZShareTypeEditAnswer)];
    [self.btnEdit addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnEdit];
}

-(void)getDeleteAnswerBtn
{
    self.btnDelete = [[ZButton alloc] initWithShareType:(ZShareTypeDeleteAnswer)];
    [self.btnDelete addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnDelete];
}

-(void)getDownloadBtn
{
    self.btnDownload = [[ZButton alloc] initWithShareType:(ZShareTypeDownload)];
    [self.btnDownload addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnDownload];
}

-(void)getCollectionBtn
{
    self.btnCollection = [[ZButton alloc] initWithShareType:(ZShareTypeCollection)];
    [self.btnCollection addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnCollection];
}

-(void)getYingXiangBtn
{
    self.btnYingXiang = [[ZButton alloc] initWithShareType:(ZShareTypeYinXiang)];
    [self.btnYingXiang addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnYingXiang];
}

-(void)getYouDaoBtn
{
    self.btnYouDao = [[ZButton alloc] initWithShareType:(ZShareTypeYouDao)];
    [self.btnYouDao addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnYouDao];
}

-(void)getCancelBtn
{
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancel setTitle:kCancel forState:(UIControlStateNormal)];
    [self.btnCancel setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.viewContent addSubview:self.btnCancel];
}

-(void)btnItemClick:(ZButton *)sender
{
    [self dismiss];
    if (self.onItemClick) {
        self.onItemClick(sender.type);
    }
}

-(void)viewBGTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}

-(void)btnCancelClick
{
    [self dismiss];
}

-(void)setViewFrame
{
    [self.viewBG setFrame:self.bounds];
    
    self.contentFrame = CGRectMake(0, self.viewBG.height, self.viewBG.width, 0);
    
    [self.viewContent setFrame:self.contentFrame];
    
    CGFloat lineH = 0.8;
    [self.viewLine1 setFrame:CGRectMake(0, 0, self.viewContent.width, lineH)];
    
    CGFloat space = 10;
    CGFloat btnSpace = (self.width-kButtonShareW*4)/5;
    CGFloat btnY = self.viewLine1.y+self.viewLine1.height+space;
    
    [self.btnWeChat setBtnPoint:CGPointMake(btnSpace, btnY)];
    [self.btnWeChatCircle setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnY)];
    
    [self.btnQQ setBtnPoint:CGPointMake(btnSpace*3+kButtonShareW*2, btnY)];
    [self.btnQZone setBtnPoint:CGPointMake(btnSpace*4+kButtonShareW*3, btnY)];
    
    CGFloat cancelH = 45;
    CGFloat contentH = 0;
    CGFloat cancelX = -1;
    CGFloat cancelW = self.viewContent.width+2;
    CGFloat btnTwoY = self.btnWeChat.y+self.btnWeChat.height+space;
    
    switch (self.showType) {
        case ZShowShareTypeNone:
        {
            [self.viewLine2 setFrame:CGRectMake(0, btnTwoY, self.viewContent.width, lineH)];
            
            CGFloat cancelY = btnTwoY;
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeReport:
        {
            [self.btnReport setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeReportCollection:
        {
            [self.btnReport setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            [self.btnCollection setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeBlacklist:
        {
            [self.btnBlackList setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeReportBlacklist:
        {
            [self.btnReport setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            [self.btnBlackList setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeEditQ:
        {
            [self.btnEdit setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            [self.btnDelete setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeEditA:
        {
            [self.btnEdit setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            [self.btnDelete setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeDownload:
        {
            [self.btnDownload setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeCollection:
        {
            [self.btnCollection setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeDownloadCollection:
        {
            [self.btnDownload setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            [self.btnCollection setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypePractice:
        {
            [self.btnYingXiang setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            [self.btnYouDao setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypePracticeCollection:
        {
            [self.btnYingXiang setBtnPoint:CGPointMake(btnSpace, btnTwoY)];
            [self.btnYouDao setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnTwoY)];
            [self.btnCollection setBtnPoint:CGPointMake(btnSpace*3+kButtonShareW*2, btnTwoY)];
            
            CGFloat cancelY = btnTwoY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeOnlyReportBlacklist:
        {
            [self.btnWeChat setHidden:YES];
            [self.btnWeChatCircle setHidden:YES];
            [self.btnQQ setHidden:YES];
            [self.btnQZone setHidden:YES];
            
            [self.btnReport setBtnPoint:CGPointMake(btnSpace, btnY)];
            [self.btnBlackList setBtnPoint:CGPointMake(btnSpace*2+kButtonShareW, btnY)];
            
            CGFloat cancelY = btnY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        case ZShowShareTypeOnlyReport:
        {
            [self.btnWeChat setHidden:YES];
            [self.btnWeChatCircle setHidden:YES];
            [self.btnQQ setHidden:YES];
            [self.btnQZone setHidden:YES];
            
            [self.btnReport setBtnPoint:CGPointMake(btnSpace, btnY)];
            
            CGFloat cancelY = btnY+kButtonShareH+space;
            [self.viewLine2 setFrame:CGRectMake(0, cancelY, self.viewContent.width, lineH)];
            
            [self.btnCancel setFrame:CGRectMake(cancelX, cancelY, cancelW, cancelH)];
            contentH = self.btnCancel.y+self.btnCancel.height;
            break;
        }
        default: break;
    }
    CGRect cFrame = self.contentFrame;
    cFrame.size.height = contentH;
    self.contentFrame = cFrame;
    [self.viewContent setFrame:cFrame];
}

-(void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_btnQQ);
    OBJC_RELEASE(_btnQZone);
    OBJC_RELEASE(_btnCancel);
    OBJC_RELEASE(_btnDelete);
    OBJC_RELEASE(_btnReport);
    OBJC_RELEASE(_btnBlackList);
    OBJC_RELEASE(_btnWeChat);
    OBJC_RELEASE(_btnEdit);
    OBJC_RELEASE(_btnCollection);
    OBJC_RELEASE(_btnDownload);
    OBJC_RELEASE(_btnYouDao);
    OBJC_RELEASE(_btnYingXiang);
    OBJC_RELEASE(_btnWeChatCircle);
    OBJC_RELEASE(_viewContent);
}

-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.viewBG setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        CGRect cFrame = self.contentFrame;
        cFrame.origin.y = cFrame.origin.y-cFrame.size.height;
        [self.viewBG setAlpha:0.4f];
        [self.viewContent setFrame:cFrame];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}

-(void)dismiss
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.viewBG setAlpha:0];
        [self.viewContent setFrame:CGRectMake(0, self.viewBG.height, self.viewContent.width, self.viewContent.height)];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
        [self setViewNil];
        [self removeFromSuperview];
    }];
}

@end
