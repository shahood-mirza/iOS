//
//  ViewController.h
//  Monopoly
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>
#import "Player.h"
#import "MonopolyBrain.h"

@interface ViewController : UIViewController
{
    sqlite3 * db;
    sqlite3_stmt *sqlStatement;
    
    AVAudioPlayer *audioPlayer;
    
    int roll1;
    int roll2;
    int currentPlayer;
    int propCost;
    int payment;
    int position;
    
    int p1x;
    int p1y;
    int p2x;
    int p2y;
    
    NSString *propName;
    NSString *owner;
    
    IBOutlet UILabel *die1;
    IBOutlet UILabel *die2;
    
    IBOutlet UILabel *player1;
    IBOutlet UILabel *money1;
    IBOutlet UILabel *property1;
    
    IBOutlet UILabel *player2;
    IBOutlet UILabel *money2;
    IBOutlet UILabel *property2;
    
    Player *p1;
    Player *p2;
    Player *activePlayer;
    
    MonopolyBrain *brain;
}

@property (strong, nonatomic) IBOutlet UIButton *p1Piece;
@property (strong, nonatomic) IBOutlet UIButton *p2Piece;

-(IBAction)diceRoll:(UIButton *)sender;
-(void)movePieces;

@end
