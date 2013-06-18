//
//  ShareViewController.m
//  iOSFBTutorial2
//
//  Created by Matthew Liu on 6/17/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import "ShareViewController.h"

NSString *const kPlaceholderPostMessage = @"Say something about this...";

@interface ShareViewController () 

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;

@property (strong, nonatomic) NSMutableDictionary *postParams;

@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;


- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;

@end

@implementation ShareViewController

@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       @"https://developers.facebook.com/ios", @"link",
                       @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
                       @"Facebook SDK for iOS", @"name",
                       @"Build great social apps and get more installs.", @"caption",
                       @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
                       nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self resetPostMessage];
    
    [_postNameLabel setText:[_postParams objectForKey:@"name"]];
    [_postCaptionLabel setText:[_postParams objectForKey:@"caption"]];
    [_postCaptionLabel sizeToFit];
    [_postDescriptionLabel setText:[_postParams objectForKey:@"description"]];
    [_postDescriptionLabel sizeToFit];
    
    _imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[_postParams objectForKey:@"picture"]]];
    _imageConnection = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:self];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonAction:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonAction:(id)sender
{
    //Hide keyboard if showing when button clicked
    if ([_postMessageTextView isFirstResponder]) {
        [_postMessageTextView resignFirstResponder];
    }
    
    //Add user message parameter if user filled it in
    if (![[_postMessageTextView text] isEqualToString:kPlaceholderPostMessage] && ![[_postMessageTextView text] isEqualToString:@""]) {
        [_postParams setObject:[_postMessageTextView text] forKey:@"message"];
    }
    
    //Ask for publish_actions permissions in context
    if ([[[FBSession activeSession] permissions] indexOfObject:@"publish_actions"] == NSNotFound) {
        [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe completionHandler: ^(FBSession *session, NSError *error){
            if (!error) {
                //If permissions granted, publish the story
                [self publishStory];
            }
        }];
    } else {
        //If permissions already present, publish the story
        [self publishStory];
    }
}

- (void)resetPostMessage
{
    [_postMessageTextView setText:kPlaceholderPostMessage];
    [_postMessageTextView setTextColor:[UIColor lightGrayColor]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //Clear the message text when the user starts editing
    if ([[textView text] isEqualToString:kPlaceholderPostMessage]) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:@""]) {
        [self resetPostMessage];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([_postMessageTextView isFirstResponder] && _postMessageTextView != [touch view]) {
        [_postMessageTextView resignFirstResponder];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_postImageView setImage:[UIImage imageWithData:[NSData dataWithData:_imageData]]];
    _imageConnection = nil;
    _imageData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _imageConnection = nil;
    _imageData = nil;
}

- (void)publishStory
{
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:_postParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSString *alertText;
        if (error) {
            alertText = [NSString stringWithFormat:@"error: domain = %@, code = %d", [error domain], [error code]];
        } else {
            alertText = [NSString stringWithFormat:@"Posted action, id: %@", [result objectForKey:@"id"]];
        }
        
        
        //Show the result in an alert
        [[[UIAlertView alloc] initWithTitle:@"Result" message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         
    }];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
