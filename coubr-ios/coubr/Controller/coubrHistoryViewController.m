//
//  coubrHistoryViewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrHistoryViewController.h"

@interface coubrHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@end

@implementation coubrHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.historyTableView setDataSource:self];
    [self.historyTableView setDelegate:self];
}

#pragma mark - Table View Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrHistoryTableViewCell"];

    return cell;
}

@end
