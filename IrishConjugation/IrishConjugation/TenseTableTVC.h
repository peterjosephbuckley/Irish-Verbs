//
//  TenseTableTVC.h
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TenseTable+Create.h"
#import "Verb+Create.h"

@interface TenseTableTVC : UITableViewController
@property (nonatomic, strong) NSArray *tenseTables;
@property (nonatomic, strong) Verb *verb;
@property (nonatomic) NSInteger tableIndex;
@end
