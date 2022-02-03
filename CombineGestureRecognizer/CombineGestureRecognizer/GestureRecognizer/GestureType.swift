//
//  GestureType.swift
//  CombineGestureRecognizer
//
//  Created by Amakhin Ivan on 03.02.2022.
//

import UIKit

enum GestureType {
    case tap
    case swipe
    case longPress
    case pan
    case pinch
    case edge
}

extension GestureType {
    func get() -> UIGestureRecognizer {
        
        switch self {
        case .tap:
            return UITapGestureRecognizer()
        case .swipe:
            return UISwipeGestureRecognizer()
        case .longPress:
            return UILongPressGestureRecognizer()
        case .pan:
            return UIPanGestureRecognizer()
        case .pinch:
            return UIPinchGestureRecognizer()
        case .edge:
            return UIScreenEdgePanGestureRecognizer()
       }
    }
}
