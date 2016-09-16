//
//  Results.m
//  QuizzerApp
//

#import "Results.h"
#import "MainViewController.h"

@interface Results ()

@end

@implementation Results

@synthesize audioPlayer;

- (IBAction)buttonTapped:(UIButton *)sender
{
    [audioPlayer stop];
    
    //when home button is pressed, return to home
    [self presentViewController:([self.storyboard instantiateViewControllerWithIdentifier:@"mainView"]) animated:YES completion:NULL];
    
    //play go home sound
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Whoosh" ofType:@"mp3"]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer play];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    QuizBrain *sharedBrain = [QuizBrain sharedBrain]; //required to access singleton QuizBrain methods
    
    //set labels to depict scores
    right.text = [NSString stringWithFormat:@"Right: %d", [sharedBrain getRight]];
    wrong.text = [NSString stringWithFormat:@"Wrong: %d", [sharedBrain getWrong]];
    
    //reset score values for next iteration
    [sharedBrain setRight:0];
    [sharedBrain setWrong:0];
    
    //reset all arrays for next interation
    [sharedBrain generateRandomNumber:0]; //reset for  random image display
    [sharedBrain setRight:0];   //score reset
    [sharedBrain setWrong:0];   //score reset
    
    //play applause sound
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Applaud" ofType:@"mp3"]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer play];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
