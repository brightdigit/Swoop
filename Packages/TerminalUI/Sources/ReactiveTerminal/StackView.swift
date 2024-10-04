

struct StackView<Content : View> : View {
  internal init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content()
  }
  
  let content : Content
  
  func doPrint() {
    if let content = self.content as? ViewCollectionable{
      content.doPrintEach{
        print()
      }
    } else {
      print("Eeek")
    }
  }
}
