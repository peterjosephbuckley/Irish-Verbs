//
//  TenseTable+Create.h
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "TenseTable.h"
#import "Verb+Create.h"
#define TENSE_TABLE_ENTITY @"TenseTable"

@interface TenseTable (Create)

- (NSInteger)numberOfSections;
- (NSString *)titleForSection:(NSInteger)section verb:(Verb *)verb;;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSString *)textForCellAtIndexPath:(NSIndexPath *)indexPath verb:(Verb *)verb;
- (NSString *)detailTextForCellAtIndexPath:(NSIndexPath *)indexPath verb:(Verb *)verb;

+ (TenseTable *)tenseTableWithDict:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context;

@end
