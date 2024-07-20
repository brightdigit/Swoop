import Foundation
import TerminalUI

struct HStack : TerminalContent {
  var desiredSize: WindowSize?
  
  
  func render<View>(to view: inout View) where View : TerminalView {
    
  }
  
  
}
struct List<Data : Sequence, Element : Identifiable, Content: TerminalContent> : TerminalContent where Data.Element == Element {
  var desiredSize: WindowSize? 
  
  let data : Data
  let content : (Data) -> Content
  
  func render<View>(to view: inout View) where View : TerminalView {
    
  }
}

let controller = TerminalController(content: TextBox().padding(.all, 5))

controller.run()
