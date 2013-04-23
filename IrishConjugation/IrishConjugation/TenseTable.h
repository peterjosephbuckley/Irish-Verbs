//
//  TenseTable.h
//  IrishConjugation
//
//  Created by comp41550 on 18/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConjugationTables, TenseDescription;

@interface TenseTable : NSManagedObject

@property (nonatomic, retain) NSString * genericExample;
@property (nonatomic, retain) NSString * impersonal;
@property (nonatomic, retain) NSString * impersonalExample;
@property (nonatomic, retain) NSString * interrogative;
@property (nonatomic, retain) NSString * interrogativeExample;
@property (nonatomic, retain) NSString * negative;
@property (nonatomic, retain) NSString * negativeExample;
@property (nonatomic, retain) NSString * pastParticiple;
@property (nonatomic, retain) NSString * pastParticipleExample;
@property (nonatomic, retain) NSString * plural1;
@property (nonatomic, retain) NSString * plural2;
@property (nonatomic, retain) NSString * plural3;
@property (nonatomic, retain) NSString * presentParticiple;
@property (nonatomic, retain) NSString * presentParticipleExample;
@property (nonatomic, retain) NSString * singular1;
@property (nonatomic, retain) NSString * singular2;
@property (nonatomic, retain) NSString * singular3;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) ConjugationTables *conjugationTables;
@property (nonatomic, retain) TenseDescription *tenseDescription;

@end
