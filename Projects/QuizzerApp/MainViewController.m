//
//  MainViewController.m
//  QuizzerApp
//
//  By Shahood Mirza

#import "MainViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

@synthesize audioPlayer;

//Sets the action of the start button on the home page to go to the quiz or learn-mode according to settings
- (IBAction)startMode:(UIButton *)sender
{
    QuizBrain *sharedBrain = [QuizBrain sharedBrain]; //required to access singleton QuizBrain methods
    
    [sharedBrain setQuesCount:0]; //resets the question counter so both modes can begin from the start
    
    if([sharedBrain getQuizMode])
        [self presentViewController:([self.storyboard instantiateViewControllerWithIdentifier:@"instructions"]) animated:YES completion:NULL];
    else
        [self presentViewController:([self.storyboard instantiateViewControllerWithIdentifier:@"tutorial"]) animated:YES completion:NULL];
}

//Action delegated by the home icon (bottom left)
- (IBAction)goHome:(UIButton *)sender
{
    //displays an alert to confirm loss of progress before going to the home page
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"Going back to MAIN. All progress will be lost." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Main", nil];
    [alert show];
}

//Plays the sound associated with the displayed picture
- (IBAction)playSound:(UIButton *)sender
{
    QuizBrain *sharedBrain = [QuizBrain sharedBrain];  //required to access singleton QuizBrain methods
    NSURL *url;
    
    //depending on the mode (quiz/learn-mode) the sounds will play in a different order
    if([sharedBrain getQuizMode])
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",randomNum] ofType:@"mp3"]];
    else
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",[sharedBrain getQuesCount]] ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer play];
}

//Main quiz actions delegated by the segmented controls in each view
- (IBAction)goToNextQuestion:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *) sender;
    QuizBrain *sharedBrain = [QuizBrain sharedBrain];  //required to access singleton QuizBrain methods
    
    //check to see if the selected answer was incorrect
    if(!([sharedBrain correctAnswer:[seg titleForSegmentAtIndex:[seg selectedSegmentIndex]]:randomNum]))
    {
        display.text = @"Wrong!!"; //display indicator to the user
        
        [sharedBrain setWrong:1]; //increase the counter for wrong guesses (score)
        [sharedBrain setWrongOnce:YES]; //set flag to indicate the user got the question wrong
        
        [self playRightWrong:NO]; //play a 'wrong' sound
    }
    else //runs when the answer is correct
    {
        [self playRightWrong:YES]; //play a 'right' sound
        
        display.text = @"Correct!!"; //display an indicator to the user
        
        if(!([sharedBrain getWrongOnce])) //check to see if the question was flagged with a wrong guess
        {
            [sharedBrain setRight:1]; //if no guesses were made, increase the counter for right guesses (score)
        }
        
        [sharedBrain setWrongOnce:NO]; //clear wrong flag
        
        if([sharedBrain getQuesCount]>=9)
        {
            //if the last question is reached, stop any playing audio and transition to the results view
            
            [audioPlayer stop];
            
            [sharedBrain generateRandomNumber:0];
            
            [self presentViewController:([self.storyboard instantiateViewControllerWithIdentifier:@"results"]) animated:YES completion:NULL];
        }
        else
        {
            //increase the counter and progress bar
            [sharedBrain setQuesCount:1];
            [progBar setProgress:([progBar progress]+0.1)];
            quesNum.text = [NSString stringWithFormat:@"%d",[sharedBrain getQuesCount]+1];
            
            //generate a random number to delegate the next image to display and/or the correct answer
            randomNum = [sharedBrain generateRandomNumber:1];
            
            //we only display an image if the difficulty is on easy, otherwise a question mark is shown
            if(quizDiff)
            {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",randomNum]];
                [imageView setImage:image];
            }
            else
            {
                UIImage *image = [UIImage imageNamed:@"qMark.jpg"];
                [imageView setImage:image];
            }
            
            //generate random numbers and place filler answers (incorrect) randomly
            for (int s=0; s<3; s++)
            {
                randIndex = [sharedBrain generateRandomArrayIndex:1];
                [segOne setTitle:[NSString stringWithFormat:@"%@", [sharedBrain getLabel:randIndex]] forSegmentAtIndex:s];
                randIndex = [sharedBrain generateRandomArrayIndex:1];
                [segTwo setTitle:[NSString stringWithFormat:@"%@", [sharedBrain getLabel:randIndex]] forSegmentAtIndex:s];
                randIndex = [sharedBrain generateRandomArrayIndex:1];
                [segThree setTitle:[NSString stringWithFormat:@"%@", [sharedBrain getLabel:randIndex]] forSegmentAtIndex:s];
            }
            
            [sharedBrain generateRandomArrayIndex:0]; //reset random answer array
            
            //to place the right answer, the first step is to determine how many segments are on (from settings)
            randSeg = arc4random() %(quizLevel+1); //next, a random segment display is chosen
            
            //finally, a random slot is chosen to insert the correct answer
            if (randSeg == 0)
            {
                randSeg = arc4random() %3;
                [segOne setTitle:[NSString stringWithFormat:@"%@", [sharedBrain currentAnswer:randomNum]] forSegmentAtIndex:randSeg];
            }
            else if (randSeg == 1)
            {
                randSeg = arc4random() %3;
                [segTwo setTitle:[NSString stringWithFormat:@"%@", [sharedBrain currentAnswer:randomNum]] forSegmentAtIndex:randSeg];
            }
            else
            {
                randSeg = arc4random() %3;
                [segThree setTitle:[NSString stringWithFormat:@"%@", [sharedBrain currentAnswer:randomNum]] forSegmentAtIndex:randSeg];
            }
        }
    }
}

