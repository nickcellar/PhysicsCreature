//
//  MyScene.m
//  PhysicsCreature
//
//  Created by Nicholas Wong on 2/19/14.
//  Copyright (c) 2014 Nicholas Workshop. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()
@property SKSpriteNode *head;
@property SKSpriteNode *leftHand;
@property SKSpriteNode *rightHand;
@property SKSpriteNode *waist;
@property SKSpriteNode *leftFoot;
@property SKSpriteNode *rightFoot;
@property SKSpriteNode *myShelf;
@property SKPhysicsJoint *leftArmJoint;
@property SKPhysicsJoint *rightArmJoint;
@property SKPhysicsJoint *leftLegJoint;
@property SKPhysicsJoint *rightLegJoint;
@property SKPhysicsJoint *backBoneJoint;
@property SKPhysicsJointSpring *handSpringJoint;
@property SKPhysicsJointSpring *leftSupportSpringJoint;
@property SKPhysicsJointSpring *rightSupportSpringJoint;
@end

@implementation MyScene

- (void)activateJointRope
{
    _leftArmJoint = [SKPhysicsJointLimit jointWithBodyA:_head.physicsBody
                                                  bodyB:_leftHand.physicsBody
                                                anchorA:_head.position
                                                anchorB:_leftHand.position];

    _rightArmJoint = [SKPhysicsJointLimit jointWithBodyA:_head.physicsBody
                                                   bodyB:_rightHand.physicsBody
                                                 anchorA:_head.position
                                                 anchorB:_rightHand.position];

    _backBoneJoint = [SKPhysicsJointLimit jointWithBodyA:_head.physicsBody
                                                   bodyB:_waist.physicsBody
                                                 anchorA:_head.position
                                                 anchorB:_waist.position];

    _leftLegJoint = [SKPhysicsJointLimit jointWithBodyA:_waist.physicsBody
                                                  bodyB:_leftFoot.physicsBody
                                                anchorA:_waist.position
                                                anchorB:_leftFoot.position];

    _rightLegJoint = [SKPhysicsJointLimit jointWithBodyA:_waist.physicsBody
                                                   bodyB:_rightFoot.physicsBody
                                                 anchorA:_waist.position
                                                 anchorB:_rightFoot.position];

    _handSpringJoint = [SKPhysicsJointSpring jointWithBodyA:_leftHand.physicsBody
                                                      bodyB:_rightHand.physicsBody
                                                    anchorA:_leftHand.position
                                                    anchorB:_rightHand.position];

    _leftSupportSpringJoint = [SKPhysicsJointSpring jointWithBodyA:_head.physicsBody
                                                             bodyB:_leftFoot.physicsBody
                                                           anchorA:_head.position
                                                           anchorB:_leftFoot.position];

    _rightSupportSpringJoint = [SKPhysicsJointSpring jointWithBodyA:_head.physicsBody
                                                              bodyB:_rightFoot.physicsBody
                                                            anchorA:_head.position
                                                            anchorB:_rightFoot.position];

    [self.physicsWorld addJoint:_leftArmJoint];
    [self.physicsWorld addJoint:_rightArmJoint];
    [self.physicsWorld addJoint:_backBoneJoint];
    [self.physicsWorld addJoint:_leftLegJoint];
    [self.physicsWorld addJoint:_rightLegJoint];
    [self.physicsWorld addJoint:_handSpringJoint];
    [self.physicsWorld addJoint:_leftSupportSpringJoint];
    [self.physicsWorld addJoint:_rightSupportSpringJoint];
}

- (void)spawnSquares
{
    _head = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(70, 70)];
    _leftHand = [[SKSpriteNode alloc] initWithColor:[SKColor purpleColor] size:CGSizeMake(70, 70)];
    _rightHand = [[SKSpriteNode alloc] initWithColor:[SKColor orangeColor] size:CGSizeMake(70, 70)];
    _waist = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(70, 70)];
    _leftFoot = [[SKSpriteNode alloc] initWithColor:[SKColor purpleColor] size:CGSizeMake(70, 70)];
    _rightFoot = [[SKSpriteNode alloc] initWithColor:[SKColor orangeColor] size:CGSizeMake(70, 70)];

    [_head setPosition:CGPointMake(self.size.width / 2, self.size.height / 4 * 3)];
    [_leftHand setPosition:CGPointMake(self.size.width / 4, self.size.height / 2)];
    [_rightHand setPosition:CGPointMake(self.size.width / 4 * 3, self.size.height / 2)];
    [_waist setPosition:CGPointMake(self.size.width / 2, self.size.height / 2)];
    [_leftFoot setPosition:CGPointMake(self.size.width / 4, self.size.height / 4)];
    [_rightFoot setPosition:CGPointMake(self.size.width / 4 * 3, self.size.height / 4)];

    _head.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_head.size];
    _leftHand.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_leftHand.size];
    _rightHand.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_rightHand.size];
    _waist.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_waist.size];
    _leftFoot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_leftFoot.size];
    _rightFoot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_rightFoot.size];

    [_head.physicsBody setRestitution:1.0];
    [_leftHand.physicsBody setRestitution:1.0];
    [_rightHand.physicsBody setRestitution:1.0];
    [_waist.physicsBody setRestitution:1.0];
    [_leftFoot.physicsBody setRestitution:1.0];
    [_rightFoot.physicsBody setRestitution:1.0];

    [_head.physicsBody setDynamic:NO];

    [self addChild:_head];
    [self addChild:_leftHand];
    [self addChild:_rightHand];
    [self addChild:_waist];
    [self addChild:_leftFoot];
    [self addChild:_rightFoot];
}

- (void)makeShelf
{
    _myShelf = [[SKSpriteNode alloc] initWithColor:[SKColor lightGrayColor] size:CGSizeMake(100, 40)];
    _myShelf.position = CGPointMake(self.size.width / 2.4, self.size.height / 2);
    _myShelf.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_myShelf.size];
    [_myShelf.physicsBody setDynamic:NO];
    [self addChild:_myShelf];
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self.physicsBody setRestitution:1];
        [self spawnSquares];
        [self activateJointRope];
//        [self makeShelf];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_head.physicsBody.dynamic) {
        [_head.physicsBody setDynamic:NO];
    }
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_head setPosition:location];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_head setPosition:location];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_head.physicsBody.dynamic) {
        [_head.physicsBody setDynamic:YES];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_head.physicsBody.dynamic) {
        [_head.physicsBody setDynamic:YES];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
