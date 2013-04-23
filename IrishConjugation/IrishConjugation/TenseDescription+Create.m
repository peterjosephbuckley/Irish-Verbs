//
//  TenseDescription+Create.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "TenseDescription+Create.h"

@implementation TenseDescription (Create)

+ (TenseDescription *)tenseDescriptionWithDict:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context
{
    TenseDescription *tenseDescription;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TENSE_DESCRIPTION_ENTITY];
    request.predicate = [NSPredicate predicateWithFormat:@"abbreviation = %@",[infoDict objectForKey:@"ABBREVIATION"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // error
    } else if ([matches count] == 0) {
        tenseDescription = [NSEntityDescription insertNewObjectForEntityForName:TENSE_DESCRIPTION_ENTITY inManagedObjectContext:context];
        tenseDescription.english = [infoDict objectForKey:@"ENGLISH"];
        tenseDescription.irish = [infoDict objectForKey:@"IRISH"];
        tenseDescription.abbreviation = [infoDict objectForKey:@"ABBREVIATION"];
        tenseDescription.index = [infoDict objectForKey:@"INDEX"];
        tenseDescription.tableType = [infoDict objectForKey:@"TYPE"];
    } else {
        infoDict = [matches lastObject];
    }
    
    return tenseDescription;
}

+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TENSE_DESCRIPTION_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (TenseDescription *tenseDescription in fetchedObjects)
    {
        [context deleteObject:tenseDescription];
    }
    if ([context hasChanges] && ![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

+ (void)importFromJSON:(NSString *)filePath inManagedObjectContext:(NSManagedObjectContext *)context clearContext:(BOOL)shouldClear
{
    if (shouldClear) [[self class] deleteAllInManagedObjectContext:context];
    
    dispatch_queue_t jsonParsingQ = dispatch_queue_create("ie.ucd.csi.import.tense_description", NULL);
    dispatch_async(jsonParsingQ, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IrishConjugation" ofType:@"json"];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:NSJSONReadingMutableContainers error:NULL];
        dispatch_async(dispatch_get_main_queue(),^{
            for (NSDictionary *tenseDescription in [jsonData objectForKey:@"TENSE_DESCRIPTION"]) {
                [TenseDescription tenseDescriptionWithDict:tenseDescription inManagedObjectContext:context];
            }
            NSError *error;
            if ([context hasChanges] && ![context save:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        });
    });
    
}
@end
