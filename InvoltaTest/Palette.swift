import Foundation
import UIKit

enum Palette: String {
    case lDark_dWhite
    case lWhite_dDark
    
     var color: UIColor {
         guard let color = UIColor(named: self.rawValue) else {
             return UIColor.clear
         }
         return color
    }
    
    static func color(for palette: Palette) -> UIColor {
        return palette.color
    }
}
