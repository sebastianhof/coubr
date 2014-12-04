//
//  coubrHistoryTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrHistoryTableViewController.h"
#import "coubrHistoryTableViewCell.h"
#import "coubrDatabaseManager.h"
#import <CoreData/CoreData.h>
#import "History+CRUD.h"
#import "History+Date.h"
#import "UIImage+ImageEffects.h"

@interface coubrHistoryTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *profileHistoryTableView;
@property (strong, nonatomic) NSFetchedResultsController *historyFetchedResultsController;
@property (weak, nonatomic) UIView* emptyTableView;

@end

@implementation coubrHistoryTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSError* error;
    [self.historyFetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Could not fetch history: %@", [error localizedDescription]);
    } else {
        
        if ([[self.historyFetchedResultsController fetchedObjects] count] > 0) {
            [self.profileHistoryTableView reloadData];
            
            [self hideEmptyTableView];
            
        } else {
            
            [self showEmptyTableView];

        }
        
    }

}

- (NSFetchedResultsController *)historyFetchedResultsController
{
    if (!_historyFetchedResultsController) {
        _historyFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[History fetchRequestForHistory] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:@"dateSection" cacheName:nil];
    }
    return _historyFetchedResultsController;
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.historyFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.historyFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.historyFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrHistoryTableViewCell" forIndexPath:indexPath];
    
    NSManagedObject *managedObject = [self.historyFetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[History class]]) {
        [(coubrHistoryTableViewCell *) cell initCellWithHistory:(History *)managedObject];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([[self.historyFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.historyFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else {
        return nil;
    }
    
}

#pragma mark - Empty table view

- (UIView *)emptyTableView
{
    if (!_emptyTableView) {
        _emptyTableView = ((UIViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"coubrHistoryTableViewEmptyViewController"]).view;
        
        CGRect superviewFrame = self.view.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height);
        [_emptyTableView setFrame:frame];
        
        
    }
    return _emptyTableView;
}

- (void)showEmptyTableView
{
    
    if (![[self.view subviews] containsObject:_emptyTableView]) {
        [self.view addSubview:self.emptyTableView];
    }
    
    
}

- (void)hideEmptyTableView
{
    
    if ([[self.view subviews] containsObject:_emptyTableView]) {
        [self.emptyTableView removeFromSuperview];
    }
    
}

@end
