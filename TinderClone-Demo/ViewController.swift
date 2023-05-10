//
//  ViewController.swift
//  TinderClone-Demo
//
//  Created by vignesh kumar c on 10/05/23.
//

import UIKit
import UIKit

class ViewController: UIViewController {
    private var cardContainerView: CardContainerView!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialCardCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardContainerView()
        addCards()
        setupPanGestureRecognizer()
    }
    
    private func setupCardContainerView() {
        cardContainerView = CardContainerView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        cardContainerView.center = view.center
        view.addSubview(cardContainerView)
    }
    
    private func addCards() {
        for i in 0..<5 {
            let card = CardView()
            card.backgroundColor = UIColor(red: CGFloat(i) * 0.1, green: 0.3, blue: 0.5, alpha: 1.0)
            cardContainerView.addCard(card)
        }
    }
    
    private func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        cardContainerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard cardContainerView.currentCardIndex < cardContainerView.cards.count else {
            return
        }
        
        let card = cardContainerView.cards[cardContainerView.currentCardIndex]
        
        switch gestureRecognizer.state {
        case .began:
            initialCardCenter = card.center
        case .changed:
            let translation = gestureRecognizer.translation(in: cardContainerView)
            let rotationAngle = translation.x / cardContainerView.frame.width * -0.4
            let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
                .rotated(by: rotationAngle)
            card.transform = transform
        case .ended:
            let translation = gestureRecognizer.translation(in: cardContainerView)
            let velocity = gestureRecognizer.velocity(in: cardContainerView)
            
            if translation.x > 100 || velocity.x > 500 {
                animateCardOffScreen(withDirection: .right)
            } else if translation.x < -100 || velocity.x < -500 {
                animateCardOffScreen(withDirection: .left)
            } else {
                UIView.animate(withDuration: 0.3) {
                    card.transform = CGAffineTransform.identity
                }
            }
        default:
            break
        }
    }


    private func animateCardOffScreen(withDirection direction: SwipeDirection) {
        let card = cardContainerView.cards[cardContainerView.currentCardIndex]
        
        let translationX: CGFloat = direction == .right ? cardContainerView.bounds.width : -cardContainerView.bounds.width
        let translation = CGAffineTransform(translationX: translationX, y: 0)
        let rotation = CGAffineTransform(rotationAngle: direction == .right ? CGFloat.pi/4 : -CGFloat.pi/4)
        let transform = translation.concatenating(rotation)
        
        UIView.animate(withDuration: 0.3, animations: {
            card.transform = transform
        }) { _ in
            card.removeFromSuperview()
            self.cardContainerView.cards.remove(at: self.cardContainerView.currentCardIndex)
            self.cardContainerView.currentCardIndex = min(self.cardContainerView.currentCardIndex, self.cardContainerView.cards.count - 1)
            self.cardContainerView.layoutCards()
        }
    }

    private enum SwipeDirection {
        case left, right
    }

}

