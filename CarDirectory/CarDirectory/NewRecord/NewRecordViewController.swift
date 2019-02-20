import UIKit

protocol NewRecordViewControllerDelegate: AnyObject {
    func newRecordViewController(sender: NewRecordViewController, didFinishWithRecord record: Record?)
}

class NewRecordViewController: UIViewController {
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var classificationTextField: UITextField!
    @IBOutlet weak var bodyTypeTextField: UITextField!
    
    weak var delegate: NewRecordViewControllerDelegate?
    
    static let storyboardIndentifier: String = "NewRecordViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension NewRecordViewController {
    
    func showAlert() {
        let alertController = UIAlertController(title: "Can't save record", message: "Not all fields are filled", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func saveRecord() {
        guard let yearText = yearTextField.text,
            let modelText = modelTextField.text,
            let manufacturerText = manufacturerTextField.text,
            let classificationText = classificationTextField.text,
            let bodyTypeText = bodyTypeTextField.text,
            !yearText.isEmpty,
            !modelText.isEmpty,
            !manufacturerText.isEmpty,
            !classificationText.isEmpty,
            !bodyTypeText.isEmpty else {
                showAlert()
                return
        }
        
        let record = Record(year: yearText, model: modelText, manufacturer: manufacturerText, classification: classificationText, bodyType: bodyTypeText)
        delegate?.newRecordViewController(sender: self, didFinishWithRecord: record)
    }
}

private extension NewRecordViewController {
    func setupNavbar() {
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                            target: self, action: #selector(NewRecordViewController.didTouchCancelBarButtonItem))
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save,
                                             target: self, action: #selector(NewRecordViewController.didTouchSaveBarButtonItem))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc func didTouchCancelBarButtonItem() {
        delegate?.newRecordViewController(sender: self, didFinishWithRecord: nil)
    }
    
    @objc func didTouchSaveBarButtonItem() {
        saveRecord()
    }
    
}

