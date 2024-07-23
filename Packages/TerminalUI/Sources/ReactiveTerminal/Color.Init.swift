

extension BinaryInteger {
  init<FloatingPointType: BinaryFloatingPoint>(clamping value: FloatingPointType) {
    let intValue = Int(value)
    self.init(clamping: intValue)
  }
}

extension Color {
  init(approximateValueBasedOnRed red: UInt8, green: UInt8, blue: UInt8) {
    let hexValue = Int(red) << 16 |  Int(green) << 8 |  Int(blue)
    self.init(approximateValueBasedOnHexValue: hexValue)
  }
  
  init(approximateValueBasedOnWhite white: UInt8) {
    let hexValue = Int(white) << 16 |  Int(white) << 8 |  Int(white)
    self.init(approximateValueBasedOnHexValue: hexValue)
  }
  
  init(approximateValueBasedOnRed red: Double, green: Double, blue: Double) {
    self.init(
      approximateValueBasedOnRed: .init(clamping: Double(UInt8.max) * red),
      green: .init(clamping:Double(UInt8.max) * green),
      blue: .init(clamping:Double(UInt8.max) * blue)
    )
  }
  
  init(approximateValueBasedOnWhite white: Double) {
    let byteValue : UInt8 = .init(clamping: Double(UInt8.max) * white)
    self.init(approximateValueBasedOnWhite: byteValue)
  }
  fileprivate init(exactValueBasedOnHexValue hexValue: Int) {
    guard let index = Self.hexValues.firstIndex(of: hexValue) else {
      preconditionFailure()
    }
    self.init(.init(index))
  }
  
  init(approximateValueBasedOnHexValue hexValue: Int) {
    var currentIndex : Int = -1
    var currentValue : Int?
    for (index, value) in Self.hexValues.enumerated() {
      if value == hexValue {
        self.init(UInt8(index))
      } else if let oldValue = currentValue {
        if (abs(oldValue - hexValue) > abs(value - hexValue)) {
        currentIndex = index
        currentValue = value
        }
      } else {
        currentIndex = index
        currentValue = value
      }
    }
    self.init(.init(currentIndex))
  }
  
  init(red: ComponentValue, green: ComponentValue, blue: ComponentValue) {
    let hexValue = Int(red.byteValue) << 16 |  Int(green.byteValue) << 8 |  Int(blue.byteValue)
    self.init(exactValueBasedOnHexValue: hexValue)
  }
  
  init(white: GreyscaleValue) {
    let byteValue =  Int(white.byteValue)
    let hexValue = byteValue << 16 |  byteValue << 8 |  byteValue
    self.init(exactValueBasedOnHexValue: hexValue)
  }
  
  
}
