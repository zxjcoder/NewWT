//
//  ZFeekBackImagesTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackImagesTVC.h"

@interface ZFeekBackImagesTVC()

@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZButton *btnAdd;

@property (strong, nonatomic) NSMutableArray *arrayImages;

@end

@implementation ZFeekBackImagesTVC

static CGFloat itemSize = 60;
static CGFloat itemSpace = 13;
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
    self.cellH = [ZFeekBackImagesTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.viewContent = [[ZView alloc] initWithFrame:(CGRectMake(self.space, 10, self.cellW-self.space*2, self.cellH-10))];
    [self.viewMain addSubview:self.viewContent];
    self.arrayImages = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        CGFloat itemX = itemSpace*(i-1)+itemSize*(i-1);
        ZImageView *imageView = [[ZImageView alloc] initWithFrame:(CGRectMake(itemX, 0, itemSize, itemSize))];
        [imageView setHidden:true];
        [imageView setBackgroundColor:COLORVIEWBACKCOLOR2];
        [[imageView layer] setMasksToBounds:true];
        [imageView setUserInteractionEnabled:true];
        [imageView setTag:i];
        [imageView setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
        
        ZButton *btnItem = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [btnItem setFrame:(CGRectMake(imageView.width-19, -1, 20, 20))];
        [btnItem setImage:[SkinManager getImageWithName:@"img_delete"] forState:(UIControlStateNormal)];
        [btnItem setImage:[SkinManager getImageWithName:@"img_delete"] forState:(UIControlStateHighlighted)];
        [btnItem setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [btnItem setUserInteractionEnabled:true];
        [btnItem setTag:i];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [imageView addSubview:btnItem];
        [imageView bringSubviewToFront:btnItem];
        
        [self.viewContent addSubview:imageView];
    }
    self.btnAdd = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAdd setFrame:(CGRectMake(self.viewContent.x, self.viewContent.y, itemSize, itemSize))];
    [self.btnAdd setBackgroundImage:[SkinManager getImageWithName:@"img_add"] forState:(UIControlStateNormal)];
    [self.btnAdd setBackgroundImage:[SkinManager getImageWithName:@"img_add"] forState:(UIControlStateHighlighted)];
    //[self.btnAdd setImage:[SkinManager getImageWithName:@"img_add"] forState:(UIControlStateNormal)];
    //[self.btnAdd setImage:[SkinManager getImageWithName:@"img_add"] forState:(UIControlStateHighlighted)];
    [self.btnAdd setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnAdd setUserInteractionEnabled:true];
    [self.btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnAdd];
    [self.viewMain sendSubviewToBack:self.viewContent];
}
-(void)btnItemClick:(UIButton *)sender
{
    if (sender.tag <= self.arrayImages.count) {
        [self.arrayImages removeObjectAtIndex:sender.tag-1];
        [self setReloadView];
    }
}
-(void)btnAddClick
{
    if (self.onAddImageClick) {
        self.onAddImageClick();
    }
}
///移除所有的图片
-(void)removeImageArray
{
    [self.arrayImages removeAllObjects];
    [self setReloadView];
}
///设置图片集合
-(void)setCellDataImage:(NSArray *)array
{
    [self.arrayImages addObjectsFromArray:array];
    [self setReloadView];
}
-(void)setReloadView
{
    for (ZImageView *imageView in self.viewContent.subviews) {
        imageView.hidden = true;
    }
    if (self.arrayImages.count > 0) {
        for (int i = 0; i < self.arrayImages.count; i++) {
            ZImageView *imageItem = [self.viewContent viewWithTag:i+1];
            if (imageItem) {
                imageItem.hidden = false;
                imageItem.image = [self.arrayImages objectAtIndex:i];
            }
        }
    }
    [self.btnAdd setHidden:self.arrayImages.count>=4];
    self.btnAdd.frame = CGRectMake(self.viewContent.x+itemSize*(self.arrayImages.count)+itemSpace*(self.arrayImages.count), self.viewContent.y, itemSize, itemSize);
}
-(NSArray *)getImagesArray
{
    return self.arrayImages;
}
+(CGFloat)getH
{
    return 75;
}

@end
