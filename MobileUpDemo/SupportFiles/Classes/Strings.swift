//
//  Strings.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 26.07.2021.
//

import Foundation
import Localizer

class Strings {
    static let logout = String(.en("Logout"), .ru("Выход"))
    static let errorOccurred = String(.en("Error occurred!"), .ru("Произошла ошибка!"))
    static let networkProblem = String(.en("Network problem, please try again."), .ru("Проблемы с сетью, повторите попытку."))
    static let sessionHasEnded = String(
        .en("The session has ended. Please sign in again."),
        .ru("Сессия завершена. Пожалуйста, совершите вход заново.")
    )
    static let enterVK = String(.en("Enter via VK"), .ru("Вход через VK"))
    static let somethingWentWrong = String(.en("Something went wrong."), .ru("Что-то пошло не так."))
    static let saveWithNotification = String(.en("Save with notification"), .ru("Сохранить с уведомлением"))
    static let saveFailed =  String(.en("Save failed!"), .ru("Не удалось сохранить!"))
    static let somethingWentWrongWithTryAgain =  String(
        .en("Something went wrong, please, try again."),
        .ru("Что-то пошло не так, пожалуйста, попробуйте еще раз.")
    )
    static let successSave = String(.en("Success!"), .ru("Сохранено!"))
    static let photoSavedSuccessfully = String(.en("Photo saved successfully."), .ru("Фото было успешно сохранено."))
    static let ok = String(.en("Ok"), .ru("Ок"))
    static let retry = String(.en("Retry"), .ru("Попробовать еще"))
    static let cancel = String(.en("Cancel"), .ru("Отмена"))
    static let contactDeveloper = String(.en("Contact the developer for help."), .ru("Обратитесь к разработчику за помощью."))
}
