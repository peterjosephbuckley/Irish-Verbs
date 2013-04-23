//
//  CoreDataTableViewController.h
//  FlickrFetcher
//
//  Created by CSI COMP41550 on 09/03/2012.
//  Copyright (c) 2012 UCD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *searchFetchedResultsController;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property (nonatomic) BOOL verbose;

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView;
- (void)performFetch:(NSFetchedResultsController *)controller;
@end
