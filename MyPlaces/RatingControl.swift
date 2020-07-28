//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Roman Titkov on 28.07.2020.
//  Copyright © 2020 Roman Titkov. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
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
    
    var rating = 0
    
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
    
    @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed")
    }
    
    // MARK: Private Actions
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview() 
        }
        
        ratingButtons.removeAll()
        
        for _ in 0..<starCount {
            // Create button
            let button = UIButton()
            button.backgroundColor = .red
            
            // Adding constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starsSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starsSize.width).isActive = true
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
            
            // Add the new button to button array
            ratingButtons.append(button)
        }
    }
}
