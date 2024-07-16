// The Swift Programming Language
// https://docs.swift.org/swift-book
import ScriptingBridge

let appURL = URL(filePath: "/Applications/Xcode-beta.app")
guard let application = SBApplication(url: appURL) else {
  exit(1)
}

let xcode = application as XcodeApplication
let result = xcode.open?("/Users/leo/Documents/Projects/Bitness/Bitness.xcodeproj")

guard let elements = xcode.documents?.get() else {
  exit(1)
}

let ununiqueDocuments = elements.compactMap { document -> (URL, XcodeDocument)? in
  guard let value = document as? XcodeDocument else {
    return nil
  }
  guard let key = value.file else {
    return nil
  }
  return (key, value)
}

let documents = Dictionary(grouping: ununiqueDocuments) { pair in
  return pair.0
}.compactMapValues { values in
  values.first?.1
}.values

for document in documents {
  print(document.file)
}


