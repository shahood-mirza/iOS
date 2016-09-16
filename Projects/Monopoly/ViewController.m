//
//  ViewController.m
//  Monopoly
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize p1Piece;
@synthesize p2Piece;

//create objects we will use

- (Player *)p1
{
    if (!p1) p1 = [[Player alloc] init];
    return p1;
}

- (Player *)p2
{
    if (!p2) p2 = [[Player alloc] init];
    return p2;
}

- (Player *)activePlayer
{
    if (!activePlayer) activePlayer = [[Player alloc] init];
    return activePlayer;
}

- (MonopolyBrain *)brain
{
    if (!brain) brain = [[MonopolyBrain alloc] init];
    return brain;
}

-(IBAction)diceRoll:(UIButton *)sender
{
    //roll dice and set labels
    roll1 = arc4random()%6+1;
    roll2 = arc4random()%6+1;
    
    //for testing (just moving piece by one)
    //roll1 = 1;
    //roll2 = 0;
    
    [die1 setText:[NSString stringWithFormat:@"%d",roll1]];
    [die2 setText:[NSString stringWithFormat:@"%d",roll2]];
    
    //dice roll audio
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dice" ofType:@"wav"]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer play];
    
    //activePlayer is a temporary character used to switch between the two player objects
    if (currentPlayer == 1)
    {
        activePlayer = p1;
    }
    else if (currentPlayer == 2)
    {
        activePlayer = p2;
    }
    
    //set player token position
    [[self activePlayer] setPosition:(roll1+roll2)];
    [self movePieces];
    
    //get name of property that the player is on
    propName = [[self brain] runSQL:([NSString stringWithFormat:@"SELECT Name FROM  Properties WHERE Position=%d",[[self activePlayer] getPosition]])];
    
    if(currentPlayer == 1)
        [property1 setText:propName];
    else
        [property2 setText:propName];
    
    //get cost of property landed on
    propCost = [[[self brain] runSQL:([NSString stringWithFormat:@"SELECT Cost FROM  Properties WHERE Position=%d",[[self activePlayer] getPosition]])] intValue];
    
    //when a player lands on a property, we need to see who owns it
    //if the bank owns it, ask the player to buy and change the db to reflect purchase
    //if another player owns it, pay the rent
    //otherwise do nothing
    owner = [[self brain] runSQL:([NSString stringWithFormat:@"SELECT Owner FROM  OwnableProperties WHERE Position=%d",[[self activePlayer] getPosition]])];
    
    if ([owner isEqual:@"B"])
    {
        if ([[self activePlayer] getMoney] < propCost)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:[NSString stringWithFormat:@"You cannot afford %@", propName]
                                  message:[NSString stringWithFormat:@"Buying this property will cost $%d",propCost]
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:[NSString stringWithFormat:@"Do you want to buy %@?", propName]
                                  message:[NSString stringWithFormat:@"Buying this property will cost $%d",propCost]
                                  delegate:self
                                  cancelButtonTitle:@"Pass"
                                  otherButtonTitles:@"Buy It!", nil];
            alert.tag = 0; //alert used for buying properties
            [alert show];
        }
    }
    else if ([owner isEqual:@"P1"]) //rent calculation for player1's properties
    {
        payment = [[self brain] rentPayment:[[self activePlayer] getPosition]:@"P1":(roll1+roll2)];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"%@", propName]
                              message:[NSString stringWithFormat:@"Current Rent: $%d",payment]
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        
        [[self activePlayer] setMoney:-payment]; //take rent form current user
        [[self p1] setMoney:payment]; //pay to player 1
    }
    else if ([owner isEqual:@"P2"]) //rent calculation for player2's properties
    {
        payment = [[self brain] rentPayment:[[self activePlayer] getPosition]:@"P2":(roll1+roll2)];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"%@", propName]
                              message:[NSString stringWithFormat:@"Current Rent: $%d",payment]
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        
        [[self activePlayer] setMoney:-payment]; //take rent form current user
        [[self p2] setMoney:payment]; //pay to player 2
    }
    else //unbuyable properties have unique effects, these are handled here
    {
        //check for chance or community chest and pull random card
        if([[[self brain] runSQL:([NSString stringWithFormat:@"SELECT Name FROM  Properties WHERE Position=%d",[[self activePlayer] getPosition]])] isEqual:@"Chance"] || [[[self brain] runSQL:([NSString stringWithFormat:@"SELECT Name FROM  Properties WHERE Position=%d",[[self activePlayer] getPosition]])] isEqual:@"Community Chest"])
        {
            int randCard = arc4random()%10+1;
            
            propCost = [[[self brain] runSQL:([NSString stringWithFormat:@"SELECT Payment FROM RandomCards WHERE ID=%d",randCard])] intValue];
            propName = [[self brain] runSQL:([NSString stringWithFormat:@"SELECT Description FROM RandomCards WHERE ID=%d",randCard])];
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:[NSString stringWithFormat:@"%@:", propName]
                                  message:[NSString stringWithFormat:@"$%d",propCost]
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
            alert.tag = 1; //alert used for buying properties
            [alert show];
        }
        else
        {
            //some unbuyable properties (taxes) have a payment that applies to all players
            [[self activePlayer] setMoney:-[[[self brain] runSQL:([NSString stringWithFormat:@"SELECT Rent FROM  Properties WHERE Position=%d",[[self activePlayer] getPosition]])] intValue]];
        }
    }
    
    //copy activeplayer values to store into actual player
    if (currentPlayer == 1)
    {
        p1 = activePlayer;
        currentPlayer = 2;
    }
    else if (currentPlayer == 2)
    {
        p2 = activePlayer;
        currentPlayer = 1;
    }
    
    //set money text after switching activePlayer so the correct value is shown before the next dice roll
    [money1 setText:[NSString stringWithFormat:@"$%d",[[self p1] getMoney]]];
    [money2 setText:[NSString stringWithFormat:@"$%d",[[self p2] getMoney]]];
    
    //checks for bankruptcy
    if([[self p1] getMoney] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Player 1 has gone BANKRUPT!"
                              message:@"Player 2 WINS!"
                              delegate:self
                              cancelButtonTitle:@"End Game"
                              otherButtonTitles:nil];
        alert.tag = 2; //alert used for bankruptcy
        [alert show];
    }
    else if([[self p2] getMoney] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Player 2 has gone BANKRUPT!"
                              message:@"Player 1 WINS!"
                              delegate:self
                              cancelButtonTitle:@"End Game"
                              otherButtonTitles:nil];
        alert.tag = 2; //alert used for bankruptcy
        [alert show];
    }
}

