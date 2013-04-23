//
//  Tab.m
//  real test 2013
//
//  Created by CSIUCD on 09/04/2013.
//  Copyright (c) 2013 Appsbyme. All rights reserved.
//

#import "Tab.h"

@interface Tab ()

@property (strong, readwrite, nonatomic) IBOutletCollection(UITableViewCell) NSArray *CellLabel;

@end


@implementation Tab

@synthesize allTabButton = _allTabButton;

@synthesize favoritesTabButton = _favoritesTabButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
