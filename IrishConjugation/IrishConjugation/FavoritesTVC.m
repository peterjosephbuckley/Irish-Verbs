//
//  FavoritesTVC.m
//  IrishConjugation
//
//  Created by comp41550 on 19/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "FavoritesTVC.h"
#import "TenseTableTVC.h"
#import "TenseTable+Create.h"
#import "ConjugationTables+Create.h"
#import "TenseDescription+Create.h"

#import "AppDelegate.h"

@interface FavoritesTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation FavoritesTVC

- (void)viewWillAppear:(BOOL)animated
{
    [Verb exportToCVS:self.managedObjectContext];

    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        _managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return _managedObjectContext;
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:TENSE_TABLE_ENTITY];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favorite == 1"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
                                    [NSSortDescriptor sortDescriptorWithKey:@"tenseDescription.index" ascending:YES selector:@selector(compare:)],
                                    [NSSortDescriptor sortDescriptorWithKey:@"conjugationTables.irish" ascending:YES selector:@selector(compare:)], nil];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"tenseDescription.abbreviation" cacheName:nil];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TenseTable *tenseTable = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
        tenseTable.favorite = [NSNumber numberWithBool:NO];
        [((AppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
    }
}

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TenseTable *tenseTable = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [tenseTable.conjugationTables.irish capitalizedString], [tenseTable.conjugationTables.english capitalizedString]];
    switch ([tenseTable.tenseDescription.tableType intValue]) {
        case 0:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [tenseTable.singular1 capitalizedString], [tenseTable.genericExample capitalizedString]];
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [tenseTable.presentParticiple capitalizedString], [tenseTable.presentParticipleExample capitalizedString]];
            break;
        case 2:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [tenseTable.pastParticiple capitalizedString], [tenseTable.pastParticipleExample capitalizedString]];
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Table"]) {
        // fetch tenses tables
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSArray *tableList = [self fetchedResultsControllerForTableView:self.tableView].fetchedObjects;
        [segue.destinationViewController setTenseTables:tableList];
        TenseTable *selectedTable = [[self fetchedResultsControllerForTableView:self.tableView] objectAtIndexPath:indexPath];
        [segue.destinationViewController setTableIndex:[tableList indexOfObject:selectedTable]];
    }    
}



@end
