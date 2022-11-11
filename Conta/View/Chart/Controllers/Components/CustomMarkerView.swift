import Foundation
import Charts

class CustomMarkerView: MarkerView {
    var text = ""

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        super.refreshContent(entry: entry, highlight: highlight)
        text = String(entry.y)
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        var drawAttributes = [NSAttributedString.Key : Any]()
        drawAttributes[.font] = UIFont.systemFont(ofSize: 15)
        drawAttributes[.foregroundColor] = UIColor.white
        drawAttributes[.backgroundColor] = UIColor(named: K.colorRedOne)

        self.bounds.size = (" \(text) " as NSString).size(withAttributes: drawAttributes)
        self.offset = CGPoint(x: 0, y: -self.bounds.size.height - 2)

        let offset = self.offsetForDrawing(atPoint: point)

        drawText(text: " \(text) " as NSString, rect: CGRect(origin: CGPoint(x: point.x + offset.x, y: point.y + offset.y), size: self.bounds.size), withAttributes: drawAttributes)
    }

    func drawText(text: NSString, rect: CGRect, withAttributes attributes: [NSAttributedString.Key : Any]? = nil) {
        let size = text.size(withAttributes: attributes)
        let centeredRect = CGRect(x: rect.origin.x + (rect.size.width - size.width) / 2.0, y: rect.origin.y + (rect.size.height - size.height) / 2.0, width: size.width, height: size.height)
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
