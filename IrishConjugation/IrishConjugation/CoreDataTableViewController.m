//
//  CoreDataTableViewController.m
//  FlickrFetcher
//
//  Created by CSI COMP41550 on 09/03/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "NSString+FetchByInitial.h"

@interface CoreDataTableViewController ()
@property (nonatomic) BOOL beganUpdates;
@end

@implementation CoreDataTableViewController
@synthesize searchFetchedResultsController = _searchFetchedResultsController;

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != _fetchedResultsController) {
        _fetchedResultsController = fetchedResultsController;
        fetchedResultsController.delegate = self;
        if (fetchedResultsController) [self performFetch:fetchedResultsController];
    } else {
            if (self.verbose) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableView reloadData];
    }
}

- (void)setSearchFetchedResultsController:(NSFetchedResultsController *)searchFetchedResultsController
{
    if (searchFetchedResultsController != _searchFetchedResultsController) {
        _searchFetchedResultsController = searchFetchedResultsController;
        searchFetchedResultsController.delegate = self;
        if (searchFetchedResultsController) [self performFetch:searchFetchedResultsController];
    } else {
        if (self.verbose) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (NSPredicate *)searchPredicate
{
    NSArray *sortDescriptors = self.fetchedResultsController.fetchRequest.sortDescriptors;
    NSPredicate *predicate;
    if (sortDescriptors.count) {
        predicate = [NSPredicate predicateWithFormat:
                     [NSString stringWithFormat:@"%@ CONTAINS[cd] %%@",
                      [[sortDescriptors lastObject] key]], self.searchDisplayController.searchBar.text];
        
        if (self.fetchedResultsController.fetchRequest.predicate)
        {
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                         [NSArray arrayWithObjects:self.fetchedResultsController.fetchRequest.predicate, predicate, nil]];
        }
    }
    return predicate;
}

- (NSFetchedResultsController *)searchFetchedResultsController
{
    if (!_searchFetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.fetchedResultsController.fetchRequest.entityName];
        fetchRequest.sortDescriptors = self.fetchedResultsController.fetchRequest.sortDescriptors;
        fetchRequest.predicate = [self searchPredicate];
        _searchFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.fetchedResultsController.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _searchFetchedResultsController.delegate = self;
        [self performFetch:_searchFetchedResultsController];
    }
    return _searchFetchedResultsController;
}


- (void)didReceiveMemoryWarning
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    
    [super didReceiveMemoryWarning];
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    return tableView == self.tableView ? self.fetchedResultsController : self.searchFetchedResultsController;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsControllerForTableView:tableView] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section] name];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return  [[self fetchedResultsControllerForTableView:tableView] sectionForSectionIndexTitle:title atIndex:index];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [[self fetchedResultsControllerForTableView:tableView] sectionIndexTitles];
//}

#pragma mark - fetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        UITableView *tableView = (controller == self.fetchedResultsController) ? self.tableView : self.searchDisplayController.searchResultsTableView;
        [tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        UITableView *tableView = (controller == self.fetchedResultsController) ? self.tableView : self.searchDisplayController.searchResultsTableView;

        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        UITableView *tableView = (controller == self.fetchedResultsController) ? self.tableView : self.searchDisplayController.searchResultsTableView;

        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) {
        UITableView *tableView = (controller == self.fetchedResultsController) ? self.tableView : self.searchDisplayController.searchResultsTableView;
        [tableView endUpdates];
    }
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

#pragma mark - Fetching

- (void)performFetch:(NSFetchedResultsController *)controller
{
    if (controller) {
        if (controller.fetchRequest.predicate) {
            if (self.verbose) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), controller.fetchRequest.entityName, controller.fetchRequest.predicate);
        } else {
            if (self.verbose) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), controller.fetchRequest.entityName);
        }
        NSError *error;
        [controller performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.verbose) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    
    UITableView *tableView = (controller == self.fetchedResultsController) ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView reloadData];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    if (_searchFetchedResultsController) {
        self.searchFetchedResultsController.fetchRequest.predicate = [self searchPredicate];
        [self performFetch:_searchFetchedResultsController];
    }
}

#pragma mark -
#pragma mark Search Bar

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{
    // search is done, clear searchFetchedResultsController
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[controller.searchBar selectedScopeButtonIndex]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[controller.searchBar text] scope:[controller.searchBar selectedScopeButtonIndex]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
