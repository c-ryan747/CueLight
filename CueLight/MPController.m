//
//  MPController.m
//  CueLight
//
//  Created by Callum Ryan on 27/10/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "MPController.h"

@interface MPController()

- (void)createPeerWithDisplayName:(NSString *)displayName;
- (void)createSession;

@end

@implementation MPController

@synthesize controllerID = _controllerID;

#pragma mark - Own methods
//  Create only one instance of this object
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MPController *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MPController alloc] init];
    });
    
    return sharedInstance;
}

//  Main init method, create name, peerID ans session if needed
- (void)setupIfNeededWithName:(NSString *)name {
    if ([name length] == 0) {
        name = [UIDevice currentDevice].name;
    }
    if (!self.peerID) {
        [self createPeerWithDisplayName:name];
    }
    if (!self.session) {
        [self createSession];
    }
    
}

- (void)createPeerWithDisplayName:(NSString *)displayName {
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
}

- (void)createSession {
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)createBrowser {
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"cuelight" session:self.session];
}

- (void)advertiseSelf:(BOOL)advertise {
    if (advertise) {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"cuelight" discoveryInfo:nil session:self.session];
        [self.advertiser start];
    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

//  End current network use and clean up
- (void)disconnect {
    [self.session disconnect];
    self.session = nil;
}

#pragma mark - Delegate methods
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    //  Object doesn't run in main thread so need to specify to run in the main thread before contacting delegate
    dispatch_async(dispatch_get_main_queue(), ^{
        //  if controller disconnects then tell delegate, and clean up
        if (self.controllerID == peerID && state == MCSessionStateNotConnected) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(controllerConnected:)]) {
                [self.delegate controllerConnected:NO];
            }
            self.controllerID = nil;
        }
        
        //  if delegate will respond to it, send peer list changed message
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(peerListChanged)]) {
            [self.delegate peerListChanged];
        }
    });
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    id receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //  if recieved a string, cast as string
    if ([receivedObject isKindOfClass:[NSString class]]) {
        NSString *recievedString = receivedObject;
        
        //  if notification of controller ID, update own data, then inform delegate, else give delegate message
        if ([recievedString isEqualToString:@"imTheController"]) {
            self.controllerID = peerID;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(controllerConnected:)]) {
                    [self.delegate controllerConnected:YES];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(recievedMessage:fromPeer:)]) {
                    [self.delegate recievedMessage:recievedString fromPeer:peerID];
                }
            });
        }
    //  else if its an array, cast as array
    } else if ([receivedObject isKindOfClass:[NSArray class]]) {
        NSArray *recievedArray = receivedObject;
        
        //  if delegate wants cues, give it the cues and sender peerID
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(recieveNewCues:fromPeer:)]) {
                [self.delegate recieveNewCues:recievedArray fromPeer:peerID];
            }
        });
    }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    //  Started recieving file, required delegate method
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    //  if delegate wants audio, give it to the delegate with sender info
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(recievedAudioAtURL:fromPeer:)]) {
            [self.delegate recievedAudioAtURL:localURL fromPeer:peerID];
        }
    });
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    //  Recieved stream, required delegate method
}

- (void)sendObject:(id)obj ToPeers:(NSArray*)peers {
    //  if inited and provided with a peer, send data
    if (peers.count > 0 && self.session) {
        [self.session sendData:[NSKeyedArchiver archivedDataWithRootObject:obj] toPeers:peers withMode:MCSessionSendDataReliable error:nil];
    }
}

- (void)sendFile:(NSURL *)url ToPeer:(MCPeerID *)peer {
    //  if inited and provided with a peer, send audio
    if (peer && self.session) {
        [self.session sendResourceAtURL:url withName:@"Audio" toPeer:peer withCompletionHandler:nil];
    }
}
@end
