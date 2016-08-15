//
//  ViewController.m
//  Wireless Media
//
//  Created by Nikola on 8/13/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultsVC.h"

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) showResultsVC {
    if ([self.searchField.text isEqualToString:@""] || self.searchField.text == nil) {
        // NOPE
    } else {
        SearchResultsVC *srvc = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultsVC"];
        NSString *searchTerm = self.searchField.text;
        
        searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@"\"" withString:@"+"];
        
        if ([searchTerm characterAtIndex:searchTerm.length - 1] == '+') {
            searchTerm =[searchTerm substringToIndex:searchTerm.length - 1];
        }
        
        srvc.originalSearchTerm = self.searchField.text;
        srvc.searchTerm = searchTerm;
        [self.navigationController pushViewController:srvc animated:true];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text != nil || textField.text.length > 0) {
        [self showResultsVC];
        return true;
    } else {
        return false;
    }
}

- (IBAction)searchButtonTapped:(id)sender {
    [self showResultsVC];
}


@end