//Tutorial button (next/previous) control method
- (IBAction)tutorialNextPrev:(id)sender
{
    QuizBrain *sharedBrain = [QuizBrain sharedBrain]; //required to access singleton QuizBrain methods
    NSURL *url;
    
    
    if(segOne.selectedSegmentIndex == 0) //check if 'previous' was selected
    {
        //play button sound
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Prev" ofType:@"mp3"]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer play];
        
        //if the image shown is not the first image, decrease the progress bar and counter
        if([sharedBrain getQuesCount]>0)
        {
            [sharedBrain setQuesCount:-1];
            [progBar setProgress:([progBar progress]-0.1)];
        }
        //if the image shown is the first image, return home and play home sound
        else
        {
            [audioPlayer stop];
            
            url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Whoosh" ofType:@"mp3"]];
            NSError *error;
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            [audioPlayer play];
            
            [self presentViewController:([self.storyboard instantiateViewControllerWithIdentifier:@"mainView"]) animated:YES completion:NULL];
        }
    }
    else //runs if 'next' is selected
    {
        //play button sound
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Next" ofType:@"mp3"]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer play];
        
        //if the image shown is not the last image, increase the progress bar and counter
        if([sharedBrain getQuesCount]<9)
        {
            [sharedBrain setQuesCount:1];
            [progBar setProgress:([progBar progress]+0.1)];
        }
        //if the image shown is the last image, play applause sound and show an alert
        else
        {
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Applaud" ofType:@"mp3"]];
            NSError *error;
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            [audioPlayer play];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HOORAH!" message:@"Tutorial is Complete." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Home", nil];
            [alert show];
        }
    }
    
    //display image according to counter
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",[sharedBrain getQuesCount]]];
    [imageView setImage:image];
    
    //set image description text
    display.text = [NSString stringWithFormat:@"%@\n\nScientific %@",[sharedBrain currentAnswer:[sharedBrain getQuesCount]], [sharedBrain currentSciAnswer:[sharedBrain getQuesCount]]];

    //set progress bar text
    quesNum.text = [NSString stringWithFormat:@"%d",([sharedBrain getQuesCount]+1)];
}

- (void)playRightWrong:(BOOL)corrAns
{
    NSURL *url;
    soundWrong = (arc4random() %3); //generate a random number for the different wrong answer sounds
    
    if(corrAns) //if statement to decide whether the sound is for right or wrong answers
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Correct" ofType:@"mp3"]];
    else
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Wrong%d",soundWrong] ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer play];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //runs if cancel is NOT pressed on the popup alert
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        [audioPlayer stop]; //stop any audio already playing
        
        //transition to home page
        [self presentViewController:([self.storyboard instantiateViewControllerWithIdentifier:@"mainView"]) animated:YES completion:NULL];
        
        //play go home sound 
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Whoosh" ofType:@"mp3"]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer play];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    QuizBrain *sharedBrain = [QuizBrain sharedBrain]; //required to access singleton QuizBrain methods
    
    //reset all arrays on start
    [sharedBrain generateRandomNumber:0]; //reset for  random image display
    [sharedBrain setRight:0];   //score reset
    [sharedBrain setWrong:0];   //score reset
    
    //set settings for once instance
    quizLevel = [sharedBrain getQuizLevel];
    quizDiff = [sharedBrain getQuizDiff];
    
    //set initial image for hard mode
    if (!quizDiff && [sharedBrain getQuizMode])
    {
        UIImage *image = [UIImage imageNamed:@"qMark.jpg"];
        [imageView setImage:image];
    }
    
    //when the view is loaded, modify any settings as according to the flipside
    //these if statements hide/show the segmented displays
    if (quizLevel == 0)
    {
        [segOne setHidden:NO];
        [segTwo setHidden:YES];
        [segThree setHidden:YES];
    }
    else if (quizLevel == 1)
    {
        [segOne setHidden:NO];
        [segTwo setHidden:NO];
        [segThree setHidden:YES];
    }
    else
    {
        [segOne setHidden:NO];
        [segTwo setHidden:NO];
        [segThree setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
