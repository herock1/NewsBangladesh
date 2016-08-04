//
//  NBPreference.m
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBPreference.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"

static NSString * const kNBFONTSIZEKEY = @"NBFONTSIZEKEY";
static NSString * const kNBLANGUAGEMODEEKEY = @"NBLANGUAGEMODEEKEY";
static NSString * const kNBBREAKINGNEWSALERTEEKEY = @"NBBREAKINGNEWSALERTEEKEY";
static NSString * const kNBBAUTOMATICREFRESHKEY = @"NBBAUTOMATICREFRESHKEY";

static NSString * const kNBGlobalHeadingFontFamily = @"HelveticaNeue-Bold";
static NSString * const kNBGlobalBodyFontFamily = @"HelveticaNeue";

@interface NBPreference ()

@end

@implementation NBPreference

+ (void)setFontSize:(CGFloat)fontSize {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setFloat:fontSize forKey:kNBFONTSIZEKEY];
    [pref synchronize];
}

+ (CGFloat)fontSize {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    CGFloat fontSize = [pref floatForKey:kNBFONTSIZEKEY];
    
    return (fontSize <= 5.0f) ? 16.0f : fontSize;
}

+ (UIFont *)fontForHeadingLabel {
    
    return [UIFont fontWithName:kNBGlobalHeadingFontFamily size:[NBPreference fontSize] + 2.0f];
}

+ (UIFont *)fontForBodyLabel {
    
    return [UIFont fontWithName:kNBGlobalBodyFontFamily size:[NBPreference fontSize]];
}

+ (void)setLanguageMode:(NBLanguageMode) mode {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setInteger:mode forKey:kNBLANGUAGEMODEEKEY];
    [pref synchronize];
}

+ (NBLanguageMode)languageMode {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    return (NBLanguageMode)[pref integerForKey:kNBLANGUAGEMODEEKEY];
}

+ (void)setBreakingNewsAlert:(BOOL)yes {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setBool:yes forKey:kNBBREAKINGNEWSALERTEEKEY];
    [pref synchronize];
}

+ (BOOL)breakingNewsAlert {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    return [pref boolForKey:kNBBREAKINGNEWSALERTEEKEY];
}

+ (void)setAutomaticRefresh:(BOOL)yes {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setBool:yes forKey:kNBBAUTOMATICREFRESHKEY];
    [pref synchronize];
}

+ (BOOL)automaticRefresh {
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    
    return [pref boolForKey:kNBBAUTOMATICREFRESHKEY];
}
+ (NSString *)deviceUUID
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]])
        return [[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
    
    @autoreleasepool {
        
        CFUUIDRef uuidReference = CFUUIDCreate(nil);
        CFStringRef stringReference = CFUUIDCreateString(nil, uuidReference);
        NSString *uuidString = (__bridge NSString *)(stringReference);
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuidReference);
        CFRelease(stringReference);
        return uuidString;
    }
}

+(void)sendDeviceToken
{
   
    int a=[NBPreference languageMode];
    
    NSString *language=[NSString stringWithFormat:@"%d",a];
    NSLog(@"Language Mode: %d",a);
    NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *apns=[[NSUserDefaults standardUserDefaults] stringForKey:@"apnsToken"];
    NSLog(@"%@",apns);
    NSLog(@"%@",uniqueIdentifier);
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.newsbangladesh.com/gcm/register.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *posturl=[NSString stringWithFormat:@"regId=%@&name=%@&email=%@&device_os=2",apns,uniqueIdentifier,language];
    
    NSData *requestData = [posturl dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    

    
    
}

@end
