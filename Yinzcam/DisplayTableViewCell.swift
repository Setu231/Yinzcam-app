//
//  DisplayTableViewCell.swift
//  Yinzcam
//
//  Created by Setu Desai on 5/9/21.
//

import UIKit

class DisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblScore1: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOpponentTeam: UILabel!
    @IBOutlet weak var lblScore2: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var lblDisplayPlace: UILabel!
    @IBOutlet weak var lblDisplayHC: NSLayoutConstraint!
    @IBOutlet weak var lblEndHC: NSLayoutConstraint!
    @IBOutlet weak var viewCurve: UIView!
    @IBOutlet weak var viewHidden: UIView!
    @IBOutlet weak var imgOpponent: UIImageView!
    @IBOutlet weak var imgHomeTeam: UIImageView!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var lblBye: UILabel!
    @IBOutlet weak var lblWeekHidden: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
