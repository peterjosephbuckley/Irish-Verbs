//
//  Verb+Create.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "Verb+Create.h"
#import "ConjugationTables+Create.h"

@implementation Verb (Create)

- (NSString *)english
{
    NSString *_english = [self primitiveValueForKey:@"english"];
    return [[_english componentsSeparatedByString:@", "] objectAtIndex:0];
}

- (NSString *)englishForRule:(NSString *)rule
{
    NSArray *rules = @[@"_E_", @"_E1_", @"_E2_", @"_E3_", @"_E4_"];
    NSString *_english = [self primitiveValueForKey:@"english"];
    NSArray *components = [_english componentsSeparatedByString:@", "];
    int index = [rules indexOfObject:rule];
    NSString *text = components[0];
    if (components.count > index) text = components[index];
    else {
        if ([rule isEqualToString:@"_E1_"])
            text = [components[0] stringByAppendingString:@"s"];
        else if([rule isEqualToString:@"_E3_"]) {
            if ([components[0] hasSuffix:@"e"])
                text = [components[0] stringByAppendingString:@"n"];
            else
                text = [components[0] stringByAppendingString:@"en"];
        }
        else if([rule isEqualToString:@"_E4_"]) {
            if ([components[0] hasSuffix:@"e"])
                text = [[components[0] substringToIndex:[components[0] length] - 1] stringByAppendingString:@"ing"];
            else
                text = [components[0] stringByAppendingString:@"ing"];
        }
    }
    return text;
}


+ (void)exportToCVS:(NSManagedObjectContext *)context
{
    NSError *error;
    [context save:&error];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"verb_list.csv"];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:VERB_ENTITY];
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:
                                    [NSSortDescriptor sortDescriptorWithKey:@"conjugationTables.index" ascending:YES selector:@selector(compare:)],                                     
                                    [NSSortDescriptor sortDescriptorWithKey:@"irish" ascending:YES selector:@selector(compare:)],
                                    nil];
    NSArray *verbList = [context executeFetchRequest:fetchRequest error:&error];
   
    NSMutableString *cvsText = [@"IRISH,ENGLISH,IRISH_EXAMPLE,ENGLISH_EXAMPLE,TABLE_REF\n" mutableCopy];
    for (Verb *verb in verbList) {
        [cvsText appendFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",%d\n",
         verb.irish,
         verb.english,
         verb.irishExample,
         verb.englishExample,
         [verb.conjugationTables.index intValue]];
    }
    [cvsText writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}

+ (Verb *)verbWithDict:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context
{
    Verb *verb = [NSEntityDescription insertNewObjectForEntityForName:VERB_ENTITY inManagedObjectContext:context];
    verb.english = [[infoDict objectForKey:@"ENGLISH"] lowercaseString];
    verb.englishExample = [[infoDict objectForKey:@"ENGLISH_EXAMPLE"] lowercaseString];
    verb.irish = [[infoDict objectForKey:@"IRISH"] lowercaseString];
    verb.irishExample = [[infoDict objectForKey:@"IRISH_EXAMPLE"] lowercaseString];

    // fetch conjugation tables
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CONJUGATION_TABLES_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *sortKey = @"index";
    fetchRequest.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES selector:@selector(compare:)]];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    int tableRef = [[infoDict objectForKey:@"TABLE_REF"] intValue] - 1;
    if (tableRef < fetchedObjects.count) {
        verb.conjugationTables = [fetchedObjects objectAtIndex:tableRef];
    }    

    return verb;
}

+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:VERB_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Verb *verb in fetchedObjects)
    {
        [context deleteObject:verb];
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
    
    dispatch_queue_t jsonParsingQ = dispatch_queue_create("ie.ucd.csi.import.verb_list", NULL);
    dispatch_async(jsonParsingQ, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IrishConjugation" ofType:@"json"];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:NSJSONReadingMutableContainers error:NULL];
        dispatch_async(dispatch_get_main_queue(),^{
            for (NSDictionary *verb in [jsonData objectForKey:@"VERB_LIST"]) {
                [Verb verbWithDict:verb inManagedObjectContext:context];
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


