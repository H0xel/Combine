import Foundation
import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

public func example(
    of description: String,
    isEnabled: Bool,
    action: () -> Void
) {
    guard isEnabled else { return }
  print("\n——— Example of:", description, "———")
  action()
}

/*________________________________________________________________________*/

example(of: "prepend(Output...)", isEnabled: false) {
  // 1
  let publisher = [3, 4].publisher
  
  // 2
  publisher
    .prepend(1, 2)
    .prepend(-1, 0)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "append(Output...)", isEnabled: false) {
  // 1
  let publisher = [1].publisher

  // 2
  publisher
    .append(2, 3)
    .append(4)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "switchToLatest", isEnabled: false) {
  // 1
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()
  let publisher3 = PassthroughSubject<Int, Never>()

  // 2
  let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()

  // 3
  publishers
        .print("event")
    .switchToLatest()
    .sink(
      receiveCompletion: { _ in print("Completed!") },
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)

  // 4
  publishers.send(publisher1)
  publisher1.send(1)
  publisher1.send(2)

  // 5
  publishers.send(publisher2)
  publisher1.send(3)
  publisher2.send(4)
  publisher2.send(5)

  // 6
  publishers.send(publisher3)
  publisher2.send(6)
  publisher3.send(7)
  publisher3.send(8)
  publisher3.send(9)

  // 7
  publisher3.send(completion: .finished)
  publishers.send(completion: .finished)
}

/*
 Если вы не уверены, почему это полезно в реальном приложении, рассмотрите следующий сценарий: ваш пользователь нажимает кнопку, которая запускает сетевой запрос. Сразу после этого пользователь снова нажимает кнопку, что запускает второй сетевой запрос. Но как избавиться от ожидающего запроса и использовать только последний запрос? switchToLatest спешит на помощь!
 */

//example(of: "switchToLatest - Network Request") {
//  let url = URL(string: "https://source.unsplash.com/random")!
//
//  // 1
//  func getImage() -> AnyPublisher<UIImage?, Never> {
//      URLSession.shared
//        .dataTaskPublisher(for: url)
//        .map { data, _ in UIImage(data: data) }
//        .print("image")
//        .replaceError(with: nil)
//        .eraseToAnyPublisher()
//  }
//
//  // 2
//  let taps = PassthroughSubject<Void, Never>()
//
//  taps
//    .map { _ in getImage() } // 3
//    .switchToLatest() // 4
//    .sink(receiveValue: { _ in })
//    .store(in: &subscriptions)
//
//  // 5
//  taps.send()
//
//  DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//    taps.send()
//  }
//
//  DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
//    taps.send()
//  }
//}

/*________________________________________________________________________*/

example(of: "merge(with:)", isEnabled: false) {
  // 1
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()

  // 2
  publisher1
    .merge(with: publisher2)
    .sink(
      receiveCompletion: { _ in print("Completed") },
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)

  // 3
  publisher1.send(1)
  publisher1.send(2)

  publisher2.send(3)

  publisher1.send(4)

  publisher2.send(5)

  // 4
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}

/*________________________________________________________________________*/

example(of: "combineLatest", isEnabled: false) {
  // 1
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<String, Never>()

  // 2
  publisher1
    .combineLatest(publisher2)
    .sink(
      receiveCompletion: { _ in print("Completed") },
      receiveValue: { print("P1: \($0), P2: \($1)") }
    )
    .store(in: &subscriptions)

  // 3
  publisher1.send(1)
  publisher1.send(2)
  
  publisher2.send("a")
  publisher2.send("b")
  
  publisher1.send(3)
  
  publisher2.send("c")

  // 4
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}

/*________________________________________________________________________*/

example(of: "zip", isEnabled: false) {
  // 1
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<String, Never>()

  // 2
  publisher1
      .zip(publisher2)
      .sink(
        receiveCompletion: { _ in print("Completed") },
        receiveValue: { print("P1: \($0), P2: \($1)") }
      )
      .store(in: &subscriptions)

  // 3
  publisher1.send(1)
  publisher1.send(2)
  publisher2.send("a")
  publisher2.send("b")
  publisher1.send(3)
  publisher2.send("c")
  publisher2.send("d")

  // 4
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}

