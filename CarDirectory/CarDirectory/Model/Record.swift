import Foundation

struct Record {
    var id: Int64 = 0
    let year: String
    let model: String
    let manufacturer: String
    let classification: String
    let bodyType: String
    
    init(id: Int64, year: String, model: String, manufacturer: String,
         classification: String, bodyType: String) {
        self.id = id
        self.year = year
        self.model = model
        self.manufacturer = manufacturer
        self.classification = classification
        self.bodyType = bodyType
    }
    
    init(year: String, model: String, manufacturer: String,
         classification: String, bodyType: String) {
        self.year = year
        self.model = model
        self.manufacturer = manufacturer
        self.classification = classification
        self.bodyType = bodyType
    }
}

