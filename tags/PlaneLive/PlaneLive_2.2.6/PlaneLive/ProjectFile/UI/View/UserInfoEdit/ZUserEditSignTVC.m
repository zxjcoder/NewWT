//
//  ZUserEditSignTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserEditSignTVC.h"
#import "ZTextView.h"

@interface ZUserEditSignTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) ZTextView *textView;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserEditSignTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZUserEditSignTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.space, 8, self.leftW, self.lbH)];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setText:kSign];
    [self.viewMain addSubview:self.lbTitle];
    
    self.textView = [[ZTextView alloc] init];
    [self.textView setViewFrame:CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height, self.cellW-self.space*2, 60)];
    [self.textView setMaxLength:kNumberSignMaxLength];
    [self.textView setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.textView setPlaceholderText:kPleaseEnterPersonalizedSignature];
    [self.textView setIsHiddenCountLabel:YES];
    [self.viewMain addSubview:self.textView];
    
    ZWEAKSELF
    [self.textView setOnBeginEditText:^{
        if (weakSelf.onBeginEdit) {
            weakSelf.onBeginEdit();
        }
    }];
    
    self.imgLine = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self.imgLine setFrame:CGRectMake(0, self.cellH-kLineMaxHeight, self.cellW, kLineMaxHeight)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
///获取个性签名
-(NSString *)getSign
{
    return self.textView.text;
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self.textView setText:model.sign];
    
    return self.cellH;
}
+(CGFloat)getH
{
    return 100;
}

@end
