//
//  FavouritesViewController.h
//  real test 2013
//
//  Created by CSIUCD on 03/04/2013.
//  Copyright (c) 2013 Appsbyme. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavouritesViewController;

@protocol FavouritesViewControllerDelegate <NSObject>
@optional
- (void)favouritesTVC:(FavouritesViewController *)sender selectedFavourite:(id)favourite;
- (void)favouritesTVC:(FavouritesViewController *)sender deleteFromFavourites:(id)favourite;
@end

@interface FavouritesViewController : UITableViewController
@property (nonatomic, strong) NSArray *verbFavorites;
@property (nonatomic, assign) id<FavouritesViewControllerDelegate> delegate;
@end