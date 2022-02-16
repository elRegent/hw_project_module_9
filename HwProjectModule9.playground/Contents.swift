import UIKit

/** характеристики */
let weight = 2108 // кг
let length = 4976 // мм
let width = 1963 // мм
let height = 1435 // мм
let wheelbase = 2959 // мм
let clearance = 154.9 // мм
let trunkVolume = 900 // л

/** начальные параметры */
/** оперировать будем через методы set get swith */
/** в дальнейшем когда дойдем до классов переменные можно будет сделать приватными, а методы публичными */
var currentControlMode = "manual" // manual autopilot
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
    case tooHotForAirCondition // Слишком высокая температура для включенного кондиционера
    case tooColdForAirCondition // Слишком низкая температура для включенного кондиционера
    case tooHighTemp // температуру выше 25 задавать нельзя
    case tooLowTemp // температуру ниже 1 задавать нельзя
    case incorrectChannel // недопустимый идентификатор канала
    case incorrectSunroofOpenLevel // некорректно заданный процент открытия крыши
    case incorrectBlowingFanSpeed // некорректная скорость обдува
}

/** режим управления */
func switchControlMode() {
    if (currentControlMode == "manual") {
        currentControlMode = "autopilot"
        print("Внимание! Включен автопилот, следите за дорогой!")
    } else {
        currentControlMode = "manual"
        print("Внимание! Автопилот выключен, включено ручное управление!")
    }
}

// установка значения через метод
func setMusicVolume(newValue: Int) throws {
    if newValue > 10 {
        throw AutoError.tooLoudMusic
    }
    if newValue < 0 {
        throw AutoError.tooQuietMusic
    }
    // присваиваем после выброса ошибки, чтобы не получилось что несмотря на ошибку значение стало 11
    musicVolume = newValue
}

// установка значения температуры через метод
func setClimatControlTemp(newValue: Int) throws {
    if (climatControlAirConditionEnabled) {
        if newValue > 15 {
            throw AutoError.tooHotForAirCondition
        }
        if newValue < 5 {
            throw AutoError.tooColdForAirCondition
        }
    } else {
        if newValue > 25 {
            throw AutoError.tooHighTemp
        }
        if newValue <= 0 {
            throw AutoError.tooLowTemp
        }
    }
    // температура допустимая, присваиваем
    climatControlTemp = newValue
}

func getClimatControlTemp() -> Int {
    return climatControlTemp
}

// вкл/выкл кондиционера
func switchСlimatControlAirCondition() {
    let currentTemp = getClimatControlTemp()
    if !climatControlAirConditionEnabled {
        // надо проверить и отрегулировать температуру
        if currentTemp > 15 {
            // хорошо бы через метод setClimatControlTemp
            climatControlTemp = 15
            print("Температура уменьшена до 15 градусов, чтобы кондицинер включился")
        }
        if currentTemp < 5 {
            // хорошо бы через метод setClimatControlTemp
            climatControlTemp = 5
            print("Температура увеличена до 5 градусов, чтобы кондицинер включился")
        }
    }

    climatControlAirConditionEnabled = !climatControlAirConditionEnabled
    
    print(climatControlAirConditionEnabled ? "Кондиционер включен" : "Кондиционер выключен")
}

// поменять музыку
func changeMusic(newChannel: Int) throws {
    if (newChannel < 1 || newChannel > 6) {
        throw AutoError.incorrectChannel
    }
    
    musicChannel = newChannel
}

// открытие крыши
func setSunroofOpenLevel(newValue: Int) throws {
    if (newValue < 0 || newValue > 95) {
        throw AutoError.incorrectSunroofOpenLevel
    }
    
    sunroofOpenLevel = newValue
}

// скорость обдува
func setBlowingFanSpeed(newValue: Int) throws {
    if (newValue < 0 || newValue > 5) {
        throw AutoError.incorrectBlowingFanSpeed
    }
}

// НАЧИНАЕМ ВЫЗЫВАТЬ МЕТОДЫ, проверяем работу программы
// переключаем режим управления
switchControlMode()

// пробуем присваивать новые значения громкости музыки
do {
    try setMusicVolume(newValue: 11)
} catch AutoError.tooLoudMusic {
    print("Ошибка! Музыкальная система не предусмотрена для более громкого звука!")
} catch AutoError.tooQuietMusic {
    print("Ошибка! Недопустимо отрицательное значение уровня громкости!")
}

// пробуем присваивать новые значения температуры в систему климат-контроля
do {
    try setClimatControlTemp(newValue: -1)
} catch AutoError.tooHotForAirCondition {
    print("Ошибка! Нельзя еще увеличить температуру пока кондиционер включен!")
} catch AutoError.tooColdForAirCondition {
    print("Ошибка! Нельзя еще уменьшить температуру пока кондиционер включен!")
} catch AutoError.tooHighTemp {
    print("Ошибка! Слишком высокая температура!")
} catch AutoError.tooLowTemp {
    print("Ошибка! Нельзя выставить температуру 0 или ниже!")
}

// включаем кондиционер
switchСlimatControlAirCondition()
// и затем выключаем кодниционер
switchСlimatControlAirCondition()

//меняем радиостанцию на недопустимую
do {
    try changeMusic(newChannel: 10)
} catch AutoError.incorrectChannel {
    print("Ошибка! Вы пытаетесь выбрать ненастроенный канал!")
}

//меняем радиостанцию на недопустимую
do {
    try setSunroofOpenLevel(newValue: 100)
} catch AutoError.incorrectSunroofOpenLevel {
    print("Ошибка! Процент открытия должен быть не менее 0 и не более 95!")
}

//меняем радиостанцию на недопустимую
do {
    try setBlowingFanSpeed(newValue: -1)
} catch AutoError.incorrectBlowingFanSpeed {
    print("Ошибка! Скорость обдува должна быть от 0 до 5!")
}
