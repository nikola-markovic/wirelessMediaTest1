//
//  DetailsVC.h
//  Wireless Media
//
//  Created by Nikola on 8/15/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsVC : UIViewController

@property (strong, nonatomic) NSDictionary *selectedItem;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;

@property (strong, nonatomic) NSDictionary *itemJSON;

@end
