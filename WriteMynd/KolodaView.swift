//
//  SwipeDirection.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 16/03/2016.
//  Copyright © 2016 The Leaf. All rights reserved.
//

import Foundation
import pop

//Default values
private let defaultCountOfVisibleCards = 3
private let backgroundCardsTopMargin: CGFloat = 4.0
private let backgroundCardsScalePercent: CGFloat = 0.95
private let backgroundCardsLeftMargin: CGFloat = 8.0
private let backgroundCardFrameAnimationDuration: TimeInterval = 0.2

//Opacity values
private let defaultAlphaValueOpaque: CGFloat = 1.0
private let defaultAlphaValueTransparent: CGFloat = 0.0
private let defaultAlphaValueSemiTransparent: CGFloat = 0.7

//Animations constants
private let revertCardAnimationName = "revertCardAlphaAnimation"
private let revertCardAnimationDuration: TimeInterval = 1.0
private let revertCardAnimationToValue: CGFloat = 1.0
private let revertCardAnimationFromValue: CGFloat = 0.0

private let kolodaAppearScaleAnimationName = "kolodaAppearScaleAnimation"
private let kolodaAppearScaleAnimationFromValue = CGPoint(x: 0.1, y: 0.1)
private let kolodaAppearScaleAnimationToValue = CGPoint(x: 1.0, y: 1.0)
private let kolodaAppearScaleAnimationDuration: TimeInterval = 0.8
private let kolodaAppearAlphaAnimationName = "kolodaAppearAlphaAnimation"
private let kolodaAppearAlphaAnimationFromValue: CGFloat = 0.0
private let kolodaAppearAlphaAnimationToValue: CGFloat = 1.0
private let kolodaAppearAlphaAnimationDuration: TimeInterval = 0.8


protocol SwipeViewDataSource:class {
    func koloda(kolodaNumberOfCards koloda:SwipeView) -> UInt
    func koloda(_ koloda: SwipeView, viewForCardAtIndex index: UInt) -> UIView
    func koloda(_ koloda: SwipeView, viewForCardOverlayAtIndex index: UInt, onContentView view:UIView) -> OverlayView?
}
extension SwipeViewDataSource {
    func koloda(_ koloda: SwipeView, viewForCardOverlayAtIndex index: UInt, onContentView view:UIView) -> OverlayView? {
        return nil
    }
}


protocol SwipeViewDelegate:class {
    func koloda(_ koloda: SwipeView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeDirection)
    func koloda(kolodaDidRunOutOfCards koloda: SwipeView)
    func koloda(_ koloda: SwipeView, didSelectCardAtIndex index: UInt)
    func koloda(kolodaShouldApplyAppearAnimation koloda: SwipeView) -> Bool
    func koloda(kolodaShouldMoveBackgroundCard koloda: SwipeView) -> Bool
    func koloda(kolodaShouldTransparentizeNextCard koloda: SwipeView) -> Bool
    func koloda(kolodaBackgroundCardAnimation koloda: SwipeView) -> POPPropertyAnimation?
    func koloda(_ koloda: SwipeView, draggedCardWithFinishPercent finishPercent: CGFloat, inDirection direction: SwipeDirection)
    func koloda(kolodaDidResetCard koloda: SwipeView)
    func koloda(kolodaSwipeThresholdRatioMargin koloda: SwipeView) -> CGFloat?
    func koloda(_ koloda: SwipeView, didShowCardAtIndex index: UInt)
}
extension SwipeViewDelegate {
    func koloda(_ koloda: SwipeView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeDirection) {}
    func koloda(kolodaDidRunOutOfCards koloda: SwipeView) {}
    func koloda(_ koloda: SwipeView, didSelectCardAtIndex index: UInt) {}
    func koloda(kolodaShouldApplyAppearAnimation koloda: SwipeView) -> Bool {return true}
    func koloda(kolodaShouldMoveBackgroundCard koloda: SwipeView) -> Bool {return true}
    func koloda(kolodaShouldTransparentizeNextCard koloda: SwipeView) -> Bool {return false}
    func koloda(kolodaBackgroundCardAnimation koloda: SwipeView) -> POPPropertyAnimation? {return nil}
    func koloda(_ koloda: SwipeView, draggedCardWithFinishPercent finishPercent: CGFloat, inDirection direction: SwipeDirection) {}
    func koloda(kolodaDidResetCard koloda: SwipeView) {}
    func koloda(kolodaSwipeThresholdRatioMargin koloda: SwipeView) -> CGFloat? {return nil}
    func koloda(_ koloda: SwipeView, didShowCardAtIndex index: UInt) {}
}


