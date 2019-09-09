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

@interface ZRankDetailCompanyView()<UIScrollViewDelegate>
{
    NSInteger _offsetIndex;
}

@property (strong, nonatomic) ZRankDetailHeaderView *viewHeader;

@property (strong, nonatomic) ZRankDetailCompanyTableView *tvCompany;

@property (strong, nonatomic) ZRankDetailCompanyTableView *tvUser;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *btnCompany;

@property (strong, nonatomic) UIButton *btnUser;

@property (strong, nonatomic) UIView *viewLine;

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
    
    self.btnCompany = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCompany setTitle:@"新三板" forState:(UIControlStateNormal)];
    [self.btnCompany setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnCompany setTag:1];
    [[self.btnCompany titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnCompany addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnCompany];
    
    self.btnUser = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnUser setTitle:@"律师" forState:(UIControlStateNormal)];
    [self.btnUser setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnUser setTag:2];
    [[self.btnUser titleLabel] setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.btnUser addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnUser];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:MAINCOLOR];
    [self addSubview:self.viewLine];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self addSubview:self.scrollView];
    
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
    
    __weak typeof(self) weakSelf = self;
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

-(void)btnItemClick:(UIButton *)sender
{
    _offsetIndex = sender.tag - 1;
    [self setViewSelectItemWithType:_offsetIndex];
    [self.scrollView setContentOffset:CGPointMake(_offsetIndex*self.scrollView.width, 0) animated:YES];
}

-(void)setViewSelectItemWithType:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            self.selType = 1;
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.btnCompany setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
                [self.btnUser setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
            }];
            break;
        }
        case 1:
        {
            self.selType = 2;
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.btnCompany setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
                [self.btnUser setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
            }];
            break;
        }
        default: break;
    }
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

-(void)setViewFrame
{
    CGFloat viewW = APP_FRAME_WIDTH;
    [self.viewHeader setFrame:CGRectMake(0, 0, viewW, self.viewHeader.getH)];
    
    CGFloat btnH = 30;
    CGFloat btnY = self.viewHeader.getH;
    [self.btnCompany setFrame:CGRectMake(0, btnY, viewW/2, btnH)];
    [self.btnUser setFrame:CGRectMake(viewW/2, btnY, viewW/2, btnH)];
    
    [self.viewLine setFrame:CGRectMake(viewW/2*_offsetIndex, self.btnCompany.y+self.btnCompany.height, viewW/2, 2)];
    
    [self.scrollView setFrame:CGRectMake(0, self.viewLine.y+self.viewLine.height, viewW, self.height-40)];
    [self.scrollView setContentSize:CGSizeMake(viewW*2, self.scrollView.height)];
    
    [self setViewHeaderFrame];
    
    [self.tvCompany setFrame:CGRectMake(0, 30, self.scrollView.width, self.scrollView.height-30)];
    [self.tvUser setFrame:CGRectMake(self.scrollView.width, 30, self.scrollView.width, self.scrollView.height-30)];
}

-(void)setViewDataWithModel:(ModelRankCompany *)model
{
    [self.viewHeader setViewDataWithModel:model];
    switch (model.type) {
        case 1:
            [self.btnUser setTitle:@"会计" forState:(UIControlStateNormal)];
            break;
        case 2:
            [self.btnUser setTitle:@"券商" forState:(UIControlStateNormal)];
            break;
        default:
            [self.btnUser setTitle:@"律师" forState:(UIControlStateNormal)];
            break;
    }
    [self setViewFrame];
}
-(void)dealloc
{
    _scrollView.delegate = nil;
    OBJC_RELEASE(_btnCompany);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_arrUser);
    OBJC_RELEASE(_btnUser);
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
    [self setViewSelectItemWithType:_offsetIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect lineFrame = self.viewLine.frame;
    lineFrame.origin.x = scrollView.contentOffset.x/2;
    [self.viewLine setFrame:lineFrame];
}

@end
