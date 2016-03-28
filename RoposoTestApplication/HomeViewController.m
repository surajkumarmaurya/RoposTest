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

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listViewTable;
@property (strong, nonatomic) NSArray *storyArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self accessJSONFileAndSaveData];
    self.storyArray = [self fetchStoryData];
}

-(void)accessJSONFileAndSaveData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    for (NSDictionary *dataDict in dataArray) {
        if ([dataDict valueForKey:@""]) {
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
