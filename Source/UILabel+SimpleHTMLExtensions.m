//
//  UILabel+SimpleHTMLExtensions.m
//  CoreTextHTML
//
//  Created by Jonathan Wight on 3/13/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

#import "UILabel+SimpleHTMLExtensions.h"

#import <objc/runtime.h>

#import "NSString_HTMLExtensions.h"
#import "CMarkupValueTransformer.h"
#import "NSAttributedString_Extensions.h"

@implementation UILabel (SimpleHTMLExtensions)

static void *kMarkupValueTransformerKey;

- (CMarkupValueTransformer *)markupValueTransformer
    {
    CMarkupValueTransformer *theMarkupValueTransformer = objc_getAssociatedObject(self, &kMarkupValueTransformerKey);
    if (theMarkupValueTransformer == NULL)
        {
        theMarkupValueTransformer = [[CMarkupValueTransformer alloc] init];
        theMarkupValueTransformer.whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
        objc_setAssociatedObject(self, &kMarkupValueTransformerKey, theMarkupValueTransformer, OBJC_ASSOCIATION_RETAIN);
        }
    return(theMarkupValueTransformer);
    }
    
- (void)setMarkupValueTransformer:(CMarkupValueTransformer *)inMarkupValueTransformer
    {
    objc_setAssociatedObject(self, &kMarkupValueTransformerKey, inMarkupValueTransformer, OBJC_ASSOCIATION_RETAIN);
    }

- (void)setMarkup:(NSString *)inMarkup
    {
    NSError *theError = NULL;
    NSAttributedString *theAttributedString = [self.markupValueTransformer transformedValue:inMarkup error:&theError];
    NSAssert1(theAttributedString != NULL, @"Could not transform HTML into attributed string: %@", theError);
    self.attributedText = [NSAttributedString normalizedAttributedStringForAttributedString:theAttributedString baseFont:self.font];
    }

@end
