//
//  MPController.h
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//
//  Description : Singleton to handle network communication
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "AudioController.h"

//  Protocol for other objects getting data from this class
@protocol MPControllerDelegate <NSObject>

@optional
- (void)recievedMessage:(NSString *)data fromPeer:(MCPeerID *)peer;
- (void)peerListChanged;
- (void)recieveNewCues:(NSArray *)cues fromPeer:(MCPeerID *)peer;
- (void)recievedAudioAtURL:(NSURL *)url fromPeer:(MCPeerID *)peer;
- (void)controllerConnected:(BOOL)connected;

@end


@interface MPController : NSObject <MCSessionDelegate>

//  Networking components
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCPeerID *controllerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

//  Delegate reference
@property (nonatomic, weak  ) id <MPControllerDelegate> delegate;

//  Singleton access
+ (instancetype)sharedInstance;

//  Controlling methods
- (void)setupWithName:(NSString *)name;
- (void)createBrowser;
- (void)advertiseSelf:(BOOL)advertise;
- (void)disconnect;

//  Sending methods
- (void)sendObject:(id)obj ToPeers:(NSArray*)peers;
- (void)sendFile:(NSURL *)obj ToPeer:(MCPeerID *)peer;

@end
