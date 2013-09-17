//
//  RoomViewController.h
//  AnyChat
//
//  Created by bairuitech on 13-7-5.
//
//

#import <UIKit/UIKit.h>

@interface RoomViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    IBOutlet UITableView *onlineUserTable;
    NSMutableArray *onlineUserList;
}

@property (nonatomic, retain) IBOutlet UITableView *onlineUserTable;
@property (nonatomic, retain) NSMutableArray *onlineUserList;


-(void) RefreshRoomUserList;

- (IBAction) OnLeaveRoomBtnClicked:(id)sender;

@end

