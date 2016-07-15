//
//  NIMViewController.m
//  CoreTextHTML
//
//  Created by Jonathan Wight on 3/13/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

#import "NIMViewController.h"

#import "UILabel+MarkupExtensions.h"
#import "CMarkupTransformer.h"

@interface NIMViewController ()
@end

@implementation NIMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (id theSubview in self.view.subviews)
        {
        if ([theSubview isKindOfClass:[UILabel class]] == NO)
            {
            continue;
            }

        UILabel *theLabel = theSubview;
        [theLabel setMarkup:theLabel.text];
        }
}


@end