class SwipeView: UIView, SwipeableCardDelegate {
    weak var dataSource: SwipeViewDataSource? {
        didSet {
            setupDeck()
        }
    }
    weak var delegate: SwipeViewDelegate?
    var allowedDirections:[SwipeDirection] = [.left, ._15Degrees, ._30Degrees, ._45Degrees, ._60Degrees, ._75Degrees, ._90Degrees, ._105Degrees, ._120Degrees, ._135Degrees, ._150Degrees,
        ._165Degrees ]
    fileprivate(set) var currentCardNumber = 0
    fileprivate(set) var countOfCards = 0
    
    var countOfVisibleCards = defaultCountOfVisibleCards
    fileprivate var visibleCards = [SwipeableCardView]()
    fileprivate var animating = false
    
    var alphaValueOpaque: CGFloat = defaultAlphaValueOpaque
    var alphaValueTransparent: CGFloat = defaultAlphaValueTransparent
    var alphaValueSemiTransparent: CGFloat = defaultAlphaValueSemiTransparent
    
    fileprivate var shouldTransparentize: Bool {
        if let delegate = delegate {
            return delegate.koloda(kolodaShouldTransparentizeNextCard: self)
        }
        return true
    }
    
    //MARK: Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    deinit {
        unsubsribeFromNotifications()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !animating {
            
            if self.visibleCards.isEmpty {
                reloadData()
            } else {
                layoutDeck()
            }
        }
    }
    
    //MARK: Configurations
    
    fileprivate func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SwipeView.layoutDeck), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    fileprivate func unsubsribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func configure() {
        subscribeForNotifications()
    }
    
    fileprivate func setupDeck() {
        if let dataSource = dataSource {
            countOfCards = Int(dataSource.koloda(kolodaNumberOfCards: self))
            
            if countOfCards - currentCardNumber > 0 {
                
                let countOfNeededCards = min(countOfVisibleCards, countOfCards - currentCardNumber)
                
                for index in 0..<countOfNeededCards {
                    let nextCardContentView = dataSource.koloda(self, viewForCardAtIndex: UInt(index+currentCardNumber))
                    let nextCardView = SwipeableCardView(frame: frameForTopCard())
                    
                    nextCardView.delegate = self
                    if shouldTransparentize {
                        nextCardView.alpha = index == 0 ? alphaValueOpaque : alphaValueSemiTransparent
                    }
                    nextCardView.isUserInteractionEnabled = index == 0
                    
                    let overlayView = dataSource.koloda(self, viewForCardOverlayAtIndex: UInt(index+currentCardNumber), onContentView: nextCardContentView)
                    
                    nextCardView.configure(nextCardContentView, overlayView: overlayView)
                    visibleCards.append(nextCardView)
                    index == 0 ? addSubview(nextCardView) : insertSubview(nextCardView, belowSubview: visibleCards[index - 1])
                }
                self.delegate?.koloda(self, didShowCardAtIndex: UInt(currentCardNumber))
            }
        }
    }
    
    func layoutDeck() {
        if !visibleCards.isEmpty {
            for (index, card) in visibleCards.enumerated() {
                if index == 0 {
                    card.frame = frameForTopCard()
                    card.layer.transform = CATransform3DIdentity
                } else {
                    let cardParameters = backgroundCardParametersForFrame(frameForCardAtIndex(UInt(index)))
                    
                    let scale = cardParameters.scale
                    card.layer.transform = CATransform3DScale(CATransform3DIdentity, scale.width, scale.height, 1.0)
                    
                    card.frame = cardParameters.frame
                }
                
            }
        }
    }
    
    //MARK: Frames
    func frameForCardAtIndex(_ index: UInt) -> CGRect {
        let bottomOffset:CGFloat = 0
        let topOffset = backgroundCardsTopMargin * CGFloat(self.countOfVisibleCards - 1)
        let scalePercent = backgroundCardsScalePercent
        let width = self.frame.width * pow(scalePercent, CGFloat(index))
        let xOffset = (self.frame.width - width) / 2
        let height = (self.frame.height - bottomOffset - topOffset) * pow(scalePercent, CGFloat(index))
        let multiplier: CGFloat = index > 0 ? 1.0 : 0.0
        let previousCardFrame = index > 0 ? frameForCardAtIndex(max(index - 1, 0)) : CGRect.zero
        let yOffset = (previousCardFrame.height - height + previousCardFrame.origin.y + backgroundCardsTopMargin) * multiplier
        let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        
        return frame
    }
    
    fileprivate func frameForTopCard() -> CGRect {
        return frameForCardAtIndex(0)
    }
    
    fileprivate func backgroundCardParametersForFrame(_ initialFrame: CGRect) -> (frame: CGRect, scale: CGSize) {
        var finalFrame = frameForTopCard()
        finalFrame.origin = initialFrame.origin
        
        var scale = CGSize.zero
        scale.width = initialFrame.width / finalFrame.width
        scale.height = initialFrame.height / finalFrame.height
        
        return (finalFrame, scale)
    }
    
    fileprivate func moveOtherCardsWithFinishPercent(_ percent: CGFloat) {
        if visibleCards.count > 1 {
            
            for index in 1..<visibleCards.count {
                let previousCardFrame = frameForCardAtIndex(UInt(index - 1))
                var frame = frameForCardAtIndex(UInt(index))
                let percentage = percent / 100
                
                let distanceToMoveY: CGFloat = (frame.origin.y - previousCardFrame.origin.y) * percentage
                
                frame.origin.y -= distanceToMoveY
                
                let distanceToMoveX: CGFloat = (previousCardFrame.origin.x - frame.origin.x) * percentage
                
                frame.origin.x += distanceToMoveX
                
                let widthDelta = (previousCardFrame.size.width - frame.size.width) * percentage
                let heightDelta = (previousCardFrame.size.height - frame.size.height) * percentage
                
                frame.size.width += widthDelta
                frame.size.height += heightDelta
                
                let cardParameters = backgroundCardParametersForFrame(frame)
                let scale = cardParameters.scale
                
                let card = visibleCards[index]
                
                card.layer.transform = CATransform3DScale(CATransform3DIdentity, scale.width, scale.height, 1.0)
                card.frame = cardParameters.frame
                
                //For fully visible next card, when moving top card
                if shouldTransparentize {
                    if index == 1 {
                        card.alpha = alphaValueSemiTransparent + (alphaValueOpaque - alphaValueSemiTransparent) * percentage
                    }
                }
            }
        }
    }
    
    //MARK: Animations
    func applyAppearAnimation() {
        isUserInteractionEnabled = false
        animating = true
        
        let kolodaAppearScaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        
        kolodaAppearScaleAnimation.beginTime = CACurrentMediaTime() + cardSwipeActionAnimationDuration
        kolodaAppearScaleAnimation?.duration = kolodaAppearScaleAnimationDuration
        kolodaAppearScaleAnimation?.fromValue = NSValue(cgPoint: kolodaAppearScaleAnimationFromValue)
        kolodaAppearScaleAnimation?.toValue = NSValue(cgPoint: kolodaAppearScaleAnimationToValue)
        kolodaAppearScaleAnimation?.completionBlock = {
            (_, _) in
            
            self.isUserInteractionEnabled = true
            self.animating = false
        }
        
        let kolodaAppearAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        kolodaAppearAlphaAnimation.beginTime = CACurrentMediaTime() + cardSwipeActionAnimationDuration
        kolodaAppearAlphaAnimation?.fromValue = NSNumber(value: Float(kolodaAppearAlphaAnimationFromValue) as Float)
        kolodaAppearAlphaAnimation?.toValue = NSNumber(value: Float(kolodaAppearAlphaAnimationToValue) as Float)
        kolodaAppearAlphaAnimation?.duration = kolodaAppearAlphaAnimationDuration
        
        pop_add(kolodaAppearAlphaAnimation, forKey: kolodaAppearAlphaAnimationName)
        layer.pop_add(kolodaAppearScaleAnimation, forKey: kolodaAppearScaleAnimationName)
    }
    
    func applyRevertAnimation(_ card: SwipeableCardView, complete: (() -> Void)? = nil) {
        animating = true
        
        let firstCardAppearAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        firstCardAppearAnimation?.toValue = NSNumber(value: Float(revertCardAnimationToValue) as Float)
        firstCardAppearAnimation?.fromValue =  NSNumber(value: Float(revertCardAnimationFromValue) as Float)
        firstCardAppearAnimation?.duration = revertCardAnimationDuration
        firstCardAppearAnimation?.completionBlock = {
            (_, _) in
            
            self.animating = false
            complete?()
        }
        
        card.pop_add(firstCardAppearAnimation, forKey: revertCardAnimationName)
    }
    
    //MARK: DraggableCardDelegate
    
    func card(_ card: SwipeableCardView, wasDraggedWithFinishPercent percent: CGFloat, inDirection direction: SwipeDirection) {
        animating = true
        
        if let shouldMove = delegate?.koloda(kolodaShouldMoveBackgroundCard: self) , shouldMove == true {
            self.moveOtherCardsWithFinishPercent(percent)
        }
        delegate?.koloda(self, draggedCardWithFinishPercent: percent, inDirection: direction)
    }
    
    func card(_ card: SwipeableCardView, wasSwipedInDirection direction: SwipeDirection) {
        swipedAction(direction)
    }
    
    func card(cardWasReset card: SwipeableCardView) {
        if visibleCards.count > 1 {
            
            UIView.animate(withDuration: backgroundCardFrameAnimationDuration,
                delay: 0.0,
                options: .curveLinear,
                animations: {
                    self.moveOtherCardsWithFinishPercent(0)
                },
                completion: {
                    _ in
                    self.animating = false
                    
                    for index in 1..<self.visibleCards.count {
                        let card = self.visibleCards[index]
                        if self.shouldTransparentize {
                            card.alpha = index == 0 ? self.alphaValueOpaque : self.alphaValueSemiTransparent
                        }
                    }
            })
        } else {
            animating = false
        }
        
        delegate?.koloda(kolodaDidResetCard: self)
    }
    
    func card(cardWasTapped card: SwipeableCardView) {
        let index = currentCardNumber + (visibleCards.index(of: card) ?? 0)
        
        delegate?.koloda(self, didSelectCardAtIndex: UInt(index))
    }
    
    func card(cardSwipeThresholdRatioMargin card: SwipeableCardView) -> CGFloat? {
        return delegate?.koloda(kolodaSwipeThresholdRatioMargin: self)
    }
    
    //MARK: Private
    fileprivate func clear() {
        currentCardNumber = 0
        
        for card in visibleCards {
            card.removeFromSuperview()
        }
        
        visibleCards.removeAll(keepingCapacity: true)
        
    }
    
    //MARK: Actions
    fileprivate func swipedAction(_ direction: SwipeDirection) {
        animating = true
        visibleCards.removeFirst()
        
        currentCardNumber += 1
        let shownCardsCount = currentCardNumber + countOfVisibleCards
        if shownCardsCount - 1 < countOfCards {
            
            if let dataSource = dataSource {
                
                let lastCardContentView = dataSource.koloda(self, viewForCardAtIndex: UInt(shownCardsCount - 1))
                let lastCardOverlayView = dataSource.koloda(self, viewForCardOverlayAtIndex: UInt(shownCardsCount - 1), onContentView: lastCardContentView)
                
                let lastCardFrame = frameForCardAtIndex(UInt(visibleCards.count))
                let cardParameters = backgroundCardParametersForFrame(lastCardFrame)
                
                let lastCardView = SwipeableCardView(frame: cardParameters.frame)
                
                
                let scale = cardParameters.scale
                lastCardView.layer.transform = CATransform3DScale(CATransform3DIdentity, scale.width, scale.height, 1.0)
                
                lastCardView.isHidden = true
                lastCardView.isUserInteractionEnabled = true
                
                lastCardView.configure(lastCardContentView, overlayView: lastCardOverlayView)
                
                lastCardView.delegate = self
                
                if let lastCard = visibleCards.last {
                    insertSubview(lastCardView, belowSubview:lastCard)
                } else {
                    addSubview(lastCardView)
                }
                visibleCards.append(lastCardView)
            }
        }
        
        if !visibleCards.isEmpty {
            
            for (index, currentCard) in visibleCards.enumerated() {
                currentCard.removeAnimations()
                
                var frameAnimation: POPPropertyAnimation
                var scaleAnimation: POPPropertyAnimation
                if let delegateAnimation = delegate?.koloda(kolodaBackgroundCardAnimation: self) {
                    frameAnimation = delegateAnimation.copy() as! POPPropertyAnimation
                    scaleAnimation = delegateAnimation.copy() as! POPPropertyAnimation
                    
                    frameAnimation.property = POPAnimatableProperty.property(withName: kPOPViewFrame) as! POPAnimatableProperty
                    scaleAnimation.property = POPAnimatableProperty.property(withName: kPOPLayerScaleXY) as! POPAnimatableProperty
                } else {
                    frameAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
                    (frameAnimation as! POPBasicAnimation).duration = backgroundCardFrameAnimationDuration
                    scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
                    (scaleAnimation as! POPBasicAnimation).duration = backgroundCardFrameAnimationDuration
                }
                
                if index != 0 {
                    if shouldTransparentize {
                        currentCard.alpha = alphaValueSemiTransparent
                    }
                } else {
                    frameAnimation.completionBlock = {(animation, finished) in
                        self.visibleCards.last?.isHidden = false
                        self.animating = false
                        
                        self.delegate?.koloda(self, didSwipedCardAtIndex: UInt(self.currentCardNumber - 1), inDirection: direction)
                        self.delegate?.koloda(self, didShowCardAtIndex: UInt(self.currentCardNumber))
                        if self.shouldTransparentize {
                            currentCard.alpha = self.alphaValueOpaque
                        }
                    }
                    if shouldTransparentize {
                        currentCard.alpha = alphaValueOpaque
                    } else {
                        let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                        alphaAnimation?.toValue = alphaValueOpaque
                        alphaAnimation?.duration = backgroundCardFrameAnimationDuration
                        currentCard.pop_add(alphaAnimation, forKey: "alpha")
                    }
                }
                
                let cardParameters = backgroundCardParametersForFrame(frameForCardAtIndex(UInt(index)))
                
                currentCard.isUserInteractionEnabled = index == 0
                scaleAnimation.toValue = NSValue(cgSize: cardParameters.scale)
                currentCard.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
                
                frameAnimation.toValue = NSValue(cgRect: cardParameters.frame)
                currentCard.pop_add(frameAnimation, forKey: "frameAnimation")
            }
        } else {
            delegate?.koloda(self, didSwipedCardAtIndex: UInt(currentCardNumber - 1), inDirection: direction)
            animating = false
            delegate?.koloda(kolodaDidRunOutOfCards: self)
        }
        
    }
    
    func revertAction() {
        if currentCardNumber > 0 && animating == false {
            
            if countOfCards - currentCardNumber >= countOfVisibleCards {
                
                if let lastCard = visibleCards.last {
                    
                    lastCard.removeFromSuperview()
                    visibleCards.removeLast()
                }
            }
            
            currentCardNumber -= 1
            
            
            if let dataSource = self.dataSource {
                let firstCardContentView = dataSource.koloda(self, viewForCardAtIndex: UInt(currentCardNumber))
                let firstCardOverlayView = dataSource.koloda(self, viewForCardOverlayAtIndex: UInt(currentCardNumber), onContentView: firstCardContentView)
                let firstCardView = SwipeableCardView()
                
                if shouldTransparentize {
                    firstCardView.alpha = alphaValueTransparent
                }
                
                firstCardView.configure(firstCardContentView, overlayView: firstCardOverlayView)
                firstCardView.delegate = self
                
                addSubview(firstCardView)
                visibleCards.insert(firstCardView, at: 0)
                
                firstCardView.frame = frameForTopCard()
                
                applyRevertAnimation(firstCardView, complete: {
                    self.delegate?.koloda(self, didShowCardAtIndex: UInt(self.currentCardNumber))
                })
            }
            
            for index in 1..<visibleCards.count {
                let currentCard = visibleCards[index]
                
                if shouldTransparentize {
                    currentCard.alpha = alphaValueSemiTransparent
                }
                
                currentCard.isUserInteractionEnabled = false
                
                let cardParameters = backgroundCardParametersForFrame(frameForCardAtIndex(UInt(index)))
                
                let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
                scaleAnimation?.duration = backgroundCardFrameAnimationDuration
                scaleAnimation?.toValue = NSValue(cgSize: cardParameters.scale)
                currentCard.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
                
                let frameAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
                frameAnimation?.duration = backgroundCardFrameAnimationDuration
                frameAnimation?.toValue = NSValue(cgRect: cardParameters.frame)
                currentCard.pop_add(frameAnimation, forKey: "frameAnimation")
            }
        }
    }
    
    fileprivate func loadMissingCards(_ missingCardsCount: Int) {
        if missingCardsCount > 0 {
            
            let cardsToAdd = min(missingCardsCount, countOfCards - currentCardNumber)
            let startIndex = visibleCards.count
            let endIndex = startIndex + cardsToAdd - 1
            
            for index in startIndex...endIndex {
                let nextCardView = SwipeableCardView(frame: frameForCardAtIndex(UInt(index)))
                
                if shouldTransparentize {
                    nextCardView.alpha = alphaValueSemiTransparent
                }
                nextCardView.delegate = self
                
                visibleCards.append(nextCardView)
                insertSubview(nextCardView, belowSubview: visibleCards[index - 1])
            }
        }
        
        reconfigureCards()
    }
    
    fileprivate func reconfigureCards() {
        for index in 0..<visibleCards.count {
            if let dataSource = self.dataSource {
                
                let currentCardContentView = dataSource.koloda(self, viewForCardAtIndex: UInt(currentCardNumber + index))
                let overlayView = dataSource.koloda(self, viewForCardOverlayAtIndex: UInt(currentCardNumber + index), onContentView:currentCardContentView)
                let currentCard = visibleCards[index]
                
                currentCard.configure(currentCardContentView, overlayView: overlayView)
            }
        }
    }
    
    func reloadData() {
        guard let numberOfCards = dataSource?.koloda(kolodaNumberOfCards: self) , numberOfCards > 0 else {
            return
        }
        countOfCards = Int(numberOfCards)
        
        let missingCards = min(countOfVisibleCards - visibleCards.count, countOfCards - (currentCardNumber + 1))
        
        
        if currentCardNumber == 0 {
            clear()
        }
        
        if countOfCards - (currentCardNumber + visibleCards.count) > 0 {
            
            if !visibleCards.isEmpty {
                loadMissingCards(missingCards)
            } else {
                setupDeck()
                layoutDeck()
                
                if let shouldApply = delegate?.koloda(kolodaShouldApplyAppearAnimation: self) , shouldApply == true {
                    self.alpha = 0
                    applyAppearAnimation()
                }
            }
            
        } else {
            
            reconfigureCards()
        }
    }
    
    func swipe(_ direction: SwipeDirection) {
        guard allowedDirections.contains(direction) else { return }
        if (animating == false) {
            
            if let frontCard = visibleCards.first {
                
                animating = true
                
                if visibleCards.count > 1 {
                    if shouldTransparentize {
                        let nextCard = visibleCards[1]
                        nextCard.alpha = alphaValueOpaque
                    }
                }
                frontCard.swipe(direction)
            }
        }
    }
    
    func resetCurrentCardNumber() {
        clear()
        reloadData()
    }
    
    func viewForCardAtIndex(_ index: Int) -> UIView? {
        let index = Int(index)
        if visibleCards.count + currentCardNumber > index && index >= currentCardNumber {
            return visibleCards[index - currentCardNumber].contentView
        } else {
            return nil
        }
    }
}
