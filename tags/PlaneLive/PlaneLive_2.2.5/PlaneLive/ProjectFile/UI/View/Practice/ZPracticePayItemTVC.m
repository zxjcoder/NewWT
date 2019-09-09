//
//  ZPracticePayItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticePayItemTVC.h"

@interface ZPracticePayItemTVC()

/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 内容
@property (strong, nonatomic) ZLabel *lbContent;
/// 类型
@property (assign, nonatomic) ZPracticePayItemTVCType type;
/// 内容坐标
@property (assign, nonatomic) CGRect contentFrame;

@end

@implementation ZPracticePayItemTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZPracticePayItemTVCType)type
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setType:type];
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZPracticePayItemTVC getH];
    
    self.space = 20;
    CGFloat itemW = self.cellW-self.space*2;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(self.space, 15, itemW, self.lbH)];
    [self.lbTitle setTextColor:COLORCONTENT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.contentFrame = CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+10, itemW, self.lbMinH);
    self.lbContent = [[ZLabel alloc] initWithFrame:self.contentFrame];
    [self.lbContent setTextColor:COLORTEXT2];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbContent setNumberOfLines:0];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    //[self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    CGRect contentFrame = self.contentFrame;
    contentFrame.size.height = contentH;
    [self.lbContent setFrame:contentFrame];
    
    self.cellH = self.lbContent.y+self.lbContent.height+2;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelPractice *)model
{
    if (model) {
        switch (self.type) {
            case ZPracticePayItemTVCTypeSpeaker:
            {
                [self.lbTitle setText:kSpeakerIntroduction];
                [self.lbContent setText:model.person_synopsis];
                break;
            }
            case ZPracticePayItemTVCTypePractice:
            {
                [self.lbTitle setText:kPracticalIntroduction];
                [self.lbContent setText:model.share_content];
                break;
            }
            default:
                [self.lbTitle setText:kEmpty];
                [self.lbContent setText:kEmpty];
                break;
        }
    } else {
        [self.lbTitle setText:kEmpty];
        [self.lbContent setText:kEmpty];
    }
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 40;
}

@end
