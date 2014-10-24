//
//  coubrLegalViewController.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrLegalViewController.h"
#import "coubrConstants.h"

@interface coubrLegalViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *legalWebView;

@end

@implementation coubrLegalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:COUBR_BASE_URL];
    url = [url URLByAppendingPathComponent:LEGAL_URL];
    [self.legalWebView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Handle error;
    NSLog(@"Could not load legal site: %@", [error localizedDescription]);
}


@end
