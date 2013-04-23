//
//  TenseListTVC.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "TenseListTVC.h"
#import "TenseTable+Create.h"
#import "TenseDescription+Create.h"
#import "AppDelegate.h"
#import "TenseTableTVC.h"

@interface TenseListTVC ()
@end


@implementation TenseListTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setTenseTables:(NSArray *)tenseTables
{
    _tenseTables = [tenseTables sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        TenseTable *table1 = (TenseTable *) obj1;
        TenseTable *table2 = (TenseTable *) obj2;
        return [table1.tenseDescription.index compare:table2.tenseDescription.index];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tenseTables.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    TenseTable *table = self.tenseTables[indexPath.row];
    cell.textLabel.text = [table.tenseDescription.abbreviation uppercaseString];
    cell.detailTextLabel.text = [table.tenseDescription.english capitalizedString];
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Tense Table"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [segue.destinationViewController setTenseTables:self.tenseTables[indexPath.row]];
    }
}


@end