- (void)movePieces
{
    //first, the player tokens are moved on the UI according to the dice roll
    //these can be hardcoded since the board size does not change
    position = [[self activePlayer] getPosition]-1;
    if (position >= 0 && position < 10)
    {
        if (currentPlayer == 1)
        {
            CGRect p1Frame = p1Piece.frame;
            p1Frame.origin.x = (408-(position*26));
            p1Frame.origin.y = 305;
            p1Piece.frame = p1Frame;
        }
        else
        {
            CGRect p2Frame = p2Piece.frame;
            p2Frame.origin.x = (408-(position*26));
            p2Frame.origin.y = 290;
            p2Piece.frame = p2Frame;
        }
    }
    else if (position >= 10 && position < 20)
    {
        if (currentPlayer == 1)
        {
            CGRect p1Frame = p1Piece.frame;
            p1Frame.origin.x = 128;
            p1Frame.origin.y = 285-((position-10)*26);
            p1Piece.frame = p1Frame;
        }
        else
        {
            CGRect p2Frame = p2Piece.frame;
            p2Frame.origin.x = 143;
            p2Frame.origin.y = 285-((position-10)*26);
            p2Piece.frame = p2Frame;
        }
    }
    else if (position >= 20 && position < 30)
    {
        if (currentPlayer == 1)
        {
            CGRect p1Frame = p1Piece.frame;
            p1Frame.origin.x = (128+((position-19)*26));
            p1Frame.origin.y = 5;
            p1Piece.frame = p1Frame;
        }
        else
        {
            CGRect p2Frame = p2Piece.frame;
            p2Frame.origin.x = (128+((position-19)*26));
            p2Frame.origin.y = 20;
            p2Piece.frame = p2Frame;
        }
    }
    else if (position >= 30 && position < 40)
    {
        if (currentPlayer == 1)
        {
            CGRect p1Frame = p1Piece.frame;
            p1Frame.origin.x = 430;
            p1Frame.origin.y = 5+((position-29)*26);
            p1Piece.frame = p1Frame;
        }
        else
        {
            CGRect p2Frame = p2Piece.frame;
            p2Frame.origin.x = 415;
            p2Frame.origin.y = 5+((position-29)*26);
            p2Piece.frame = p2Frame;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //handling the 'buy property' alert
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            //when UIAlertView shows, the original method still completes in the background
            //thus, the current player is changed before the purchase can be completed
            //for this reason we must have the opposite player be chosen for as correct owner
            if(currentPlayer == 1)
            {
                [[self brain] runSQL:([NSString stringWithFormat:@"UPDATE OwnableProperties SET  Owner='P%d' WHERE Position=%d", 2, [[self activePlayer] getPosition]])];
            }
            else if(currentPlayer == 2)
            {
                [[self brain] runSQL:([NSString stringWithFormat:@"UPDATE OwnableProperties SET  Owner='P%d' WHERE Position=%d", 1, [[self activePlayer] getPosition]])];
            }
            [[self activePlayer] setMoney:-propCost]; //charge user for property purchase
        }
    }
    //handling the random card alert
    else if (alertView.tag == 1)
    {
        [[self activePlayer] setMoney:propCost]; //propCost used here represents the card value
    }
    //handling backruptcy alert
    else if (alertView.tag == 2)
    {
        [self.navigationController popViewControllerAnimated:NO]; //pop the main view and return to title screen
    }
    //set money text: alert shows, but program still completes method in background, so this must be set again
    [money1 setText:[NSString stringWithFormat:@"$%d",[[self p1] getMoney]]];
    [money2 setText:[NSString stringWithFormat:@"$%d",[[self p2] getMoney]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPlayer = 1; //player one goes first
    
    //set initial piece locations
    CGRect p1Frame = p1Piece.frame;
    p1x = p1Frame.origin.x = 408;
    p1y = p1Frame.origin.y = 305;
    p1Piece.frame = p1Frame;
    
    CGRect p2Frame = p2Piece.frame;
    p2x = p2Frame.origin.x = 408;
    p2y = p2Frame.origin.y = 290;
    p2Piece.frame = p2Frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//we dont need the navigation controller bar on the board view
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    //place tokens back in original locations
    CGRect p1Frame = p1Piece.frame;
    CGRect p2Frame = p2Piece.frame;
    
    p1Frame.origin.x = p1x;
    p1Frame.origin.y = p1y;
    p2Frame.origin.x = p2x;
    p2Frame.origin.y = p2y;
    
    p1Piece.frame = p1Frame;
    p2Piece.frame = p2Frame;
}

//we do need the navigation bar in the property view to get back to the board
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //we have to save position values when calling navigation controller
    CGRect p1Frame = p1Piece.frame;
    CGRect p2Frame = p2Piece.frame;
    
    p1x = p1Frame.origin.x;
    p1y = p1Frame.origin.y;
    p2x = p2Frame.origin.x;
    p2y = p2Frame.origin.y;
    
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
