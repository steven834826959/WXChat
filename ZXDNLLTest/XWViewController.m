//
//  XWViewController.m
//  StoryboardTest
//
//  Created by mxsm on 16/4/13.
//  Copyright © 2016年 mxsm. All rights reserved.
//  http://www.cocoachina.com/ios/20141219/10703.html  XMPP类的介绍
//  http://www.cocoachina.com/ios/20140922/9714.html   XMPP协议介绍
//  http://www.jianshu.com/p/a54d367adb2a    XML 数据解析
#import "XWViewController.h"
#import "YXViewController.h"
#import "XMPPStream.h"
#import "XMPPJID.h"
#import "XMPPPresence.h"
#import "XMPPMessage.h"

@interface XWViewController () <XMPPStreamDelegate>
@property(nonatomic,strong) XMPPStream * stream;

@end

@implementation XWViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.stream setMyJID:[XMPPJID jidWithString:@"zxiaoxu@127.0.0.1"]];
    [self.stream setHostName:@"127.0.0.1"];
    [self.stream setHostPort:5222];
    NSError * error=nil;
    [self.stream connectWithTimeout:1.0f error:&error];
    if (error) {
        
        NSLog(@"error======%@",error);
    }
    
}

-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    
    NSError * error = nil;
    [self.stream authenticateWithPassword:@"admin"error:&error];
    if (error) {
       
        NSLog(@"error======%@",error);

    }
}

// 上线
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
   
    XMPPPresence * presence = [XMPPPresence presence];
    [self.stream sendElement:presence];
    
}

-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    /**
     *   涉及到 XML 数据的解析
     */
    NSString * string = [[[message elementsForName:@"body"] firstObject] stringValue];
    NSLog(@"String = %@",string);

    
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    
    NSLog(@"%@",error);
    
}


-(XMPPStream * )stream
{
    
    if (!_stream) {
        
        _stream = [[ XMPPStream  alloc]init];
        [_stream  addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
     }
    return _stream;
}






// UIStoryboard 界面之间的传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if ([segue.identifier isEqualToString:@"ZXpush"]) {
        
        YXViewController  * controller = segue.destinationViewController;
        controller.YXString=@"张旭是天才";
        
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
