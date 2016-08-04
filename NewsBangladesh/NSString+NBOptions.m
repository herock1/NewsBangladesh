//
//  NSString+NBOptions.m
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/17/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+NBOptions.h"

@implementation NSString (NBOptions)

- (NSString *)stringByStrippingHTMLContent {
    
    NSString *strippedString = [self stringByReplacingOccurrencesOfString:@"&nbsp;"
                                                     withString:@" "];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"&rsquo;"
                                                     withString:@" "];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"&lsquo;"
                                                     withString:@" "];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"&zwnj;"
                                                     withString:@" "];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"&ldquo;"
                                                     withString:@" "];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"&rdquo;"
                                                     withString:@" "];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"&zwnj;্"
                                                               withString:@""];
    strippedString=[strippedString stringByReplacingOccurrencesOfString:@"&#39;"
                                                             withString:@"'"];
   
    return strippedString;
}

@end
