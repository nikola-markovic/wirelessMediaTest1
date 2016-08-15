//
//  DetailsVC.m
//  Wireless Media
//
//  Created by Nikola on 8/15/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "DetailsVC.h"
#import "AFNetworking.h"

@interface DetailsVC ()

@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UILabel *channelTitleLabel;

@end

@implementation DetailsVC {
    NSString *itemTitle;
    NSString *itemDescription;
    NSString *userName;
    NSURL *imageURL;
    
    NSMutableArray *itemsArray;
    
    CGFloat fullContentSize;
    
    UIActivityIndicatorView *loading;
}

@synthesize imageV;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize channelTitleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Details";
    
    loading = [[UIActivityIndicatorView alloc]init];
    loading.hidesWhenStopped = true;
    loading.center = self.view.center;
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:loading];
    [loading startAnimating];
    
    itemsArray = [[NSMutableArray alloc]init];
    
    [self sendRequest];
}

-(void)sendRequest {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *itemId = self.selectedItem[@"id"][@"videoId"];
    
    NSString *searchPath = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=%@&key=AIzaSyDN_io0qliBkSNhFzjb7c4F0C4cciBjdaw", itemId];
    
    [manager GET:searchPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        self.itemJSON = (NSDictionary *)responseObject;
        
        itemsArray = self.itemJSON[@"items"];
        
        NSDictionary *dwnItem = (NSDictionary *) itemsArray[0];
        
        itemTitle = dwnItem[@"snippet"][@"title"];
        itemDescription = dwnItem[@"snippet"][@"description"];
        userName = dwnItem[@"snippet"][@"channelTitle"];
        
        //IMAGE VIEW
        imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 3 / 4)];
        [self.scrollV addSubview: imageV];
        loading.center = imageV.center;
        fullContentSize += imageV.frame.size.height;
        [self setupView];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSString *imageRes = [NSString stringWithFormat:@"%@", dwnItem[@"snippet"][@"thumbnails"][@"default"][@"url"]];
            
            if (dwnItem[@"snippet"][@"thumbnails"][@"medium"][@"url"] != NULL) {
                imageRes = dwnItem[@"snippet"][@"thumbnails"][@"medium"][@"url"];
            }
            if (dwnItem[@"snippet"][@"thumbnails"][@"high"][@"url"] != NULL) {
                imageRes = dwnItem[@"snippet"][@"thumbnails"][@"high"][@"url"];
            }
            if (dwnItem[@"snippet"][@"thumbnails"][@"standard"][@"url"] != NULL) {
                imageRes = dwnItem[@"snippet"][@"thumbnails"][@"standard"][@"url"];
            }
            if (dwnItem[@"snippet"][@"thumbnails"][@"maxres"][@"url"] != NULL) {
                imageRes = dwnItem[@"snippet"][@"thumbnails"][@"maxres"][@"url"];
            }
            
            NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: imageRes]];
            if (imageData) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIImage *dImage = [UIImage imageWithData: imageData];
                    imageV.image = dImage;
                    [loading stopAnimating];
                });
            }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR!\n%@", error);
    }];
}

-(void)setupView {
    
    CGFloat phoneW = self.view.frame.size.width;
    
    //CHANNEL LABEL
    channelTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, phoneW * 3 / 4, phoneW - 16, 40)];
    channelTitleLabel.numberOfLines = 2;
    channelTitleLabel.font = [UIFont systemFontOfSize:12];
    channelTitleLabel.text = [NSString stringWithFormat:@"Channel: %@",userName];
    channelTitleLabel.textColor = [UIColor redColor];
    [self.scrollV addSubview: channelTitleLabel];
    fullContentSize += channelTitleLabel.frame.size.height;
    
    //TITLE LABEL
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, phoneW * 3 / 4 + 40, phoneW - 16, 35)];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = itemTitle;
    [titleLabel sizeToFit];
    [self.scrollV addSubview: titleLabel];
    fullContentSize += titleLabel.frame.size.height;
    
    //DESCRIPTION LABEL
    descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, titleLabel.frame.origin.y + titleLabel.frame.size.height + 8, phoneW - 16, 600)];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.text = itemDescription;
    [descriptionLabel sizeToFit];
    [self.scrollV addSubview: descriptionLabel];
    fullContentSize += descriptionLabel.frame.size.height;
    fullContentSize += 16;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    self.scrollV.contentSize = CGSizeMake(self.view.frame.size.width, fullContentSize);
}



@end
