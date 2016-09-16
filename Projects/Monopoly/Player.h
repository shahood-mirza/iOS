//
//  Player.h
//  Monopoly
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
{
    int money;
    int position;
}

-(void)setInitialPosition:(int)setLocation; //for continuing a game
-(void)setInitialMoney:(int)setAmount; //for continuing a game
-(void)setPosition:(int)roll;
-(int)getPosition;
-(void)setMoney:(int)payment;
-(int)getMoney;

@end
