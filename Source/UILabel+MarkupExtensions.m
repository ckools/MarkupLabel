//
//  UILabel+MarkupExtensions.m
//  CoreTextHTML
//
//  Created by Jonathan Wight on 3/13/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY TOXICSOFTWARE.COM ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL TOXICSOFTWARE.COM OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import "UILabel+MarkupExtensions.h"

#import <objc/runtime.h>

#import "NSString+MarkupExtensions.h"
#import "CMarkupValueTransformer.h"
#import "NSAttributedString+MarkupExtensions.h"

@implementation UILabel (MarkupExtensions)

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

    theAttributedString = [NSAttributedString normalizedAttributedStringForAttributedString:theAttributedString baseFont:self.font];

    self.attributedText = theAttributedString;
    }

@end
