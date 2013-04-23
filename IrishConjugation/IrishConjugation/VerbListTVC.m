//
//  VerbListTVC.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "VerbListTVC.h"
#import "TenseTableTVC.h"
#import "AppDelegate.h"
#import "Verb+Create.h"
#import "ConjugationTables+Create.h"

@interface SearchTVCell : UITableViewCell
@end

@interface VerbListTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSString *tabbarTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) BOOL shouldAnimate;
@end

@implementation VerbListTVC

- (IBAction)swapLanguage:(UISegmentedControl *)sender {
    NSString *selectedLanguage = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    if (![selectedLanguage isEqualToString:self.tabbarTitle]) {
        self.tabbarTitle = selectedLanguage;
        [self setupFetchedResultsController];
    }
}

- (NSString *)tabbarTitle
{
    NSString *title = self.navigationController.tabBarItem.title;
    if (!title) title = self.tabBarItem.title;
    if (!title) title = self.title;
    return title;
}

- (void)setTabbarTitle:(NSString *)tabbarTitle
{
    if (self.navigationController.tabBarItem.title) self.navigationController.tabBarItem.title = tabbarTitle;
    else if (self.tabBarItem.title) self.tabBarItem.title = tabbarTitle;
    else self.title = tabbarTitle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.segmentedControl) {
        [self swapLanguage:self.segmentedControl];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {
        [self setupFetchedResultsController];
        [self.navigationController setNavigationBarHidden:YES animated:self.shouldAnimate];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.shouldAnimate = (self.segmentedControl != nil);
    [super viewWillDisappear:animated];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"Cell";
    [tableView registerClass:[SearchTVCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:VERB_ENTITY];
    NSString *sortKey;
    NSString *sectionKey;
    if ([self.tabbarTitle isEqualToString:@"English"] ||
        [self.tabbarTitle isEqualToString:@"Irish"])
    {
        sortKey =  [self.tabbarTitle lowercaseString];
        sectionKey = [NSString stringWithFormat:@"%@.firstInitial", [self.tabbarTitle lowercaseString]];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES selector:@selector(compare:)]];
    } else if ([self.tabbarTitle isEqualToString:@"1st Conj"] ||
               [self.tabbarTitle isEqualToString:@"2nd Conj"] ||
               [self.tabbarTitle isEqualToString:@"Irregular"])
    {
        sectionKey = @"conjugationTables.index";
        sortKey = [self.tabbarTitle lowercaseString];
        fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
                                        [NSSortDescriptor sortDescriptorWithKey:@"conjugationTables.index" ascending:YES selector:@selector(compare:)],
                                        [NSSortDescriptor sortDescriptorWithKey:@"irish" ascending:YES selector:@selector(compare:)], nil];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"conjugationTables.type like \"%@\"", sortKey]];
    }
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionKey cacheName:nil];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        _managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return _managedObjectContext;
}

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Verb *verb = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    if ([self.tabbarTitle isEqualToString:@"English"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [verb.english capitalizedString], [verb.irish capitalizedString]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [verb.englishExample capitalizedString], [verb.irishExample capitalizedString]];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [verb.irish capitalizedString], [verb.english capitalizedString]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [verb.irishExample capitalizedString], [verb.englishExample capitalizedString]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier:@"Show List" sender:indexPath];
    }
}

#pragma mark -
#pragma mark Segues


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show List"]) {
        // fetch tenses tables
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            Verb *verb = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [segue.destinationViewController setTenseTables:[verb.conjugationTables.tables allObjects]];
            [segue.destinationViewController setVerb:verb];
        } else if ([sender isKindOfClass:[NSIndexPath class]]) {
            Verb *verb = [self.searchFetchedResultsController objectAtIndexPath:sender];
            [segue.destinationViewController setTenseTables:[verb.conjugationTables.tables allObjects]];
            [segue.destinationViewController setVerb:verb];
        }
    }
    self.shouldAnimate = YES;

}

@end


@implementation SearchTVCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
@end

