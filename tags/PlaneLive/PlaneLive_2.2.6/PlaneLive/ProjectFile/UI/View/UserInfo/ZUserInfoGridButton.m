//
//  ZUserInfoGridButton.m
//  PlaneLive
//
//  Created by Daniel on 13/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZUserInfoGridButton.h"
#import "ZView.h"
#import "ZImageView.h"
#import "ZLabel.h"

@interface ZUserInfoGridButton()

///图片
@property (strong, nonatomic) ZImageView *imgIcon;
///标题
@property (strong, nonatomic) ZLabel *lbTitle;
///数量
@property (strong, nonatomic) ZLabel *lbCount;

@end

@implementation ZUserInfoGridButton

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
    self.imgIcon = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"my_collection_new"]];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self addSubview:self.imgIcon];
    
    self.lbCount = [[ZLabel alloc] init];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:REDCOLOR];
    [self.lbCount setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setUserInteractionEnabled:NO];
    [self.lbCount setFont:[UIFont systemFontOfSize:kFont_Minmum_Size]];
    [self addSubview:self.lbCount];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setBackgroundColor:CLEARCOLOR];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self addSubview:self.lbTitle];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat space = 15;
    CGFloat imgSize = 25;
    CGFloat imgX = (self.width-imgSize)/2;
    [self.imgIcon setFrame:CGRectMake(imgX, space, imgSize, imgSize)];
    
    [self.lbCount setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width+5, 9, 16, 16)];
    [self.lbCount setViewRoundNoBorder];
    
    [self.lbTitle setFrame:CGRectMake(0, self.imgIcon.y+self.imgIcon.height+10, self.width, 22)];
}
-(void)setViewDataWithType:(ZUserInfoGridCVCType)type count:(long)count
{
    [self setType:type];
    [self setViewFrame];
    [self.lbCount setHidden:count==0];
    [self.lbCount setText:[NSString stringWithFormat:@"%ld",count]];
    switch (type) {
        case ZUserInfoGridCVCTypeColl:
            [self.lbTitle setText:kCollection];
            [self.imgIcon setImageName:@"my_collection_new"];
            break;
        case ZUserInfoGridCVCTypeAtt:
            [self.lbTitle setText:kAttention];
            [self.imgIcon setImageName:@"my_attention_new"];
            break;
        case ZUserInfoGridCVCTypeDownload:
            [self.lbTitle setText:kDownloadManager];
            [self.imgIcon setImageName:@"my_download_new"];
            break;
        case ZUserInfoGridCVCTypeMessage:
            [self.lbTitle setText:kMessage];
            [self.imgIcon setImageName:@"my_message_new"];
            break;
        case ZUserInfoGridCVCTypeWaitAnswer:
            [self.lbTitle setText:@"待回答"];
            [self.imgIcon setImageName:@"my_tobe_answere_new"];
            break;
        case ZUserInfoGridCVCTypeMessageCenter:
            [self.lbTitle setText:kMessageCenter];
            [self.imgIcon setImageName:@"my_message_center__new"];
            break;
        default:
            break;
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbTitle);
}


@end
