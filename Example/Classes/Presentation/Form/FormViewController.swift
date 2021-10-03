import RxCocoa
import RxSwift
import SGCommonHelpers
import SGUIKit
import UIKit

struct FormViewModel {
    var isDirty = false
    var name: String?
    var intNumber: Int?
    var mileage: Int? = 45_000
    var doubleNumber: Double? = 19.95
    var phone: String?
    var year: Int? = 2004
    var comment: String? = "Some\ncomment\n1\n2\n3\n4\n5\n6"
    var address: String? = "Москва, Большой Кисловский пер. д. 10, стр. 2, кв. 76"
}

class FormViewController: UIViewController {

    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var scrollView: UIScrollView!
    
    private lazy var keyboardObservable: KeyboardObservable = KeyboardObservableImpl(presenter: self)
    private var viewModel = FormViewModel()
    
    private var switchVM: FormSwitchView.ViewModel!
    private var switch2VM: FormSwitchView.ViewModel!
    private var strVM: FormTextFieldStringViewModel!
    private var intVM: FormTextFieldIntViewModel!
    private var mileageVM: FormTextFieldGroupedNumberViewModel!
    private var doubleVM: FormTextFieldDoubleViewModel!
    private var phoneVM: FormTextFieldPhoneViewModel!
    private var yearVM: FormTextFieldYearViewModel!
    private var addressVM: FormMultilineTextFieldView.ViewModel!
    private var commentVM: FormTextView.ViewModel!
    private var comment2VM: FormTextView.ViewModel!
        
    private weak var groupingDelegate: GroupedNumberTextFieldFormatter?
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        keyboardObservable.bindKeyboardFrame(to: scrollView) { -self.view.safeAreaInsets.bottom }
    }
    
    private func setupUI() {
        let header = FormSectionHeaderView.make(with: "Заголовок секции")
        stackView.addArrangedSubview(header)
        
        switchVM = .init(title: "Переключатель", value: .init(value: viewModel.isDirty))
        switchVM.value.bind(onNext: { [unowned self] in self.viewModel.isDirty = $0 }).disposed(by: disposeBag)
        let switchView = FormSwitchView.make(with: switchVM)
        stackView.addArrangedSubview(switchView)
        
        let vm = FormButtonCellView.ViewModel(
            title: "Кнопка",
            value: "Выберите значение",
            isEnabled: true,
            tapAction: nil
        )
        let button = FormButtonCellView.make(with: vm)
        stackView.addArrangedSubview(button)
        
        let vm1 = FormButtonCellView.ViewModel(
            title: "Кнопка c disclosure индикатором",
            value: "Выберите значение",
            isEnabled: true,
            shouldShowDisclosureIndicator: true,
            tapAction: nil
        )
        let button1 = FormButtonCellView.make(with: vm1)
        stackView.addArrangedSubview(button1)
        
        let dateVm = FormDatePickerView.ViewModel(
            title: "Дата",
            value: .init(value: nil),
            minDate: Date().addingTimeInterval(-864_000),
            maxDate: Date().addingTimeInterval(864_000),
            dateFormatter: .mscDayMonthFullYearFormatter,
            shouldUpdateWhileScrolling: true,
            validationClosure: {
                guard let date = $0 else { return .invalid }
                return date < Date() ? .valid : .failure(.init("Дата не должна быть в будущем"))
            }
        )
        let datePicker = FormDatePickerView.make(with: dateVm)
        datePicker.helpText = "Выберите дату ДТП"
        stackView.addArrangedSubview(datePicker)
        
        strVM = .init(title: "Ввод текстового значения", value: .init(value: viewModel.name), validationModel: nil)
        strVM.value.bind(onNext: { [unowned self] in
            self.viewModel.name = $0
        }).disposed(by: disposeBag)
        let textField0 = FormTextFieldView.make(with: strVM)
        textField0.helpText = "Подсказка"
        stackView.addArrangedSubview(textField0)
        
        intVM = .init(title: "Целое число", value: .init(value: viewModel.intNumber), validationModel: nil)
        intVM.value.bind(onNext: { [unowned self] in self.viewModel.intNumber = $0 }).disposed(by: disposeBag)
        let textField2 = FormTextFieldView.make(with: intVM)
        stackView.addArrangedSubview(textField2)
        
        mileageVM = .init(
            title: "Пробег",
            value: .init(value: viewModel.mileage),
            validationModel: .mileage
        )
        mileageVM.value.bind(onNext: { [unowned self] in self.viewModel.mileage = $0 }).disposed(by: disposeBag)
        let textField3 = FormTextFieldView.make(with: mileageVM)
        groupingDelegate = GroupedNumberTextFieldFormatter(maxDigits: 7)
        textField3.textField.delegate = groupingDelegate
        stackView.addArrangedSubview(textField3)
        
        doubleVM = .init(
            title: "Дробное число",
            value: .init(value: viewModel.doubleNumber),
            formatter: .realNumberFormatter
        )
        doubleVM.value.bind(onNext: { [unowned self] in self.viewModel.doubleNumber = $0 }).disposed(by: disposeBag)
        let textField4 = FormTextFieldView.make(with: doubleVM)
        stackView.addArrangedSubview(textField4)
        
        phoneVM = .init(title: "Телефон", value: .init(value: viewModel.phone))
        phoneVM.value.bind(onNext: { [unowned self] in self.viewModel.phone = $0 }).disposed(by: disposeBag)
        let textField5 = FormTextFieldView.make(with: phoneVM)
        stackView.addArrangedSubview(textField5)
        
        yearVM = .init(title: "Год", value: .init(value: viewModel.year))
        yearVM.value.bind(onNext: { [unowned self] in self.viewModel.year = $0 }).disposed(by: disposeBag)
        let textField6 = FormTextFieldView.make(with: yearVM)
        stackView.addArrangedSubview(textField6)
        
        addressVM = .init(title: "Адрес", value: .init(value: viewModel.address), validationClosure: { text in
            ValidationResult(text?.count ?? 0 > 2)
        })
        let multilineTextField = FormMultilineTextFieldView.make(with: addressVM)
        stackView.addArrangedSubview(multilineTextField)
        
        commentVM = .init(
            title: "Повреждения, не относящиеся к страховому случаю",
            value: .init(value: viewModel.comment), charactersLimit: .limit(count: 50)
        )
        commentVM.value.bind(onNext: { [unowned self] in self.viewModel.comment = $0 }).disposed(by: disposeBag)
        let textView = FormTextView.make(with: commentVM)
        stackView.addArrangedSubview(textView)
        
        comment2VM = .init(
            title: "Коментарий (необязательно)",
            value: .init(value: nil), charactersLimit: .limit(count: 200)
        )
        let textView2 = FormTextView.make(with: comment2VM)
        stackView.addArrangedSubview(textView2)
    }

}

extension NumberFormatter {
    
    static var realNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .down
        return formatter
    }
    
}

extension DateFormatter {
    
    static let mscDayMonthFullYearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
}
