import Foundation

protocol RecordsManagerType {
    
    func addRecord(record: Record)
    func deleteRecord(cid: Int64)
    func updateRecord(cid:Int64, newRecord: Record)
    var records: [Record] { get }
    
}

// 'ServiceLocator'

protocol Contextual {
    var context: Context? { get set }
}

class Context {
    let recordsManager: RecordsManagerType
    
    init(recordsManager: RecordsManagerType) {
        self.recordsManager = recordsManager
    }
}

extension Context {
    static func createFileContext() -> Context? {
        let rm: RecordsManagerType = RecordsManagerSQLite()
        let context = Context(
            recordsManager: rm
        )
        return context
    }
}

