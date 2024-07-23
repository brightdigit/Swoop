

@resultBuilder struct ViewBuilder {
  @_alwaysEmitIntoClient
  public static func buildBlock() -> EmptyView {
      .init()
  }

  @_alwaysEmitIntoClient
  public static func buildBlock<Content>(_ content: Content) -> Content where Content: View {
      content
  }
  
  public static func buildBlock<C0, C1>(
          _ c0: C0,
          _ c1: C1) -> TupleView<(C0, C1)>
          where C0: View, C1: View
      {
          .init((c0, c1))
      }
  
  public static func buildBlock<C0, C1, C2>(
          _ c0: C0,
          _ c1: C1,
          _ c2: C2) -> TupleView<(C0, C1, C2)>
          where C0: View, C1: View, C2: View
      {
          .init((c0, c1, c2))
      }
  
}
