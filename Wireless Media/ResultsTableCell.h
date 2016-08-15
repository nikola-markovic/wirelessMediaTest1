//
//  ResultsTableCell.h
//  Wireless Media
//
//  Created by Nikola on 8/13/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageV;

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *descript;

@end
