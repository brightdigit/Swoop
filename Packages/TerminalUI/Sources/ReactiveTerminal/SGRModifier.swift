

struct SGRModifier : CodedModifier {
  var prefixCode: [String] {
    var codes = [String]()
    if let foregroundColor = self.foregroundColor {
      codes.append("[38;5;\(foregroundColor.rawValue)m")
      
    }
    if let backgroundColor = self.backgroundColor {
      codes.append("[48;5;\(backgroundColor.rawValue)m")
    }
    return codes
  }
  
  var suffixCode: [String] {
    return ["[0m"]
  }
  
  static let id: Key = "sgrModifier"
  
  let backgroundColor: Color?
  let foregroundColor: Color?
  
}


