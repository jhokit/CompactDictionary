//
//  Settings.m
//  Dictionary
//
//

#import "Settings.h"


@implementation Settings

NSString *const kRecentSearchesKey = @"RecentSearches";
NSString *const kLastSearchKey = @"LastSearch";

+(void) registerDefaults 
{
	// Create standard defaults
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	    
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}


@end
