//
//  TenseTable+Create.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "TenseTable+Create.h"
#import "ConjugationTables+Create.h"
#import "TenseDescription+Create.h"
#import "Verb+Create.h"

@implementation TenseTable (Create)

- (NSInteger)numberOfSections
{
    int count = 0;
    if (self.genericExample) count++;
    if (self.impersonalExample) count++;
    if (self.negativeExample) count++;
    if (self.interrogativeExample) count++;
    if (self.presentParticiple) count++;
    if (self.pastParticipleExample) count++;
    return count;
}

- (NSString *)titleForSection:(NSInteger)section verb:(Verb *)verb
{
    NSString *title = @"Unknown";
    if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_DEFAULT_TYPE)
    {
        switch (section) {
            case 0:
                title = [TenseTable processRulesForProperty:[self valueForKey:@"genericExample"] withVerb:verb];
                break;
            case 1:
                title = @"Sb.";
                break;
            case 2:
                title = @"Diúltach";
                break;
            case 3:
                title = @"Ceisteach";
                break;
                
            default:
                break;
        }
    }
    else if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_PRES_PARTICIPLE_TYPE)
    {
        if (section == 0) title = self.tenseDescription.abbreviation;
    }
    else if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_PAST_PARTICIPLE_TYPE)
    {
        if (section == 0) title = self.tenseDescription.abbreviation;
    }
    
    return [title stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[title substringToIndex:1] capitalizedString]];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_DEFAULT_TYPE)
    {
        switch (section) {
            case 0: // singular + plurial
                rowCount = 6;
                break;
            case 1: // impersonal
                rowCount = 1;
                break;
            case 2: // negative
                rowCount = 1;
                break;
            case 3: // interrogative
                rowCount = 1;
                break;
            default:
                break;
        }
    }
    else if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_PRES_PARTICIPLE_TYPE)
    {
        if(section == 0) rowCount = 1;
    }
    else if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_PAST_PARTICIPLE_TYPE)
    {
        if(section == 0) rowCount = 1;
    }
    return rowCount;
}

+ (NSString *)processRulesForProperty:(NSString *)propertyValue withVerb:(Verb *)verb
{
    NSArray *rules = @[@"_R_", @"_R1_", @"_URU_", @"_H_", @"_E_", @"_E1_", @"_E2_", @"_E3_", @"_E4_"];
    
    // search for rule to apply
    NSRange range;
    NSString *rule;
    for (rule in rules) {
        range = [propertyValue rangeOfString:rule options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) break;
    }
    
    // processed rules
    NSString *text = propertyValue;
    if (range.location != NSNotFound) {
        NSString *root = [verb.irish lowercaseString];
        if (([verb.conjugationTables.index intValue] == 6) ||
            ([verb.conjugationTables.index intValue] == 7) ||
            ([verb.conjugationTables.index intValue] == 8)) {
            root = [verb.irishExample substringToIndex:verb.irishExample.length - 2];
        }

        // _R_ substitution rule
        if ([rule isEqual:@"_R_"]) {
        text = [propertyValue stringByReplacingOccurrencesOfString:rule withString:root options:NSCaseInsensitiveSearch range:NSMakeRange(0, propertyValue.length)];
        }
        // _R1_ substitution rule
        else if ([rule isEqual:@"_R1_"]) {
            text = [propertyValue stringByReplacingOccurrencesOfString:rule withString:[root stringByAppendingString:@"i"] options:NSCaseInsensitiveSearch range:NSMakeRange(0, propertyValue.length)];
        }
        // _URU_ substitution rule
        else if ([rule isEqual:@"_URU_"])
        {
            if (root.length) {
                unichar c = [root characterAtIndex:0];
                NSString *formatString;
                switch (c) {
                    case L'b':
                        formatString = @"m%@";
                        break;
                    case L'c':
                        formatString = @"g%@";
                        break;
                    case L'p':
                        formatString = @"b%@";
                        break;
                    case L't':
                        formatString = @"d%@";
                        break;
                    case L'd':
                    case L'g':
                        formatString = @"n%@";
                        break;
                    case L'a':
                    case L'e':
                    case L'i':
                    case L'o':
                    case L'ó':
                    case L'u':
                        formatString = @"n-%@";
                        break;
                    default:
                        formatString = @"%@";
                        break;
                }
                text = [propertyValue stringByReplacingOccurrencesOfString:rule withString:[NSString stringWithFormat:formatString, root] options:NSCaseInsensitiveSearch range:NSMakeRange(0, propertyValue.length)];
            }
        }
        // _H_ substitution rule
        else if ([rule isEqual:@"_H_"])
        {
            NSRange range = [propertyValue rangeOfString:rule options:NSCaseInsensitiveSearch];
            if ((range.location != NSNotFound) && root.length) {
                unichar c = [root characterAtIndex:0];
                NSString *formatString = @"%Ch%@";
                switch (c) {
                    case L'l':
                    case L'n':
                    case L'q':
                    case L'r':
                    case L'v':
                    case L'w':
                    case L'k':
                    case L'x':
                    case L'y':
                    case L'z':
                    case L'a':
                    case L'e':
                    case L'i':
                    case L'o':
                    case L'ó':
                    case L'u':
                        formatString = @"%C%@";
                        break;
                    case L's':
                        if ([root characterAtIndex:0] == L'c') formatString = formatString = @"%C%@";
                        break;
                }
                text = [propertyValue stringByReplacingOccurrencesOfString:rule withString:[NSString stringWithFormat:formatString, c, [root substringFromIndex:1]] options:NSCaseInsensitiveSearch range:NSMakeRange(0, propertyValue.length)];
            }
        }
        // _E#_ substitution rule
        else if ([rule hasPrefix:@"_E"]) {
                text = [propertyValue stringByReplacingOccurrencesOfString:rule withString:[verb englishForRule:rule] options:NSCaseInsensitiveSearch range:NSMakeRange(0, propertyValue.length)];
        }
    }
    return text;
}



