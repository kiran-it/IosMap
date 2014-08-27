//
//  XMLParser.m
//  XMLDemo
//
//  Created by Kiran Patel on 7/4/13.
//  Copyright (c) 2013 Kiran Patel. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

/*
-(void)showProgressBar:(UIView*)view
{
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setLable:strProcessLable];
    [HUD show:TRUE];
}

-(void)hideWithGradient
{
    [HUD hide:TRUE];
    [HUD removeFromSuperview];
}
 */

#pragma mark - Parse XML with Processbar (syncronous)
-(NSArray*)parseWithURL:(NSString*)strURL RootTag:(NSString*)rootTag TagNames:(NSArray*)aryTagNames WithProgressBar:(UIView*)pView{
    
    
    isProgressView = YES;
    tagNameYouWantArray = aryTagNames;
    strRootTag = rootTag;
    
    return [self parseWithURL:strURL];
}


#pragma mark - Parse XML without Processbar (syncronous)
-(NSArray*)parseWithURL:(NSString*)strURL RootTag:(NSString*)rootTag TagNames:(NSArray*)aryTagNames{
    
    isProgressView = NO;
    tagNameYouWantArray = aryTagNames;
    strRootTag = rootTag;   

    return [self parseWithURL:strURL];
}


#pragma parse xml data with url (Syncronus)
-(NSArray*)parseWithURL:(NSString*)strURL
{      
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    /*if(isProgressView)
        [self hideWithGradient];
     */
    
    myXMLParser = [[NSXMLParser alloc]initWithData:responseData];
    [myXMLParser setDelegate:self];
    [myXMLParser setShouldResolveExternalEntities:YES];
    aryMainArray = [[NSMutableArray alloc]init];
    [myXMLParser parse];
    
    return aryMainArray;
}


#pragma Mark - Handle In BackGround
-(void)parseWithURL:(NSString*)strURL RootTag:(NSString*)rootTag TagNames:(NSArray*)aryTagNames completionHandler:(void (^)(NSArray*))callbackBlock
{
    
    tagNameYouWantArray = aryTagNames;
    strRootTag = rootTag;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                             
                                         timeoutInterval:60.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *err) {
        
        myXMLParser = [[NSXMLParser alloc]initWithData:responseData];
        [myXMLParser setDelegate:self];
        [myXMLParser setShouldResolveExternalEntities:YES];
        aryMainArray = [[NSMutableArray alloc]init];
        [myXMLParser parse];
        
        callbackBlock(aryMainArray);
        
    }];    
    
}


#pragma Mark - Handle In BackGround With ProcessBar
-(void)parseWithURL:(NSString*)strURL RootTag:(NSString*)rootTag TagNames:(NSArray*)aryTagNames WithProgressBar:(UIView*)pView completionHandler:(void (^)(NSArray*))callbackBlock
{
    isProgressView = YES;
    //[self performSelectorInBackground:@selector(showProgressBar:) withObject:pView];
    
    [self parseWithURL:strURL RootTag:rootTag TagNames:aryTagNames completionHandler:^(NSArray *aryResult) {
              
       // [self hideWithGradient];
        callbackBlock(aryResult);
    }];
}


#pragma Mark - XML Delgate Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"item"]){
        tempDIC = [[NSMutableDictionary alloc] init];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    strTMP = [[NSString alloc]initWithString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    //if([tagNameYouWant objectForKey:elementName]) {
    if([tagNameYouWantArray containsObject:elementName]) {
        
        [tempDIC setValue:strTMP forKey:elementName];
        
    } else if([elementName isEqualToString:@"item"]){
        
        [aryMainArray addObject:tempDIC];
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    // NSLog(@"%@",aryMainArray);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Handle errors as appropriate for your application.
}


@end
