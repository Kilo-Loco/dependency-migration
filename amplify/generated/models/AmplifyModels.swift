// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "65a1e6f85cdcf6ba1464b94f421c0eb6"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Note.self)
  }
}