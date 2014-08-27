//
//  XMLParser.h
//  XMLDemo
//
//  Created by Kiran Patel on 7/4/13.
//  Copyright (c) 2013 Kiran Patel. All rights reserved.
//



//Call Methods
/*
 
 NSString *strURL = @"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wpa/MRSS/newreleases/limit=50/rss.xml";
 NSArray *arrayTag  =[NSArray arrayWithObjects:@"title",@"link",@"description",@"pubDate", nil];
 
 
 #pragma Mark - Call With ProsessBar Syncronus
 
     aryXmlData = [[XMLParser alloc] parseWithURL:strURL RootTag:@"item" TagNames:arrayTag WithProgressBar:self.view];
     
 
 #pragma Mark - Call in Background
 
      [[XMLParser alloc] parseWithURL:strURL RootTag:@"item" TagNames:arrayTag completionHandler:^(NSArray *aryResultList) {
     
            aryXmlData = aryResultList;
     
      }];


#pragma Mark - Call in Background with Processbar
 
     [[XMLParser alloc] parseWithURL:strURL RootTag:@"item" TagNames:arrayTag  WithProgressBar:self.view completionHandler:^(NSArray *aryResultList) {
     
        aryXmlData = aryResultList;
     
     }];
 */


#import <Foundation/Foundation.h>
//#import "MBProgressHUD.h"

@interface XMLParser : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *myXMLParser;
    NSMutableDictionary *tempDIC;
    NSString *strTMP;
    NSMutableArray *aryMainArray;    
    NSArray *tagNameYouWantArray;
    
    NSString *strRootTag;
    
   // MBProgressHUD *HUD;
    NSString *strProcessLable;
    BOOL isProgressView;
}
//-(NSArray*)parseWithURL:(NSString*)strURL;

-(NSArray*)parseWithURL:(NSString*)strURL RootTag:(NSString*)rootTag TagNames:(NSArray*)aryTagNames;

-(NSArray*)parseWithURL:(NSString*)strURL RootTag:(NSString*)rootTag TagNames:(NSArray*)aryTagNames WithProgressBar:(UIView*)pView;

-(void)parseWithURL:(NSString*)strURL RootTag:(NSString*)rootTag TagNames:(NSArray*)aryTagNames completionHandler:(void (^)(NSArray*))callbackBlock;

-(void)parseWithURL:(NSString*)strURL RootTag:(NSString*)rootTag TagNames:(NSArray*)aryTagNames WithProgressBar:(UIView*)pView completionHandler:(void (^)(NSArray*))callbackBlock;
@end
