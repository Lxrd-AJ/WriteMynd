//
//  SwipeableCardDelegate.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 16/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import UIKit
import pop

protocol SwipeableCardDelegate: class {
    func card(card: SwipeableCardView, wasDraggedWithFinishPercent percent: CGFloat, inDirection direction: SwipeDirection)
    func card(card: SwipeableCardView, wasSwipedInDirection direction: SwipeDirection)
    func card(cardWasReset card: SwipeableCardView)
    func card(cardWasTapped card: SwipeableCardView)
    func card(cardSwipeThresholdRatioMargin card: SwipeableCardView) -> CGFloat?
    var allowedDirections:[SwipeDirection] { get }
}

//Drag animation constants
private let rotationMax: CGFloat = 1.0
private let defaultRotationAngle = CGFloat(M_PI) / 10.0
private let scaleMin: CGFloat = 0.8
public let cardSwipeActionAnimationDuration: NSTimeInterval  = 0.4

//Reset animation constants
private let cardResetAnimationSpringBounciness: CGFloat = 10.0
private let cardResetAnimationSpringSpeed: CGFloat = 20.0
private let cardResetAnimationKey = "resetPositionAnimation"
private let cardResetAnimationDuration: NSTimeInterval = 0.2
private let screenSize = UIScreen.mainScreen().bounds.size

class SwipeableCardView: UIView {
    weak var delegate: SwipeableCardDelegate?
    private var overlayView: OverlayView?
    private(set) var contentView: UIView?
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var animationDirectionY: CGFloat = 1.0
    private var dragBegin = false
    private var dragDistance = CGPointZero
    private var swipePercentageMargin: CGFloat = 1.0
    
    //MARK: Lifecycle
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override var frame: CGRect {
        didSet {
            if let r = delegate?.card(cardSwipeThresholdRatioMargin: self) where r != 0 {
                swipePercentageMargin = r
            }else{ swipePercentageMargin = 1.0 }
        }
    }
    
