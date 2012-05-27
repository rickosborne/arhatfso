//
//  AppDelegate.h
//  arhatfso
//
//  Created by rosborne on 5/26/12.
//

#import <UIKit/UIKit.h>

@class LogInViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
	__strong LogInViewController *logInViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
