//
//  NSString+FetchByInitial.m
//  IrishConjugation
//
//  Created by comp41550 on 17/04/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "NSString+FetchByInitial.h"

@implementation NSString (FetchByInitial)

- (NSString *)firstInitial {
    NSString *initial;
    if (!self.length || self.length == 1) initial = self;
    else initial = [self substringToIndex:1];
    return [initial uppercaseString];
}

@end
