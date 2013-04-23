//
//  ConjugationTables.h
//  IrishConjugation
//
//  Created by comp41550 on 18/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TenseTable, Verb;

@interface ConjugationTables : NSManagedObject

@property (nonatomic, retain) NSString * english;
@property (nonatomic, retain) NSString * englishExample;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * irish;
@property (nonatomic, retain) NSString * irishExample;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *similarities;
@property (nonatomic, retain) NSSet *tables;
@property (nonatomic, retain) NSSet *verbs;
@end

@interface ConjugationTables (CoreDataGeneratedAccessors)

- (void)addSimilaritiesObject:(Verb *)value;
- (void)removeSimilaritiesObject:(Verb *)value;
- (void)addSimilarities:(NSSet *)values;
- (void)removeSimilarities:(NSSet *)values;

- (void)addTablesObject:(TenseTable *)value;
- (void)removeTablesObject:(TenseTable *)value;
- (void)addTables:(NSSet *)values;
- (void)removeTables:(NSSet *)values;

- (void)addVerbsObject:(Verb *)value;
- (void)removeVerbsObject:(Verb *)value;
- (void)addVerbs:(NSSet *)values;
- (void)removeVerbs:(NSSet *)values;

@end
