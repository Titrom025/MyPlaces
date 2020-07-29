//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Roman Titkov on 28.07.2020.
//  Copyright © 2020 Roman Titkov. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    // MARK: Properties
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    private var ratingButtons = [UIButton]()
    
    
    @IBInspectable var starsSize: CGSize = CGSize(width: 45, height: 45) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button Actions
    
    @objc func ratingButtonPressed(button: UIButton) {
        guard let buttonIndex = ratingButtons.firstIndex(of: button) else { return }
        
        for index in 0...buttonIndex {
            ratingButtons[index].isHighlighted = true
        }
    }
    
    @objc func ratingButtonPressedCancel(button: UIButton) {
        guard let buttonIndex = ratingButtons.firstIndex(of: button) else { return }
        
        for index in 0...buttonIndex {
            ratingButtons[index].isHighlighted = false
        }
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let buttonIndex = ratingButtons.firstIndex(of: button) else { return }
        
        // Callculate the rating of the selected button
        
        for index in 0...buttonIndex {
            ratingButtons[index].isHighlighted = false
        }
        
        let selectedRating = buttonIndex + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    // MARK: Private Actions
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview() 
        }
        
        ratingButtons.removeAll()
        
        // Load Button Image
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar",
                                in: bundle, compatibleWith:
                                self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle, compatibleWith:
                                self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                in: bundle, compatibleWith:
                                self.traitCollection)
        
        
        for _ in 0..<starCount {
            // Create button
            let button = UIButton()
            //button.backgroundColor = .red
            
            // Set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Adding constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starsSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starsSize.width).isActive = true
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Setup the button action
            button.addTarget(self, action: #selector(ratingButtonPressed), for: .touchDown)
            button.addTarget(self, action: #selector(ratingButtonPressedCancel), for: .touchDragExit)
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
            
            // Add the new button to button array
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
