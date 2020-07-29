//
//  RatingInCell.swift
//  MyPlaces
//
//  Created by Roman Titkov on 29.07.2020.
//  Copyright © 2020 Roman Titkov. All rights reserved.
//

import UIKit

@IBDesignable class RatingInCell: RatingControl {


//    override var starsSize: CGSize {
//        get {
//            return CGSize(width: 20, height: 20)
//        }
//        set {
//
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.starsSize = CGSize(width: 20, height: 20)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.starsSize = CGSize(width: 20, height: 20)
    }
}
