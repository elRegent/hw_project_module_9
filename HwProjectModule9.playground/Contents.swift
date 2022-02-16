import UIKit

/** характеристики */
let controlMode = "manual" // режим управления manual или autopilot
let weight = 2108 // кг
let length = 4976 // мм
let width = 1963 // мм
let height = 1435 // мм
let wheelbase = 2959 // мм
let clearance = 154.9 // мм
let trunkVolume = 900 // л

/** начальные параметры */
var musicVolume = 0 // громкость 0..10
var musicChannel = 1 // канал 1..6
var sunroofOpenLevel = 0 // процент открытия крыши
var blowingFanSpeed = 0 // 0..5 скорость обдува
var climatControlTemp = 20 // температура градусов
var climatControlAirConditionEnabled = false // включение кондиционера

/** закладываем набор ошибок */
enum AutoError: Error {
    case tooLoudMusic // Выше максимальной громкости
    case tooQuietMusic // Ниже нуля
}

func autoDrive() throws {
    if musicVolume > 10 {
        throw AutoError.tooLoudMusic
    }
    if musicVolume < 0 {
        throw AutoError.tooQuietMusic
    }
}
    
// пробуем присваивать новые значения
musicVolume = 11

do {
    try autoDrive()
} catch AutoError.tooLoudMusic {
    print("Музыкальная система не предусмотрена для более громкого звука!")
} catch AutoError.tooQuietMusic {
    print("Недопустимо отрицательное значение громкости!")
}
