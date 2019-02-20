import UIKit

class RecordsViewController: UIViewController, Contextual {
    var context: Context?
    
    
    @IBOutlet weak var tableView: UITableView!
    private var currentRecord: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContext()
        configureTableView()
        
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
    
    func initContext() {
        context = Context.createFileContext()
    }
    
    func configureTableView() {
        tableView.separatorStyle = .singleLine
        let nibName = UINib(nibName: "RecordCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "RecordCell")
    }
}

extension RecordsViewController {
    @IBAction func didTouchAddButton(_ sender: UIBarButtonItem) {
        let identifier = NewRecordViewController.storyboardIndentifier
        let storyboard = UIStoryboard(name: identifier, bundle: Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! NewRecordViewController
        rootViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: rootViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension RecordsViewController: NewRecordViewControllerDelegate {
    func newRecordViewController(sender: NewRecordViewController, didFinishWithRecord record: Record?) {
        dismiss(animated: true, completion: nil)
        print("cancel1")
        guard let record = record  else { return }
        context?.recordsManager.addRecord(record: record)
        tableView.reloadData()
    }
}

extension RecordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return context?.recordsManager.records.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        cell.configure(with: (context?.recordsManager.records[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let record = context?.recordsManager.records[indexPath.row]
            context?.recordsManager.deleteRecord(cid: (record?.id)!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension RecordsViewController: UITableViewDelegate, UpdateRecordViewControllerDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let record = context?.recordsManager.records[indexPath.row] else {
            return
        }
        currentRecord = record
        
        let identifier = UpdateRecordViewController.storyboardIndentifier
        let storyboard = UIStoryboard(name: identifier, bundle: Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! UpdateRecordViewController
        rootViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: rootViewController)
        present(navigationController, animated: true, completion: nil)
        
    }
    
    func updateRecordViewController(host: UpdateRecordViewController) -> Record {
        return currentRecord!
    }
    
    func updateRecordViewController(host: UpdateRecordViewController, newRecord: Record) {
        
        context?.recordsManager.updateRecord(cid: (currentRecord?.id)!, newRecord: newRecord)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    func didFinishWithCancel() {
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func didFinishWithoutChanges() {
        dismiss(animated: true, completion: nil)
    }
    
    
}






