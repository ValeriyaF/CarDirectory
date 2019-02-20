import Foundation
import SQLite

class RecordsManagerSQLite: RecordsManagerType {
    private(set) lazy var records: [Record] = [Record]()
    
    static let instance = RecordsManagerSQLite()
    private var db: Connection? = nil
    private static let recordsTableName = "recordsTable"
    private let recordsTable = Table(recordsTableName)
    
    private let id = Expression<Int64>("id")
    private let year = Expression<String>("year")
    private let model = Expression<String>("model")
    private let manufacturer = Expression<String>("manufacturer")
    private let classification = Expression<String>("classification")
    private let bodyType = Expression<String>("bodyType")
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/RecordsManagerSQLite.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        createTable()
        records = getRecords()
    }
    
    func tableExists(tableName: String) -> Bool {
        do { return try
            db?.scalar(
                "SELECT EXISTS (SELECT * FROM sqlite_master WHERE type = 'table' AND name = ?)",
                tableName
            ) as! Int64 > 0
        }
        catch {
            
        }
        
        return false
    }
    
    func createTable() {
        do {
            
            if (!tableExists(tableName: RecordsManagerSQLite.recordsTableName)) {
                
                try db?.run(recordsTable.create(ifNotExists: true) { table in
                    table.column(id, primaryKey: true)
                    table.column(year)
                    table.column(model)
                    table.column(manufacturer)
                    table.column(classification)
                    table.column(bodyType)
                })
                
                for index in 0..<3 {
                    let rec: Record = Record(year: String(1337 + index), model: "SuperMega", manufacturer: "China", classification: "Binary", bodyType: "Strong")
                    addRecord(record: rec)
                }
            }
        } catch {
            print("Unable to create table")
        }
    }
    
    func addRecord(record: Record) {
        do {
            let insert = recordsTable.insert(year <- record.year, model <- record.model, manufacturer <- record.manufacturer, classification <- record.classification, bodyType <- record.bodyType)
            let id = try db!.run(insert)
            records.append(Record(id: id, year: record.year, model: record.model, manufacturer: record.manufacturer, classification: record.classification, bodyType: record.bodyType))
        } catch {
            print("Insert failed")
        }
    }
    
    func deleteRecord(cid: Int64) {
        do {
            let record = recordsTable.filter(id == cid)
            try db!.run(record.delete())
            for index in 0..<records.count {
                if records[index].id == cid {
                    records.remove(at: index)
                    break
                }
            }
        } catch {
            print("Delete failed")
        }
    }
    
    func updateRecord(cid:Int64, newRecord: Record) {
        let record = recordsTable.filter(id == cid)
        do {
            let update = record.update([
                year <- newRecord.year,
                model <- newRecord.model,
                manufacturer <- newRecord.manufacturer,
                classification <- newRecord.classification,
                bodyType <- newRecord.bodyType
                ])
            if try db!.run(update) > 0 {
                for index in 0..<records.count {
                    if records[index].id == cid {
                        records[index] = newRecord
                        records[index].id = cid
                        break
                    }
                }
            }
        } catch {
            print("Update failed: \(error)")
        }
    }
}

private extension RecordsManagerSQLite {
    
    func getRecords() -> [Record] {
        
        var records = [Record]()
        guard let db = self.db else {
            return []
        }
        
        do {
            for record in try db.prepare(self.recordsTable) {
                records.append(Record(id: Int64(record[id]), year: record[year], model: record[model], manufacturer: record[manufacturer], classification: record[classification], bodyType: record[bodyType]))
            }
        } catch {
            print("Select failed")
        }
        
        return records
    }
    
}

