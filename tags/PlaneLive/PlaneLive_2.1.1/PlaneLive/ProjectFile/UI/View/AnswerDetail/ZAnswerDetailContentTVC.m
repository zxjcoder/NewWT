//
//  ZAnswerDetailContentTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailContentTVC.h"
#import "TYAttributedLabel.h"
#import "Utils.h"
#import "SEImageCache.h"

@interface ZAnswerDetailContentTVC()<TYAttributedLabelDelegate>

@property (strong, nonatomic) TYAttributedLabel *lbAttributed;

@property (strong, nonatomic) UIImageView *imageLine1;
@property (strong, nonatomic) UIImageView *imageLine2;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@property (assign, nonatomic) CGRect contentFrame;

@property (strong, nonatomic) NSMutableArray *arrImgUrl;

@end

@implementation ZAnswerDetailContentTVC

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
    
    self.imageLine1 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imageLine1];
    
    self.imageLine2 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imageLine2];
    
    [self createLabelAttributed];
}

-(void)createLabelAttributed
{
    self.contentFrame = CGRectMake(self.space, kSize10+self.lineMaxH, self.cellW-self.space*2, 0);
    self.lbAttributed = [[TYAttributedLabel alloc] initWithFrame:self.contentFrame];
    [self.lbAttributed setDelegate:self];
    [self.lbAttributed setUserInteractionEnabled:YES];
    [self.lbAttributed setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbAttributed];
}

-(void)setViewFrame
{
    [self.lbAttributed sizeToFit];
    CGRect titleFrame = self.lbAttributed.frame;
    if (self.modelAB.title && self.modelAB.title.length > 0) {
        titleFrame.origin.y = kSize10+self.lineMaxH;
        
        [self.imageLine1 setHidden:NO];
        [self.imageLine1 setFrame:CGRectMake(0, 0, self.cellW, self.lineMaxH)];
    } else {
        titleFrame.origin.y = kSize10;
        
        [self.imageLine1 setHidden:YES];
    }
    [self.lbAttributed setFrame:titleFrame];
    
    CGFloat lineY = self.lbAttributed.y+self.lbAttributed.height;
    if (lineY > 18) {
        lineY = lineY+self.space;
    }
    [self.imageLine2 setFrame:CGRectMake(0, lineY, self.cellW, self.lineMaxH)];
    
    self.cellH = lineY+self.lineMaxH;
    //TODO:ZWW备注-答案详情内容高度
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    if (self.onRefreshTVC) {
        self.onRefreshTVC();
    }
}

-(void)setViewContent
{
    [self setCellFontSize];
    
    if (self.modelAB) {
        
        NSString *string = self.modelAB.title;
        
        [self.lbAttributed setText:kEmpty];
        [self.lbAttributed setAttributedText:[[NSAttributedString alloc] initWithString:kEmpty]];
        
        NSArray *theArray = [Utils getRegularImg:string];
        
        NSString *newString = string;
        
        if (theArray.count > 0) {
            NSString *value = @"@!#$@!#$@!#$@!#$";
            NSString *key = [NSString stringWithFormat:@"&%@&",value];
            
            if (self.arrImgUrl == nil) {
                self.arrImgUrl = [NSMutableArray array];
            } else {
                [self.arrImgUrl removeAllObjects];
            }
            for (NSTextCheckingResult *ele in theArray) {
                NSString *theLastString = [string substringWithRange:[ele rangeAtIndex:0]];
                
                newString = [newString stringByReplacingOccurrencesOfString:theLastString withString:key];
                
                NSString *imgPath = [Utils getTrimImg:theLastString];
                [self.arrImgUrl addObject:imgPath];
            }
            NSArray *arrSepValue = [newString componentsSeparatedByString:@"&"];
            int row = 0;
            __weak typeof(self) weakSelf = self;
            for (NSString *sepValue in arrSepValue) {
                if ([sepValue isEqualToString:value]) {
                    if ([self.arrImgUrl count] > row) {
                        NSString *imgPath = [self.arrImgUrl objectAtIndex:row];
                        UIImage *img = [[SEImageCache sharedInstance] imageForURL:imgPath completionBlock:^(UIImage *image, NSError *error) {
                            if (image) {
                                GCDMainBlock(^{
                                    [weakSelf setViewContent];
                                });
                            }
                        }];
                        if (img) {
                            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                            [imageStorage setTag:row];
                            [imageStorage setImageURL:[NSURL URLWithString:imgPath]];
                            [imageStorage setImageAlignment:TYImageAlignmentFill];
                            [imageStorage setSize:CGSizeMake(CGRectGetWidth(self.lbAttributed.frame), 0)];
                            
                            CGFloat scale = weakSelf.lbAttributed.frame.size.width/img.size.width;
                            CGFloat imgW = weakSelf.lbAttributed.frame.size.width;
                            CGFloat imgH = img.size.height * scale;
                            
                            [imageStorage setImage:img];
                            [imageStorage setSize:CGSizeMake(imgW, imgH)];
                            
                            [self.lbAttributed appendTextStorage:imageStorage];
                        }
                        row++;
                    }
                } else {
                    NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:sepValue];
                    [strAttributed addAttributeTextColor:BLACKCOLOR1];
                    [strAttributed addAttributeFont:[ZFont systemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
                    [self.lbAttributed appendTextAttributedString:strAttributed];
                }
            }
        } else {
            NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:string];
            [strAttributed addAttributeTextColor:BLACKCOLOR1];
            [strAttributed addAttributeFont:[ZFont systemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
            [self.lbAttributed appendTextAttributedString:strAttributed];
        }
    }
    
    [self setViewFrame];
}
///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
}

-(CGFloat)setCellDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    [self setViewContent];
    
    return self.cellH;
}

-(void)setViewNil
{
    [_lbAttributed setDelegate:nil];
    OBJC_RELEASE(_lbAttributed);
    OBJC_RELEASE(_imageLine1);
    OBJC_RELEASE(_imageLine2);
    OBJC_RELEASE(_modelAB);
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

-(CGFloat)getHWithModel:(ModelAnswerBase *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

#pragma mark - 

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
    if ([textStorage isKindOfClass:[TYImageStorage class]]) {
        TYImageStorage *imageStorage = (TYImageStorage*)textStorage;
        if (self.onImageClick) {
            self.onImageClick(imageStorage.image, imageStorage.imageURL, imageStorage.tag, _arrImgUrl, imageStorage.size);
        }
    } else if ([textStorage isKindOfClass:[TYLinkTextStorage class]]) {
        TYLinkTextStorage *linkTextStorage = (TYLinkTextStorage*)textStorage;
        SafariOpen(linkTextStorage.text);
    }
}

@end
