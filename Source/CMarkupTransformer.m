//
//  CMarkupValueTransformer.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
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

#import "CMarkupTransformer.h"

#import "CSimpleMarkupParser.h"
#import "CColorConverter.h"
#import "UIFont+StyleUtilities.h"

NSString *const kMarkupBoldMetaAttributeName = @"com.touchcode.bold";
NSString *const kMarkupItalicMetaAttributeName = @"com.touchcode.italic";
NSString *const kMarkupSizeAdjustmentMetaAttributeName = @"com.touchcode.sizeAdjustment";
NSString *const kMarkupFontNameMetaAttributeName = @"com.touchcode.fontName";
NSString *const kMarkupFontSizeMetaAttributeName = @"com.touchcode.fontSize";
NSString *const kMarkupOutlineMetaAttributeName = @"com.touchcode.outline";

@interface CMarkupTransformerContext : NSObject <CMarkupTransformerContext>
@property (readwrite, nonatomic) NSAttributedString *currentString;
@end

#pragma mark -

@implementation CMarkupTransformerContext
@end

#pragma mark -

@interface CMarkupTransformer ()
@property (readwrite, nonatomic, strong) NSMutableDictionary *tagHandlers;
@end

#pragma mark -

@implementation CMarkupTransformer

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        _tagHandlers = [NSMutableDictionary dictionary];
		}
	return(self);
	}
    
- (NSAttributedString *)transformMarkup:(NSString *)value baseFont:(UIFont *)inBaseFont error:(NSError **)outError;
    {
    NSString *theMarkup = value;

    NSMutableAttributedString *theAttributedString = [[NSMutableAttributedString alloc] init];

    __block NSMutableDictionary *theTextAttributes = NULL;
    __block NSURL *theCurrentLink = NULL;

    CSimpleMarkupParser *theParser = [[CSimpleMarkupParser alloc] init];
    if (self.whitespaceCharacterSet != NULL)
        {
        theParser.whitespaceCharacterSet = self.whitespaceCharacterSet;
        }

    theParser.openTagHandler = ^(CSimpleMarkupTag *inTag, NSArray *tagStack) {
        if ([inTag.name isEqualToString:@"a"] == YES)
            {
            NSString *theURLString = (inTag.attributes)[@"href"];
            if ((id)theURLString != [NSNull null] && theURLString.length > 0)
                {
                theCurrentLink = [NSURL URLWithString:theURLString];
                }
            }
		else if ([inTag.name isEqualToString:@"p"] == YES)
			{
			NSAttributedString *as = [[NSAttributedString alloc] initWithString:@"\n"];
			[theAttributedString appendAttributedString:as];
			}
        };

    theParser.closeTagHandler = ^(CSimpleMarkupTag *inTag, NSArray *tagStack) {
        if ([inTag.name isEqualToString:@"a"] == YES)
            {
            theCurrentLink = NULL;
            }
    };

    theParser.textHandler = ^(NSString *inString, NSArray *tagStack) {
        NSDictionary *theAttributes = [self attributesForTagStack:tagStack currentString:theAttributedString];
        theTextAttributes = [theAttributes mutableCopy];

        if (theCurrentLink != NULL)
            {
            theTextAttributes[NSLinkAttributeName] = theCurrentLink;
            }
        
        [theAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:inString attributes:theTextAttributes]];
        };

    // In this section we use the NSScanner method
    // - (BOOL)scanCharactersFromSet:(NSCharacterSet *)scanSet intoString:(NSString **)stringValue
    // Apparently `stringValue` is autoreleased and ARC does not handle that properly.
    // Therefore we need this autorelease pool.
    @autoreleasepool
        {
        if ([theParser parseString:theMarkup error:outError] == NO)
            {
            return(NULL);
            }
        }

    return([self normalizedAttributedStringForAttributedString:theAttributedString baseFont:inBaseFont]);
    }

