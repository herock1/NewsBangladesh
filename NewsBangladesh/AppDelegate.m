//
//  AppDelegate.m
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchsDetailTableViewController.h"
#import "NBPreference.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
         UIUserNotificationTypeBadge |
         UIUserNotificationTypeSound
                                          categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    return YES;
}


- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings
{
    NSLog(@"Registering device for push notifications..."); // iOS 8
    [application registerForRemoteNotifications];
    
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    
    NSString* deviceToken = [[[[token description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    
    NSLog(@"Device_Token     -----> %@\n",deviceToken);
    
    NSString *tokens = [[token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokens = [tokens stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", tokens);
    
    NSLog(@"Registration successful, bundle identifier: %@, mode: %@, device token: %@",
          [NSBundle.mainBundle bundleIdentifier], [self modeString], token);
    
    NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"UDID:: %@", uniqueIdentifier);
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"apnsToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setBool: NO  forKey:@"registerd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Device Token: Saved on NSUserDefault %@",deviceToken);
    
    [NBPreference sendDeviceToken];
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register: %@", error);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)notification completionHandler:(void(^)())completionHandler
{
     NSDictionary *notifyjson=[notification objectForKey:@"aps"];
    NSLog(@"%@",notifyjson);
    NSLog(@"Received push notification: %@, identifier: %@", notification, identifier); // iOS 8

    if (application.applicationState == UIApplicationStateActive)
    {
    
    }
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)notification
{
    
    
    NSDictionary *notifyjson=[notification objectForKey:@"aps"];
    NSLog(@"%@",[notification objectForKey:@"aps"]);
    NSLog(@"%@",[notifyjson objectForKey:@"alert"]);
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    SearchsDetailTableViewController *controller = (SearchsDetailTableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"search"];
     controller.newsid=[notification objectForKey:@"newsId"];
     controller.languagemode=[notification objectForKey:@"language"];
   

    [navigationController pushViewController:controller animated:YES];
    NSLog(@"Received push notification: %@", notification); // iOS 7 and earlier
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSString *)modeString
{
#if DEBUG
    return @"Development (sandbox)";
#else
    return @"Production";
#endif
}

@end



/*
 //
 //  AppDelegate.m
 //  NewsBangladesh
 //
 //  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
 //  Copyright (c) 2015 DGDev. All rights reserved.
 //
 
 #import "AppDelegate.h"
 
 @interface AppDelegate ()
 
 @end
 
 @implementation AppDelegate
 
 
 - (BOOL)application:(UIApplication *)application
 didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
 NSLog(@"Requesting permission for push notifications..."); // iOS 8
 UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
 UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |
 UIUserNotificationTypeSound categories:nil];
 [UIApplication.sharedApplication registerUserNotificationSettings:settings];
 } else {
 NSLog(@"Registering device for push notifications..."); // iOS 7 and earlier
 [UIApplication.sharedApplication registerForRemoteNotificationTypes:
 UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
 UIRemoteNotificationTypeSound];
 }
 return YES; saydul@dhakacom.com
 }
 
 - (void)application:(UIApplication *)application
 didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings
 {
 NSLog(@"Registering device for push notifications..."); // iOS 8
 [application registerForRemoteNotifications];
 }
 
 - (void)application:(UIApplication *)application
 didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
 {
 NSString *tokens = [[token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
 tokens = [tokens stringByReplacingOccurrencesOfString:@" " withString:@""];
 NSLog(@"content---%@", tokens);
 
 NSLog(@"Registration successful, bundle identifier: %@, mode: %@, device token: %@",
 [NSBundle.mainBundle bundleIdentifier], [self modeString], token);
 }
 
 - (void)application:(UIApplication *)application
 didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
 {
 NSLog(@"Failed to register: %@", error);
 }
 
 - (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
 forRemoteNotification:(NSDictionary *)notification completionHandler:(void(^)())completionHandler
 {
 NSLog(@"Received push notification: %@, identifier: %@", notification, identifier); // iOS 8
 completionHandler();
 }
 
 - (void)application:(UIApplication *)application
 didReceiveRemoteNotification:(NSDictionary *)notification
 {
 NSLog(@"Received push notification: %@", notification); // iOS 7 and earlier
 }
 
 - (NSString *)modeString
 {
 #if DEBUG
 return @"Development (sandbox)";
 #else
 return @"Production";
 #endif
 }
 
 @end
 
 */
