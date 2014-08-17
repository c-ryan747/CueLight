//
//  MPController.h
//  CueLight
//
//  Created by Callum Ryan on 11/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol MPControllerDelegate <NSObject>
@optional
- (void)recievedMessage:(NSData *)data fromPeer:(MCPeerID *)peer;
- (void)peerListChanged;
@end


@interface MPController : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCPeerID *controllerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, weak  ) id <MPControllerDelegate> delegate;

- (void)createPeerWithDisplayName:(NSString *)displayName;
- (void)createSession;
- (void)createBrowser;
- (void)advertiseSelf:(BOOL)advertise;
- (void)setupIfNeededWithName:(NSString *)name;

- (void)sendString:(NSString *)string ToPeers:(NSArray*)peers;
- (void)sendDictionary:(NSDictionary *)dict ToPeers:(NSArray*)peers;

+(instancetype)sharedInstance;

@end
