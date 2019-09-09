//
//  ZRankEditViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankEditViewController.h"
#import "ZTextView.h"

@interface ZRankEditViewController ()

@property (strong, nonatomic) ZTextView *txtView;


@property (strong, nonatomic) ModelEntity *modelE;

@end

@implementation ZRankEditViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"修正"];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"提交"];
    
    [self.txtView setText:[sqlite getSysParamWithKey:kSQLITE_LAST_UPDRANK]];
}

- (void)setViewFrame
{
    [self.txtView setFrame:VIEW_ITEM_FRAME];
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
    OBJC_RELEASE(_txtView);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.txtView = [[ZTextView alloc] init];
    [self.txtView setReturnKeyType:(UIReturnKeyDone)];
    ZWEAKSELF
    [self.txtView setOnTextDidChange:^(NSString *text, NSRange range, int inputLength) {
        if (text.length > kNumberRankEditContentLength) {
            [weakSelf setViewTitle:[NSString stringWithFormat:@"超长%d字符",(int)(text.length-kNumberRankEditContentLength)]];
        } else {
            [weakSelf setViewTitle:weakSelf.title];
            [sqlite setSysParam:kSQLITE_LAST_UPDRANK value:text];
        }
    }];
    [self.txtView setPlaceholderText:@"请尽可能详细的描述您要修正的内容"];
    [self.view addSubview:self.txtView];
    
    [self setViewFrame];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.txtView resignFirstResponder];
    }
}

-(void)btnRightClick
{
    if (self.isLoaded) {return;}
    [self.view endEditing:YES];
    NSString *content = self.txtView.text;
    if ([content isEmpty]) {
        [ZProgressHUD showError:@"修正内容不能为空"];
        return;
    }
    if (content.length == 0 || content.length > kNumberRankEditContentLength) {
        [ZProgressHUD showError:[NSString stringWithFormat:@"修正内容限制在1-%d字符",kNumberRankEditContentLength]];
        return;
    }
    NSString *lastContent = [sqlite getSysParamWithKey:kSQLITE_LAST_UPDRANKCONTENT];
    if ([content isEqualToString:lastContent]) {
        [ZProgressHUD showError:@"请不要重复提交相同的内容,谢谢!"];
        return;
    }
    ZWEAKSELF
    [self setIsLoaded:YES];
    [ZProgressHUD showMessage:@"正在提交,请稍等..."];
    NSString *type = @"1";
    NSString *objId = @"";
    if ([self.modelE isKindOfClass:[ModelRankUser class]]) {
        type = @"1";
        objId = [(ModelRankUser*)self.modelE ids];
    } else if ([self.modelE isKindOfClass:[ModelRankCompany class]]) {
        type = @"2";
        objId = [(ModelRankCompany*)self.modelE ids];
    }
    [sns postFeekbackWithUserId:[AppSetting getUserDetauleId] question:content type:type objId:objId resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismiss];
            [weakSelf.txtView setViewText:nil];
            [sqlite setSysParam:kSQLITE_LAST_UPDRANKCONTENT value:content];
            [sqlite setSysParam:kSQLITE_LAST_UPDRANK value:kEmpty];
            [ZAlertView showWithMessage:@"修正内容已成功提交,感谢您提供的宝贵信息" completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

-(void)setViewDataWithModel:(ModelEntity *)model
{
    [self setModelE:model];
}

@end
