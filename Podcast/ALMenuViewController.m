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
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALMenuCell *cell = (ALMenuCell *)[tableView dequeueReusableCellWithIdentifier:kALMenuCellIdentifier forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.menuTextLabel.text = @"My Podcast";
                break;
            case 1:
                cell.menuTextLabel.text = @"Most Popular";
                break;
            case 2:
                cell.menuTextLabel.text = @"Recommended";
                break;
            case 3:
                cell.menuTextLabel.text = @"Newest";
                break;
            default:
                break;
        }
    }
    else {
        cell.menuTextLabel.text = @"Settings";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)controller.centerController;
            if (indexPath.section == 0) {
            } else {
                [navController pushViewController:[ALStoryboard settingController] animated:YES];
            }
        }
    }];
}

@end
