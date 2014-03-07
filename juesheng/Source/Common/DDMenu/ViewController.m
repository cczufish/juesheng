//
//  ViewController.m
//  Foodspotting
//
//  Created by jetson  on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
//#import "FirstViewController.h"
//#import "TwoViewController.h"
//#import "ThreeViewController.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define NUMBER_OF_ITEMS (IS_IPAD? 19: 12)
#define NUMBER_OF_VISIBLE_ITEMS 25
#define ITEM_SPACING 110.0f
#define INCLUDE_PLACEHOLDERS YES
@interface ViewController ()
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, retain) NSMutableArray *items;
@end

@implementation ViewController

@synthesize carousel;
@synthesize backImage;
@synthesize myView;
@synthesize homeTopSVBack;
@synthesize wrap;
@synthesize items;

-(id)init{
	if(self = [super init]){
//		FirstViewController *first = [[FirstViewController alloc]init];
//		UINavigationController *tab1=[[[UINavigationController alloc]init]autorelease];
//		[tab1 pushViewController:first animated:YES];
//		tabBarArray = [[NSArray alloc]initWithObjects:tab1, nil];
	}
	
	
	return self;
}
- (void)setUp
{
	//set up data
	wrap = YES;
	self.items = [NSMutableArray array];
	for (int i = 0; i < NUMBER_OF_ITEMS; i++)
	{
		[items addObject:[NSNumber numberWithInt:i]];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.title = @"首页";
	
//	UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStyleBordered target:self action:@selector(revealToggle:)];
//    self.navigationItem.leftBarButtonItem = edit;
//    [edit release];

	
	
	
//    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backImage setImage:[UIImage imageNamed:@"bg_wood.jpg"]];
//    [self.view addSubview:backgroundImage];
    
    
    [carousel setBackgroundColor:[UIColor clearColor]];
    carousel.tag= 101;
    [homeTopSVBack setImage:[UIImage imageNamed:@"filterbarbg.png"]];


      UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(110, 0, 101, 46)];
      [image setImage:[UIImage imageNamed:@"highlightglass.png"]];
      [self.view addSubview:image];

    carousel.decelerationRate = 0.5;
    carousel.type = iCarouselTypeLinear;
}


//-(void)revealToggle:(id *)sender{
//	NSLog(@"1111");
//	
//}

- (void)viewDidUnload
{
    [self setHomeTopSVBack:nil];
    [self setCarousel:nil];
    [self setBackImage:nil];
	[self setMyView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [homeTopSVBack release];
    [carousel release];
    [backImage release];
	[myView release];
    [super dealloc];
}




#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
     NSLog(@"--numberOfItemsInCarousel----");
    return [items count];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
     NSLog(@"--numberOfVisibleItemsInCarousel----");
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return NUMBER_OF_VISIBLE_ITEMS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{

    
    
            view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 101,46)];
            [view setBackgroundColor:[UIColor clearColor]];
            labelItem = [[UILabel alloc]initWithFrame:CGRectMake(35,-3,101,46)];
            labelItem.text=[NSString stringWithFormat:@"item%i",index];
            
            labelItem.backgroundColor = [UIColor clearColor];
            [view addSubview:labelItem];
            [labelItem release];

	return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    NSLog(@"--numberOfPlaceholdersInCarousel----");
	//note: placeholder views are only displayed on some carousels if wrapping is disabled
	return INCLUDE_PLACEHOLDERS? 2: 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
      NSLog(@"--placeholderViewAtIndex----");
	UILabel *label = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];
		label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [label.font fontWithSize:50.0f];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //set label
	label.text = (index == 0)? @"[": @"]";
	
	return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
     NSLog(@"--carouselItemWidth----");
    //usually this should be slightly wider than the item views
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
     NSLog(@"--itemAlphaForOffset----");
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
     NSLog(@"--itemTransformForOffset----");
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    NSLog(@"--carouselShouldWrap----");
    return NO;
}
//当滑动停止时
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    NSLog(@"----carouselDidEndScrollingAnimation----%i---%i",carousel.tag,carousel.currentItemIndex);

	if(carousel.currentItemIndex==0){
		//FirstViewController *first = [[FirstViewController alloc]init];
		//[myView addSubview:first.view];
//		[first release];
	}else if(carousel.currentItemIndex ==1){
		NSLog(@"----else-----");
		//TwoViewController *two = [[TwoViewController alloc]init];
		//[myView addSubview:two.view];
//		[two release];
	}else{
		//ThreeViewController *three = [[ThreeViewController alloc]init];
		//[myView addSubview:three.view];
	}
	
	
}
@end
