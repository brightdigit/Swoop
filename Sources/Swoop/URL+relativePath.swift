import Foundation

func relativePath(from base: URL, to target: URL) -> String? {
    let basePathComponents = base.pathComponents
    let targetPathComponents = target.pathComponents
    
    // Find the common path prefix
    var commonComponentsCount = 0
    for (baseComponent, targetComponent) in zip(basePathComponents, targetPathComponents) {
        if baseComponent == targetComponent {
            commonComponentsCount += 1
        } else {
            break
        }
    }
    
    // Calculate the number of `..` needed
    let baseUniqueComponentsCount = basePathComponents.count - commonComponentsCount
    let relativePathComponents = Array(repeating: "..", count: baseUniqueComponentsCount) +
                                 targetPathComponents[commonComponentsCount...]
    
    return NSString.path(withComponents: Array(relativePathComponents))
}
