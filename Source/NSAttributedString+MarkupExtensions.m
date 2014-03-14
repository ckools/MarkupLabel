//
//  NSAttributedString_MarkupExtensions.m
//  CoreText
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

#import "NSAttributedString+MarkupExtensions.h"

#import "UIFont+StyleUtilities.h"

NSString *const kMarkupBoldMetaAttributeName = @"com.touchcode.bold";
NSString *const kMarkupItalicMetaAttributeName = @"com.touchcode.italic";
NSString *const kMarkupSizeAdjustmentMetaAttributeName = @"com.touchcode.sizeAdjustment";
NSString *const kMarkupFontNameMetaAttributeName = @"com.touchcode.fontName";
NSString *const kMarkupFontSizeMetaAttributeName = @"com.touchcode.fontSize";
NSString *const kMarkupOutlineMetaAttributeName = @"com.touchcode.outline";

@implementation NSAttributedString (MarkupExtensions)

+ (NSAttributedString *)normalizedAttributedStringForAttributedString:(NSAttributedString *)inAttributedString baseFont:(UIFont *)inBaseFont
    {
    NSMutableAttributedString *theString = [inAttributedString mutableCopy];
    
    [theString enumerateAttributesInRange:(NSRange){ .length = theString.length } options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIFont *theFont = inBaseFont;
        if (attrs[NSFontAttributeName] != NULL)
            {
            theFont = attrs[NSFontAttributeName];
            }

        attrs = [self normalizeAttributes:attrs baseFont:theFont];
        [theString setAttributes:attrs range:range];
        }];
    return(theString);
    }

+ (NSDictionary *)normalizeAttributes:(NSDictionary *)inAttributes baseFont:(UIFont *)inBaseFont
    {
    NSMutableDictionary *theAttributes = [inAttributes mutableCopy];
        
    // NORMALIZE ATTRIBUTES
    UIFont *theBaseFont = inBaseFont;
    NSString *theFontName = theAttributes[kMarkupFontNameMetaAttributeName];
    if (theFontName != NULL)
        {
        theBaseFont = [UIFont fontWithName:theFontName size:inBaseFont.pointSize];
        [theAttributes removeObjectForKey:kMarkupFontNameMetaAttributeName];
        }
    
    UIFont *theFont = theBaseFont;
    
    BOOL theBoldFlag = [theAttributes[kMarkupBoldMetaAttributeName] boolValue];
    if (theAttributes[kMarkupBoldMetaAttributeName] != NULL)
        {
        [theAttributes removeObjectForKey:kMarkupBoldMetaAttributeName];
        }

    BOOL theItalicFlag = [theAttributes[kMarkupItalicMetaAttributeName] boolValue];
    if (theAttributes[kMarkupItalicMetaAttributeName] != NULL)
        {
        [theAttributes removeObjectForKey:kMarkupItalicMetaAttributeName];
        }
    
    if (theBoldFlag == YES && theItalicFlag == YES)
        {
        theFont = theBaseFont.boldItalicFont;
        }
    else if (theBoldFlag == YES)
        {
        theFont = theBaseFont.boldFont;
        }
    else if (theItalicFlag == YES)
        {
        theFont = theBaseFont.italicFont;
        }

    if (theAttributes[kMarkupOutlineMetaAttributeName] != NULL)
        {
        [theAttributes removeObjectForKey:kMarkupOutlineMetaAttributeName];
		theAttributes[NSStrokeWidthAttributeName] = @(3.0);
        }

    NSNumber *theSizeValue = theAttributes[kMarkupFontSizeMetaAttributeName];
    if (theSizeValue != NULL)
        {
        CGFloat theSize = [theSizeValue floatValue];
        theFont = [theFont fontWithSize:theSize];
        
        [theAttributes removeObjectForKey:kMarkupFontSizeMetaAttributeName];
        }


    NSNumber *theSizeAdjustment = theAttributes[kMarkupSizeAdjustmentMetaAttributeName];
    if (theSizeAdjustment != NULL)
        {
        CGFloat theSize = [theSizeAdjustment floatValue];
        theFont = [theFont fontWithSize:theFont.pointSize + theSize];
        
        [theAttributes removeObjectForKey:kMarkupSizeAdjustmentMetaAttributeName];
        }

    if (theFont != NULL)
        {
        theAttributes[NSFontAttributeName] = theFont;
        }
        
    return(theAttributes);
    }
    
@end
