

struct TupleView<Content> : View, ViewCollectionable {
  internal init(_ content: Content) {
    self.content = content
  }
  
  let content : Content
  
  func doPrintEach (_ closure: @escaping () -> Void) {
    if let content = self.content as? (C0 : View, C1 : View, C2 : View) {
     content.C0.doPrint()
      closure()
     content.C1.doPrint()
      closure()
      content.C2.doPrint()
    } else {
      print("Eeek")
    }
    
  }
  
  func doPrint() {
    if let content = self.content as? (C0 : View, C1 : View, C2 : View) {
     content.C0.doPrint()
     content.C1.doPrint()
      content.C2.doPrint()
    } else {
      print("Eeek")
    }
  }
  
  
}
