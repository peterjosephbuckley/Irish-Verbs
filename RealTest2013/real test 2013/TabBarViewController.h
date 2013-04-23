//
//  ABMViewController.h
//  real test 2013
//
//  Created by Adrian Buckley on 31/01/2013.
//  Copyright (c) 2013 Appsbyme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController

@property (strong, nonatomic) IBOutlet UITabBarItem *favoritesTabButton;

@property (strong, nonatomic) IBOutlet UITabBarItem *allTabButton;

@property (strong, readonly, nonatomic) IBOutletCollection(UITableViewCell) NSArray *CellLabel;




@end
