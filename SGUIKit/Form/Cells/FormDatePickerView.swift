import RxCocoa
import RxSwift
import SGCommonHelpers
import UIKit

/// Ячейка для выбора даты (использует TextField и UIDatePicker)
public final class FormDatePickerView: UIView, Validatable {
    
    private enum Constants {
        static let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        static let height: CGFloat = 88
        static let datePickerLocale = Locale(identifier: "ru_RU")
        static let toolbarButtonTitle = "Выбрать"
    }
    
    // MARK: - Private properties
    
    private var disposeBag = DisposeBag()
    private var textField = StyledTextField()
    private var selectedDate = BehaviorRelay<Date?>(value: nil)
    private var dateFormatter: DateFormatter?
    private var shouldUpdateWhileScrolling: Bool = false
    private var validationClosure: ((Date?) -> ValidationResult)?
    
    // MARK: - Public properties
    
    public var valueChangedAction: DateClosure?
    public var detailText: String? {
        set {
            textField.detailText = newValue
        }
        get {
            textField.detailText
        }
    }
    
    public var helpText: String? {
        set {
            textField.helpText = newValue
        }
        get {
            textField.helpText
        }
    }
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Fabric method
    
    public static func make(with viewModel: ViewModel) -> FormDatePickerView {
        let view = FormDatePickerView()
        view.configure(with: viewModel)
        return view
    }
    
    // MARK: - Public methods
    
    public func configure(with viewModel: ViewModel) {
        textField.title = viewModel.title
        textField.isEnabled = viewModel.isEnabled
        dateFormatter = viewModel.dateFormatter
        shouldUpdateWhileScrolling = viewModel.shouldUpdateWhileScrolling
        validationClosure = viewModel.validationClosure
        
        guard let datePicker = textField.inputView as? UIDatePicker else { return }
        datePicker.timeZone = viewModel.dateFormatter.timeZone
        datePicker.minimumDate = viewModel.minDate
        datePicker.maximumDate = viewModel.maxDate
        datePicker.datePickerMode = viewModel.dateMode
        
        if let date = viewModel.value.value {
            datePicker.date = date
            updateSelectedDate(date)
            validate()
        } else {
            textField.text = nil
        }
        selectedDate.bind(to: viewModel.value).disposed(by: disposeBag)
        
        reloadInputViews()
    }
    
    /// Проверяет введенное значение на валидность и меняет стиль контрола
    @discardableResult
    public func validate() -> Bool {
        textField.validationClosure = { [weak self] _ in
            guard let validationClosure = self?.validationClosure else { return .valid }
            return validationClosure(self?.selectedDate.value)
        }
        return textField.validate()
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        addSubview(textField, activate: [
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.insets.left),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.insets.right),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: Constants.insets.top),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.insets.bottom),
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.height)
        ])
        textField.delegate = self
        textField.inputView = buildDatePicker()
        textField.inputAccessoryView = UIToolbar.makeToolbar(
            doneTitle: Constants.toolbarButtonTitle,
            target: self,
            selector: #selector(didFinishSelectingDate)
        )
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        textField.rx.controlEvent(.editingDidEnd).bind(onNext: { [weak self] in
            self?.validate()
        }).disposed(by: disposeBag)
    }
    
    private func buildDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.locale = Constants.datePickerLocale
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(didPickDate(_:)), for: .valueChanged)
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        return datePicker
    }
    
    private func updateSelectedDate(_ date: Date) {
        guard let dateFormatter = dateFormatter else { return }
        let dateString = dateFormatter.string(from: date)
        let capitalizedDateString = dateString.prefix(1).uppercased() + dateString.dropFirst()
        textField.text = capitalizedDateString
        selectedDate.accept(date)
        valueChangedAction?(date)
    }
    
    @objc private func didPickDate(_ datePicker: UIDatePicker) {
        guard shouldUpdateWhileScrolling else { return }
        updateSelectedDate(datePicker.date)
    }
    
    @objc private func didFinishSelectingDate() {
        guard let datePicker = textField.inputView as? UIDatePicker else { return }
        if let minDate = datePicker.minimumDate, datePicker.date < minDate {
            if let maxDate = datePicker.maximumDate, minDate <= maxDate {
                // Если в DatePicker выбрана дата, которая не попадает в диапазон [minDate..maxDate],
                // ставим минимально валидную дату
                updateSelectedDate(minDate)
            } else {
                // DatePicker в неконсистентном состоянии (minDate > maxDate)
                updateSelectedDate(datePicker.date)
            }
        } else {
            updateSelectedDate(datePicker.date)
        }
        _ = textField.resignFirstResponder()
    }
}

extension FormDatePickerView: UITextFieldDelegate {
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        // Ограничение вставки текста не из пикера даты
        false
    }
    
}

// MARK: - Rx

public extension Reactive where Base: FormDatePickerView {
    
    var viewModel: Binder<FormDatePickerView.ViewModel> {
        Binder(base) { view, vm in
            view.configure(with: vm)
        }
    }
}
