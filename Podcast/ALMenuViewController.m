//
//  ALMenuViewController.m
//  Podcast
//
//  Created by Mike Tran on 6/27/13.
//  Copyright (c) 2013 Ogilvy & Mather (s) Pte Ltd. All rights reserved.
//

#import "ALMenuViewController.h"
#import "IIViewDeckController.h"
#import "ALMenuCell.h"

static NSString *const kALMenuCellIdentifier = @"ALMenuCellIdentifier";

@interface ALMenuViewController ()

@end

@implementation ALMenuViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALMenuCell *cell = (ALMenuCell *)[tableView dequeueReusableCellWithIdentifier:kALMenuCellIdentifier forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        cell.menuTextLabel.text = @"ESL Podcast";
    }
    else {
        switch (indexPath.row) {
            case 0:
                cell.menuTextLabel.text = @"Settings";
                break;
            case 1:
                cell.menuTextLabel.text = @"Send Feedback";
                break;
            case 2:
                cell.menuTextLabel.text = @"Rate This App";
                break;
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        if (indexPath.section == 1) {
            UIViewController *presentController = nil;
            switch (indexPath.row) {
                case 0:
                    presentController = [ALStoryboard settingController];
                    break;
                case 1:
                    presentController = [ALStoryboard sendFeedbackController];
                    break;
            }
            if(presentController != nil) 
                [controller.centerController presentViewController:presentController animated:YES completion:nil];
        }
        
    }];
}

@end
