//
//  GestureSubscriber.swift
//  CombineGestureRecognizer
//
//  Created by Amakhin Ivan on 02.02.2022.
//

import UIKit
import Combine


class GestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {
    
    private var subscriber: S?
    private var gestureType: GestureType
    private var view: UIView
    
    init(
        subscriber: S,
        view: UIView,
        gestureType: GestureType
    ) {
        self.subscriber = subscriber
        self.view = view
        self.gestureType = gestureType
        configureGesture(gestureType)
    }
    
    private func configureGesture(_ gestureType: GestureType) {
        let gesture = gestureType.get()
        gesture.addTarget(self, action: #selector(_handler))
        view.addGestureRecognizer(gesture)
    }
    
    /* Подписчик запрашивает значения из подписки, отправляя ей нужное количество значений (вызывая метод request(_:) подписки).
     */
    
    func request(_ demand: Subscribers.Demand) {} // обязательный метод при реализации протокола
    
    func cancel() {
        subscriber = nil
    } // обязательный метод при реализации протокола
    
    @objc private func _handler() {
        _ = subscriber?.receive(gestureType)
    }
}
