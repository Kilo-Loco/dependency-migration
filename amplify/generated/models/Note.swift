// swiftlint:disable all
import Amplify
import Foundation

public struct Note: Model {
  public let id: String
  public var title: String
  public var description: String
  
  public init(id: String = UUID().uuidString,
      title: String,
      description: String) {
      self.id = id
      self.title = title
      self.description = description
  }
}