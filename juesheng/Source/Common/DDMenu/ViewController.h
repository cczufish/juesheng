//
//  ViewController.h
//  Foodspotting
//
//  Created by jetson  on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ViewController : UIViewController<UIScrollViewDelegate,iCarouselDataSource, iCarouselDelegate>{
    UIScrollView *homeTopScrollView;
    UILabel *labelItem;
	NSArray *tabBarArray;

}
@property (retain, nonatomic) IBOutlet iCarousel *carousel;
@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) IBOutlet UIView *myView;

@property (retain, nonatomic) IBOutlet UIImageView *homeTopSVBack;

@end
