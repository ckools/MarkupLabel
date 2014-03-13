//
//  UILabel+SimpleHTMLExtensions.h
//  CoreTextHTML
//
//  Created by Jonathan Wight on 3/13/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMarkupValueTransformer;

@interface UILabel (SimpleHTMLExtensions)

@property (readwrite, nonatomic, strong) CMarkupValueTransformer *markupValueTransformer;

- (void)setMarkup:(NSString *)inMarkup;

@end
