

@available(macOS 10.15, *)
@main
public struct OurRT : ReactiveTerminal {
  public init () {}
  

  public var body: some View {
    StackView{
      Text("Hello World A").foregroundColor(.chartreuse1)
      Text(Int.random(in: 0...1).isMultiple(of: 2) ? "YeS" : "No").color(background: Bool.random() ? Color.chartreuse3A : Color.gold1, foreground: Bool.random() ? Color.darkBlue : Color.sandyBrown)
      Text2("Hello World C")
    }

  }
}
