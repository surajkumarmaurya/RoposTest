//
//  ListViewCell.h
//  RoposoTestApplication
//
//  Created by Suraj Kumar on 28/03/16.
//  Copyright © 2016 Suraj Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellBgView;
@property (weak, nonatomic) IBOutlet UIView *userNameBgView;
@property (weak, nonatomic) IBOutlet UIView *storyTimeBgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *storyDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
