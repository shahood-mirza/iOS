//
//  FlipsideViewController.m
//  QuizzerApp
//

#import "FlipsideViewController.h"
#import "MainViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //check states of settings from QuizBrain and set segments accordingly
    QuizBrain *sharedBrain = [QuizBrain sharedBrain];
    
    if([sharedBrain getQuizMode])
        quizMode.selectedSegmentIndex = 0;
    else
        quizMode.selectedSegmentIndex = 1;
    
    if([sharedBrain getQuizDiff])
        quizDiff.selectedSegmentIndex = 0;
    else
        quizDiff.selectedSegmentIndex = 1;
    
    quizLevel.selectedSegmentIndex = [sharedBrain getQuizLevel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    if(quizMode.selectedSegmentIndex == 0) //check quiz type setting (for quiz/learn mode)
        quizVal = YES;
    else
        quizVal = NO;
    
    if(quizDiff.selectedSegmentIndex == 0) //check quiz difficulty, easy or hard
        diffVal = YES;
    else
        diffVal = NO;
    
    //check quiz options setting (0->3options, 1->6options, 2->9options)
    choiceVal = quizLevel.selectedSegmentIndex;
    
    //send down settings to QuizBrain for use by other classes & views
    QuizBrain *sharedBrain = [QuizBrain sharedBrain];
    [sharedBrain setSettings:quizVal :diffVal :choiceVal];
    
    //returns to the view that called the flipside
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
