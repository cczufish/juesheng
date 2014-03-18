//
//  CateTableCell.h
//  top100
//
//  Created by Dai Cloud on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface CateTableCell : UITableViewCell

@property (strong, nonatomic) EGOImageView *logo;
@property (strong, nonatomic) UILabel *title, *subTtile;

@end
