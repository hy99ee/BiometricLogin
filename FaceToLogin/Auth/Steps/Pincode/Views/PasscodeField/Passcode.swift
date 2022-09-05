import Combine

fileprivate let emptyPin: Character = "○"
fileprivate let fillPin: Character = "◉"
fileprivate let defaultPasscode = [emptyPin, emptyPin, emptyPin, emptyPin]

protocol PasscodeType: ObservableObject {
    var passcode: AnyPublisher<[Int], Never> { get }
}

class Passcode: PasscodeType {
    @Published var visiblePasscode: String = String(defaultPasscode)
    @Published private(set) var isFull: Bool = false

    private var checkIsFull: Bool { elements.count == maxCount }

    lazy var passcode = AnyPublisher<[Int], Never>(_passcode)
    private let _passcode: PassthroughSubject<[Int], Never> = .init()

    let newElement: PassthroughSubject<Int, Never> = .init()
    let removeElement: PassthroughSubject<Void, Never> = .init()
    let reset: PassthroughSubject<Void, Never> = .init()

    var emptyInputPasscode: Bool { !visiblePasscode.contains(fillPin) }

    private let maxCount: Int
    
    private var elements: [Int] = []
    
    private var cancelBag: CancelBag = []

    init(maximum maxCount: Int = 4) {
        self.maxCount = maxCount
        
        setupBindings()
    }

    private func setupBindings() {
        $isFull
            .filter { $0 }
            .map { [unowned self] _ in elements }
            .subscribe(_passcode)
            .store(in: &cancelBag)

        newElement
            .filter { [unowned self] _ in !isFull }
            .compactMap{ [unowned self] in append($0) }
            .mapToSecureField(lenght: maxCount)
            .assign(to: &$visiblePasscode)
        
        removeElement
            .filter { [unowned self] _ in elements.count > 0 }
            .compactMap{ [unowned self] _ in removeLast() }
            .mapToSecureField(lenght: maxCount)
            .assign(to: &$visiblePasscode)
        
        reset
            .map { [] }
            .handleEvents(receiveOutput: {[unowned self] in
                elements = $0
                visiblePasscode = String(defaultPasscode)
                isFull = false
            })
            .subscribe(_passcode)
            .store(in: &cancelBag)
        
            
            
    }
    
    private func append(_ newElement: Int) -> [Int] {
        elements.append(newElement)

        if case maxCount = elements.count { isFull = true }

        return elements

    }

    private func removeLast() -> [Int] {
        elements.removeLast()

        isFull = false

        return elements
    }
}

fileprivate extension Publisher where Output == [Int], Failure == Never {
//    func append(_ element: Int) -> AnyPublisher<Output, Failure> {
//        self
//            .map { $0.append(element) }
//            .eraseToAnyPublisher()
//    }
    
    func mapToSecureField(lenght passcodeLenght: Int) -> AnyPublisher<String, Never> {
        self
            .compactMap { mapFrom(passcode: $0, lenght: passcodeLenght) }
            .eraseToAnyPublisher()
    }
    
    private func mapFrom(passcode: [Int], lenght: Int) -> String {
        var emptyField: [Character] = []
        for i in 0..<lenght { emptyField.append(
            passcode.count <= i
            ? emptyPin
            : fillPin
        )}

        return String(emptyField)
    }
}
