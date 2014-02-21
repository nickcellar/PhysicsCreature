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
@property SKShapeNode *shoulder;
@property SKShapeNode *waist;
@property SKSpriteNode *leftHand;
@property SKSpriteNode *rightHand;
@property SKSpriteNode *leftFoot;
@property SKSpriteNode *rightFoot;
@property NSMutableArray *lines;
@end

@implementation HumanScene

- (SKPhysicsJointSpring *)createSprintJointWithNodeA:(SKNode *)nodeA nodeB:(SKNode *)nodeB
{
    SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:nodeA.physicsBody
                                                                 bodyB:nodeB.physicsBody
                                                               anchorA:nodeA.position
                                                               anchorB:nodeB.position];
    [self.physicsWorld addJoint:joint];
    return joint;
}


- (SKShapeNode *)createNodeWithPosition:(CGPoint)position
{
    SKShapeNode *circle = [[SKShapeNode alloc] init];
    [circle setPosition:position];
    [circle setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:1]];
    [circle.physicsBody setRestitution:.75];
    [self addChild:circle];
    return circle;
}

- (SKShapeNode *)createCircleWithRadius:(float)radius position:(CGPoint)position
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 0, 0, radius, 0, (float) M_PI * 2, YES);
    SKShapeNode *circle = [[SKShapeNode alloc] init];
    [circle setFillColor:[UIColor blueColor]];
    [circle setStrokeColor:[UIColor blackColor]];
    [circle setLineWidth:0];
    [circle setPath:path];
    [circle setPosition:position];
    [circle setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:radius]];
    [circle.physicsBody setRestitution:.75];
    [self addChild:circle];
    return circle;
}

- (SKSpriteNode *)createRectangleWithSize:(CGSize)size position:(CGPoint)position
{
    SKSpriteNode *rectangle = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:size];
    [rectangle setPosition:position];
    [rectangle setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:rectangle.size]];
    [rectangle.physicsBody setRestitution:.75];
    [self addChild:rectangle];
    return rectangle;
}

- (CGMutablePathRef)createPathBetweenNodeA:(SKNode *)nodeA nodeB:(SKNode *)nodeB
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, nodeA.position.x, nodeA.position.y);
    CGPathAddLineToPoint(path, NULL, nodeB.position.x, nodeB.position.y);
    return path;
}

- (void)spawnHuman
{
    _head = [self createCircleWithRadius:30 position:CGPointMake(self.size.width / 2, self.size.height / 4 * 3)];
    _waist = [self createNodeWithPosition:CGPointMake(self.size.width / 2, self.size.height / 2)];
    _shoulder = [self createNodeWithPosition:CGPointMake(self.size.width / 2, self.size.height / 16 * 11)];
    _leftHand = [self createRectangleWithSize:CGSizeMake(15, 15) position:CGPointMake(self.size.width / 10 * 2, self.size.height / 2)];
    _rightHand = [self createRectangleWithSize:CGSizeMake(15, 15) position:CGPointMake(self.size.width / 10 * 8, self.size.height / 2)];
    _leftFoot = [self createRectangleWithSize:CGSizeMake(15, 15) position:CGPointMake(self.size.width / 10 * 3, self.size.height / 4)];
    _rightFoot = [self createRectangleWithSize:CGSizeMake(15, 15) position:CGPointMake(self.size.width / 10 * 7, self.size.height / 4)];

    [self createSprintJointWithNodeA:_head nodeB:_leftHand];
    [self createSprintJointWithNodeA:_head nodeB:_rightHand];
    [self createSprintJointWithNodeA:_head nodeB:_leftFoot];
    [self createSprintJointWithNodeA:_head nodeB:_rightFoot];
    [self createSprintJointWithNodeA:_head nodeB:_waist];
    [self createSprintJointWithNodeA:_head nodeB:_shoulder];
    [self createSprintJointWithNodeA:_shoulder nodeB:_leftHand];
    [self createSprintJointWithNodeA:_shoulder nodeB:_rightHand];
    [self createSprintJointWithNodeA:_waist nodeB:_leftFoot];
    [self createSprintJointWithNodeA:_waist nodeB:_rightFoot];
    [self createSprintJointWithNodeA:_leftHand nodeB:_rightHand];
    [self createSprintJointWithNodeA:_leftFoot nodeB:_rightFoot];
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self.physicsBody setRestitution:1];
        [self spawnHuman];
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
    if (_lines == NULL) {
        _lines = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            SKShapeNode *line = [[SKShapeNode alloc] init];
            [_lines addObject:line];
            [self addChild:line];
        }
    }
    [_lines[0] setPath:[self createPathBetweenNodeA:_head nodeB:_shoulder]];
    [_lines[0] setPath:[self createPathBetweenNodeA:_shoulder nodeB:_waist]];
    [_lines[1] setPath:[self createPathBetweenNodeA:_shoulder nodeB:_leftHand]];
    [_lines[2] setPath:[self createPathBetweenNodeA:_shoulder nodeB:_rightHand]];
    [_lines[3] setPath:[self createPathBetweenNodeA:_waist nodeB:_leftFoot]];
    [_lines[4] setPath:[self createPathBetweenNodeA:_waist nodeB:_rightFoot]];
}

@end
