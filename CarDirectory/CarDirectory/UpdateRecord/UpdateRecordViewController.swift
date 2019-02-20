import UIKit

protocol UpdateRecordViewControllerDelegate: AnyObject {
    func updateRecordViewController(host: UpdateRecordViewController, newRecord: Record)
    func updateRecordViewController(host: UpdateRecordViewController) -> Record
    func didFinishWithCancel()
    func didFinishWithoutChanges()
}

class UpdateRecordViewController: UIViewController {
    
    static let storyboardIndentifier: String = "UpdateRecordViewController"
    
    var currentRecord: Record?
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var bodyTypeLabel: UILabel!
    
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var classificationTextField: UITextField!
    @IBOutlet weak var bodyTypeTextField: UITextField!
    
    weak var delegate: UpdateRecordViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        getCurrentRecord()
    }
}

extension UpdateRecordViewController {
    
    func getCurrentRecord() {
        let newValueText = "New value"
        currentRecord = delegate?.updateRecordViewController(host: self)
        yearLabel.text = "Year: \(currentRecord!.year)"
        modelLabel.text = "Model: \(currentRecord!.model)"
        manufacturerLabel.text = "Manufacturer: \(currentRecord!.manufacturer)"
        classificationLabel.text = "Classification: \(currentRecord!.classification)"
        bodyTypeLabel.text = "Body type: \(currentRecord!.bodyType)"
        
        yearTextField.placeholder = newValueText
        modelTextField.placeholder = newValueText
        manufacturerTextField.placeholder = newValueText
        classificationTextField.placeholder = newValueText
        bodyTypeTextField.placeholder = newValueText
    }
    
    func updateRecord() {
        
        var yearText = yearTextField.text
        var modelText = modelTextField.text
        var manufacturerText = manufacturerTextField.text
        var classificationText = classificationTextField.text
        var bodyTypeText = bodyTypeTextField.text
        
        if (yearText!.isEmpty &&
            modelText!.isEmpty &&
            manufacturerText!.isEmpty &&
            classificationText!.isEmpty &&
            bodyTypeText!.isEmpty) { delegate?.didFinishWithoutChanges() }
        
        if (yearText!.isEmpty) { yearText = currentRecord?.year }
        if (modelText!.isEmpty) { modelText = currentRecord?.model }
        if (manufacturerText!.isEmpty) { manufacturerText = currentRecord?.manufacturer }
        if (classificationText!.isEmpty) { classificationText = currentRecord?.classification }
        if (bodyTypeText!.isEmpty) { bodyTypeText = currentRecord?.bodyType }
        
        let newRecord =  Record(year: yearText!, model: modelText!, manufacturer: manufacturerText!,
                                classification: classificationText!, bodyType: bodyTypeText!)
        
        delegate?.updateRecordViewController(host:self, newRecord: newRecord)
    }
    
    func setupNavbar() {
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                            action: #selector(UpdateRecordViewController.didTouchCancelBarButtonItem))
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self,
                                             action: #selector(UpdateRecordViewController.didTouchSaveBarButtonItem))
        
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func didTouchCancelBarButtonItem() {
        delegate?.didFinishWithCancel()
    }
    
    @objc func didTouchSaveBarButtonItem() {
        _ = updateRecord()
    }
    
}
