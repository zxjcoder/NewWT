//
//  ZPracticePayInfoTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticePayInfoTVC.h"
#import "Utils.h"

@interface ZPracticePayInfoTVC()

///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///播放时间
@property (strong, nonatomic) UILabel *lbPlayTime;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZPracticePayInfoTVC

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
    
    self.cellH = [ZPracticePayInfoTVC getH];
    
    CGFloat imgSize = self.cellH-kSizeSpace*2;
    self.imgLogo = [[ZImageView alloc] initWithFrame:CGRectMake(kSizeSpace, kSizeSpace, imgSize, imgSize)];
    [self.imgLogo.layer setMasksToBounds:YES];
    [self.imgLogo setViewRound:kIMAGE_ROUND_SIZE borderWidth:1 borderColor:WHITECOLOR];
    self.imgLogo.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.imgLogo.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.imgLogo.layer.shadowOpacity = 0.58;//不透明度
    self.imgLogo.layer.shadowRadius = 5.0;//半径
    [self.viewMain addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setNumberOfLines:4];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:SPEAKERCOLOR];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setFont:[ZFont boldSystemFontOfSize:kFont_Min_Size]];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setTextColor:DESCCOLOR];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
    [self.viewMain addSubview:self.imgLine];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat imgSize = self.cellH-kSizeSpace*2;
    [self.imgLogo setFrame:CGRectMake(kSizeSpace, kSizeSpace, imgSize, imgSize)];
    
    CGFloat lbX = self.imgLogo.x+self.imgLogo.width+kSize8;
    CGFloat lbW = self.viewMain.width-lbX-kSizeSpace;
    CGFloat lbY = kSize15;
    
    CGRect titleFrame = CGRectMake(lbX, lbY, lbW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {
        titleFrame.size.height = maxH;
    } else {
        titleFrame.size.height = titleH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat rightW = lbW;
    CGFloat lbLY = self.lbTitle.y + titleFrame.size.height + kSize3;
    [self.lbLecturer setFrame:CGRectMake(lbX, lbLY, rightW, self.lbMinH)];
    
    CGFloat lbPTY = self.lbLecturer.y+self.lbLecturer.height+2;
    CGFloat lbPTH = 16;
    [self.lbPlayTime setFrame:CGRectMake(lbX, lbPTY, rightW, lbPTH)];
}

-(CGFloat)setCellDataWithModel:(ModelPractice *)model
{
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getPracticeImage]];
    
    [self.lbTitle setText:model.title];
    
    [self.lbLecturer setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, model.nickname]];
    [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:DESCCOLOR];
    
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getHHMMSSFromSS:model.time]]];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbLecturer);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgLogo);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return 128;
}


@end
