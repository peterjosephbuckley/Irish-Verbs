//
//  PageVC.m
//  real test 2013
//
//  Created by CSIUCD on 10/04/2013.
//  Copyright (c) 2013 Appsbyme. All rights reserved.
//

#import "VerbVC.h"
#import "VerbListTVC.h"
@interface VerbVC ()

@end

@implementation VerbVC

@synthesize verb = _verb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@", [self.verb objectForKey: @"Irish"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
