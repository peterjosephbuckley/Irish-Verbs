//
//  ConjugationTableListTVC.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "ConjugationTableListTVC.h"
#import "ConjugationTables+Create.h"
#import "AppDelegate.h"
#import "TenseListTVC.h"

@interface ConjugationTableListTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end


@implementation ConjugationTableListTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupFetchedResultsController];    
}

- (void)setupFetchedResultsController
{
    NSString *sortKey = @"index";
    NSString *sectionKey = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:CONJUGATION_TABLES_ENTITY];
    request.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES selector:@selector(compare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionKey cacheName:nil];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        _managedObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return _managedObjectContext;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    ConjugationTables *conjugationTables = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[conjugationTables.irish uppercaseString] stringByAppendingFormat:@" %@",conjugationTables.english];
    cell.detailTextLabel.text = [[conjugationTables.irishExample uppercaseString] stringByAppendingFormat:@" %@",conjugationTables.englishExample];
    cell.detailTextLabel.text = conjugationTables.note;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show List"]) {
        // fetch tenses tables
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ConjugationTables *conjugationTables = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [segue.destinationViewController setTenseTables:[conjugationTables.tables allObjects]];
    }
}



@end
