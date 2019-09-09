//
//  ZAccountBindWeChat.m
//  PlaneLive
//
//  Created by Daniel on 29/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountBindWeChatTVC.h"

@interface ZAccountBindWeChatTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbBind;

@property (strong, nonatomic) UIImageView *imgNext;

@end

@implementation ZAccountBindWeChatTVC

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
    
    self.cellH = [ZAccountBindWeChatTVC getH];
    
    self.imgNext = [[UIImageView alloc] initWithFrame:CGRectMake(self.cellW-25, self.cellH/2-18/2, 10, 18)];
    [self.imgNext setImage:[SkinManager getImageWithName:@"wode_btn_enter_s"]];
    [self.viewMain addSubview:self.imgNext];
    
    CGFloat bindW = 60;
    CGFloat bindX = self.imgNext.x-bindW-kSize8;
    self.lbBind = [[UILabel alloc] initWithFrame:CGRectMake(bindX, self.cellH/2-self.lbH/2, bindW, self.lbH)];
    [self.lbBind setTextAlignment:(NSTextAlignmentRight)];
    [self.lbBind setTextColor:DESCCOLOR];
    [self.lbBind setText:kNotBound];
    [self.lbBind setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbBind];
    
    CGFloat imgS = 30;
    self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeSpace, self.cellH/2-imgS/2, imgS, imgS)];
    [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_weixin"]];
    [self.viewMain addSubview:self.imgIcon];
    
    CGFloat titleX = self.imgIcon.x+self.imgIcon.width+kSize8;
    CGFloat titleW = bindX-titleX;
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, self.cellH/2-self.lbH/2, titleW, self.lbH)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setText:kMyWeChatBind];
    [self.viewMain addSubview:self.lbTitle];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    if (model.wechat_id == nil || model.wechat_id.length == 0) {
        [self.lbBind setText:kNotBound];
        [self.lbTitle setText:kMyWeChatBind];
    } else {
        [self.lbBind setText:kBound];
        [self.lbTitle setText:model.nickname];
    }
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbBind);
    OBJC_RELEASE(_imgNext);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 50;
}

@end
