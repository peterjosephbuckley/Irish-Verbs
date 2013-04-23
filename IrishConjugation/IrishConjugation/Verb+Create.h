//
//  Verb+Create.h
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "Verb.h"
#define VERB_ENTITY @"Verb"

@interface Verb (Create)

- (NSString *)englishForRule:(NSString *)rule;
+ (Verb *)verbWithDict:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)importFromJSON:(NSString *)filePath inManagedObjectContext:(NSManagedObjectContext *)context clearContext:(BOOL)shouldClear;
+ (void)exportToCVS:(NSManagedObjectContext *)context;
@end
