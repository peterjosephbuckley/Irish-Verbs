//
//  TenseTableTVC.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "TenseTableTVC.h"
#import "TenseTable+Create.h"
#import "TenseDescription+Create.h"
#import "AppDelegate.h"

@interface TenseTableTVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;
@end

@implementation TenseTableTVC

- (void)setTenseTables:(NSArray *)tenseTables
{
    _tenseTables = [tenseTables sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        TenseTable *table1 = (TenseTable *) obj1;
        TenseTable *table2 = (TenseTable *) obj2;
        return [table1.tenseDescription.index compare:table2.tenseDescription.index];
    }];
}

- (IBAction)toggleFavoriteState:(UIBarButtonItem *)sender
{
    TenseTable *tenseTable = self.tenseTables[self.tableIndex];
    tenseTable.favorite = [NSNumber numberWithBool:![tenseTable.favorite boolValue]];
    [((AppDelegate *)[UIApplication sharedApplication].delegate) saveContext];
    [self updateUI];
}

- (IBAction)nextTenseTable:(UISwipeGestureRecognizer *)sender
{
    if (self.tableIndex >= self.tenseTables.count - 1)  self.tableIndex = 0;
    else self.tableIndex++;
}

- (IBAction)previousTenseTable:(UISwipeGestureRecognizer *)sender
{
    if (self.tableIndex < 1) self.tableIndex = self.tenseTables.count - 1;
    else self.tableIndex--;
}

- (void)setTableIndex:(NSInteger)tableIndex
{
    if (tableIndex != _tableIndex)
    {
        _tableIndex = tableIndex;
        [self updateUI];
    }
}

- (void)updateUI
{
    [self.tableView reloadData];
    // update favourite button
    TenseTable *tenseTable = self.tenseTables[self.tableIndex];
    if ([tenseTable.favorite boolValue]) {
        self.favoriteButton.image = [UIImage imageNamed:@"star_w_del.png"];
        self.favoriteButton.tintColor = [UIColor colorWithRed:180.0/255.0 green:0.0 blue:0.0 alpha:1];
    } else {
        self.favoriteButton.image = [UIImage imageNamed:@"star_w.png"];
        self.favoriteButton.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.25 alpha:1];
    }
    
    NSString *title = tenseTable.tenseDescription.abbreviation;
    if (self.navigationController.navigationItem.title) self.navigationController.navigationItem.title = title;
    else if (self.navigationItem.title) self.navigationItem.title = title;
    else self.title = title;

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self updateUI];
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.tenseTables[self.tableIndex] numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tenseTables[self.tableIndex] numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tenseTables[self.tableIndex] titleForSection:section verb:self.verb];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text  = [self.tenseTables[self.tableIndex] textForCellAtIndexPath:indexPath verb:self.verb];
    cell.detailTextLabel.text = [self.tenseTables[self.tableIndex] detailTextForCellAtIndexPath:indexPath verb:self.verb];
    return cell;
}

@end
