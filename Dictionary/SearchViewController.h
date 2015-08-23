//
//  ViewController.h
//  Dictionary
//
//  Created by Jeff Hokit on 10/20/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITraitEnvironment>
{
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITextChecker *textChecker;
@property (strong, nonatomic) NSArray *suggestions;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSMutableArray* recentSearches;

// ------ recent searches
-(void)addToRecentSearches:(NSString*)aSearch;
//-(void)clearRecentSearches;

@end
