import Foundation

struct Text2 : View {
  internal init(_ text: String) {
    self.text = text
  }
  
  let text : String
  func doPrint() {
    Swift.print(text)
  }
  
  
}

@available(macOS 10.15, *)
public protocol ReactiveTerminal {
  associatedtype Body : View
  init ()
  @ViewBuilder var body: Self.Body { get }
}
 
enum Helpers {
  static func escapeWith(code: String) {
    print("\u{1B}\(code)", terminator: "")
  }
}
@available(macOS 10.15, *)
public extension ReactiveTerminal {
  
  static func main () {
    
//    for i in 0..<16 {
//      for j in 0..<16 {
//
//            let code = "\(i * 16 + j)"
//        Self.escapeWith(code: "[38;5;\(code)m")
//        print(code, terminator: " ")
//
//        escapeWith(code: "[0m")
//      }
//    }
//    for i in range(0, 16):
//        for j in range(0, 16):
//            code = str(i * 16 + j)
//            sys.stdout.write(u"\u001b[38;5;" + code + "m " + code.ljust(4))
//        print u"\u001b[0m"
    let app = Self.init()
    let subscription = Timer.publish(every: 1.0, on: .main, in: .default)
      .autoconnect()
      .sink { _ in
        Helpers.escapeWith(code: "[2J")
        Helpers.escapeWith(code: "[0;0H")
        app.body.doPrint()
      }

    withExtendedLifetime(subscription) {
      RunLoop.current.run()
    }
  }
}


