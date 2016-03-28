//
//  StoryDescription+CoreDataProperties.h
//  
//
//  Created by Suraj Kumar on 28/03/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "StoryDescription.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoryDescription (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *storyDescription;
@property (nullable, nonatomic, retain) NSString *storyID;
@property (nullable, nonatomic, retain) NSString *verb;
@property (nullable, nonatomic, retain) NSString *db;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *si;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *like_flag;
@property (nullable, nonatomic, retain) NSNumber *likes_count;
@property (nullable, nonatomic, retain) NSNumber *comment_count;

@end

NS_ASSUME_NONNULL_END
