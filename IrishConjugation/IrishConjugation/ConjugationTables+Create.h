//
//  ConjugationTables+Create.h
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "ConjugationTables.h"
#define CONJUGATION_TABLES_ENTITY @"ConjugationTables"
#define TENSE_TABLE_DEFAULT_TYPE 0
#define TENSE_TABLE_PRES_PARTICIPLE_TYPE 1
#define TENSE_TABLE_PAST_PARTICIPLE_TYPE 2


@interface ConjugationTables (Create)

+ (void)exportToCVS:(NSManagedObjectContext *)context;
+ (ConjugationTables *)conjugationTablesWithDict:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)importFromJSON:(NSString *)filePath inManagedObjectContext:(NSManagedObjectContext *)context clearContext:(BOOL)shouldClear;

@end
