import Foundation
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

example(of: "filter", isEnabled: false) {
  // 1
  let numbers = (1...10).publisher
  
  // 2
  numbers
    .filter { $0.isMultiple(of: 3) }
    .sink(receiveValue: { n in
      print("\(n) is a multiple of 3!")
    })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "removeDuplicates", isEnabled: false) {
  // 1
  let words = "hey hey there! want to listen to mister mister ?"
                  .components(separatedBy: " ")
                  .publisher
  // 2
  words
    .removeDuplicates()
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "compactMap", isEnabled: false) {
  // 1
  let strings = ["a", "1.24", "3",
                 "def", "45", "0.23"].publisher
  
  // 2
  strings
    .compactMap { Float($0) }
    .sink(receiveValue: {
      // 3
      print($0)
    })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "ignoreOutput", isEnabled: false) {
  // 1
  let numbers = (1...10_000).publisher
  
  // 2
  numbers
    .ignoreOutput()
    .sink(receiveCompletion: { print("Completed with: \($0)") },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "first(where:)", isEnabled: false) {
  // 1
  let numbers = (1...9).publisher
  
  // 2
  numbers
//    .print("event")
    .first(where: { $0 % 2 == 0 })
    .sink(receiveCompletion: { print("Completed with: \($0)") },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "last(where:)", isEnabled: false) {
  // 1
  let numbers = (1...9).publisher
  
  // 2
  numbers
    .last(where: { $0 % 2 == 0 })
    .sink(receiveCompletion: { print("Completed with: \($0)") },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "last(where:)", isEnabled: false) {
    let numbers = PassthroughSubject<Int, Never>()
  
  numbers
    .last(where: { $0 % 2 == 0 })
    .sink(receiveCompletion: { print("Completed with: \($0)") },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  numbers.send(1)
  numbers.send(2)
  numbers.send(3)
  numbers.send(4)
  numbers.send(5)
//    numbers.send(completion: .finished)
}

/*________________________________________________________________________*/

example(of: "dropFirst", isEnabled: false) {
  // 1
  let numbers = (1...10).publisher
  
  // 2
  numbers
    .dropFirst(8)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "drop(while:)", isEnabled: false) {
  // 1
  let numbers = (1...10).publisher
  
  // 2
  numbers
    .drop(while: { $0 % 5 != 0 })
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "drop(untilOutputFrom:)", isEnabled: false) {
  // 1
  let isReady = PassthroughSubject<Void, Never>()
  let taps = PassthroughSubject<Int, Never>()
  
  // 2
  taps
    .drop(untilOutputFrom: isReady)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  // 3
  (1...5).forEach { n in
    taps.send(n)
    
    if n == 3 {
      isReady.send()
    }
  }
}

/*________________________________________________________________________*/

example(of: "prefix", isEnabled: false) {
  // 1
  let numbers = (1...10).publisher
  
  // 2
  numbers
    .prefix(2)
    .sink(receiveCompletion: { print("Completed with: \($0)") },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
}


/*________________________________________________________________________*/

example(of: "prefix(untilOutputFrom:)", isEnabled: false) {
  // 1
  let isReady = PassthroughSubject<Void, Never>()
  let taps = PassthroughSubject<Int, Never>()
  
  // 2
  taps
    .prefix(untilOutputFrom: isReady)
    .sink(receiveCompletion: { print("Completed with: \($0)") },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  // 3
  (1...5).forEach { n in
    taps.send(n)
    
    if n == 2 {
      isReady.send()
    }
  }
}