- (NSString *)textForCellAtIndexPath:(NSIndexPath *)indexPath verb:(Verb *)verb
{
    NSString *text = @"unknown";
    NSArray *propertyList = @[@"singular1", @"singular2", @"singular3", @"plural1", @"plural2", @"plural3", @"impersonal", @"negative", @"interrogative", @"presentParticiple", @"pastParticiple"];

    if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_DEFAULT_TYPE)
    {
        switch (indexPath.section) {
            case 0:
                text = [self valueForKey:propertyList[indexPath.row]];
                break;
            case 1:
                text = self.impersonal;
                break;
            case 2:
                text = self.negative;
                break;
            case 3:
                text = self.interrogative;
                break;
            default:
                break;
        }
    }
    else if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_PRES_PARTICIPLE_TYPE)
    {
        if ((indexPath.section == 0) && (indexPath.row == 0)) text = self.presentParticiple;
    }
    else if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_PAST_PARTICIPLE_TYPE)
    {
        if ((indexPath.section == 0) && (indexPath.row == 0)) text = self.pastParticiple;
    }
    
    return [TenseTable processRulesForProperty:text withVerb:verb];
}

- (NSString *)detailTextForCellAtIndexPath:(NSIndexPath *)indexPath verb:(Verb *)verb
{
    NSString *text = @"";
    NSArray *propertyList = @[@"genericExample", @"impersonalExample", @"negativeExample", @"interrogativeExample", @"presentParticipleExample", @"pastParticipleExample"];

    if (indexPath.section < propertyList.count) {
        if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_DEFAULT_TYPE)
        {
            if (indexPath.section > 0) text = [self valueForKey:propertyList[indexPath.section]];
        }
        else if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_PRES_PARTICIPLE_TYPE)
        {
            text = [self valueForKey:propertyList[4]];
        }
        else if ([self.tenseDescription.tableType intValue] == TENSE_TABLE_PAST_PARTICIPLE_TYPE)
        {
            text = [self valueForKey:propertyList[5]];
        }
    }
    return [TenseTable processRulesForProperty:text withVerb:verb];
;
}

+ (TenseTable *)tenseTableWithDict:(NSDictionary *)infoDict inManagedObjectContext:(NSManagedObjectContext *)context
{
    TenseTable *table = [NSEntityDescription insertNewObjectForEntityForName:TENSE_TABLE_ENTITY inManagedObjectContext:context];
    //    table.abbreviation =
    //    table.english =
    //    table.irish =

    NSArray *tableData = [infoDict objectForKey:@"TABLE_DATA"];
    if ([[infoDict objectForKey:@"TABLE_TYPE"] intValue] == TENSE_TABLE_DEFAULT_TYPE)
    {
        if (tableData.count > 6) {
            table.genericExample = [tableData[0] lowercaseString];
            table.singular1 = [tableData[1] lowercaseString];
            table.singular2 = [tableData[2] lowercaseString];
            table.singular3 = [tableData[3] lowercaseString];
            table.plural1 = [tableData[4] lowercaseString];
            table.plural2 = [tableData[5] lowercaseString];
            table.plural3 = [tableData[6] lowercaseString];
        }
        if (tableData.count > 9) {
            table.impersonal = [tableData[9] lowercaseString];
            table.impersonalExample = [tableData[8] lowercaseString];
        }
        if (tableData.count > 12) {
            table.negative = [tableData[12] lowercaseString];
            table.negativeExample = [tableData[11] lowercaseString];
        }
        if (tableData.count > 15) {
            table.interrogative = [tableData[15] lowercaseString];
            table.interrogativeExample = [tableData[14] lowercaseString];
        }
    } else if ([[infoDict objectForKey:@"TABLE_TYPE"] intValue] == TENSE_TABLE_PRES_PARTICIPLE_TYPE)
    {
        if (tableData.count >= 1) {
            table.presentParticiple = [tableData[1] lowercaseString];
            table.presentParticipleExample = [tableData[0] lowercaseString];
        }        
    } else if ([[infoDict objectForKey:@"TABLE_TYPE"] intValue] == TENSE_TABLE_PAST_PARTICIPLE_TYPE) {
        if (tableData.count >= 1) {
            table.pastParticiple = [tableData[1] lowercaseString];
            table.pastParticipleExample = [tableData[0] lowercaseString];
        }
    }
    return table;
}

+ (void)deleteAllInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TENSE_TABLE_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (TenseTable *table in fetchedObjects)
    {
        [context deleteObject:table];
    }
    if ([context hasChanges] && ![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
