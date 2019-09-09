//
//  ZFoundPracticeTypeTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZFoundPracticeTypeTVC.h"

@interface ZFoundPracticeTypeTVC()

@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZFoundPracticeTypeTVC

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
    
    self.cellH = [ZFoundPracticeTypeTVC getH];
}

-(CGFloat)setCellDataWithModel:(ModelEntity *)model
{
    
    return self.cellH;
}

-(CGFloat)setCellDataWithArray:(NSArray *)array
{
    if (self.arrayMain.count == array.count) {
        return self.cellH;
    }
    if (array && array.count > 0) {
        [self setArrayMain:array];
        for (UIView *view in self.viewMain.subviews) {
            [view removeFromSuperview];
        }
        int index = 0;
        CGFloat itemH = 38;
        CGFloat itemW = 20;
        CGFloat itemX = kSizeSpace;
        CGFloat itemY = 15;
        CGFloat space = 15;
        CGFloat contentW = self.cellW-kSizeSpace*2;
        for (ModelPracticeType *model in array) {
            ZButton *btnItem = [ZButton buttonWithType:(UIButtonTypeCustom)];
            [btnItem setTitle:model.type forState:(UIControlStateNormal)];
            [btnItem setTitleColor:RGBCOLOR(247,190,149) forState:(UIControlStateNormal)];
            [btnItem setViewRound:kVIEW_ROUND_SIZE borderWidth:1 borderColor:RGBCOLOR(247,190,149)];
            [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
            [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.viewMain addSubview:btnItem];
            [btnItem setTag:index];
            [btnItem setModel:model];
            
            itemW = [btnItem.titleLabel getLabelWidthWithMinWidth:10]+20;
            if (contentW < (itemX+itemW)) {
                itemX = kSizeSpace;
                itemY = itemY + itemH + space;
            }
            [btnItem setFrame:CGRectMake(itemX, itemY, itemW, itemH)];
            itemX = itemX + itemW + space;
            
            index++;
        }
        
        self.cellH = itemY + itemH + 55;
    } else {
        if (self.arrayMain.count == 0) {
            [self setArrayMain:array];
            for (UIView *view in self.viewMain.subviews) {
                [view removeFromSuperview];
            }
            self.cellH = 55;
        }
    }
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    return self.cellH;
}

-(void)btnItemClick:(ZButton *)sender
{
    if (self.onPracticeTypeClick) {
        self.onPracticeTypeClick((ModelPracticeType*)sender.model);
    }
}

-(void)setViewNil
{
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    OBJC_RELEASE(_arrayMain);
    OBJC_RELEASE(_onPracticeTypeClick);
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
    return 55;
}

@end
