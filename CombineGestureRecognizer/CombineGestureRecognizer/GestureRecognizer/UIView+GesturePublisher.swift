//
//  UIView.swift
//  CombineGestureRecognizer
//
//  Created by Amakhin Ivan on 02.02.2022.
//

import UIKit
import Combine


extension UIView {
    func gesture(_ gestureType: GestureType) -> GesturePublisher {
        .init(view: self, gestureType: gestureType)
    }
}


