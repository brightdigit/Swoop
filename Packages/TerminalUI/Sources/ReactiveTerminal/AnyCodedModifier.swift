


struct AnyCodedModifier : Hashable {
  static func == (lhs: AnyCodedModifier, rhs: AnyCodedModifier) -> Bool {
    type(of: lhs.modifier).id.hashValue == type(of: rhs.modifier).id.hashValue
  }
  
  let modifier : CodedModifier
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.key)
  }
  
  var key : String {
    type(of: modifier).id
  }
  
}
