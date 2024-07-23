



struct Text : View {
  internal init(_ text: String, modifiers: [AnyCodedModifier] = .init()) {
    self.content = text
    self.modifiers = modifiers
  }
  
  let modifiers : [AnyCodedModifier]
  let content : String
  func doPrint() {
    
    for modifier in modifiers {
      for code in modifier.modifier.prefixCode {
        Helpers.escapeWith(code: code)
      }
    }
    Swift.print(self.content, terminator: "")
    
      for modifier in modifiers {
        if modifier.modifier.prefixCode.isEmpty {
          continue
        }
        
          for code in modifier.modifier.suffixCode {
            Helpers.escapeWith(code: code)
          }
      }
  }
  
  func foregroundColor(_ color: Color) -> Self {
    var modifiers = self.modifiers
    modifiers.append(.init(modifier: SGRModifier(backgroundColor: nil, foregroundColor: color)))
    return .init(self.content, modifiers: modifiers)
  }
  
  
  func backgroundColor(_ color: Color) -> Self {
    var modifiers = self.modifiers
    modifiers.append(.init(modifier: SGRModifier(backgroundColor: color, foregroundColor: nil)))
    return .init(self.content, modifiers: modifiers)
  }
  
  func color(background: Color?, foreground: Color?) -> Self {
    var modifiers = self.modifiers
    modifiers.append(.init(modifier: SGRModifier(backgroundColor: background, foregroundColor: foreground)))
    return .init(self.content, modifiers: modifiers)
    
  }
}
