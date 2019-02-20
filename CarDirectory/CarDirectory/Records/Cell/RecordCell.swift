import UIKit


class RecordCell: UITableViewCell {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var bodyTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
    func configure(with model: Record) {
        yearLabel.text = model.year
        modelLabel.text = model.model
        manufacturerLabel.text = model.manufacturer
        classificationLabel.text = model.classification
        bodyTypeLabel.text = model.bodyType
    }
}

