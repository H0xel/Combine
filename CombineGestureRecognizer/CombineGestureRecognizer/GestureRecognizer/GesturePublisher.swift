//
//  GesturePublisher.swift
//  CombineGestureRecognizer
//
//  Created by Amakhin Ivan on 02.02.2022.
//

import UIKit
import Combine


struct GesturePublisher: Publisher {
    
    typealias Output = GestureType
    typealias Failure = Never
    
    private let view: UIView
    private let gestureType: GestureType
    
    init(
        view: UIView,
        gestureType: GestureType
    ) {
        self.view = view
        self.gestureType = gestureType
    }
    
    
    func receive<S: Subscriber>(
        subscriber: S
    ) where S.Input == Output, S.Failure == Failure {
        
        /*
         
         Протокол издателя имеет один обязательный метод `receive<S>(subscriber: S)`, который «прикрепляет указанного подписчика к этому издателю».
         
         Издатель создает подписку, а затем передает ее подписчику (вызывая получение receive(subscription:)).
         
         Этот метод будет вызываться каждый раз, когда издатель получает нового подписчика.

         Метод `sink` будет использоваться позже для создания нашего подписчика.
         
         */
        
        let subscription = GestureSubscription(
            subscriber: subscriber,
            view: view,
            gestureType: gestureType)
        
        subscriber.receive(subscription: subscription)
    }
}
