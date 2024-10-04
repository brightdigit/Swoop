

protocol CodedModifier {
  typealias Key = String
  static var id : Key { get }
  var prefixCode : [String] { get }
  var suffixCode : [String] { get }
}
