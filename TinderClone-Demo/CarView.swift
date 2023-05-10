//
//  CarView.swift
//  TinderClone-Demo
//
//  Created by vignesh kumar c on 10/05/23.
//

import Foundation
import UIKit

class CardContainerView: UIView {
     var cards: [CardView] = []
     var currentCardIndex = 0
     let visibleCardCount = 3
     let cardStackCount = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        // Add any additional configuration for the card container view
        backgroundColor = .white
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }
    
    func addCard(_ card: CardView) {
        cards.append(card)
        addSubview(card)
        layoutCards()
    }
    func checkCardStack() {
        let remainingCardCount = cards.count - currentCardIndex
        
        if remainingCardCount < visibleCardCount {
            loadMoreCards()
        }
    }
    
    func loadMoreCards() {
        let cardCountToAdd = min(cardStackCount, visibleCardCount - (cards.count - currentCardIndex))
        
        for _ in 0..<cardCountToAdd {
            let card = createNewCard()
            addCard(card)
        }
    }
    
    func createNewCard() -> CardView {
        // Customize the card appearance as needed
        let card = CardView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 10.0
        card.layer.borderWidth = 1.0
        card.layer.borderColor = UIColor.lightGray.cgColor
        card.clipsToBounds = true
        
        // Set card data
        card.title = "Card Title"
        card.descriptionText = "Card Description"
        return card
    }
    
    func swipeLeft() {
        guard currentCardIndex < cards.count - 1 else { return }
        currentCardIndex += 1
        animateCardSwipe()
    }
    
    func swipeRight() {
        guard currentCardIndex > 0 else { return }
        currentCardIndex -= 1
        animateCardSwipe()
    }
    
    private func animateCardSwipe() {
        UIView.animate(withDuration: 0.3) {
            self.layoutCards()
        }
    }
    
     func layoutCards() {
        var previousCard: UIView?
        
        for (index, card) in cards.enumerated() {
            card.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: leadingAnchor),
                card.trailingAnchor.constraint(equalTo: trailingAnchor),
                card.heightAnchor.constraint(equalTo: heightAnchor),
                card.topAnchor.constraint(equalTo: topAnchor)
            ])
            
            if let previousCard = previousCard {
                card.topAnchor.constraint(equalTo: previousCard.bottomAnchor).isActive = true
            } else {
                card.topAnchor.constraint(equalTo: topAnchor).isActive = true
            }
            
            if index == currentCardIndex {
                card.transform = CGAffineTransform.identity
                card.alpha = 1.0
            } else if index > currentCardIndex {
                card.transform = CGAffineTransform(translationX: 0, y: 20 * CGFloat(index - currentCardIndex))
                card.alpha = 0.7
            } else {
                card.transform = CGAffineTransform(translationX: 0, y: -20 * CGFloat(currentCardIndex - index))
                card.alpha = 0.7
            }
            
            previousCard = card
        }
        
        if let lastCard = cards.last {
            lastCard.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}

class CardView: UIView {
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
    }
}


