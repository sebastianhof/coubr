//
//  coubrHelpViewController.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrHelpViewController.h"
#import "coubrConstants.h"

@interface coubrHelpViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *helpWebView;

@end

@implementation coubrHelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:HELP_URL];
    [self.helpWebView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Handle error;
     NSLog(@"Could not load help site: %@", [error localizedDescription]);
}


@end
