//
//  UserData+CoreDataProperties.h
//  
//
//  Created by Suraj Kumar on 28/03/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserData.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *about;
@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSNumber *followers;
@property (nullable, nonatomic, retain) NSNumber *following;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *handle;
@property (nullable, nonatomic, retain) NSNumber *is_following;
@property (nullable, nonatomic, retain) NSNumber *createdOn;

@end

NS_ASSUME_NONNULL_END
