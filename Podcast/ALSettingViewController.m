//
//  ALSettingViewController.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALSettingViewController.h"

@interface ALSettingViewController ()
- (IBAction)actionDone:(id)sender;
@end

@implementation ALSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
