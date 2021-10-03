import RxCocoa
import RxSwift
import SGCommonHelpers
import SGUIKit
import UIKit

struct FormViewModel {
    var isDirty = false
    var name: String?
    var cardholder: String? = "IVAN PETROV"
    var intNumber: Int?
    var mileage: Int? = 45_000
    var doubleNumber: Double? = 19.95
    var phone: String?
    var year: Int? = 2004
    var comment: String? = "Some comment\nline 2\nline 3"
    var address: String? = "125130, Москва, Большой Кисловский пер.\nд. 10, стр. 2, кв. 76"
}

class FormViewController: UIViewController {

    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var scrollView: UIScrollView!
    
    private lazy var keyboardObservable: KeyboardObservable = KeyboardObservableImpl(presenter: self)
    private var viewModel = FormViewModel()
    
    private var strVM: FormTextFieldStringViewModel!
    private var nameVM: FormTextFieldStringViewModel!
    private var intVM: FormTextFieldIntViewModel!
    private var mileageVM: FormTextFieldGroupedNumberViewModel!
    private var doubleVM: FormTextFieldDoubleViewModel!
    private var phoneVM: FormTextFieldPhoneViewModel!
    private var yearVM: FormTextFieldYearViewModel!
    private var addressVM: FormMultilineTextFieldView.ViewModel!
    private var commentVM: FormTextView.ViewModel!
    
    private var groupingDelegate: GroupedNumberTextFieldFormatter?
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        keyboardObservable.bindKeyboardFrame(to: scrollView) { .zero }
        keyboardObservable.setupCloseKeyboardGesture()
    }
    
    private func setupUI() {
        let header = FormSectionHeaderView.make(with: "Заголовок секции")
        stackView.addArrangedSubview(header)
        
        strVM = .init(title: "Ввод текстового значения", value: .init(value: viewModel.name), validationModel: nil)
        strVM.value.bind(onNext: { [unowned self] in
            self.viewModel.name = $0
        }).disposed(by: disposeBag)
        let textField0 = FormTextFieldView.make(with: strVM)
        textField0.helpText = "Подсказка"
        stackView.addArrangedSubview(textField0)
        
        nameVM = .init(
            title: "Имя на карте",
            value: .init(value: viewModel.cardholder),
            keyboardType: .asciiCapable,
            autocapitalizationType: .allCharacters,
            validationModel: .cardholder
        )
        strVM.value.bind(onNext: { [unowned self] in self.viewModel.cardholder = $0 }).disposed(by: disposeBag)
        let textField1 = FormTextFieldView.make(with: nameVM)
        stackView.addArrangedSubview(textField1)
        
        intVM = .init(title: "Целое число", value: .init(value: viewModel.intNumber), validationClosure: nil)
        intVM.value.bind(onNext: { [unowned self] in self.viewModel.intNumber = $0 }).disposed(by: disposeBag)
        let textField2 = FormTextFieldView.make(with: intVM)
        stackView.addArrangedSubview(textField2)
        
        mileageVM = .init(
            title: "Число с группировкой разрядов",
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
            title: "Коментарий (не более 200 символов)",
            value: .init(value: viewModel.comment), charactersLimit: .limit(count: 200)
        )
        commentVM.value.bind(onNext: { [unowned self] in self.viewModel.comment = $0 }).disposed(by: disposeBag)
        let textView = FormTextView.make(with: commentVM)
        stackView.addArrangedSubview(textView)
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
