//
//  searchResultsVC.h
//  Wireless Media
//
//  Created by Nikola on 8/13/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsVC : UIViewController

@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSString *originalSearchTerm;

@property (strong, nonatomic) NSDictionary *searchResultsJSON;

@property (strong, nonatomic) NSMutableArray *searchItems;

@property (strong, nonatomic) IBOutlet UITableView *resultsTV;




@end
