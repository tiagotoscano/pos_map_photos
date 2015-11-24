//
//  ViewControllerCell.h
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 21/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewCell;

@property (strong, nonatomic) IBOutlet UILabel *labDesc;
@end
