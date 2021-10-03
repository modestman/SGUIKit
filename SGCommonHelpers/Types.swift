import CoreLocation
import Foundation
import UIKit

public typealias VoidClosure = () -> Void
public typealias StringClosure = (String) -> Void
public typealias OptionalStringClosure = (String?) -> Void
public typealias DateClosure = (Date) -> Void
public typealias BoolClosure = (Bool) -> Void
public typealias IntClosure = (Int) -> Void
public typealias ErrorClosure = (Error) -> Void
public typealias ImageCompletion = (UIImage) -> Void
public typealias CGImageCompletion = (CGImage) -> Void
public typealias ImageOptionalCompletion = (UIImage?) -> Void
public typealias LocationClosure = (CLLocation?) -> Void
public typealias NotificationCenterObservation = NSObjectProtocol
public typealias TextValidationClosure = (String?) -> ValidationResult
