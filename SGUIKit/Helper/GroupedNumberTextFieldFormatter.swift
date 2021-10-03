import UIKit

/// Форматтер отделяющий каждые 3 цифры с правого края пробелом.
/// Можно назначить делегатом текстфилда, чтобы в текстфилде автоматически добавлялись/удалялись пробелы
public class GroupedNumberTextFieldFormatter: NSObject {
    
    private(set) var caretPosition: Int
    private(set) var formattedText: String?
    
    private let maxDigits: Int
    
    public init(maxDigits: Int) {
        caretPosition = 0
        self.maxDigits = maxDigits
        
        super.init()
    }
    
    private func setFormattedText(textField: UITextField, range: NSRange, string: String) {
        let selfType = type(of: self)
        let range = selfType.makeRange(text: textField.text ?? "", range: range, string: string)
        let number = selfType.makeNumber(text: textField.text ?? "", range: range, string: string)
        if selfType.isValid(number: number, maxDigits: maxDigits) {
                   
            let formattedText = selfType.format(price: number)
            caretPosition = selfType.makeCompleteCaretPosition(
                text: textField.text ?? "",
                formattedText: formattedText,
                initialCaretPosition: textField.caretPosition,
                range: range
            )
            self.formattedText = formattedText
                   
        } else {
                   
            caretPosition = textField.caretPosition
            formattedText = nil
                   
        }
    }
    
    /**
     Формат для стоимости:
     Начиная с правого края, пробелом отбиваются каждые три символа.
     Пример:
     300 000, 1 000, 6 000 000
     */
    public static func format(price: String) -> String {
        String(
            price
                .reversed()
                .reduce("") { res, char -> String in
                    if (res.count + 1) % 4 == 0 {
                        return res + " \(char)"
                    }
                    return res + "\(char)"
                }
                .reversed()
        )
    }
    
    public static func format(price: Int) -> String {
        format(price: String(price))
    }
    
    /// Изменяет удаляемый отрезок.
    ///
    /// В случае если стирается пробел, то необходимо стереть также и символ перед ним.
    ///
    /// - Parameters:
    ///   - text: Исходный текст.
    ///   - range: Отрезок где производится замена.
    ///   - string: Строка, с изменениями.
    /// - Returns: Новый где производится замена
    private static func makeRange(text: String, range: NSRange, string: String) -> NSRange {
        if string == "", let range = Range(range, in: text), text[range] == " " {
            let index = text.index(before: range.lowerBound)
            return NSRange(index..<range.upperBound, in: text)
        } else {
            return range
        }
    }
    
    /// Применяет изменения к строке и убирает разделители.
    ///
    /// - Parameters:
    ///   - text: Исходный текст.
    ///   - range: Отрезок где производится замена.
    ///   - string: Строка, с изменениями.
    /// - Returns: Строка с произведенной заменой и вырезанными разделителями.
    private static func makeNumber(text: String, range: NSRange, string: String) -> String {
        text
            .newString(replacementRange: range, replacementString: string)
            .replacingOccurrences(of: " ", with: "")
    }
    
    /// Проверка не форматированной строки.
    ///
    /// - Parameters:
    ///   - number: Неформатированная строка.
    ///   - maxDigits: Максимальное количество цифр в строке.
    private static func isValid(number: String, maxDigits: Int) -> Bool {
        number.count <= maxDigits && number.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    /// Рассчитывает позицию курсора после применения изменений к текстовому полю.
    ///
    /// - Parameters:
    ///   - text: Исходный текст.
    ///   - formattedText: Форматированный текст.
    ///   - string: Строка, с изменениями.
    ///   - initialCaretPosition: Позиция курсора до изменений.
    ///   - range: Отрезок где производится замена.
    /// - Returns: Итоговая позиция курсора.
    private static func makeCompleteCaretPosition(
        text: String,
        formattedText: String,
        initialCaretPosition: Int,
        range: NSRange
    ) -> Int {
        
        if range.length > 1 {
            let tailCount = text.count - (range.location + range.length)
            let textSeparatorInTailCount = text.reversed
                .substring(to: tailCount)
                .filter { $0 == " " }.count
            let formattedTextSeparatorInTailCount = formattedText.reversed
                .substring(to: tailCount)
                .filter { $0 == " " }.count
            let caretPosition = formattedText.count
                - tailCount
                - textSeparatorInTailCount
                + formattedTextSeparatorInTailCount
            return max(caretPosition, 0)
        } else {
            let caretPosition: Int
            
            if formattedText.count > text.count {
                caretPosition = initialCaretPosition + formattedText.count - text.count
            } else if formattedText.count == text.count {
                caretPosition = initialCaretPosition + range.length
            } else {
                caretPosition = initialCaretPosition - (text.count - formattedText.count)
            }
            return max(caretPosition, 0)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension GroupedNumberTextFieldFormatter: UITextFieldDelegate {
 
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        setFormattedText(textField: textField, range: range, string: string)
        if let formattedText = formattedText {
            textField.text = formattedText
        }
        
        DispatchQueue.main.async {
            textField.caretPosition = self.caretPosition
        }
        
        return false
    }
}
