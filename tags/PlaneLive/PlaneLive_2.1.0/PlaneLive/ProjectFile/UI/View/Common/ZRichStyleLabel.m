//
//  ZRichStyleLabel.m
//  PlaneCircle
//
//  Created by Daniel on 8/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRichStyleLabel.h"
#import "ClassCategory.h"
#import "Utils.h"

@interface ZRichStyleLabel()

@end

@implementation ZRichStyleLabel

- (void)setText:(NSString *)text
{
    NSString *content = text.imgReplacing;
    if (content) {
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
    }
    [super setText:content];
}

#pragma mark - Link

- (void)setLinkAttributedText:(NSString *)text
{
    [self setLinkAttributedText:text linkAttributes:nil];
}

- (void)setLinkAttributedText:(NSString *)text linkAttributes:(NSDictionary *)attributesDict
{
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                               error:nil];
    [self setAttributedText:text withRegularExpression:detector attributes:attributesDict];
}

#pragma mark - Regualr Expression

- (void)setAttributedText:(NSString *)text
       withRegularPattern:(NSString *)pattern
               attributes:(NSDictionary *)attributesDict
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:nil];
    [self setAttributedText:text withRegularExpression:regex attributes:attributesDict];
}

/**
 关键字高亮设置
 */
- (void)setAttributedText:(NSString *)text
    withRegularExpression:(NSRegularExpression *)expression
               attributes:(NSDictionary *)attributesDict
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [expression enumerateMatchesInString:text
                                 options:0
                                   range:NSMakeRange(0, [text length])
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  NSRange matchRange = [result range];
                                  if (attributesDict) {
                                      [attributedString addAttributes:attributesDict range:matchRange];
                                  }
                                  
                                  if ([result resultType] == NSTextCheckingTypeLink) {
                                      NSURL *url = [result URL];
                                      [attributedString addAttribute:NSLinkAttributeName value:url range:matchRange];
                                  }
                              }];
    [self setAttributedText:attributedString];
}

- (void)setAttributedText:(NSString *)text withPatternAttributeDictionary:(NSDictionary *)dictionary
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSRegularExpression *expression;
            NSDictionary *attributesDict = (NSDictionary *)obj;
            
            if ([key isKindOfClass:[NSRegularExpression class]]) {
                expression = (NSRegularExpression *)key;
            } else if ([key isKindOfClass:[NSString class]]) {
                expression = [NSRegularExpression regularExpressionWithPattern:key
                                                                       options:0
                                                                         error:nil];
            }
            
            [expression enumerateMatchesInString:text
                                         options:0
                                           range:NSMakeRange(0, [text length])
                                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                          NSRange matchRange = [result range];
                                          if (attributesDict) {
                                              [attributedString addAttributes:attributesDict range:matchRange];
                                          }
                                      }];
        }
    }];
    [self setAttributedText:attributedString];
}

@end


@implementation NSString (RegularString)
/**
 关键字 正则判断
 */
-(NSString *)regularPattern:(NSArray *)keys
{
    NSMutableString *pattern = [[NSMutableString alloc]initWithString:@"(?i)"];
    
    for (NSString *key in keys) {
        [pattern appendFormat:@"%@|",key];
    }
    
    return pattern;
}

@end
