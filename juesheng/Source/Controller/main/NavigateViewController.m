//
//  NavigateViewController.m
//  juesheng
//
//  Created by runes on 13-6-1.
//  Copyright (c) 2013年 heige. All rights reserved.
//

#import "NavigateViewController.h"
#import "MyTableTextItem.h"
#import "TableViewController.h"
#import "LoginViewController.h"

@interface NavigateViewController ()

@end

@implementation NavigateViewController
@synthesize navigateArray=_navigateArray,parentNavigate=_parentNavigate;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query
{
    self = [self init];
    if (self) {
        _navigateArray = [[query objectForKey:@"navigateList"] retain];
        _parentNavigate = [query objectForKey:@"parentNavigate"];
        self.title = _parentNavigate.navigateName;
    }
    return self;
}

- (id)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        if ([Three20 systemMajorVersion] >= 7) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        else{
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        self.tableView.backgroundView.alpha = 0;
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:TTIMAGE(@"bundle://middle_bk.jpg")];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"navigateViewMemoryWarning");
    // Dispose of any resources that can be recreated.
}

- (void)createModel {
    if (_navigateArray&&_parentNavigate) {
        NSMutableArray* items = [[NSMutableArray alloc] init];
        NSMutableArray* sections = [[NSMutableArray alloc] init];
    
        // Styles Section
        [sections addObject:NSLocalizedString(_parentNavigate.navigateName, _parentNavigate.navigateName)];
        NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
        for (Navigate *navigate in _navigateArray){
            [itemsRow addObject:[MyTableTextItem itemWithText:navigate.navigateName delegate:self selector:@selector(selectItem:) withObject:navigate]];
        }
        if ([itemsRow count] == 0) {
            [itemsRow addObject:[TTTableTextItem itemWithText:@"建设中..."]];
        }
        [items addObject:itemsRow];
        [itemsRow release];
    
    
        self.dataSource = [[[TTSectionedDataSource alloc] initWithItems:items sections:sections] autorelease];
        [items release];
        [sections release];
    }
}

- (void)dealloc
{
    [super dealloc];
    TT_RELEASE_SAFELY(_navigateArray);
}

- (void) selectItem:(id)sender
{
    MyTableTextItem *myTableTextItem = (MyTableTextItem*)sender;
//    TTURLAction *action =  [[[TTURLAction actionWithURLPath:@"tt://tableView"]
//                             applyQuery:[NSDictionary dictionaryWithObject:myTableTextItem.myDistObject forKey:@"navigate"]]
//                            applyAnimated:YES];
//    [[TTNavigator navigator] openURLAction:action];
    Navigate *navigate = (Navigate*)myTableTextItem.myDistObject;
    NSString *runType = navigate.navigateRunType;
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    if (runType && [runType compare:@"B" options:comparisonOptions] == NSOrderedSame){
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:navigate.navigateClassType forKey:@"classType"];
        [dictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isEdit"];
        //[dictionary setObject:[_tableFieldArray retain] forKey:@"tableFieldArray"];
        EditViewController *editViewController = [[EditViewController alloc] initWithURL:nil query:dictionary];
        editViewController.delegate = self;
        [self.navigationController pushViewController:editViewController animated:YES];
        TT_RELEASE_SAFELY(dictionary);
        [editViewController release];
    }
    else{
        TableViewController *tableViewController = [[TableViewController alloc] initWithURL:[NSDictionary dictionaryWithObject:myTableTextItem.myDistObject forKey:@"navigate"]];
        [[self navigationController] pushViewController:tableViewController animated:YES];
        [tableViewController release];
    }
}

- (void)refreshListView
{
    
}

@end
