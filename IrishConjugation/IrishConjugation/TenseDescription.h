//
//  TenseDescription.h
//  IrishConjugation
//
//  Created by comp41550 on 18/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TenseTable;

@interface TenseDescription : NSManagedObject

@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSString * english;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * irish;
@property (nonatomic, retain) NSNumber * tableType;
@property (nonatomic, retain) NSSet *tenseTables;
@end

@interface TenseDescription (CoreDataGeneratedAccessors)

- (void)addTenseTablesObject:(TenseTable *)value;
- (void)removeTenseTablesObject:(TenseTable *)value;
- (void)addTenseTables:(NSSet *)values;
- (void)removeTenseTables:(NSSet *)values;

@end
