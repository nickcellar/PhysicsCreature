//
//  HumanScene.m
//  PhysicsCreature
//
//  Created by Nicholas Wong on 2/19/14.
//  Copyright (c) 2014 Nicholas Workshop. All rights reserved.
//

#import "HumanScene.h"

@interface HumanScene ()
@property SKShapeNode *head;
@property SKSpriteNode *leftHand;
@property SKSpriteNode *rightHand;
@property SKSpriteNode *leftFoot;
@property SKSpriteNode *rightFoot;
@property SKSpriteNode *myShelf;
@property SKPhysicsJointSpring *leftArmJoint;
@property SKPhysicsJointSpring *rightArmJoint;
@property SKPhysicsJointSpring *leftLegJoint;
@property SKPhysicsJointSpring *rightLegJoint;
@property SKPhysicsJointSpring *handSpringJoint;
@property SKPhysicsJointSpring *leftSupportSpringJoint;
@property SKPhysicsJointSpring *rightSupportSpringJoint;
@property SKPhysicsJointSpring *legSpringJoint;
@property SKShapeNode *leftArm;
@property SKShapeNode *rightArm;
@property SKShapeNode *leftLeg;
@property SKShapeNode *rightLeg;
@end

@implementation HumanScene

- (void)activateJointRope
{
    _leftArmJoint = [SKPhysicsJointSpring jointWithBodyA:_head.physicsBody
                                                   bodyB:_leftHand.physicsBody
                                                 anchorA:_head.position
                                                 anchorB:_leftHand.position];

    _rightArmJoint = [SKPhysicsJointSpring jointWithBodyA:_head.physicsBody
                                                    bodyB:_rightHand.physicsBody
                                                  anchorA:_head.position
                                                  anchorB:_rightHand.position];

    _leftLegJoint = [SKPhysicsJointSpring jointWithBodyA:_head.physicsBody
                                                   bodyB:_leftFoot.physicsBody
                                                 anchorA:_head.position
                                                 anchorB:_leftFoot.position];

    _rightLegJoint = [SKPhysicsJointSpring jointWithBodyA:_head.physicsBody
                                                    bodyB:_rightFoot.physicsBody
                                                  anchorA:_head.position
                                                  anchorB:_rightFoot.position];

    _handSpringJoint = [SKPhysicsJointSpring jointWithBodyA:_leftHand.physicsBody
                                                      bodyB:_rightHand.physicsBody
                                                    anchorA:_leftHand.position
                                                    anchorB:_rightHand.position];

    _leftSupportSpringJoint = [SKPhysicsJointSpring jointWithBodyA:_leftHand.physicsBody
                                                             bodyB:_leftFoot.physicsBody
                                                           anchorA:_leftHand.position
                                                           anchorB:_leftFoot.position];

    _rightSupportSpringJoint = [SKPhysicsJointSpring jointWithBodyA:_rightHand.physicsBody
                                                              bodyB:_rightFoot.physicsBody
                                                            anchorA:_rightHand.position
                                                            anchorB:_rightFoot.position];

    _legSpringJoint = [SKPhysicsJointSpring jointWithBodyA:_leftFoot.physicsBody
                                                     bodyB:_rightFoot.physicsBody
                                                   anchorA:_leftFoot.position
                                                   anchorB:_rightFoot.position];

    [_leftSupportSpringJoint setFrequency:.5];
    [_rightSupportSpringJoint setFrequency:.5];
    [_leftSupportSpringJoint setDamping:.5];
    [_rightSupportSpringJoint setDamping:.5];

    [self.physicsWorld addJoint:_leftArmJoint];
    [self.physicsWorld addJoint:_rightArmJoint];
    [self.physicsWorld addJoint:_leftLegJoint];
    [self.physicsWorld addJoint:_rightLegJoint];
    [self.physicsWorld addJoint:_handSpringJoint];
    [self.physicsWorld addJoint:_leftSupportSpringJoint];
    [self.physicsWorld addJoint:_rightSupportSpringJoint];
    [self.physicsWorld addJoint:_legSpringJoint];
}

