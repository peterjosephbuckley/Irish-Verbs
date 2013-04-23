//
//  TenseInfoTVC.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "TenseInfoTVC.h"
#import "AppDelegate.h"
#import "TenseDescription+Create.h"

@interface TenseInfoTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation TenseInfoTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    NSString *sortKey = @"index";
    NSString *sectionKey = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TENSE_DESCRIPTION_ENTITY];
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
    TenseDescription *tenseDescription = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[tenseDescription.irish capitalizedString] stringByAppendingFormat:@" (%@)",[tenseDescription.abbreviation uppercaseString]];
    cell.detailTextLabel.text = [tenseDescription.english capitalizedString];
    return cell;
}

@end
