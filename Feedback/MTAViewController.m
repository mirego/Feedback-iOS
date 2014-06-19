//
//  MTAViewController.m
//  Feedback
//
//  Created by Simon Audet on 2014-06-18.
//  Copyright (c) 2014 Mirego. All rights reserved.
//

#import "MTAViewController.h"
#import <MessageUI/MessageUI.h>

@interface MTAViewController () <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate> {
    CGRect _oldFrame;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *response1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *response2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *response3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *response4;
@property (weak, nonatomic) IBOutlet UITextView *response5;
@property (weak, nonatomic) IBOutlet UITextView *response6;
@property (weak, nonatomic) IBOutlet UITextView *response7;

@end

@implementation MTAViewController



-(void)viewDidLoad {
    for (UIView* subview in self.scrollview.subviews) {
        subview.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)send:(id)sender {
    MFMailComposeViewController* composer = [[MFMailComposeViewController alloc] init];
    [composer setSubject:@"Feedback from : "];
    composer.mailComposeDelegate = self;
    [composer setToRecipients:@[@"saudet@mirego.com"]];
    
    NSMutableString* body = [NSMutableString string];
    [body appendFormat:@"1. How helpful was the content of the Bootcamp? %@ \n\n", [self.response1 titleForSegmentAtIndex:self.response1.selectedSegmentIndex]];
    [body appendFormat:@"2. How would rate the presentation? %@ \n\n", [self.response1 titleForSegmentAtIndex:self.response2.selectedSegmentIndex]];
    [body appendFormat:@"3. How interested are you to continue developing on iOS after this Bootcamp? %@ \n\n", [self.response3 titleForSegmentAtIndex:self.response3.selectedSegmentIndex]];
    [body appendFormat:@"4. How likely are you to refer this Bootcamp to someone else? %@ \n\n", [self.response4 titleForSegmentAtIndex:self.response4.selectedSegmentIndex]];
    [body appendFormat:@"5. What would change in this Bootcamp to make it more effective for you? %@ \n\n", self.response5.text];
    [body appendFormat:@"6. Do you have an iOS project that you are currently working on or interested in starting that can benefit from a private half day workshop at your office performed by Mirego? %@ \n\n", self.response6.text];
    [body appendFormat:@"7. Do you need more information or a follow-up call from BlueStar? %@ \n\n", self.response7.text];

    [composer setMessageBody:body isHTML:NO];
    
    [self presentViewController:composer
                       animated:YES
                     completion:^{
        
    }];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) keyboardDidShow:(NSNotification *)nsNotification {
    
    // take good note of the old frame.
    _oldFrame = self.scrollview.frame;
    
    // get the keyboard size.
    NSDictionary * userInfo = [nsNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat kHeight = kbSize.height;
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        kHeight = kbSize.width;
    }
    
    // create a new frame and assign it.
    CGRect newFrame = self.scrollview.frame;
    newFrame.size.height -= kHeight;
    
    [self.scrollview setFrame:newFrame];
    NSLog(@"%@", self.scrollview);
}

- (void) keyboardWillHide:(NSNotification *)nsNotification {
    
    NSLog(@"Keyboard is closing.");
    
    [self.scrollview setFrame:_oldFrame];
    
}

@end
