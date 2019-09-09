//
//  ZRankDetailCompanyView.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailCompanyView.h"
#import "ZRankDetailCompanyTableView.h"
#import "ZRankDetailHeaderView.h"

#import "ZSwitchToolView.h"

@interface ZRankDetailCompanyView()<UIScrollViewDelegate>
{
    __block NSInteger _offsetIndex;
}

@property (strong, nonatomic) ZRankDetailHeaderView *viewHeader;

@property (strong, nonatomic) ZRankDetailCompanyTableView *tvCompany;

@property (strong, nonatomic) ZRankDetailCompanyTableView *tvUser;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) ZSwitchToolView *viewTool;

@property (strong, nonatomic) UIView *viewTitle1;

@property (strong, nonatomic) UILabel *lbNumber1;

@property (strong, nonatomic) UILabel *lbCode1;

@property (strong, nonatomic) UILabel *lbName1;

@property (strong, nonatomic) UIView *viewTitle2;

@property (strong, nonatomic) UILabel *lbNumber2;

@property (strong, nonatomic) UILabel *lbName2;

@property (strong, nonatomic) NSMutableArray *arrCompany;

@property (strong, nonatomic) NSMutableArray *arrUser;

@end

@implementation ZRankDetailCompanyView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.selType = 1;
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self addSubview:self.scrollView];
    
    __weak typeof(self) weakSelf = self;
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemRankDetail)];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        weakSelf.selType = (int)index;
        _offsetIndex = index - 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(_offsetIndex*self.scrollView.width, 0) animated:YES];
    }];
    [self addSubview:self.viewTool];
    
    self.viewTitle1 = [[UIView alloc] init];
    [self.viewTitle1 setBackgroundColor:RGBCOLOR(255, 240, 228)];
    [self.scrollView addSubview:self.viewTitle1];
    
    self.lbNumber1 = [[UILabel alloc] init];
    [self.lbNumber1 setTextColor:BLACKCOLOR1];
    [self.lbNumber1 setText:@"序号"];
    [self.lbNumber1 setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbNumber1 setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle1 addSubview:self.lbNumber1];
    
    self.lbCode1 = [[UILabel alloc] init];
    [self.lbCode1 setTextColor:BLACKCOLOR1];
    [self.lbCode1 setText:@"公司代码"];
    [self.lbCode1 setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCode1 setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle1 addSubview:self.lbCode1];
    
    self.lbName1 = [[UILabel alloc] init];
    [self.lbName1 setTextColor:BLACKCOLOR1];
    [self.lbName1 setText:@"公司名称"];
    [self.lbName1 setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbName1 setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle1 addSubview:self.lbName1];
    
    self.viewTitle2 = [[UIView alloc] init];
    [self.viewTitle2 setBackgroundColor:RGBCOLOR(255, 240, 228)];
    [self.scrollView addSubview:self.viewTitle2];
    
    self.lbNumber2 = [[UILabel alloc] init];
    [self.lbNumber2 setTextColor:BLACKCOLOR1];
    [self.lbNumber2 setText:@"序号"];
    [self.lbNumber2 setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbNumber2 setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle2 addSubview:self.lbNumber2];
    
    self.lbName2 = [[UILabel alloc] init];
    [self.lbName2 setTextColor:BLACKCOLOR1];
    [self.lbName2 setText:@"姓名"];
    [self.lbName2 setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbName2 setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewTitle2 addSubview:self.lbName2];
    
    self.viewHeader = [[ZRankDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 100)];
    [self.viewHeader setOnUpdRankCompanyClick:^(ModelRankCompany *model) {
        if (weakSelf.onUpdRankCompanyClick) {
            weakSelf.onUpdRankCompanyClick(model);
        }
    }];
    [self addSubview:self.viewHeader];
    
    self.tvCompany = [[ZRankDetailCompanyTableView alloc] init];
    [self.tvCompany setOnRefreshFooter:^{
        if (weakSelf.onRefreshCompanyFooter) {
            weakSelf.onRefreshCompanyFooter();
        }
    }];
    [self.scrollView addSubview:self.tvCompany];
    
    self.tvUser = [[ZRankDetailCompanyTableView alloc] init];
    [self.tvUser setOnRefreshFooter:^{
        if (weakSelf.onRefreshUserFooter) {
            weakSelf.onRefreshUserFooter();
        }
    }];
    [self.scrollView addSubview:self.tvUser];
    
    [self setViewFrame];
}

