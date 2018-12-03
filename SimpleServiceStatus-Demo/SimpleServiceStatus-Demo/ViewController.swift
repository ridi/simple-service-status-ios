import UIKit
import SimpleServiceStatus

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.serviceStatusAlertChecker.delegate = self
    }
}

// MARK: - ServiceStatusAlertCheckerDelegate

extension ViewController: ServiceStatusAlertCheckerDelegate {
    func alertCheckerRequiresHandling(of alert: AlertService.Alert) -> Bool {
        textView.text = "\(textView.text ?? "")\n\n\nReceived At: \(Date().description(with: Locale.current))\nID: \(alert.id)\nTitle: \(alert.title)\nType: \(alert.type)\nContents: \(alert.contents)"
        textView.scrollRangeToVisible(NSRange(location: textView.text.count - 1, length: 1))
        return true
    }
    
    func alertCheckerEncountered(_ backendError: AlertService.BackendError) {
        switch backendError {
        case .network(let error):
            NSLog(error.localizedDescription)
        case .jsonSerialization(let error):
            NSLog(error.localizedDescription)
        case .objectConstruction(let reason):
            NSLog(reason)
        }
    }
}
