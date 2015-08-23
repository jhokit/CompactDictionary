//
//  SearchViewController.m
//  Dictionary
//
//  Created by Jeff Hokit on 10/20/13.
//  Copyright (c) 2013 Jeff Hokit. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "Settings.h"
#import "UIColor+AppColors.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

//------------------------------------------------------------------------------
// Keep an instance of a UITextChecker for getting suggestions.
//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    // tint the bar red - do this right away for best appearance
    self.navigationController.navigationBar.barTintColor = [UIColor dictionaryRed];

    [super viewDidLoad];
    
    // get the array of recent searches from user defaults, or make a new one
    NSArray *storedRecents = [[NSUserDefaults standardUserDefaults] arrayForKey:kRecentSearchesKey];
    if (storedRecents)
    {
        self.recentSearches = [NSMutableArray arrayWithArray:storedRecents];
    }
    else
    {
        self.recentSearches = [NSMutableArray arrayWithCapacity:0];
    }

    // Keep an instance of UITextChecker for getting suggested words from word fragments.
    // This is the autocorrect word list, not the actual dictionary list, so it will return some words without definitions.
    // That's not ideal, but the alternate implementation of checking for actual definitions is just too slow (see alternate implemenation of searchBar:textDidChange: below)
    self.textChecker = [[UITextChecker alloc] init];
    // set to the user's preferred language. In iOS 8 use NSBundle, as [UITextChecker availableLanguages] no longer returns the languages in the user's preferred order
    NSArray *mainBundlePreferredLocalizations =  [NSBundle mainBundle].preferredLocalizations;
    self.language = mainBundlePreferredLocalizations[0];
    
    // install a UISearchBar in the naviationBar - could this be done earlier to elimiate the noticable tansisition on older slower devices?
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleProminent; // use the prominent style to get a white background
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.navigationItem.titleView = self.searchBar;
   [self.searchBar becomeFirstResponder]; // display the keyboard right away
}



//------------------------------------------------------------------------------
// Present a UIReferenceLibraryViewController showing a definition.
// Variations for regular and compact size class environments
//------------------------------------------------------------------------------
-(void)presentReferenceViewControllerWithTerm:(NSString*)term
{
    // Add this word to recent searches
    [self addToRecentSearches:term];
    
    // Always have to make a new UIReferenceLibraryViewController for each word
    UIReferenceLibraryViewController *referenceLibraryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:term];

    // Only when size class is regular (at this writing, on iPad in full screen mode).
    if ([UIApplication sharedApplication].keyWindow.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        // Present the UIReferenceLibraryViewController in our right-hand-side container view

        // remove any previous child UIReferenceLibraryViewController
        if ([appDelegate.containerViewController.childViewControllers count] > 0)
        {
            UIViewController *previousChildViewController = (appDelegate.containerViewController.childViewControllers)[0];
            if (previousChildViewController)
            {
                [previousChildViewController.view removeFromSuperview];
                [previousChildViewController removeFromParentViewController];
            }
        }
        
        // add the new UIReferenceLibraryViewController
        [appDelegate.containerViewController addChildViewController:referenceLibraryViewController];
        referenceLibraryViewController.view.frame = appDelegate.containerViewController.view.bounds;
        [appDelegate.containerViewController.view addSubview:referenceLibraryViewController.view];
        [referenceLibraryViewController didMoveToParentViewController:appDelegate.containerViewController];
        
        // get the keyboard out of the way
        [self.searchBar resignFirstResponder];
    }
    else // compact (iPhone & iPad split screen) case
    {
        // Simply present in a fullscreen modal view
        // Cant push onto a navigation stack because of the peculiar behavour of the NavBar within the controller.
        // That would be the nicer UI, but the UIReferenceLibraryViewController has its own navbar doesn't work well within an existing navbar stack
        [self presentViewController:referenceLibraryViewController animated:YES completion:nil];
    }

}


//------------------------------------------------------------------------------
// User tapped a row with a term in it
// Show the definition for either a suggestion or recent search, depending on
// which set we're displaying right now.
//------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *term; // the term we'll be defining
    
    NSString *searchText = self.searchBar.text;
    if (searchText && searchText.length > 0)    // if the search bar has some text in it
    {
        // the table is showing suggestions, so find the suggestion at indexPath.row
        term = (self.suggestions)[indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        // the table is showing recent searches, so find the recent search at indexPath.row
        term = (self.recentSearches)[indexPath.row];

        // and animate that to the top of the list, as it will now be the most recent search
        [self.tableView beginUpdates];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.tableView endUpdates];
    }
    
    // Show the UIReferenceLibraryViewController appropriately for the platform
    [self presentReferenceViewControllerWithTerm:term];

}



//------------------------------------------------------------------------------
// Always one section
//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


//------------------------------------------------------------------------------
// Enough rows to show the suggestions
//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    
    NSString *searchText = self.searchBar.text;
    if (searchText && searchText.length > 0)    // if the search bar has some text in it
    {
        result = self.suggestions.count;        // show suggestions
    }
    else
    {
        result = self.recentSearches.count;     // show recent searches
    }
    
    return result;
}




