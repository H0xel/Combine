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

example(of: "min", isEnabled: false) {
  // 1
  let publisher = [1, -50, 246, 0].publisher

  // 2
  publisher
    .print("publisher")
    .min()
    .sink(receiveValue: { print("Lowest value is \($0)") })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "min non-Comparable", isEnabled: false) {
  // 1
  let publisher = ["12345",
                   "ab",
                   "hello world"]
    .map { Data($0.utf8) } // [Data]
    .publisher // Publisher<Data, Never>

  // 2
  publisher
    .print("publisher")
    .min(by: { $0.count < $1.count })
    .sink(receiveValue: { data in
      // 3
      let string = String(data: data, encoding: .utf8)!
      print("Smallest data is \(string), \(data.count) bytes")
    })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "max", isEnabled: false) {
  // 1
  let publisher = ["A", "F", "Z", "E"].publisher

  // 2
  publisher
    .print("publisher")
    .max()
    .sink(receiveValue: { print("Highest value is \($0)") })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "first", isEnabled: false) {
  // 1
  let publisher = ["A", "B", "C"].publisher

  // 2
  publisher
    .print("publisher")
    .first()
    .sink(receiveValue: { print("First value is \($0)") })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "last", isEnabled: false) {
  // 1
  let publisher = ["A", "B", "C"].publisher

  // 2
  publisher
    .print("publisher")
    .last()
    .sink(receiveValue: { print("Last value is \($0)") })
    .store(in: &subscriptions)
}

example(of: "output(at:)", isEnabled: false) {
  // 1
  let publisher = ["A", "B", "C"].publisher

  // 2
  publisher
    .print("publisher")
    .output(at: 1)
    .sink(receiveValue: { print("Value at index 1 is \($0)") })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "count", isEnabled: false) {
  // 1
  let publisher = ["A", "B", "C"].publisher
    
  // 2
  publisher
    .print("publisher")
    .count()
    .sink(receiveValue: { print("I have \($0) items") })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/


example(of: "contains", isEnabled: false) {
  // 1
  let publisher = ["A", "B", "C", "D", "E"].publisher
  let letter = "C"

  // 2
  publisher
    .print("publisher")
    .contains(letter)
    .sink(receiveValue: { contains in
      // 3
      print(contains ? "Publisher emitted \(letter)!"
                     : "Publisher never emitted \(letter)!")
    })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "allSatisfy", isEnabled: false) {
  // 1
  let publisher = stride(from: 0, to: 5, by: 2).publisher
  
  // 2
  publisher
    .print("publisher")
    .allSatisfy { $0 % 2 == 0 }
    .sink(receiveValue: { allEven in
      print(allEven ? "All numbers are even"
                    : "Something is odd...")
    })
    .store(in: &subscriptions)
}

/* принимает предикат закрытия и выдает логическое значение, указывающее, соответствуют ли этому предикату все значения,
 выдаваемые вышестоящим издателем.
 Он жадный и поэтому будет ждать, пока вышестоящий издатель не выдаст событие завершения .finished:
 */

/*________________________________________________________________________*/

example(of: "reduce", isEnabled: false) {
  // 1
  let publisher = ["Hel", "lo", " ", "Wor", "ld", "!"].publisher
  
  publisher
    .print("publisher")
    .reduce("") { accumulator, value in
      // 2
      accumulator + value
    }
    .sink(receiveValue: { print("Reduced into: \($0)") })
    .store(in: &subscriptions)
}
