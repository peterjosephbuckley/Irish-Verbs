//
//  TenseDescription+Create.h
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "TenseDescription.h"
#define TENSE_DESCRIPTION_ENTITY @"TenseDescription"

@interface TenseDescription (Create)
+ (TenseDescription *)tenseDescriptionWithDict:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)importFromJSON:(NSString *)filePath inManagedObjectContext:(NSManagedObjectContext *)context clearContext:(BOOL)shouldClear;
@end
