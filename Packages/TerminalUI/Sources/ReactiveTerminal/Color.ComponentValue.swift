
extension Color {
  struct ComponentValue : ExpressibleByIntegerLiteral, RawRepresentable {
    init(rawValue: UInt8) {
      let index = Int(rawValue)
      precondition((0..<Self.byteValues.count).contains(index))
      self.rawValue = rawValue
      self.byteValue = Self.byteValues[index]
    }
    
    init(integerLiteral value: IntegerLiteralType) {
      self = .init(rawValue: UInt8(value))
    }
    
    let rawValue: UInt8
    let byteValue : UInt8
    
    typealias RawValue = UInt8
    
    static let byteValues : [UInt8] = [0,95
    ,128
    ,135
    ,175
    ,192
    ,215
    ,255]
  }
}