    deinit {
        removeGestureRecognizer(panGestureRecognizer)
        removeGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setup() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panGestureRecognized:"))
        addGestureRecognizer(panGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapRecognized:"))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: Configurations
    func configure(view: UIView, overlayView: OverlayView?) {
        self.overlayView?.removeFromSuperview()
        self.contentView?.removeFromSuperview()
        
        if let overlay = overlayView {
            self.overlayView = overlay
            overlay.alpha = 0;
            self.addSubview(overlay)
            configureOverlayView()
            self.insertSubview(view, belowSubview: overlay)
        } else {
            self.addSubview(view)
        }
        
        self.contentView = view
        configureContentView()
    }
    
    private func configureOverlayView() {
        if let overlay = self.overlayView {
            overlay.translatesAutoresizingMaskIntoConstraints = false
            
            let width = NSLayoutConstraint(
                item: overlay,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1.0,
                constant: 0)
            let height = NSLayoutConstraint(
                item: overlay,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1.0,
                constant: 0)
            let top = NSLayoutConstraint (
                item: overlay,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0)
            let leading = NSLayoutConstraint (
                item: overlay,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1.0,
                constant: 0)
            addConstraints([width,height,top,leading])
        }
    }
    
    private func configureContentView() {
        if let contentView = self.contentView {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let width = NSLayoutConstraint(
                item: contentView,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1.0,
                constant: 0)
            let height = NSLayoutConstraint(
                item: contentView,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1.0,
                constant: 0)
            let top = NSLayoutConstraint (
                item: contentView,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0)
            let leading = NSLayoutConstraint (
                item: contentView,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1.0,
                constant: 0)
            
            addConstraints([width,height,top,leading])
        }
    }
    
    //MARK: GestureRecognizers
    func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        dragDistance = gestureRecognizer.translationInView(self)
        
        let touchLocation = gestureRecognizer.locationInView(self)
        
        switch gestureRecognizer.state {
        case .Began:
            
            let firstTouchPoint = gestureRecognizer.locationInView(self)
            let newAnchorPoint = CGPointMake(firstTouchPoint.x / bounds.width, firstTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
            removeAnimations()
            
            dragBegin = true
            
            animationDirectionY = touchLocation.y >= frame.size.height / 2 ? -1.0 : 1.0
            
            layer.shouldRasterize = true
            
            break
        case .Changed:
            let rotationStrength = min(dragDistance.x / CGRectGetWidth(frame), rotationMax)
            let rotationAngle = animationDirectionY * defaultRotationAngle * rotationStrength
            let scaleStrength = 1 - ((1 - scaleMin) * fabs(rotationStrength))
            let scale = max(scaleStrength, scaleMin)
            
            var transform = CATransform3DIdentity
            transform = CATransform3DScale(transform, scale, scale, 1)
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, dragDistance.x, dragDistance.y, 0)
            layer.transform = transform
            
            updateOverlayWithFinishPercent(dragPercentage, mode: dragDirection)
            //100% - for proportion
            delegate?.card(self, wasDraggedWithFinishPercent:min(fabs(100 * dragPercentage), 100), inDirection: dragDirection)
            
            break
        case .Ended:
            swipeMadeAction()
            
            layer.shouldRasterize = false
        default :
            break
        }
    }
    
    func tapRecognized(recogznier: UITapGestureRecognizer) {
        delegate?.card(cardWasTapped: self)
    }
    
    //MARK: Private
    private var directions:[SwipeDirection] {
        return delegate?.allowedDirections ?? [.Left]
    }
    
    private var dragDirection: SwipeDirection {
        let degree = swipeAngle(dragDistance.x, yDistance: dragDistance.y)
        switch Int(degree) {
        case 270..<285:
            return ._15Degrees
        case 285..<300:
            return ._30Degrees
        case 300..<315:
            return ._45Degrees
        case 315..<330:
            return ._60Degrees
        case 330..<345:
            return ._75Degrees
        case 345...360:
            return ._90Degrees
        case 0..<15:
            return ._105Degrees
        case 15..<30:
            return ._120Degrees
        case 30..<45:
            return ._135Degrees
        case 45..<60:
            return ._150Degrees
        case 60..<75:
            return ._165Degrees
        case 75...90:
            return ._165Degrees //TODO: Ask Lizzie
        default:
            return .Left
        }
    }
    
    private var dragPercentage:CGFloat {
        // normalize dragDistance then convert project closesest direction vector
        let normalizedDragPoint = dragDistance.normalizedPointForSize(bounds.size)
        let swipePoint = normalizedDragPoint.scalarProjectionPointWith(dragDirection.point)

        // rect to represent bounds of card in normalized coordinate system
        let rect = SwipeDirection.boundsRect

        // if point is outside rect, percentage of swipe in direction is over 100%
        if !rect.contains(swipePoint) {
            return 1.0
        } else {
            let centerDistance = swipePoint.distanceTo(.zero)
            let targetLine = (swipePoint, CGPoint.zero)
            // check 4 borders for intersection with line between touchpoint and center of card
            return rect.perimeterLines.reduce(CGFloat.infinity) { minPer, line in
                // return minimum distance of intersection point to swipePoint
                if let point = CGPoint.intersectionBetweenLines(targetLine, line2: line) {
                    return min(minPer, centerDistance / point.distanceTo(.zero))
                }
                return minPer
            }
            
        }
    }
    
    /*
     The coordinate system is like this, just like the CALayer Rotation system
         270
     180  +  0
         90
     - return: the degree of the x and y intersection
    */
    private func swipeAngle( xDistance:CGFloat, yDistance:CGFloat ) -> CGFloat {
        let _radians = atan2(yDistance, xDistance)
        let _degrees = _radians * CGFloat(180 / M_PI)
        let degrees = (_degrees > 0.0 ? _degrees : (360 + _degrees))
        return degrees
    }
    
    private func updateOverlayWithFinishPercent(percent: CGFloat, mode:SwipeDirection) {
        if let overlayView = self.overlayView {
            overlayView.overlayState = mode
            //Overlay is fully visible on half way
            let overlayStrength = max(min(percent/swipePercentageMargin, 1.0), 0)
            overlayView.alpha = overlayStrength
        }
    }
    
    private func swipeMadeAction() {
        if dragPercentage >= swipePercentageMargin && directions.contains(dragDirection) {
            swipeAction(dragDirection)
        } else {
            resetViewPositionAndTransformations()
        }
    }
    
    private func animationPointForDirection(direction:SwipeDirection) -> CGPoint {
        let point = direction.point
        let animatePoint = CGPoint(x: point.x * 4, y: point.y * 4) //should be 2
        let retPoint = animatePoint.screenPointForSize(screenSize)
        return retPoint
    }
    
    private func animationRotationForDirection(direction:SwipeDirection) -> CGFloat {
        return CGFloat(direction.bearing/2.0 - M_PI_4)
    }
    
    private func swipeAction(direction: SwipeDirection) {
        
        overlayView?.overlayState = direction
        overlayView?.alpha = 1.0
        delegate?.card(self, wasSwipedInDirection: direction)
        let translationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
        translationAnimation.duration = cardSwipeActionAnimationDuration
        translationAnimation.fromValue = NSValue(CGPoint:POPLayerGetTranslationXY(layer))
        translationAnimation.toValue = NSValue(CGPoint: animationPointForDirection(direction))
        translationAnimation.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
        layer.pop_addAnimation(translationAnimation, forKey: "swipeTranslationAnimation")
        
        
//        //TEST
//        UIView.animateWithDuration(0.1, animations: {
//            self.transform = CGAffineTransformMakeTranslation(self.dragDistance.x * 100, self.dragDistance.y * 100)
//            }, completion: { bool in
//                self.delegate?.card(self, wasSwipedInDirection: direction)
//        })
    }
    
    private func resetViewPositionAndTransformations() {
        delegate?.card(cardWasReset: self)
        
        removeAnimations()
        
        let resetPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
        resetPositionAnimation.fromValue = NSValue(CGPoint: CGPoint(x: dragDistance.x, y: dragDistance.y))
        resetPositionAnimation.toValue = NSValue(CGPoint: CGPointZero)
        resetPositionAnimation.springBounciness = cardResetAnimationSpringBounciness
        resetPositionAnimation.springSpeed = cardResetAnimationSpringSpeed
        resetPositionAnimation.completionBlock = {
            (_, _) in
            self.layer.transform = CATransform3DIdentity
            self.dragBegin = false
        }
        
        layer.pop_addAnimation(resetPositionAnimation, forKey: "resetPositionAnimation")
        
        let resetRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
        resetRotationAnimation.fromValue = POPLayerGetRotationZ(layer)
        resetRotationAnimation.toValue = CGFloat(0.0)
        resetRotationAnimation.duration = cardResetAnimationDuration
        
        layer.pop_addAnimation(resetRotationAnimation, forKey: "resetRotationAnimation")
        
        let overlayAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        overlayAlphaAnimation.toValue = 0.0
        overlayAlphaAnimation.duration = cardResetAnimationDuration
        overlayAlphaAnimation.completionBlock = { _, _ in
            self.overlayView?.alpha = 0
        }
        overlayView?.pop_addAnimation(overlayAlphaAnimation, forKey: "resetOverlayAnimation")
        
        let resetScaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        resetScaleAnimation.toValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
        resetScaleAnimation.duration = cardResetAnimationDuration
        layer.pop_addAnimation(resetScaleAnimation, forKey: "resetScaleAnimation")
    }
    
    //MARK: Public
    func removeAnimations() {
        pop_removeAllAnimations()
        layer.pop_removeAllAnimations()
    }
    
    func swipe(direction: SwipeDirection) {
        if !dragBegin {
            delegate?.card(self, wasSwipedInDirection: direction)
            
            let swipePositionAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
            swipePositionAnimation.fromValue = NSValue(CGPoint:POPLayerGetTranslationXY(layer))
            swipePositionAnimation.toValue = NSValue(CGPoint:animationPointForDirection(direction))
            swipePositionAnimation.duration = cardSwipeActionAnimationDuration
            swipePositionAnimation.completionBlock = {
                (_, _) in
                self.removeFromSuperview()
            }
            
            layer.pop_addAnimation(swipePositionAnimation, forKey: "swipePositionAnimation")
            
            let swipeRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
            swipeRotationAnimation.fromValue = POPLayerGetRotationZ(layer)
            swipeRotationAnimation.toValue = CGFloat(animationRotationForDirection(direction))
            swipeRotationAnimation.duration = cardSwipeActionAnimationDuration
            
            layer.pop_addAnimation(swipeRotationAnimation, forKey: "swipeRotationAnimation")
            
            overlayView?.overlayState = direction
            let overlayAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            overlayAlphaAnimation.toValue = 1.0
            overlayAlphaAnimation.duration = cardSwipeActionAnimationDuration
            overlayView?.pop_addAnimation(overlayAlphaAnimation, forKey: "swipeOverlayAnimation")
        }
    }
}