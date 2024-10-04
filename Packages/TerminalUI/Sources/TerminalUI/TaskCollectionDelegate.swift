public protocol TaskCollectionDelegate: AnyObject {
  func tasks(_ collection: TaskCollection, updatedFromSource source: Any?)
}