- (void)spawnSquares
{
    // init all nodes
    _head = [[SKShapeNode alloc] init];
    _leftArm = [[SKShapeNode alloc] init];
    _rightArm = [[SKShapeNode alloc] init];
    _leftLeg = [[SKShapeNode alloc] init];
    _rightLeg = [[SKShapeNode alloc] init];
    _leftHand = [[SKSpriteNode alloc] initWithColor:[SKColor purpleColor] size:CGSizeMake(30, 30)];
    _rightHand = [[SKSpriteNode alloc] initWithColor:[SKColor orangeColor] size:CGSizeMake(30, 30)];
    _leftFoot = [[SKSpriteNode alloc] initWithColor:[SKColor purpleColor] size:CGSizeMake(50, 25)];
    _rightFoot = [[SKSpriteNode alloc] initWithColor:[SKColor orangeColor] size:CGSizeMake(50, 25)];

    [_leftArm setStrokeColor:[UIColor redColor]];
    [_rightArm setStrokeColor:[UIColor redColor]];
    [_leftLeg setStrokeColor:[UIColor redColor]];
    [_rightLeg setStrokeColor:[UIColor redColor]];

    // update head shape
    CGMutablePathRef headShape = CGPathCreateMutable();
    CGPathAddArc(headShape, NULL, 0, 0, 50, 0, M_PI* 2, YES);
    [_head setPath:headShape];
    [_head setFillColor:[UIColor blueColor]];
    [_head setStrokeColor:[UIColor blackColor]];

    // set node positions
    [_head setPosition:CGPointMake(self.size.width / 2, self.size.height / 4 * 3)];
    [_leftHand setPosition:CGPointMake(self.size.width / 5, self.size.height / 2)];
    [_rightHand setPosition:CGPointMake(self.size.width / 5 * 4, self.size.height / 2)];
    [_leftFoot setPosition:CGPointMake(self.size.width / 10 * 3, self.size.height / 4)];
    [_rightFoot setPosition:CGPointMake(self.size.width / 10 * 7, self.size.height / 4)];

    // create physics body
    _head.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
    _leftHand.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_leftHand.size];
    _rightHand.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_rightHand.size];
    _leftFoot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_leftFoot.size];
    _rightFoot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_rightFoot.size];

    // set physics restitutions
    [_head.physicsBody setRestitution:.75];
    [_leftHand.physicsBody setRestitution:.75];
    [_rightHand.physicsBody setRestitution:.75];

    // add to scene
    [self addChild:_head];
    [self addChild:_leftHand];
    [self addChild:_rightHand];
    [self addChild:_leftFoot];
    [self addChild:_rightFoot];
    [self addChild:_leftArm];
    [self addChild:_rightArm];
    [self addChild:_leftLeg];
    [self addChild:_rightLeg];
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
    CGMutablePathRef leftArmPath = CGPathCreateMutable();
    CGPathMoveToPoint(leftArmPath, NULL, _head.position.x, _head.position.y);
    CGPathAddLineToPoint(leftArmPath, NULL, _leftHand.position.x, _leftHand.position.y);
    _leftArm.path = leftArmPath;

    /* Called before each frame is rendered */
    CGMutablePathRef rightArmPath = CGPathCreateMutable();
    CGPathMoveToPoint(rightArmPath, NULL, _head.position.x, _head.position.y);
    CGPathAddLineToPoint(rightArmPath, NULL, _rightHand.position.x, _rightHand.position.y);
    _rightArm.path = rightArmPath;

    /* Called before each frame is rendered */
    CGMutablePathRef leftLegPath = CGPathCreateMutable();
    CGPathMoveToPoint(leftLegPath, NULL, _head.position.x, _head.position.y);
    CGPathAddLineToPoint(leftLegPath, NULL, _leftFoot.position.x, _leftFoot.position.y);
    _leftLeg.path = leftLegPath;

    /* Called before each frame is rendered */
    CGMutablePathRef rightLegPath = CGPathCreateMutable();
    CGPathMoveToPoint(rightLegPath, NULL, _head.position.x, _head.position.y);
    CGPathAddLineToPoint(rightLegPath, NULL, _rightFoot.position.x, _rightFoot.position.y);
    _rightLeg.path = rightLegPath;
}

@end
