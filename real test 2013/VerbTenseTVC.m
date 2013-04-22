//
//  VerbTenseTVC.m
//  real test 2013
//
//  Created by CSIUCD on 11/04/2013.
//  Copyright (c) 2013 Appsbyme. All rights reserved.
//

#import "VerbTenseTVC.h"
#import "VerbListTVC.h"

@interface VerbTenseTVC () <UIActionSheetDelegate>


@property (nonatomic)int tenseIndex;

- (IBAction)buttonPressed:(UIBarButtonItem *)sender;
@end

@implementation VerbTenseTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:@"VERB_FAV"];
    if ([favorites containsObject:[self.verb objectForKey: @"Irish"]])
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = [NSString stringWithFormat:@"%@", [self.verb objectForKey: @"Irish"]];

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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *allTenses = [[self.verb objectForKey:@"Tense"] allKeys];
    return allTenses[self.tenseIndex];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *allTenses = [[self.verb objectForKey:@"Tense"] allKeys];
    if (allTenses.count < 1) return 0;
    else {
        NSArray *tenseTable = [[self.verb objectForKey:@"Tense"] objectForKey:allTenses[self.tenseIndex]];
        return tenseTable.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *allTenses = [[self.verb objectForKey:@"Tense"] allKeys];
    NSArray *tenseTable = [[self.verb objectForKey:@"Tense"] objectForKey:allTenses[self.tenseIndex]];
    cell.textLabel.text = tenseTable[indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(IBAction)buttonPressed:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Do you want to add this verb to your Favourites?"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Add to Favourites", nil];
    actionSheet.delegate = self;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    if (buttonIndex == 1) {
        NSMutableArray *verbFavorites = [[[NSUserDefaults standardUserDefaults] objectForKey:@"VERB_FAV"] mutableCopy];
        if (!verbFavorites) {
            verbFavorites = [NSMutableArray array];
        }
        if (![verbFavorites containsObject:[self.verb objectForKey:@"Irish"]]) {
            [verbFavorites addObject:[self.verb objectForKey:@"Irish"]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:verbFavorites forKey:@"VERB_FAV"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        NSLog(@"%@", verbFavorites);
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)incrementTenseCount:(UISwipeGestureRecognizer *)sender
{
    self.tenseIndex ++;
    NSArray *allTenses = [[self.verb objectForKey:@"Tense"] allKeys];
    if (self.tenseIndex >= allTenses.count) self.tenseIndex = 0;
    [self.tableView reloadData];
}
@end
