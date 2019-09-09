//
//  ZPracticeDetailInfoTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailInfoTVC.h"
#import "Utils.h"

@interface ZPracticeDetailInfoTVC()

///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///标题
//@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///主持人机构名称
@property (strong, nonatomic) UILabel *lbLecturerDesc;
///主持人机构名称图标
//@property (strong, nonatomic) UIImageView *imgLecturerDesc;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZPracticeDetailInfoTVC

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
    
//    self.lbTitle = [[UILabel alloc] init];
//    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Default_Size]];
//    [self.lbTitle setNumberOfLines:2];
//    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
//    [self.lbTitle setTextColor:BLACKCOLOR];
//    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[UIFont boldSystemFontOfSize:kFont_Small_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:RGBCOLOR(238, 166, 116)];
    [self.lbLecturer setText:@"主讲人: "];
    [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:BLACKCOLOR1];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbLecturerDesc = [[UILabel alloc] init];
    [self.lbLecturerDesc setFont:[UIFont boldSystemFontOfSize:kFont_Min_Size]];
    [self.lbLecturerDesc setNumberOfLines:0];
    [self.lbLecturerDesc setTextColor:DESCCOLOR];
    [self.lbLecturerDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturerDesc];
    
//    self.imgLecturerDesc = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"shiwu_icon_tag"]];
//    [self.viewMain addSubview:self.imgLecturerDesc];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)setViewFrame
{
    CGFloat sp = 8;
    CGFloat imgS = 75;
    [self.viewLogoBG setFrame:CGRectMake(sp, 15, imgS, imgS)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    CGFloat rightX = self.viewLogoBG.x+imgS+self.space;
    CGFloat rightW = self.cellW-rightX-self.space;
    
//    [self.lbTitle setFrame:CGRectMake(rightX, self.space, rightW, self.lbH)];
//    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
//    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
//    if (titleH > maxH) {
//        titleH = maxH;
//    }
//    [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, self.lbTitle.width, titleH)];
    
//    CGFloat lY = self.lbTitle.y + 40 + 2;
    CGFloat lY = self.space;
    [self.lbLecturer setFrame:CGRectMake(rightX, lY, rightW, self.lbH)];
    
//    CGFloat imgLDS = 16;
    CGFloat ldY = self.lbLecturer.y+self.lbLecturer.height+2;
    
//    [self.imgLecturerDesc setFrame:CGRectMake(rightX, ldY+imgLDS/4, imgLDS/2, imgLDS/2)];
    
    [self.lbLecturerDesc setFrame:CGRectMake(rightX, ldY, rightW, self.lbMinH)];
    
    CGFloat lecturerDescH = [self.lbLecturerDesc getLabelHeightWithMinHeight:self.lbMinH];
//    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbLecturerDesc];
//    if (lecturerDescH > maxH) {
//        lecturerDescH = maxH;
//    }
    [self.lbLecturerDesc setFrame:CGRectMake(self.lbLecturerDesc.x, self.lbLecturerDesc.y, self.lbLecturerDesc.width, lecturerDescH)];
    
    CGFloat contentH = (self.lbLecturerDesc.y+self.lbLecturerDesc.height);
    if (contentH <= 75+15) {
        self.cellH = 75+15*2+5;
    } else {
        self.cellH = contentH + 15;
    }
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(void)setCellDataWithModel:(ModelPractice *)model
{
    if (model) {
        [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getImageWithName:@"new_p_image_default"]];
        
//        [self.lbTitle setText:model.title];
        
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
    OBJC_RELEASE(_viewLine);
//    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbLecturer);
    OBJC_RELEASE(_lbLecturerDesc);
//    OBJC_RELEASE(_imgLecturerDesc);
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
//+(CGFloat)getH
//{
//    return 105;
//}


@end
