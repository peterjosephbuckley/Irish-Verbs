//
//  ConjugationTables+Create.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "ConjugationTables+Create.h"
#import "TenseTable+Create.h"
#import "TenseDescription+Create.h"

@implementation ConjugationTables (Create)

+ (void)exportToCVS:(NSManagedObjectContext *)context
{
    NSError *error;
    [context save:&error];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *sortKey = @"index";
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CONJUGATION_TABLES_ENTITY];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES selector:@selector(compare:)]];
    NSArray *conjugationTableList = [context executeFetchRequest:fetchRequest error:&error];
    
    for (int i = 0; i < conjugationTableList.count; i++) {
        NSMutableString *cvsText = [NSMutableString string];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"conjugation_table%d.csv", i]];
        ConjugationTables *conjugationTables = conjugationTableList[i];
        NSArray *tenseTables = [conjugationTables.tables allObjects];
        tenseTables = [tenseTables sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            TenseTable *table1 = (TenseTable *) obj1;
            TenseTable *table2 = (TenseTable *) obj2;
            return [table1.tenseDescription.index compare:table2.tenseDescription.index];
        }];

        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            [cvsText appendFormat:@"\"%@\"%@", table.tenseDescription.abbreviation,(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field;
            switch ([table.tenseDescription.tableType intValue]) {
                case 0:
                    field = table.genericExample;
                    break;
                case 1:
                    field = table.presentParticipleExample;
                    break;
                case 2:
                    field = table.pastParticipleExample;
                    break;                    
                default:
                    break;
            }
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field;
            switch ([table.tenseDescription.tableType intValue]) {
                case 0:
                    field = table.singular1;
                    break;
                case 1:
                    field = table.presentParticiple;
                    break;
                case 2:
                    field = table.pastParticiple;
                    break;
                default:
                    break;
            }
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.singular2;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.singular3;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.plural1;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.plural2;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.plural3;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            [cvsText appendFormat:@"\"%@\"%@", @"Sb.",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.impersonalExample;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.impersonal;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            [cvsText appendFormat:@"\"%@\"%@", @"Diúltach",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.negativeExample;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.negative;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            [cvsText appendFormat:@"\"%@\"%@", @"Ceisteach",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.interrogativeExample;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        for (int j = 0; j < tenseTables.count; j++) {
            TenseTable *table = tenseTables[j];
            NSString *field = table.interrogative;
            [cvsText appendFormat:@"\"%@\"%@", field?field:@"",(j < tenseTables.count - 1)?@",":@"\n"];
        }
        [cvsText writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    
}


+ (ConjugationTables *)conjugationTablesWithDict:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context
{
    ConjugationTables *tables = [NSEntityDescription insertNewObjectForEntityForName:CONJUGATION_TABLES_ENTITY inManagedObjectContext:context];
    tables.index = [infoDict objectForKey:@"INDEX"];
    tables.irish = [[infoDict objectForKey:@"TABLE_NAME"] objectAtIndex:0];
    tables.english = [[infoDict objectForKey:@"TABLE_NAME"] objectAtIndex:1];
    tables.irishExample = [[infoDict objectForKey:@"TABLE_NAME"] objectAtIndex:2];
    tables.englishExample = [[infoDict objectForKey:@"TABLE_NAME"] objectAtIndex:3];
    tables.note = [infoDict objectForKey:@"NOTE"];
    
    // fetch all tense description
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TENSE_DESCRIPTION_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (TenseDescription *tenseDescription in fetchedObjects)
    {
        NSArray *tableData = [infoDict objectForKey:[tenseDescription.abbreviation uppercaseString]];
        if (tableData) {
            NSNumber *tableType = [NSNumber numberWithInt:[tenseDescription.tableType intValue]];
            NSDictionary *tableDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       tables.irishExample, @"IRISH",
                                       tableType, @"TABLE_TYPE",
                                       tableData, @"TABLE_DATA", nil];
            TenseTable *tenseTable = [TenseTable tenseTableWithDict:tableDict inManagedObjectContext:context];
            tenseTable.tenseDescription = tenseDescription;
            [tables addTablesObject:tenseTable];
        } else {
            NSLog(@"Error: %@ (%@)", tables.english, [tenseDescription.abbreviation uppercaseString]);
        }
    }
    
    return tables;
}

+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CONJUGATION_TABLES_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (ConjugationTables *tables in fetchedObjects)
    {
        [context deleteObject:tables];
    }
    if ([context hasChanges] && ![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

+ (void)importFromJSON:(NSString *)filePath inManagedObjectContext:(NSManagedObjectContext *)context clearContext:(BOOL)shouldClear
{
    if (shouldClear) {
        [[self class] deleteAllInManagedObjectContext:context];
        [TenseTable deleteAllInManagedObjectContext:context];
    }
    
    dispatch_queue_t jsonParsingQ = dispatch_queue_create("ie.ucd.csi.import.conjugation_tables", NULL);
    dispatch_async(jsonParsingQ, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IrishConjugation" ofType:@"json"];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:NSJSONReadingMutableContainers error:NULL];
        dispatch_async(dispatch_get_main_queue(),^{
            NSArray *tableList = [jsonData objectForKey:@"CONJUGATION_TABLES"];
            for (int i = 0; i < [tableList count]; i++)
            {
                NSMutableDictionary *tables = [tableList[i] mutableCopy];
                [tables setObject:[NSNumber numberWithInt:i + 1] forKey:@"INDEX"];
                ConjugationTables *conjugationTables = [ConjugationTables conjugationTablesWithDict:tables inManagedObjectContext:context];
                if (i < 14) conjugationTables.type = @"1st conj";
                else if (i < 23) conjugationTables.type = @"2nd conj";
                else conjugationTables.type = @"irregular";
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
