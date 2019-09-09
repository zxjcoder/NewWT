//
//  ZPracticeTypeHeaderView.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZPracticeTypeHeaderView.h"
#import "ZButton.h"

@interface ZPracticeTypeHeaderView()<UISearchBarDelegate>

///搜索
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation ZPracticeTypeHeaderView

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
    [self setBackgroundColor:RGBCOLOR(242, 242, 242)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 10, self.width-8*2, 35)];
    [self.searchBar setBarTintColor:DESCCOLOR];
    [self.searchBar setBackgroundColor:CLEARCOLOR];
    [self.searchBar setDelegate:self];
    [self setSearchTextFiled];
    [self addSubview:self.searchBar];
}

///设置搜索按钮是否可用
-(void)setSearchTextFiled
{
    UITextField *textField = nil;
    for (UIView *view in self.searchBar.subviews) {
        if (view.subviews.count > 0) {
            for (UIView *item in view.subviews) {
                if ([item isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                    textField = (UITextField *)item;
                }
                if ([item isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [item removeFromSuperview];
                }
            }
        }
    }
    if (textField) {
        [textField setReturnKeyType:(UIReturnKeyDone)];
        [textField setBackgroundColor:WHITECOLOR];
        [[textField layer] setMasksToBounds:YES];
        UIImageView *imageSearch = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 17, 19)];
        [imageSearch setImage:[SkinManager getImageWithName:@"home_search_icon"]];
        [textField setLeftView:imageSearch];
        [textField setViewRound:14 borderWidth:0 borderColor:CLEARCOLOR];
        [self setSearchPlaceholder:@"搜索您想听的实务" textField:textField];
    }
}
-(void)setSearchPlaceholder:(NSString *)placeholder textField:(UITextField *)textField
{
    [textField setPlaceholder:placeholder];
    [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:SEARCHTINTCOLOR,NSFontAttributeName:[ZFont systemFontOfSize:kFont_Least_Size]}]];
}
///获取试图高度
+(CGFloat)getViewH
{
    return 55;
}
-(void)dealloc
{
    _searchBar.delegate = nil;
    OBJC_RELEASE(_searchBar);
}

#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (self.onBeginEdit) {
        self.onBeginEdit();
    }
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if (self.onEndEdit) {
        self.onEndEdit();
    }
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (self.onCancelClick) {
        self.onCancelClick();
    }
    [searchBar setText:nil];
    [self.searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.onSearchClick) {
        self.onSearchClick();
    }
    [self.searchBar resignFirstResponder];
}

@end
