//
//  TableViewController.m
//  real test 2013
//
//  Created by CSIUCD on 09/04/2013.
//  Copyright (c) 2013 Appsbyme. All rights reserved.
//

#import "VerbListTVC.h"
#import "VerbTenseTVC.h"

@interface VerbListTVC ()

@end

@implementation VerbListTVC

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSMutableDictionary *)verbList
{
    if (!_verbList) {
        _verbList = [NSMutableDictionary dictionary];
    }
    return _verbList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataModel];
    [self.tableView reloadData];
}

- (void)loadDataModel
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"VerbList" ofType:@"plist"];
    NSMutableArray *verbList = [NSMutableArray array];
    
    if ([self.navigationItem.title isEqualToString:@"Select Favorite Verb"])
    {
        NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"VERB_FAV"];
        NSLog(@"%@", favorites);
        
        for (NSDictionary *verb in [NSArray arrayWithContentsOfFile:filePath]) {
            if ([favorites containsObject:[verb objectForKey:@"Irish"]])
            {
                [verbList addObject:verb];
            }
        }
    } else
    {
        verbList = [[NSArray arrayWithContentsOfFile:filePath] mutableCopy];
    }
    
    NSMutableDictionary *verbDict = [NSMutableDictionary dictionary];
    for (NSDictionary *verbItem in verbList) {
        NSString *verbChar =  [[verbItem objectForKey:@"Irish"] substringToIndex:1];
        NSMutableArray *verbSubList = [verbDict objectForKey:verbChar];
        if (!verbSubList) {
            verbSubList = [NSMutableArray array];
        }
        [verbSubList addObject:verbItem];
        [verbDict setObject:verbSubList forKey:verbChar];
    }
    
    // sort keys
    NSArray *verbDictKeys = [[verbDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                             {
                                 return [((NSString *) obj1) compare:(NSString *)obj2];
                             }];
    
    for (NSString *verbChar in verbDictKeys) {
        // sort verbs for a given key
        NSArray *sortedVerbs = [[verbDict objectForKey:verbChar] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                {
                                    NSString * name1 = [obj1 objectForKey:@"Irish"];
                                    NSString * name2 = [obj2 objectForKey:@"Irish"];
                                    return [name1 compare:name2];
                                }];
        [self.verbList setObject:sortedVerbs forKey:verbChar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.verbList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString * verbChar = [[self.verbList allKeys] objectAtIndex:section];
    return [[self.verbList objectForKey:verbChar] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VerbCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *verbChar = [[self.verbList allKeys] objectAtIndex:indexPath.section];
    NSDictionary *verbItem = [[self.verbList objectForKey:verbChar] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [verbItem objectForKey:@"Irish"];
    cell.detailTextLabel.text  = [verbItem objectForKey:@"English"];

    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return ([self.navigationItem.title isEqualToString:@"Select Favorite Verb"]);
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *verbName = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        NSMutableArray *verbFavorites = [[[NSUserDefaults standardUserDefaults] objectForKey:@"VERB_FAV"] mutableCopy];
        [verbFavorites removeObject:verbName];
        [[NSUserDefaults standardUserDefaults] setObject:verbFavorites forKey:@"VERB_FAV"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%@", verbFavorites);

        NSString *verbChar = [verbName substringToIndex:1];
        NSMutableArray *subList = [[self.verbList objectForKey:verbChar] mutableCopy];
        if (subList.count <= 1) {
            [self.verbList removeObjectForKey:verbChar];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [subList removeObjectAtIndex:indexPath.row];
            [self.verbList setObject:subList forKey:verbChar];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

    }
}


#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSString *verbChar = [[self.verbList allKeys] objectAtIndex:indexPath.section];
    NSDictionary *verbItem = [[self.verbList objectForKey:verbChar] objectAtIndex:indexPath.row];

    [segue.destinationViewController setVerb:[verbItem mutableCopy]];
}

@end
