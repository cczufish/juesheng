//
//  SubCateViewController.m
//  top100
//
//  Created by Dai Cloud on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SubCateViewController.h"
#import "NameValue.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#define COLUMN 1

@interface SubCateViewController ()

@end

@implementation SubCateViewController

@synthesize subCates=_subCates;
@synthesize cateVC=_cateVC;

- (void)dealloc
{
    [_subCates release];
    [_cateVC release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tmall_bg_furley.png"]];
    
    // init cates show
    
}

- (void)reloadCateData
{
    int total = self.subCates.count;
#define ROWHEIHT 170
    int rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
    
    for (int i=0; i<total; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        NameValue *data = [self.subCates objectAtIndex:i];
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(80*column, ROWHEIHT*row, 290, ROWHEIHT)] autorelease];
        view.backgroundColor = [UIColor clearColor];
        EGOImageButton *btn = [[EGOImageButton alloc] initWithFrame:CGRectMake(15, 15, 290, 150)];
//        btn.frame = CGRectMake(15, 15, 50, 50);
        btn.tag = i;
        
        [btn addTarget:self.cateVC action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (data.idImageUrl) {
//            [btn performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString: data.idImageUrl] waitUntilDone:NO];
//            //[btn setImageURL:data.idImageUrl];
//            btn.placeholderImage = [UIImage imageNamed:@"logo.png"];
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(15, 15, 290, 150)];
            [imageView performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString: data.idImageUrl] waitUntilDone:NO];
            //[imageView setImageURL:[NSURL URLWithString: data.idImageUrl]];
            imageView.placeholderImage = [UIImage imageNamed:@"logo.png"];
            [view addSubview:imageView];
            [imageView release];
        }
        else{
            [btn setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        }
        
        
        [view addSubview:btn];
        [btn release];
        
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 165, 290, 14)] autorelease];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.textColor = [UIColor colorWithRed:204/255.0
                                        green:204/255.0
                                         blue:204/255.0
                                        alpha:1.0];
        lbl.font = [UIFont systemFontOfSize:12.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = data.idName;
        [view addSubview:lbl];
        
        [self.view addSubview:view];
    }
    
    //CGRect viewFrame = self.view.frame;
    //viewFrame.size.height = ROWHEIHT * rows + 19;
    //NSLog(@"高度:%f",viewFrame.size.height);
    //self.view.frame = viewFrame;
    [(UIScrollView *)self.view setContentSize:CGSizeMake(self.view.frame.size.width, ROWHEIHT * rows + 19)];
}

@end
