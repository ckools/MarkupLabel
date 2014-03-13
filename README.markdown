# MarkupLabel

This is a subset of my CoreTextToy (https://github.com/schwa/CoreTextToy) extracted out into it's own github repo.

Specifically this code allows you to use (simple) HTML markup with UILabel.

## License

This code is licensed under the 2-clause BSD license ("Simplified BSD License" or "FreeBSD License") license. The license is reproduced below:

Copyright 2011 Jonathan Wight. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY JONATHAN WIGHT ''AS IS'' AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHAN WIGHT OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of Jonathan Wight.

## Requirements

The master and develop branches require iOS 6.0 or higher with ARC.

## Design

### UILabel+MarkupExtensions

This implements a "setMarkup:" method. Pass it HTML. This is the point of this library.

### CMarkupValueTransformer

A value transformer capable of converting _simple_ markup (a small subset of HTML) into a NSAttributedString.

### UIFont+MarkupExtensions

Extension on UIFont to get a CTFont and to get bold/italic, etc variations of the font. Scans the font name to work out the attributes of a particular font.

This code is crude and effective - but needs to be tested on _all_ iOS font names (especially the weirder ones).

## FAQ

### Why does this even exist? Why not just use UIWebView?

UIWebViews are expensive to create and are pretty much overkill when all you need is a simple UILabel type class that shows static styled text.

### Why does this even exist? Why not just use https://github.com/Cocoanetics/NSAttributedString-Additions-for-HTML

CCoreTextLabel is designed simply to show static text on screen, akin to UILabel. "NSAttributedString-Additions-for-HTML" seems to do a lot of things that I just dont need.

### How much HTML does this thing support?

It uses a minimal subset of HTML. In fact don't think of it as pure HTML - think of it as just a convenient method for creating NSAttributedString.

Only a handful of tags are supported right now, but you can define your own quite easily.

The following tags are supported. More tags might be supported, see the source code for details.

* &lt;br&gt;
* &lt;b&gt;
* &lt;i&gt;
* &lt;mark&gt;
* &lt;strike&gt;

### What about link (<a>) and image (<img>) tags?

Img tags are not supported. You'll need to use CoreTextToy for that. Links might be supported pending further testing.

### So how do I get HTML into a UILabel?

The quick way:

    NSString *theMarkup = @"<b>Hello world</b>";
    NSError *theError = NULL;
    NSString *theAttributedString = [NSAttributedString attributedStringWithMarkup:theMarkup error:&theError];
    // Error checking goes here.
    theLabel.attributedString = theAttributedString

The quicker way (if you want to use the CCoreTextLabel_HTMLExtensions category)

    NSString *theMarkup = @"<b>Hello world</b>";
    theLabel.markup = theMarkup;

For the long way, see "How do I add custom styles?"

### How do I add custom styles?

    // Here's the markup we want to put into our. Note the custom <username> tag
    NSString *theMarkup = [NSString stringWithFormat:@"<username>%@</username> %@", theUsername, theBody];

    NSError *theError = NULL;

    // Create a transformer and give it a default font.
    CMarkupValueTransformer *theTransformer = [[CMarkupValueTransformer alloc] init];
    theTransformer.standardFont = [UIFont systemFontOfSize:13];

    // Create custom attributes for our new "username" tag
    NSDictionary *theAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
        (__bridge id)[UIColor blueColor].CGColor, (__bridge NSString *)kCTForegroundColorAttributeName,
        (__bridge id)[theTransformer.standardFont boldFont].CTFont, (__bridge NSString *)kCTFontAttributeName,
        NULL];
    [theTransformer addStyleHandlerWithAttributes:theAttributes forTagSet:[NSSet setWithObject:@"username"]];

    // Transform the markup into a NSAttributedString
    NSAttributedString *theAttributedString = [theTransformer transformedValue:theMarkup error:&theError];

    // Give the attributed string to the CCoreTextLabel.
    self.label.text = theAttributedString;
