//
//  ViewController.h
//  SQL_Test
//
//  Created by Shahood Mirza
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController
{
    sqlite3 * db;
    sqlite3_stmt *sqlStatement;
}

@end
