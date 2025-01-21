

import Foundation
import SwiftUI

class MailComposer {
    let refModel: DataModel
    
    init(refModel: DataModel) {
        self.refModel = refModel
    }
    
    func getExchangersAndTimesTableBody(_ date: Date)->String{
        var content = ""
        let dishesAtDay = self.refModel.getDishesAtDay(date: date)
        
        for dish in dishesAtDay {
            let time = dish.date
            let sumWW = dish.getSumWW()
            let sumWbt = dish.getSumWbt()
            
            content =
            """
            \(content)
            <tr>
                <td>\(getFormatInHHMM(time))</td>
                <td>\(sumWW)</td>
                <td>\(sumWbt)</td>
            </tr>

            """
        }
        
        return content
    }
    
    func getGlucoseLevelsTableBody(_ date: Date)->String{
        var content = ""
        
        let glucoseAtDay = self.refModel.getGlucoseAtDay(date: date)
        for reading in glucoseAtDay {
            let time = reading.timeOfMeasurement
            let level = reading.measuredValue
            
            content =
            """
            \(content)
            <tr>
                <td>\(getFormatInHHMM(time))</td>
                <td>\(level)</td>
            </tr>
            """
        }
        
        return content
    }
    
    func prepareContentOfDiv(_ date: Date)->String {
        let toRet =
        """
        <h2>
            \(getFormatInDDMMYYYY(date, sep: "-"))
        </h2>
        <h3>
            Glucose levels
        </h3>
        <table>
            <tr>
                <td>Time</td>
                <td>Level</td>
            </tr>
            \(getGlucoseLevelsTableBody(date))
        </table>
        <h3>
            Exchangers levels
        </h3>
        <table>
            <tr>
                <td>Time</td>
                <td>WW</td>
                <td>Wbt</td>
            </tr>
            \(getExchangersAndTimesTableBody(date))
        </table>
        """
        
        return toRet
    }
    
    func createMailDivForDate(_ date: Date) -> String{
        let toRet =
        """
        <div style="background: #aaaaaa;padding:10px;border-radius: 20px;margin-bottom: 10px;">
            \(prepareContentOfDiv(date))
        </div>
        """
        
        return toRet
    }
    
    func prepareTextForMail(_ startDate: Date, _ endDate: Date)->String {
        var bodyContent = ""
        
        for includedDate in getInclusiveDatesRange(
            startDate: startDate,
            endDate: endDate
        ) {
            bodyContent =
            """
            \(bodyContent)
            \(createMailDivForDate(includedDate))
            """
        }
        
        let toRet =
        """
        <html>
            <head>
                <style>
                    table {
                        width: 200px;
                        border-collapse: collapse;
                    }
                    td {
                        text-align: left;
                    }
                    .name {
                        width: 30%;
                        font-weight: bold;
                    }
                    .value {
                        width: 70%;
                        padding-left: 20px;
                    }
                </style>
            </head>
            <body>
                \(bodyContent)
            </body>
        </html>
        """
        
        return toRet
    }
    
    
    @MainActor func getImageForDate(_ date: Date)->Data?{
        let stateForChart = GlucoseAtDateState(
            dataModel: self.refModel,
            dateToPick: date
        )
        let viewToRender = ChartAtDate(chartState: stateForChart)

        
        let size = CGSize(width: 500, height: 500)
        let renderingResult = renderViewToPNG(
            viewToConvert: viewToRender,
            size: size
        )
        return renderingResult
    }
    
    @MainActor func getImagesForEmail(_ startDate: Date, _ endDate: Date)->[ImageData]{
        var images: [ImageData] = []
        
        for includedDate in getInclusiveDatesRange(
            startDate: startDate,
            endDate: endDate
        ) {
            if let renderedImage = getImageForDate(includedDate) {
                let dataToInsert = ImageData(
                    imageName: "ChartAt\(getFormatInDDMMYYYY(includedDate, sep: "-"))",
                    actualImage: renderedImage
                )
                images.append(dataToInsert)
            }
        }
        
        return images
    }
    
    @MainActor func prepareTextAndImagesForMail(_ startDate: Date, _ endDate: Date)->(String, [ImageData]){
        let textOfMail = prepareTextForMail(startDate, endDate)
        let images = getImagesForEmail(startDate, endDate)
        
        return (textOfMail, images)
    }
}
