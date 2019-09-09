//
//  ZRichStyleLabel.h
//  PlaneCircle
//
//  Created by Daniel on 8/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRichStyleLabel : UILabel

#pragma mark - Link

- (void)setLinkAttributedText:(NSString *)text;

- (void)setLinkAttributedText:(NSString *)text linkAttributes:(NSDictionary *)attributesDict;

#pragma mark - Regualr Expression

- (void)setAttributedText:(NSString *)text
    withRegularExpression:(NSRegularExpression *)expression
               attributes:(NSDictionary *)attributesDict;

- (void)setAttributedText:(NSString *)text
       withRegularPattern:(NSString *)pattern
               attributes:(NSDictionary *)attributesDict;

- (void)setAttributedText:(NSString *)text withPatternAttributeDictionary:(NSDictionary *)dictionary;

@end


@interface NSString (RegularString)

-(NSString *)regularPattern:(NSArray *)keys;

@end
