import Foundation

public enum CommonValidationPatterns {
    
    /// Маска ввода для телефонного номера
    public static let phoneInputMask = "+7 ([000]) [000]-[00]-[00]"
    
    /// Регулярное выражение для валидации разрешенных символов во время ввода целого числа
    public static let intNumberInputPattern = #"^\d{0,10}$"#
    
    /// Регулярное выражение для валидации разрешенных символов во время ввода дробного числа
    public static let floatNumberInputPattern = "^(\\d{0,10})(([.,]{1}\\d{0,2}$)|$)"
    
    /// Регулярное выражение проверяющие email адрес
    public static let emailRegexp = "^[ ]*[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}[ ]*$"
    
    /// Регулярное выражение проверяющие гос. номер автомобиля
    public static let licensePlateRegexp
        = "(^[АВЕКМНОРСТУХавекмнорстух0-9]{6,9}$)|(^[ABEKMHOPCTYXDabekmhopctyxd0-9]{6,10}$)"
    
    /// Регулярное выражение для валидации разрешенных символов во время ввода гос. номера автомобиля
    public static let licensePlateInputPattern
        = "(^[АВЕКМНОРСТУХавекмнорстух0-9]{0,9}$)|(^[ABEKMHOPCTYXDabekmhopctyxd0-9]{0,10}$)"
    
    /// Регулярное выражение для валидации разрешенных символов во время ввода VIN
    public static let vinInputPattern = "^[A-HJ-NPR-Za-hj-npr-z0-9]{0,17}$"
    
    /// Регулярное выражение проверяющие VIN автомобиля
    public static let vinRegexp = "[A-HJ-NPR-Z0-9]{17}"
    
    /// Регулярное выражение для валидации разрешенных символов во время ввода номера ПТС
    public static let vehicleLicenseInputPattern = "^[0-9А-Яа-я]{0,15}$"
    
    /// Регулярное выражение проверяющие номер ПТС
    ///
    /// Если ПТС обычный:
    ///     Серия: 2 цифры, потом 2 буквы или 2 цифры
    ///     Номер: 6 цифр.
    ///     (Пример: 21ПП231234)
    ///
    /// Если ПТС электронный:
    ///     15 цифр.
    ///     (Пример: 123456789012345)
    public static let vehicleLicenseRegexp = "^[0-9]{2}((([А-Я]|[0-9]){2}[0-9]{6}$)|([0-9]){13}$)"
}
