//
//  DetailViewController.h
//  RoposoTestApplication
//
//  Created by Suraj Kumar on 29/03/16.
//  Copyright © 2016 Suraj Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryDescription.h"
#import "UserData.h"

@interface DetailViewController : UIViewController
@property (nonatomic,strong) StoryDescription *storyObject;
@property (nonatomic,strong) UserData *userObject;
@end
