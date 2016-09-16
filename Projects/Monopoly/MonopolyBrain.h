//
//  MonopolyBrain.h
//  Monopoly
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MonopolyBrain : NSObject
{
    sqlite3 * db;
    sqlite3_stmt *sqlStatement;
    
    BOOL monopoly;
    
    int payment;
    int monCount;
    
    NSString *result;
    NSString *colour;
}

-(int)rentPayment:(int) position :(NSString *) owner :(int) diceroll;
-(NSString *)runSQL:(NSString *) statement;
-(BOOL)isMonopoly:(int) position :(NSString *) owner;

@end
