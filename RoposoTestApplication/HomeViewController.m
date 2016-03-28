//
//  HomeViewController.m
//  
//
//  Created by Suraj Kumar on 28/03/16.
//
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ListViewCell.h"
#import "UserData.h"
#import "StoryDescription.h"
#import "DetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listViewTable;
@property (strong, nonatomic) NSArray *storyArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Home";
    [self accessJSONFileAndSaveData];
    self.listViewTable.estimatedRowHeight = 150;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.storyArray = [self fetchStoryData];
    [self.listViewTable reloadData];
}

-(void)deleteEntitiesForName:(NSString *)entityName{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject *object in results) {
        [appDelegate.managedObjectContext deleteObject:object];
    }
}

-(void)accessJSONFileAndSaveData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iOS_Data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    [self deleteEntitiesForName:@"UserData"];
    [self deleteEntitiesForName:@"StoryDescription"];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    for (NSDictionary *dataDict in dataArray) {
        if ([[dataDict valueForKey:@"type"] isEqualToString:@"story"]) {
            [self saveStoryData:dataDict];
        }else{
            [self saveUserData:dataDict];
        }
    }
}

-(void)saveUserData:(NSDictionary *)userDict{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UserData *userObject = [NSEntityDescription insertNewObjectForEntityForName:@"UserData"
                                                   inManagedObjectContext:appDelegate.managedObjectContext];
    userObject.about = [userDict valueForKey:@"about"];
    userObject.userID = [userDict valueForKey:@"id"];
    userObject.userName = [userDict valueForKey:@"username"];
    userObject.followers = [userDict valueForKey:@"followers"];
    userObject.following = [userDict valueForKey:@"following"];
    userObject.image = [userDict valueForKey:@"image"];
    userObject.url = [userDict valueForKey:@"url"];
    userObject.handle = [userDict valueForKey:@"handle"];
    userObject.is_following = [userDict valueForKey:@"is_following"];
    userObject.createdOn = [userDict valueForKey:@"createdOn"];
    [appDelegate saveContext];
}

-(void)saveStoryData:(NSDictionary *)storyDict{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    StoryDescription *storyObject = [NSEntityDescription insertNewObjectForEntityForName:@"StoryDescription"
                                                         inManagedObjectContext:appDelegate.managedObjectContext];
    storyObject.storyDescription = [storyDict valueForKey:@"description"];
    storyObject.storyID = [storyDict valueForKey:@"id"];
    storyObject.verb = [storyDict valueForKey:@"verb"];
    storyObject.db = [storyDict valueForKey:@"db"];
    storyObject.si = [storyDict valueForKey:@"si"];
    storyObject.url = [storyDict valueForKey:@"url"];
    storyObject.type = [storyDict valueForKey:@"type"];
    storyObject.title = [storyDict valueForKey:@"title"];
    storyObject.like_flag = [storyDict valueForKey:@"like_flag"];
    storyObject.likes_count = [storyDict valueForKey:@"likes_count"];
    storyObject.comment_count = [storyDict valueForKey:@"comment_count"];
    [appDelegate saveContext];
}

-(NSArray *)fetchStoryData{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StoryDescription" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ListViewCell";
    ListViewCell *cell = (ListViewCell *)[self.listViewTable dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCellForIndexPath:indexPath andCell:cell];
    return cell;
}

-(void)configureCellForIndexPath:(NSIndexPath *)indexPath andCell:(ListViewCell *)cell{
    
    StoryDescription *storyObject = (StoryDescription *)self.storyArray[indexPath.row];
    UserData *userObject = (UserData *)[self fetchUserProfileDataForID:storyObject.db];
    
    cell.userNameLabel.text = userObject.userName;
    cell.storyTimeLabel.text = storyObject.verb;
    cell.storyTitleLabel.text = storyObject.title;
    cell.storyDescriptionLabel.text = storyObject.storyDescription;
    
    [cell.followButton addTarget:self action:@selector(followButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    cell.followButton.layer.cornerRadius = 4.0;
    cell.followButton.layer.borderWidth = 1.0;
    cell.followButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    if ([userObject.is_following boolValue]) {
        [cell.followButton setBackgroundColor:[UIColor greenColor]];
        [cell.followButton setTitle:@"Following" forState:UIControlStateNormal];
        [cell.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [cell.followButton setBackgroundColor:[UIColor whiteColor]];
        [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    NSURL *url = [NSURL URLWithString:storyObject.si];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak ListViewCell *weakCell = cell;
    
    cell.storyImageView.layer.cornerRadius = 0.0;
    cell.storyImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.storyImageView.layer.borderWidth = 0.0;
    cell.storyImageView.image = nil;
    
    [cell.activityIndicator startAnimating];
    [cell.storyImageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.storyImageView.image = image;
                                       [weakCell.activityIndicator stopAnimating];
                                       weakCell.storyImageView.layer.cornerRadius = 4.0;
                                       weakCell.storyImageView.layer.borderColor = [UIColor blackColor].CGColor;
                                       weakCell.storyImageView.layer.borderWidth = 1.0;
                                       [weakCell setNeedsLayout];
                                   } failure:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [(ListViewCell *)cell.contentView layoutSubviews];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:((ListViewCell *)cell).cellBgView.bounds];
    ((ListViewCell *)cell).cellBgView.layer.masksToBounds = NO;
    ((ListViewCell *)cell).cellBgView.layer.shadowColor = [UIColor blackColor].CGColor;
    ((ListViewCell *)cell).cellBgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    ((ListViewCell *)cell).cellBgView.layer.shadowOpacity = 0.5f;
    ((ListViewCell *)cell).cellBgView.layer.shadowPath = shadowPath.CGPath;
}

-(void)followButtonPressed:(UIButton *)sender{
    NSIndexPath *indexPath = [self.listViewTable indexPathForRowAtPoint:[self.listViewTable convertPoint:sender.center fromView:sender.superview]];
    StoryDescription *storyObject = (StoryDescription *)self.storyArray[indexPath.row];
    UserData *userObject = (UserData *)[self fetchUserProfileDataForID:storyObject.db];
    if ([userObject.is_following boolValue]) {
        userObject.is_following = [NSNumber numberWithBool:NO];
    }else{
        userObject.is_following = [NSNumber numberWithBool:YES];
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    self.storyArray = [self fetchStoryData];
    [self.listViewTable reloadData];
    [self.listViewTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:false];
}

-(NSArray *)fetchUserProfileDataForID:(NSString *)userID{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserData" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"userID = %@",userID];
    [request setPredicate:predicateName];
    
    NSError *error = nil;
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil){
        return [results lastObject];
    }else
        return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = (DetailViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"DetailView"];
    detailVC.storyObject = (StoryDescription *)self.storyArray[indexPath.row];
    detailVC.userObject = (UserData *)[self fetchUserProfileDataForID:detailVC.storyObject.db];
    [self.navigationController pushViewController:detailVC animated:true];
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
