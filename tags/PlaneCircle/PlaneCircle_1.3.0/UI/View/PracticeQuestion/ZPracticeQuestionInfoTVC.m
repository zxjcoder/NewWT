//
//  ZPracticeQuestionInfoTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeQuestionInfoTVC.h"
#import "Utils.h"

@interface ZPracticeQuestionInfoTVC()

///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///主持人机构名称
@property (strong, nonatomic) UILabel *lbLecturerDesc;

@end

@implementation ZPracticeQuestionInfoTVC

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
    
    self.cellH = 75+15*2+5;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewLogoBG = [[UIView alloc] init];
    [[self.viewLogoBG layer] setMasksToBounds:YES];
    [self.viewLogoBG setViewRound:5 borderWidth:2 borderColor:RGBCOLOR(241, 241, 241)];
    [self.viewMain addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:RGBCOLOR(238, 166, 116)];
    [self.lbLecturer setText:@"主讲人: "];
    [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:BLACKCOLOR1];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbLecturerDesc = [[UILabel alloc] init];
    [self.lbLecturerDesc setFont:[ZFont boldSystemFontOfSize:kFont_Min_Size]];
    [self.lbLecturerDesc setNumberOfLines:0];
    [self.lbLecturerDesc setTextColor:DESCCOLOR];
    [self.lbLecturerDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturerDesc];
    
    [self setCellFontSize];
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbLecturer setFont:[ZFont boldSystemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
    
    [self.lbLecturerDesc setFont:[ZFont boldSystemFontOfSize:kSet_Font_Least_Size(self.fontSize)]];
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGFloat sp = kSize10;
    CGFloat imgS = 75;
    CGFloat imgY = 15;
    [self.viewLogoBG setFrame:CGRectMake(sp, imgY, imgS, imgS)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    CGFloat rightX = self.viewLogoBG.x+imgS+kSize10;
    CGFloat rightW = self.cellW-rightX-kSize10;
    
    CGFloat lbLecturerY = kSize13;
    [self.lbLecturer setFrame:CGRectMake(rightX, lbLecturerY, rightW, self.lbH)];
    
    CGFloat ldY = self.lbLecturer.y+self.lbLecturer.height+kSize3;
    CGRect lecturerDescFrame = CGRectMake(rightX, ldY, rightW, self.lbMinH);
    [self.lbLecturerDesc setFrame:lecturerDescFrame];
    
    CGFloat lecturerDescH = [self.lbLecturerDesc getLabelHeightWithMinHeight:self.lbMinH];
    lecturerDescFrame.size.height = lecturerDescH;
    [self.lbLecturerDesc setFrame:lecturerDescFrame];
    
    CGFloat contentH = (self.lbLecturerDesc.y+self.lbLecturerDesc.height);
    if (contentH <= imgS+imgY) {
        self.cellH = imgS+imgY+imgY+5;
    } else {
        self.cellH = lecturerDescFrame.origin.y+lecturerDescFrame.size.height + 15;
    }
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelPractice *)model
{
    if (model) {
        [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getImageWithName:@"new_p_image_default"]];
        
        [self.lbLecturer setText:[NSString stringWithFormat:@"主讲人: %@",model.nickname]];
        [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:BLACKCOLOR1];
        
        [self.lbLecturerDesc setText:model.person_synopsis];
    }
    
    [self setViewFrame];
}

-(CGFloat)getHWithModel:(ModelPractice *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_lbLecturer);
    OBJC_RELEASE(_lbLecturerDesc);
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

@end
