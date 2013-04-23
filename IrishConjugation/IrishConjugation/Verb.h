//
//  Verb.h
//  IrishConjugation
//
//  Created by comp41550 on 18/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConjugationTables;

@interface Verb : NSManagedObject

@property (nonatomic, retain) NSString * english;
@property (nonatomic, retain) NSString * irishExample;
@property (nonatomic, retain) NSString * irish;
@property (nonatomic, retain) NSString * englishExample;
@property (nonatomic, retain) ConjugationTables *conjugationTables;

@end
