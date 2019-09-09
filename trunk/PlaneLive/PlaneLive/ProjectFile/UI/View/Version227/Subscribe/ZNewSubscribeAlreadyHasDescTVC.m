//
//  ZNewSubscribeAlreadyHasDescTVC.m
//  PlaneLive
//
//  Created by WT on 29/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewSubscribeAlreadyHasDescTVC.h"

@interface ZNewSubscribeAlreadyHasDescTVC()

/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 内容
@property (strong, nonatomic) ZLabel *lbContent;
/// 类型
@property (assign, nonatomic) ZSubscribeDetailTextTVCType type;
/// 内容坐标
@property (assign, nonatomic) CGRect contentFrame;

@end

@implementation ZNewSubscribeAlreadyHasDescTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZSubscribeDetailTextTVCType)type
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setType:type];
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [super innerInit];
    self.space = 20;
    self.cellH = [ZNewSubscribeAlreadyHasDescTVC getH];
    
    CGFloat itemW = self.cellW-self.space*2;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(self.space, 15, itemW, self.lbH)];
    [self.lbTitle setTextColor:COLORCONTENT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
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
    
    [self setViewFrame];
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

-(CGFloat)setCellDataWithModel:(ModelSubscribeDetail *)model
{
    if (model) {
        switch (self.type) {
            case ZSubscribeDetailTextTVCTypeInfo:
            {
                [self.lbTitle setText:kThemeInfo];
                [self.lbContent setText:model.theme_intro];
                break;
            }
            case ZSubscribeDetailTextTVCTypeTeamInfo:
            {
                [self.lbTitle setText:kTeamInfo];
                [self.lbContent setText:model.team_info];
                break;
            }
            case ZSubscribeDetailTextTVCTypeFitPeople:
            {
                [self.lbTitle setText:kFitPeople];
                [self.lbContent setText:model.fit_people];
                break;
            }
            case ZSubscribeDetailTextTVCTypeNeedHelp:
            {
                [self.lbTitle setText:kNeedHelp];
                [self.lbContent setText:model.need_help];
                break;
            }
            case ZSubscribeDetailTextTVCTypeMustKnow:
            {
                [self.lbTitle setText:kSubscribeMustKnow];
                [self.lbContent setText:model.must_know];
                break;
            }
            case ZSubscribeDetailTextTVCTypeLatestPush:
            {
                [self.lbTitle setText:kLatestPush];
                [self.lbContent setText:model.latest_push];
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

@end
