//
//  ZAnswerDetailContentTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailContentTVC.h"
#import "ZTextAttachment.h"
#import "TYAttributedLabel.h"
#import "Utils.h"
#import "SEImageCache.h"

@interface ZAnswerDetailContentTVC()<UITextViewDelegate,TYAttributedLabelDelegate>

@property (strong, nonatomic) TYAttributedLabel *lbAttributed;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@property (assign, nonatomic) CGRect contentFrame;

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
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewL];
    
    [self createLabelAttributed];
}

-(void)createLabelAttributed
{
    self.contentFrame = CGRectMake(self.space, self.space, self.cellW-self.space*2, 0);
    self.lbAttributed = [[TYAttributedLabel alloc] initWithFrame:self.contentFrame];
    [self.lbAttributed setDelegate:self];
    [self.lbAttributed setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbAttributed];
}

-(void)setViewFrame
{
    [self.lbAttributed sizeToFit];
    
    CGFloat lineY = self.lbAttributed.y+self.lbAttributed.height;
    if (lineY > 18) {
        lineY = lineY+self.space;
    }
    [self.viewL setFrame:CGRectMake(0, lineY, self.cellW, self.lineMaxH)];
    
    self.cellH = lineY+self.lineMaxH;
    
    NSLog(@"lbAttributed sizeToFit: %.2f  ,  lineY: %.2f , cellH: %.2f", self.lbAttributed.height,lineY, self.cellH);
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    if (self.onRefreshTVC) {
        self.onRefreshTVC();
    }
}

-(void)setViewContent
{
    if (self.modelAB) {
        
        NSString *string = self.modelAB.title;
        
        [self.lbAttributed setText:kEmpty];
        [self.lbAttributed setAttributedText:[[NSAttributedString alloc] initWithString:kEmpty]];
        
        NSArray *theArray = [Utils getRegularImg:string];
        
        NSString *newString = string;
        
        NSMutableArray *arrImage = [NSMutableArray array];
        if (theArray.count > 0) {
            NSString *value = @"@!#$@!#$@!#$@!#$";
            NSString *key = [NSString stringWithFormat:@"&%@&",value];
            for (NSTextCheckingResult *ele in theArray) {
                NSString *theLastString = [string substringWithRange:[ele rangeAtIndex:0]];
                
                newString = [newString stringByReplacingOccurrencesOfString:theLastString withString:key];
                
                [arrImage addObject:theLastString];
            }
            NSArray *arrSepValue = [newString componentsSeparatedByString:@"&"];
            int row = 0;
            __weak typeof(self) weakSelf = self;
            for (NSString *sepValue in arrSepValue) {
                if ([sepValue isEqualToString:value]) {
                    if (arrImage.count > row) {
                        NSString *imgHtml = [arrImage objectAtIndex:row];
                        NSString *imgPath = [Utils getTrimImg:imgHtml];
                        
                        UIImage *img = [[SEImageCache sharedInstance] imageForURL:imgPath completionBlock:^(UIImage *image, NSError *error) {
                            if (image) {
                                dispatch_async(dispatch_get_main_queue(), ^ {
                                    [weakSelf setViewContent];
                                });
                            }
                        }];
                        if (img) {
                            TYImageStorage *imageUrlStorage = [[TYImageStorage alloc]init];
                            [imageUrlStorage setImageAlignment:TYImageAlignmentFill];
                            imageUrlStorage.size = CGSizeMake(CGRectGetWidth(self.lbAttributed.frame), 0);
                            
                            CGFloat scale = weakSelf.lbAttributed.frame.size.width/img.size.width;
                            CGFloat imgW = weakSelf.lbAttributed.frame.size.width;
                            CGFloat imgH = img.size.height * scale;
                            
                            [imageUrlStorage setImage:img];
                            [imageUrlStorage setSize:CGSizeMake(imgW, imgH)];
                            
                            [self.lbAttributed appendTextStorage:imageUrlStorage];
                        }
                        row++;
                    }
                } else {
                    NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:sepValue];
                    [strAttributed addAttributeTextColor:BLACKCOLOR1];
                    [strAttributed addAttributeFont:[UIFont systemFontOfSize:kFont_Default_Size]];
                    [self.lbAttributed appendTextAttributedString:strAttributed];
                }
            }
        } else {
            NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:string];
            [strAttributed addAttributeTextColor:BLACKCOLOR1];
            [strAttributed addAttributeFont:[UIFont systemFontOfSize:kFont_Default_Size]];
            [self.lbAttributed appendTextAttributedString:strAttributed];
        }
    }
    [self setViewFrame];
}

-(void)setCellDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    [self setViewContent];
}

-(void)setViewNil
{
    [_lbAttributed setDelegate:nil];
    OBJC_RELEASE(_lbAttributed);
    OBJC_RELEASE(_viewL);
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
            self.onImageClick(imageStorage.image, imageStorage.imageURL, imageStorage.size);
        }
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return YES;
}

@end
