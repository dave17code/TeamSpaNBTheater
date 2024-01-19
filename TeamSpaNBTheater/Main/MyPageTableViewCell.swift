//
//  MyPageTableViewCell.swift
//  TeamSpaNBTheater
//
//  Created by woonKim on 2024/01/19.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = "cell"
    
    @IBOutlet weak var bookMovieDate: UILabel!
    @IBOutlet weak var bookMovieTitle: UILabel!
    @IBOutlet weak var bookPepleCount: UILabel!
    @IBOutlet weak var bookMovieStartTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
