


public protocol View {
  func doPrint ()
}

struct List<Content : View> : View {
  func doPrint() {
    
  }
  
  init (@ViewBuilder content: () -> Content) {
    
  }
  
}