//------------------------------------------------------------------------------
// Vend a cell and set the suggestion or recent term text
//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordCell" forIndexPath:indexPath];
    
    NSString *searchText = self.searchBar.text;
    if (searchText && searchText.length > 0)     // if the search bar has some text in it
    {
        cell.textLabel.text = (self.suggestions)[indexPath.row];  // show suggestion
    }
    else
    {
        cell.textLabel.text = (self.recentSearches)[indexPath.row];  // show recent search
    }
    
    return cell;
}


//------------------------------------------------------------------------------
// As each new character is typed in the search bar, get new suggestions
// In english, skip over suggestions that end in ' or 's (those come up often
// but never have definitions)
//------------------------------------------------------------------------------
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSArray *unfilteredSuggestions = [self.textChecker completionsForPartialWordRange:NSMakeRange(0, [searchText length]) inString:searchText language:self.language];
    NSMutableArray *filteredSuggestions = [NSMutableArray arrayWithCapacity:[unfilteredSuggestions count]];
    
    if ([self.language hasPrefix:@"en"])    // for english only
    {
        for (NSString *suggestion in unfilteredSuggestions)
        {
            if (!(([suggestion hasSuffix:@"'"]) || ([suggestion hasSuffix:@"'s"]))) // if the word does not end in ' or 's
            {
                [filteredSuggestions addObject:suggestion]; // add it to the filtered list of words
            }
        }
        self.suggestions = filteredSuggestions; // use the filtered list of suggested words for English
    }
    else // for all languages except English
    {
        self.suggestions = unfilteredSuggestions;   // use the unfiltered list of suggested workds
    }

    [self.tableView reloadData];
}




//------------------------------------------------------------------------------
// As each new character is typed in the search bar, get new suggestions
// The OLD way, too slow. [UIReferenceLibraryViewController dictionaryHasDefinitionForTerm] takes a long time.
// Slows down the UI terribly.
// Consider re-implementing this on a background thread.
//------------------------------------------------------------------------------
//- (void)OLDsearchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    int count = 0;
//    NSArray *unfilteredSuggestions = [self.textChecker completionsForPartialWordRange:NSMakeRange(0, [searchText length]) inString:searchText language:self.language];
//    
//    NSMutableArray *filteredSuggestions = [NSMutableArray arrayWithCapacity:[unfilteredSuggestions count]];
//    
//    for (NSString *suggestion in unfilteredSuggestions)
//    {
//        if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:suggestion])
//        {
//            [filteredSuggestions addObject:suggestion];
//        }
//        else
//        {
//            count++;
//            NSLog(@"unused suggestion %@",suggestion);
//        }
//    }
//    
//    NSLog(@"words unused: %i",count);
//
//    self.suggestions = filteredSuggestions;
//    [self.tableView reloadData];
//}


//------------------------------------------------------------------------------
// This is called when the user touches the Search button on the Keyboard
//------------------------------------------------------------------------------
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self presentReferenceViewControllerWithTerm:[searchBar text]];
}


//------------------------------------------------------------------------------
// When the user moves the table, get the keyboard out of the way
//------------------------------------------------------------------------------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}



//------------------------------------------------------------------------------
// not used for now
//------------------------------------------------------------------------------
//-(void)clearRecentSearches
//{
//    [self.recentSearches removeAllObjects];
//    [[NSUserDefaults standardUserDefaults] setObject:self.recentSearches forKey:kRecentSearchesKey];
//}


//------------------------------------------------------------------------------
// Add the search term to our list of recent searches, dealing with duplicates
// and keeping the list trimmed to 10
//------------------------------------------------------------------------------
-(void)addToRecentSearches:(NSString*)aSearch
{
    NSUInteger foundIndex = [self.recentSearches indexOfObject:aSearch];
    if (foundIndex == NSNotFound)
    {
        // not already in recents, add it
        [self.recentSearches insertObject:aSearch atIndex:0];
    }
    else
    {
        // move found object to index 0
        NSString* object = (self.recentSearches)[foundIndex];
        [self.recentSearches removeObjectAtIndex:foundIndex];
        [self.recentSearches insertObject:object atIndex:0];
    }
    
    // trim recent searches if over 10
    if ([self.recentSearches count] > 10)
    {
        [self.recentSearches removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.recentSearches forKey:kRecentSearchesKey];
}


- (void) traitCollectionDidChange: (UITraitCollection *) previousTraitCollection {
    [super traitCollectionDidChange: previousTraitCollection];
    if ((self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass)
        || self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass) {
        NSLog(@"trait collection changed");
    }
    
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator> _Nonnull)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSLog(@"size transitioned");

}

- (void)willTransitionToTraitCollection:(UITraitCollection * _Nonnull)newCollection
              withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator> _Nonnull)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    NSLog(@"will transition to Trait");
}

@end
