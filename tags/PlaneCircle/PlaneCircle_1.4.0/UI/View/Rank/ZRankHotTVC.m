//
//  ZRankHotTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankHotTVC.h"
#import "ZRankButton.h"

@interface ZRankHotTVC()

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZRankHotTVC

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
    
    [self setCellH:0];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)setCellDataWithDictionary:(NSDictionary *)dicResult
{
    for (UIView *view in self.viewContent.subviews) {
        [view removeFromSuperview];
    }
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        NSArray *arrCompany = [dicResult objectForKey:kResultKey];
        NSArray *arrUser = [dicResult objectForKey:@"resultCsf"];
        
        ///律师
        NSMutableArray *arrL = [NSMutableArray array];
        ///证券
        NSMutableArray *arrZ = [NSMutableArray array];
        ///会计
        NSMutableArray *arrK = [NSMutableArray array];
        if (arrCompany && [arrCompany isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrCompany) {
                ModelRankCompany *modelRC = [[ModelRankCompany alloc] initWithCustom:dic];
                switch (modelRC.type) {
                    case 0: [arrL addObject:modelRC]; break;
                    case 1: [arrK addObject:modelRC]; break;
                    case 2: [arrZ addObject:modelRC]; break;
                    default: break;
                }
            }
        }
        if (arrUser && [arrUser isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrUser) {
                ModelRankUser *modelRU = [[ModelRankUser alloc] initWithCustom:dic];
                switch (modelRU.type) {
                    case 0: [arrL addObject:modelRU]; break;
                    case 1: [arrK addObject:modelRU]; break;
                    case 2: [arrZ addObject:modelRU]; break;
                    default: break;
                }
            }
        }
        CGFloat itemX = kSize14;
        CGFloat itemY = 15;
        CGFloat itemH = 28;
        CGFloat spaceW = 8;
        CGFloat spaceH = 11;
        
        for (ModelEntity *modelItem in arrZ) {
            ZRankButton *btnItem = [ZRankButton buttonWithType:(UIButtonTypeCustom)];
            [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.viewContent addSubview:btnItem];
            if ([modelItem isKindOfClass:[ModelRankUser class]]) {
                ModelRankUser *modelRU = (ModelRankUser*)modelItem;
                [btnItem setTitle:modelRU.nickname forState:(UIControlStateNormal)];
                [self setButtonColorWithBtn:btnItem row:modelRU.type];
                [btnItem setType:2];
                [btnItem setModelUser:modelRU];
            } else {
                ModelRankCompany *modelRC = (ModelRankCompany*)modelItem;
                [btnItem setTitle:modelRC.cpy_name forState:(UIControlStateNormal)];
                [self setButtonColorWithBtn:btnItem row:modelRC.type];
                [btnItem setType:1];
                [btnItem setModelCommpany:modelRC];
            }
            [btnItem setFrame:CGRectMake(itemX, itemY, 0, itemH)];
            CGFloat itemW = [btnItem.titleLabel getLabelWidthWithMinWidth:20]+25;
            if ((itemX+itemW)>(self.cellW-kSize14*2)) {
                itemX = kSize14;
                itemY = itemY+itemH+spaceH;
            }
            [btnItem setFrame:CGRectMake(itemX, itemY, itemW, itemH)];
            itemX = itemX+itemW+spaceW;
        }
        for (ModelEntity *modelItem in arrL) {
            ZRankButton *btnItem = [ZRankButton buttonWithType:(UIButtonTypeCustom)];
            [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.viewContent addSubview:btnItem];
            if ([modelItem isKindOfClass:[ModelRankUser class]]) {
                ModelRankUser *modelRU = (ModelRankUser*)modelItem;
                [btnItem setTitle:modelRU.nickname forState:(UIControlStateNormal)];
                [self setButtonColorWithBtn:btnItem row:modelRU.type];
                [btnItem setType:2];
                [btnItem setModelUser:modelRU];
            } else {
                ModelRankCompany *modelRC = (ModelRankCompany*)modelItem;
                [btnItem setTitle:modelRC.cpy_name forState:(UIControlStateNormal)];
                [self setButtonColorWithBtn:btnItem row:modelRC.type];
                [btnItem setType:1];
                [btnItem setModelCommpany:modelRC];
            }
            [btnItem setFrame:CGRectMake(itemX, itemY, 0, itemH)];
            CGFloat itemW = [btnItem.titleLabel getLabelWidthWithMinWidth:20]+25;
            if ((itemX+itemW)>(self.cellW-kSize14*2)) {
                itemX = kSize14;
                itemY = itemY+itemH+spaceH;
            }
            [btnItem setFrame:CGRectMake(itemX, itemY, itemW, itemH)];
            itemX = itemX+itemW+spaceW;
        }
        for (ModelEntity *modelItem in arrK) {
            ZRankButton *btnItem = [ZRankButton buttonWithType:(UIButtonTypeCustom)];
            [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.viewContent addSubview:btnItem];
            if ([modelItem isKindOfClass:[ModelRankUser class]]) {
                ModelRankUser *modelRU = (ModelRankUser*)modelItem;
                [btnItem setTitle:modelRU.nickname forState:(UIControlStateNormal)];
                [self setButtonColorWithBtn:btnItem row:modelRU.type];
                [btnItem setType:2];
                [btnItem setModelUser:modelRU];
            } else {
                ModelRankCompany *modelRC = (ModelRankCompany*)modelItem;
                [btnItem setTitle:modelRC.cpy_name forState:(UIControlStateNormal)];
                [self setButtonColorWithBtn:btnItem row:modelRC.type];
                [btnItem setType:1];
                [btnItem setModelCommpany:modelRC];
            }
            [btnItem setFrame:CGRectMake(itemX, itemY, 0, itemH)];
            CGFloat itemW = [btnItem.titleLabel getLabelWidthWithMinWidth:20]+25;
            if ((itemX+itemW)>(self.cellW-kSize14*2)) {
                itemX = kSize14;
                itemY = itemY+itemH+spaceH;
            }
            [btnItem setFrame:CGRectMake(itemX, itemY, itemW, itemH)];
            itemX = itemX+itemW+spaceW;
        }
        if ((arrCompany && [arrCompany isKindOfClass:[NSArray class]] && arrCompany.count > 0)
            || (arrUser && [arrUser isKindOfClass:[NSArray class]] && arrUser.count > 0)) {
            self.cellH = itemY+itemH+20;
        } else {
            self.cellH = 0;
        }
    } else {
        self.cellH = 0;
    }
    [self.viewContent setFrame:CGRectMake(0, 0, self.cellW, self.cellH-self.lineMaxH)];
    [self.viewLine setFrame:CGRectMake(0, self.viewContent.height, self.cellW, self.lineMaxH)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setButtonColorWithBtn:(ZRankButton *)btnItem row:(int)row
{
    [btnItem setViewRound:5 borderWidth:1 borderColor:RGBCOLOR(227, 227, 227)];
    [btnItem setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
//    switch (row) {
//        case 0://律师
//        {
//            [btnItem setViewRound:5 borderWidth:1 borderColor:RGBCOLOR(24, 184, 234)];
//            [btnItem setTitleColor:RGBCOLOR(24, 184, 234) forState:(UIControlStateNormal)];
//            break;
//        }
//        case 1://会计
//        {
//            [btnItem setViewRound:5 borderWidth:1 borderColor:RGBCOLOR(115, 171, 248)];
//            [btnItem setTitleColor:RGBCOLOR(115, 171, 248) forState:(UIControlStateNormal)];
//            break;
//        }
//        case 2://证券
//        {
//            [btnItem setViewRound:5 borderWidth:1 borderColor:RGBCOLOR(247, 98, 103)];
//            [btnItem setTitleColor:RGBCOLOR(247, 98, 103) forState:(UIControlStateNormal)];
//            break;
//        }
//        default: break;
//    }
}

-(void)btnItemClick:(ZRankButton *)sender
{
    if (sender.type == 1) {
        if (self.onRankCompanyClick) {
            self.onRankCompanyClick(sender.modelCommpany);
        }
    } else if (sender.type == 2) {
        if (self.onRankUserClick) {
            self.onRankUserClick(sender.modelUser);
        }
    }
}

-(void)setViewNil
{
    for (UIView *view in self.viewContent.subviews) {
        [view removeFromSuperview];
    }
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewLine);
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
