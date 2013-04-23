//
//  Tab.h
//  real test 2013
//
//  Created by CSIUCD on 09/04/2013.
//  Copyright (c) 2013 Appsbyme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tab : UITabBarController {
    UITabBarItem *favouritesTabButton;
    UITabBarItem *allTabButton;
    }

@property (strong, nonatomic) IBOutlet UITabBarItem *favoritesTabButton;

@property (strong, nonatomic) IBOutlet UITabBarItem *allTabButton;

@end

