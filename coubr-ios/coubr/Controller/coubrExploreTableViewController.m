//
//  coubrExploreTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 17/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "coubrExploreTableViewController.h"
#import "coubrExploreTableViewCell.h"

#import "Explore.h"

@interface coubrExploreTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *exploreTableView;

@end

@implementation coubrExploreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.exploreTableView setDataSource:self];
    [self.exploreTableView setDelegate:self];
    
    [self initRefreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:FetchedResultsControllerDidUpdatedNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {
        [self.exploreTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    
}

#pragma mark - Init

- (void)initRefreshControl
{
    
    if (!self.refreshControl) {
        self.refreshControl = [[UIRefreshControl alloc] init];
    }
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"Refreshing coubr"];

    [title addAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Raleway-Light" size:14] }
                   range:NSMakeRange(0, 10)];
    
    [title addAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Courgette" size:14] }
                   range:NSMakeRange(11, 5)];

    [self.refreshControl setAttributedTitle:title];
    self.refreshControl.tintColor = [UIColor colorWithRed:51 green:51 blue:51 alpha:1];
    
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Refresh

- (void)refreshTableView
{
    [self.parentController refresh];
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.parentController.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.parentController.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.parentController.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrExploreTableViewCell" forIndexPath:indexPath];
    
    NSManagedObject *managedObject = [self.parentController.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[Explore class]]) {
        [(coubrExploreTableViewCell *) cell initCellWithExploreItem:(Explore *)managedObject];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([[self.parentController.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.parentController.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else {
        return nil;
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.parentController.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.parentController.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

@end
