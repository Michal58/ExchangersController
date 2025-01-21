

import Foundation


func calcWW(_ carbValue:Int)->Int{
    carbValue/10
}

func calcWbt(_ protValue:Int, _ fatValue: Int)->Int {
    (4*protValue+9*fatValue)/100
}

func calcKcal(_ carbValue: Int, _ protValue: Int, _ fatValue: Int)->Int {
    4*(carbValue+protValue)+9*fatValue
}
