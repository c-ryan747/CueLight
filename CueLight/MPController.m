//
//  MPController.m
//  CueLight
//
//  Created by Callum Ryan on 11/08/2014.
//  Copyright (c) 2014 Callum Ryan. All rights reserved.
//

#import "MPController.h"

@implementation MPController
@synthesize controllerID;

#pragma mark - Own methods
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MPController *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MPController alloc] init];
    });
    return sharedInstance;
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

- (void)disconnect {
    [self.session disconnect];
    self.session = nil;
}
#pragma mark - Delegate methods
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"Peer changed state:%@", peerID);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.controllerID == peerID && state == MCSessionStateNotConnected) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(controllerConnected:)]) {
                [self.delegate controllerConnected:NO];
            }
            self.controllerID = nil;
        }
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(peerListChanged)]) {
            [self.delegate peerListChanged];
        }
    });
   
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    id receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([receivedObject isKindOfClass:[NSString class]]) {
        NSString *recievedString = receivedObject;
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
                    [self.delegate recievedMessage:data fromPeer:peerID];
                }
            });
        }
    } else if ([receivedObject isKindOfClass:[NSArray class]]) {
        NSArray *recievedArray = receivedObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(recieveNewCues:fromPeer:)]) {
                [self.delegate recieveNewCues:recievedArray fromPeer:peerID];
            }
        });
    }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    NSLog(@"Started to recieve file");
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    NSLog(@"Recieved file");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(recievedAudioAtURL:fromPeer:)]) {
            [self.delegate recievedAudioAtURL:localURL fromPeer:peerID];
        }
    });
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

- (void)sendObject:(id)obj ToPeers:(NSArray*)peers {
    if (peers.count > 0 && self.session) {
        [self.session sendData:[NSKeyedArchiver archivedDataWithRootObject:obj] toPeers:peers withMode:MCSessionSendDataReliable error:nil];
    }
}

- (void)sendFile:(NSURL *)url ToPeer:(MCPeerID *)peer {
    if (peer && self.session) {
        [self.session sendResourceAtURL:url withName:@"Audio" toPeer:peer withCompletionHandler:nil];
    }
}
@end