-(void)endRefreshCompanyFooter
{
    [self.tvCompany endRefreshFooter];
}

-(void)endRefreshUserFooter
{
    [self.tvUser endRefreshFooter];
}

-(void)setViewFrame
{
    CGFloat viewW = APP_FRAME_WIDTH;
    [self.viewHeader setFrame:CGRectMake(0, 0, viewW, self.viewHeader.getH)];
    
    CGFloat btnY = self.viewHeader.getH;
    [self.viewTool setFrame:CGRectMake(0, btnY, viewW, [ZSwitchToolView getViewH])];
    
    [self.scrollView setFrame:CGRectMake(0, self.viewTool.y+self.viewTool.height, viewW, self.height-self.viewTool.height)];
    [self.scrollView setContentSize:CGSizeMake(viewW*2, self.scrollView.height)];
    
    [self setViewHeaderFrame];
    
    [self.tvCompany setFrame:CGRectMake(0, 30, self.scrollView.width, self.scrollView.height-30)];
    [self.tvUser setFrame:CGRectMake(self.scrollView.width, 30, self.scrollView.width, self.scrollView.height-30)];
}

-(void)setViewHeaderFrame
{
    CGFloat viewW = APP_FRAME_WIDTH;
    
    [self.viewTitle1 setFrame:CGRectMake(0, 0, viewW, 30)];
    
    [self.lbNumber1 setFrame:CGRectMake(0, 5, 50, 25)];
    [self.lbCode1 setFrame:CGRectMake(self.lbNumber1.x+self.lbNumber1.width, 5, 110, 25)];
    [self.lbName1 setFrame:CGRectMake(self.lbCode1.x+self.lbCode1.width, 5, viewW-self.lbNumber1.width-self.lbCode1.width, 25)];
    
    [self.viewTitle2 setFrame:CGRectMake(viewW, 0, viewW, 30)];
    
    [self.lbNumber2 setFrame:CGRectMake(0, 5, 70, 25)];
    [self.lbName2 setFrame:CGRectMake(self.lbNumber2.x+self.lbNumber2.width, 5, viewW-self.lbNumber2.width, 25)];
}

-(void)setViewDataWithModel:(ModelRankCompany *)model
{
    [self.viewHeader setViewDataWithModel:model];
    switch (model.type) {
        case 1:
            [self.viewTool setButtonText:@"会计" index:2];
            break;
        case 2:
            [self.viewTool setButtonText:@"券商" index:2];
            break;
        default:
            [self.viewTool setButtonText:@"律师" index:2];
            break;
    }
    [self setViewFrame];
}
-(void)dealloc
{
    _scrollView.delegate = nil;
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_arrUser);
    OBJC_RELEASE(_lbCode1);
    OBJC_RELEASE(_lbName1);
    OBJC_RELEASE(_lbName2);
    OBJC_RELEASE(_viewTitle1);
    OBJC_RELEASE(_viewTitle2);
    OBJC_RELEASE(_tvCompany);
    OBJC_RELEASE(_arrCompany);
    OBJC_RELEASE(_tvUser);
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_viewHeader);
}
///设置搜索内容
-(void)setViewCompanyWithDictionary:(NSDictionary *)dic
{
    [self.tvCompany setViewDataWithDictionary:dic];
}
///设置搜索用户
-(void)setViewUserWithDictionary:(NSDictionary *)dic
{
    [self.tvUser setViewDataWithDictionary:dic];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self.viewTool setViewSelectItemWithType:(_offsetIndex+1)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewTool setOffsetChange:scrollView.contentOffset.x];
}

@end
