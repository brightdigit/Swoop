import Foundation

public class Task {
  public let id: UUID
  public let name: String
  public let speed: TimeInterval
  public var progress: Double = 0.0 {
    didSet {
      self.delegate?.taskUpdated(self)
    }
  }

  public private(set) var timer: Timer?
  public weak var delegate: TaskDelegate?

  public init(id: UUID? = nil, name: String? = nil, speed: TimeInterval? = nil) {
    self.id = id ?? UUID()
    self.name = name ?? TaskName.shared.generate()
    self.speed = speed ?? Double.random(in: 0.5 ... 5.0)
  }

  public func start() {
    let timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { _ in
      self.progress = min(100.0, self.progress + 0.1)
      if self.progress >= 100.0 {
        self.timer?.invalidate()
        self.timer = nil
      }
    }
    self.timer = timer
  }
}
