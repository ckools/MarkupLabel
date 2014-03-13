//
//  NIMViewController.m
//  CoreTextHTML
//
//  Created by Jonathan Wight on 3/13/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

#import "NIMViewController.h"

#import "UILabel+SimpleHTMLExtensions.h"

@interface NIMViewController ()
@property (readwrite, nonatomic, strong) IBOutlet UILabel *label;
@end

@implementation NIMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.label setMarkup:@"<b>Hello</b> world!"];
}


@end
