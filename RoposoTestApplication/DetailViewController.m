//
//  DetailViewController.m
//  RoposoTestApplication
//
//  Created by Suraj Kumar on 29/03/16.
//  Copyright © 2016 Suraj Kumar. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "AppDelegate.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *storyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *storyDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileIMageView;
@property (weak, nonatomic) IBOutlet UILabel *profileUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButtonArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItems = @[backButton];
    
    self.navigationItem.title = @"Detail";

}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)initializeView{
    self.storyTimeLabel.text = self.storyObject.verb;
    self.storyTitleLabel.text = self.storyObject.title;
    
    NSURL *url = [NSURL URLWithString:self.storyObject.si];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.activityIndicator startAnimating];
    
    __weak DetailViewController *weakSelf = self;

    [self.storyImageView setImageWithURLRequest:request
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakSelf.storyImageView.image = image;
                                            [self.activityIndicator stopAnimating];
                                            weakSelf.storyImageView.layer.cornerRadius = 12.0;
                                            weakSelf.storyImageView.layer.borderColor = [UIColor blackColor].CGColor;
                                            weakSelf.storyImageView.layer.borderWidth = 1.0;
                                        } failure:nil];
    
    self.storyDescriptionLabel.text = self.storyObject.storyDescription;
    self.profileUserNameLabel.text = self.userObject.userName;
    self.profileHandleLabel.text = self.userObject.handle;
    self.profileDetailLabel.text = self.userObject.about;
    
    url = [NSURL URLWithString:self.userObject.image];
    request = [NSURLRequest requestWithURL:url];
    
    [self.profileIMageView setImageWithURLRequest:request
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakSelf.profileIMageView.image = image;
                                            [self.activityIndicator stopAnimating];
                                            weakSelf.profileIMageView.layer.cornerRadius = weakSelf.profileIMageView.frame.size.width/2;
                                            weakSelf.profileIMageView.layer.borderColor = [UIColor blackColor].CGColor;
                                            weakSelf.profileIMageView.layer.borderWidth = 1.0;
                                        } failure:nil];
    [self updateButtonUI];
}

-(void)updateButtonUI{
    self.followButton.layer.cornerRadius = 4.0;
    self.followButton.layer.borderWidth = 1.0;
    self.followButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    if ([self.userObject.is_following boolValue]) {
        [self.followButton setBackgroundColor:[UIColor greenColor]];
        [self.followButton setTitle:@"Following" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.followButton setBackgroundColor:[UIColor whiteColor]];
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (IBAction)profileButtonPressed:(id)sender {
    if ([self.userObject.is_following boolValue]) {
        self.userObject.is_following = [NSNumber numberWithBool:NO];
    }else{
        self.userObject.is_following = [NSNumber numberWithBool:YES];
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [self updateButtonUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
