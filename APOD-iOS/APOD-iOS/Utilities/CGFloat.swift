import Foundation
import UIKit

// Scales the CGFloat value based on the screen width and device type
extension CGFloat {
    var scaled: CGFloat {
        self * UIScreen.main.bounds.width / 414.0 * (Utils.device == .iPad ? 0.8 : 1.0)
    }
}

extension Int {
    var scaled: CGFloat {
        CGFloat(self).scaled
    }
}

// Scales the CGSize dimensions (width and height)
extension CGSize {
    var scaled: CGSize {
        CGSize(width: self.width.scaled, height: self.height.scaled)
    }
}
