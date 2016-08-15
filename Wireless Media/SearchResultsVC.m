//
//  searchResultsVC.m
//  Wireless Media
//
//  Created by Nikola on 8/13/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "SearchResultsVC.h"
#import "ResultsTableCell.h"
#import "AFNetworking.h"
#import "DetailsVC.h"

@interface SearchResultsVC () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@end

@implementation SearchResultsVC {
    int prevCount;
    UIActivityIndicatorView *loading;
    UIAlertView *wrongSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    wrongSearch = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please redefine your search!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    loading = [[UIActivityIndicatorView alloc]init];
    loading.hidesWhenStopped = true;
    loading.center = self.view.center;
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:loading];
    [loading startAnimating];
    self.title = [NSString stringWithFormat: @"\"%@\"", self.originalSearchTerm];
    
    self.searchItems = [[NSMutableArray alloc]init];
    
    [self loadMoreData];
    prevCount = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadMoreData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *searchPath = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&maxResults=%i&key=AIzaSyDN_io0qliBkSNhFzjb7c4F0C4cciBjdaw", self.searchTerm, 50];
    
    [manager GET:searchPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        self.searchResultsJSON = (NSDictionary *)responseObject;
        
        NSArray *downloadedItems = self.searchResultsJSON[@"items"];
        
        for (NSDictionary *item in downloadedItems) {
            if ([item[@"id"][@"kind"] isEqualToString:@"youtube#video"]) {
                [self.searchItems addObject:item];
            }
        }
        if (self.searchItems.count > 0) {
            [self showMore];
        }
        [loading stopAnimating];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR!\n%@", error);
        [wrongSearch show];
    }];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return prevCount + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResultsTableCell *cell = (ResultsTableCell *)[self.resultsTV dequeueReusableCellWithIdentifier:@"itemCell"];
    
    if (indexPath.row != prevCount) {
            NSDictionary *item = (NSDictionary *) self.searchItems[indexPath.row][@"snippet"];
            cell.title.text = item[@"title"];
            cell.descript.text = item[@"description"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

            NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@", item[@"thumbnails"][@"default"][@"url"]]]];
            if (imageData) {
//                UIImage *dImage = [UIImage imageWithData: imageData];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIImage *dImage = [UIImage imageWithData: imageData];
                    cell.imageV.image = dImage;

                });
            }
        });
    } else {
        cell = nil;
        if (cell == nil) {
            cell = [[ResultsTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"def"];
        }
        if (indexPath.row == self.searchItems.count) {
            cell.textLabel.text = @"END (load more on desktop)";
        } else {
            cell.textLabel.text = @"LOAD MORE";
        }
        if (self.searchItems.count == 0)
            cell.textLabel.text = @"NO RESULTS";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row <= self.searchItems.count) {
        if (indexPath.row >= prevCount) {
            [self showMore];
        } else {
            NSDictionary *selectedItem = self.searchItems[indexPath.row];
            [self showDetailsOfItem: selectedItem];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

-(void) showMore {
    if (prevCount + 10 > self.searchItems.count) {
        prevCount += self.searchItems.count - prevCount;
    } else {
        prevCount += 10;
    }
    [self.resultsTV reloadData];
}

-(void) showDetailsOfItem:(NSDictionary *)selectedItem {
        
    DetailsVC *dvc = (DetailsVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    
    dvc.selectedItem = selectedItem;
    
    [self.navigationController pushViewController: dvc animated:true];
    
}


@end
