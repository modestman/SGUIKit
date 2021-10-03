import Foundation

// MARK: - Вспомогательные функции строк

/// Пример:
/// let str = "Hello, playground"
/// print(str.substring(from: 7))         // playground
/// print(str.substring(to: 5))           // Hello
/// print(str.substring(with: 7..<11))    // play

public extension String {

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    private func index(from: Int) -> Index {
        index(startIndex, offsetBy: from)
    }

    var withoutWhitespaces: String {
        replacingOccurrences(of: " ", with: "")
    }

    /// Проверка строки на регулярное выражение
    ///
    /// - parameter regExp: регулярное выражение
    ///
    /// - returns: результат проверки
    /// при отсутствии regExp - результат true
    func checkRegularExpression(_ regExp: NSRegularExpression?) -> Bool {
        guard let regExp = regExp else { return !isEmpty }

        let myRange = NSRange(
            location: 0,
            length: count
        )

        guard let range = regExp.firstMatch(
            in: self,
            range: myRange
        )?.range else { return false }

        return range.length > 0
    }

    func newString(replacementRange range: NSRange, replacementString: String) -> String {
        if range.length > 0, replacementString.isEmpty {
            return replaceCharacters(
                inText: self,
                range: range,
                withCharacters: ""
            )
        } else {
            return replaceCharacters(
                inText: self,
                range: range,
                withCharacters: replacementString
            )
        }
    }

    private func replaceCharacters(
        inText text: String?,
        range: NSRange,
        withCharacters newText: String
    ) -> String {
        if let text = text {
            if range.length > 0 {
                let result = NSMutableString(string: text)
                result.replaceCharacters(in: range, with: newText)
                return result as String
            } else {
                let result = NSMutableString(string: text)
                result.insert(newText, at: range.location)
                return result as String
            }
        } else {
            return ""
        }
    }

}

public extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        if let unwrapped = self {
            return unwrapped.isEmpty
        } else {
            return true
        }
    }
    
}
