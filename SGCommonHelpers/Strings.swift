import Foundation

// MARK: - Вспомогательные функции строк

/// Пример:
/// let str = "Hello, playground"
/// print(str.substring(from: 7))         // playground
/// print(str.substring(to: 5))           // Hello
/// print(str.substring(with: 7..<11))    // play

public extension String {

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }

    private func index(from: Int) -> Index {
        index(startIndex, offsetBy: from)
    }

}

// MARK: - Вычисляемые поля

public extension String {

    var withoutWhitespaces: String {
        replacingOccurrences(of: " ", with: "")
    }

    var capitalizedFirstLetter: String {
        guard !isEmpty else { return self }
        return prefix(1).capitalized + dropFirst()
    }
}

public extension String {

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
}

public extension String {

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

public extension String {

    /**
     Склоняет для числительных слова.
     Пример использования:
     String.declensionForNumber(2, ["день", "дня", "дней"]) // return @"дня"
     
     - parameter number: число для которого будет подбираться склонение
     - parameter titles: массив 3х вариантов просклоненных слов, напр.:
     ["именительный", "родительный", "множественное число"]
     */
    static func declensionForNumber(_ number: Int, titles: [String]) -> String {
        if titles.count != 3 {
            return "Необходим массив из 3х вариантов просклоненных слов"
        }

        let cases = [2, 0, 1, 1, 1, 2]
        if number % 100 > 4, number % 100 < 20 {
            return titles[2]
        } else {
            return titles[cases[(number % 10 < 5) ? number % 10 : 5]]
        }
    }

}

public extension String {
    func validate(with regex: String) -> Bool {
        guard
            let regex = try? NSRegularExpression(
                pattern: regex,
                options: [.anchorsMatchLines]
            ) else { return false }
        
        let numberOfMatches = regex.numberOfMatches(
            in: self,
            options: [],
            range: NSRange(startIndex..., in: self)
        )
        return numberOfMatches > 0
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
