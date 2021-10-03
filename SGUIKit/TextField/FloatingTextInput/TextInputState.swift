import Foundation

/// Состояние текстового поля.
///
/// - empty: Нет текста.
/// - text: Содержит текст.
/// - placeholder: Поле в фокусе, но еще нет текста.
/// - textInput: Ввод текста.
public enum TextInputState {
    case empty
    case text
    case placeholder
    case textInput

    public init(hasText: Bool, firstResponder: Bool) {
        switch (hasText, firstResponder) {
        case (false, false):
            self = .empty
        case (true, false):
            self = .text
        case (false, true):
            self = .placeholder
        case (true, true):
            self = .textInput
        }
    }
}