- (void)addStandardStyles
    {
    MarkupTagHandler theTagHandler = NULL;

    // ### b
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        return(@{kMarkupBoldMetaAttributeName: @YES});
        };
    [self addHandler:theTagHandler forTag:@"b"];
    [self addHandler:theTagHandler forTag:@"strong"];

    // ### i
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        return(@{kMarkupItalicMetaAttributeName: @YES});
        };
    [self addHandler:theTagHandler forTag:@"i"];
    [self addHandler:theTagHandler forTag:@"em"];

    // ### a
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        return(@{
			NSForegroundColorAttributeName: [UIColor blueColor],
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
			});
        };
    [self addHandler:theTagHandler forTag:@"a"];

    // ### mark
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        return(@{
			NSForegroundColorAttributeName: [UIColor yellowColor],
			});
        };
    [self addHandler:theTagHandler forTag:@"mark"];

    // ### strike
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        return(@{
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)
            });
        };
    [self addHandler:theTagHandler forTag:@"strike"];

    // ### outline
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        return(@{kMarkupOutlineMetaAttributeName: @YES});
        };
    [self addHandler:theTagHandler forTag:@"outline"];

    // ### small
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        return(@{kMarkupSizeAdjustmentMetaAttributeName: @-4.0f});
        };
    [self addHandler:theTagHandler forTag:@"small"];

    // ### font
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {

        NSMutableDictionary *theStyle = [NSMutableDictionary dictionary];

        NSString *theFaceAttribute = inTag.attributes[@"face"];
        if (theFaceAttribute.length > 0)
            {
            theStyle[kMarkupFontNameMetaAttributeName] = theFaceAttribute;
            }
        NSString *theColorString = inTag.attributes[@"color"];
        if (theColorString.length > 0)
            {
            UIColor *theColor = [UIColor colorWithString:theColorString error:NULL];
            theStyle[NSForegroundColorAttributeName] = theColor;
            }
        NSString *theSizeString = inTag.attributes[@"size"];
        if (theSizeString.length > 0)
            {
            theStyle[kMarkupFontSizeMetaAttributeName] = @(theSizeString.floatValue);
            }
        return(theStyle);
        };
    [self addHandler:theTagHandler forTag:@"font"];


    // ### Shadows
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        NSShadow *theShadow = [[NSShadow alloc] init];
        theShadow.shadowOffset = (CGSize){ 1, 1 };
        return(@{
            NSShadowAttributeName: theShadow,
            });
        };
    [self addHandler:theTagHandler forTag:@"xshadow"];

    // ### Letter Press
    theTagHandler = ^(CSimpleMarkupTag *inTag, id <CMarkupTransformerContext> context) {
        return(@{
            NSTextEffectAttributeName: NSTextEffectLetterpressStyle,
            });
        };
    [self addHandler:theTagHandler forTag:@"xletterpress"];
    }

- (void)addHandler:(MarkupTagHandler)inHandler forTag:(NSString *)inTag
    {
    (self.tagHandlers)[inTag] = [inHandler copy];
    }

- (void)removeHandlerForTag:(NSString *)inTag
    {
    [self.tagHandlers removeObjectForKey:inTag];
    }

#pragma mark -

- (NSDictionary *)attributesForTagStack:(NSArray *)inTagStack currentString:(NSAttributedString *)inAttributedString
    {
    NSMutableDictionary *theCumulativeAttributes = [NSMutableDictionary dictionary];

    CMarkupTransformerContext *theContext = [[CMarkupTransformerContext alloc] init];
    theContext.currentString = inAttributedString;

    for (CSimpleMarkupTag *theTag in inTagStack)
        {
        MarkupTagHandler theHandler = (self.tagHandlers)[theTag.name]; 
        if (theHandler)
            {
            NSDictionary *theAttributes = theHandler(theTag, theContext);
            [theCumulativeAttributes addEntriesFromDictionary:theAttributes];
            }
        }

    return(theCumulativeAttributes);
    }

- (NSAttributedString *)normalizedAttributedStringForAttributedString:(NSAttributedString *)inAttributedString baseFont:(UIFont *)inBaseFont
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

- (NSDictionary *)normalizeAttributes:(NSDictionary *)inAttributes baseFont:(UIFont *)inBaseFont
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
