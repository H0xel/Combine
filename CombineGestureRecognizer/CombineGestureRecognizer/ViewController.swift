//
//  ViewController.swift
//  CombineGestureRecognizer
//
//  Created by Amakhin Ivan on 02.02.2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @Published private var _isOn = false
    private var _cancellable = Set<AnyCancellable>()
    private let _switcher = UISwitch()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupSubscription()
        _addSwitcher()
        _addMethod()
    }
    
    private func _setupSubscription() {
        
        $_isOn
            .sink { [weak self] in
                self?.view.backgroundColor = $0 ? .blue : .red
            }.store(in: &_cancellable)
        
        view
            .gesture(.tap)
            .sink { tap in
                print(tap)
            }
            .store(in: &_cancellable)
        
//        let tap = view.gesture(.tap)
//        let swipe = view.gesture(.swipe)
//        let longPress = view.gesture(.longPress)
//        let pan = view.gesture(.pan)
//        let pinch = view.gesture(.pinch)
//        let edge = view.gesture(.edge)
        
//        Publishers.MergeMany(tap, swipe, longPress, pan, pinch, edge)
//            .print("event")
//            .sink(receiveValue: { gesture in
//                switch gesture {
//                case .tap:
//                    print("Tapped !")
//                case .swipe:
//                    print("Swiped !")
//                case .longPress:
//                    print("Long pressed !")
//                case .pan:
//                    print("Panned !")
//                case .pinch:
//                    print("Pinched !")
//                case .edge:
//                    print("Panned edges !")
//                }
//        }).store(in: &cancellable)
    }
    
    private func _addMethod() {
        _switcher.addTarget(self, action: #selector(isOn), for: .touchUpInside)
    }
    
    @objc func isOn() {
        _isOn = _switcher.isOn
    }
    
    private func _addSwitcher() {
        _switcher.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(_switcher)
        
        NSLayoutConstraint.activate([
            _switcher.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _switcher.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
