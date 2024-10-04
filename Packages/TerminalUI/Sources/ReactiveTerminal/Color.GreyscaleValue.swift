
extension Color {
  
  struct GreyscaleValue  : ExpressibleByIntegerLiteral, RawRepresentable  {
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
    
    static let byteValues : [UInt8] = [
      0,
      8,
      18,
      28,
      38,
      48,
      58,
      68,
      78,
      88,
      98,
      108,
      118,
      128,
      138,
      148,
      158,
      168,
      178,
      188,
      198,
      208,
      218,
      228,
      238,
      255
    ]
  }
}
