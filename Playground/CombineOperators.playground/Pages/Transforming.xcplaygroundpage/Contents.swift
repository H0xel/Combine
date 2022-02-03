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

example(of: "collect", isEnabled: false) {
  ["A", "B", "C", "D", "E"].publisher
//    .collect()
    .sink(receiveCompletion: { print($0) },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "map", isEnabled: false) {
  // 1
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  
  // 2
  [123, 4, 56].publisher
    // 3
    .map {
      formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
    }
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "flatMap", isEnabled: false) {
  // 1
  func decode(_ codes: [Int]) -> AnyPublisher<String, Never> {
    // 2
    Just(
      codes
        .compactMap { code in
          guard (32...255).contains(code) else { return nil }
          return String(UnicodeScalar(code) ?? " ")
        }
        // 3
        .joined()
    )
    // 4
    .eraseToAnyPublisher()
  }
    /*
     1. Определите функцию, которая принимает массив целых чисел, каждое из которых представляет код ASCII,
     и возвращает средство публикации строк со стертым типом, которое никогда не выдает ошибок.
     2. Создайте издатель Just, который преобразует код символа в строку,
     если он находится в диапазоне 32...255, который включает стандартные и расширенные печатные символы ASCII.
     3. Соедините струны вместе.
     4. Введите стереть издатель, чтобы он соответствовал типу возвращаемого значения для функции.
     */
    
    [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
      .publisher
      .collect()
      // 6
      .flatMap(decode)
      // 7
      .sink(receiveValue: { print($0) })
      .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "replaceNil", isEnabled: false) {
  // 1
  ["A", nil, "C"].publisher
    .eraseToAnyPublisher()
    .replaceNil(with: "-") // 2
    .sink(receiveValue: { print($0) }) // 3
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "replaceEmpty(with:)", isEnabled: false) {
  // 1
  let empty = Empty<Int, Never>()
  
  // 2
  empty
    .replaceEmpty(with: 1) // есть еще replaceError(with: Int)
    .sink(receiveCompletion: { print($0) },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*________________________________________________________________________*/

example(of: "scan", isEnabled: false) {
  // 1
  var dailyGainLoss: Int { .random(in: -10...10) }

  // 2
  let august2019 = (0..<22)
    .map { _ in dailyGainLoss }
    .publisher

  // 3
  august2019
    .scan(50) { latest, current in
      max(0, latest + current)
    }
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/*
 1. Создайте вычисляемое свойство, которое генерирует случайное целое число в диапазоне от -10 до 10.
 2. Используйте этот генератор для создания издателя из массива случайных целых чисел, представляющих фиктивные ежедневные изменения цен на акции в течение месяца.
 3. Используйте сканирование с начальным значением 50, а затем добавляйте каждое ежедневное изменение к текущей цене акции. Использование max сохраняет цену неотрицательной — к счастью, цены на акции не могут упасть ниже нуля!
 */
