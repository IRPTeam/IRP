#language: ru
@tree
@Positive
@IgnoreOnCIMainBuild
Функционал: check saving of plugin to a folder on the computer



Контекст:
    Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: check saving of plugin to a folder on the computer
    * Добавление внешней обработки без указания пути отладки
        И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
        И я нажимаю на кнопку с именем 'FormCreate'
        И в поле 'Name' я ввожу текст 'ExternalSpecialMessage'
        И в поле 'TR' я ввожу текст 'ExternalTest'
        И я буду выбирать внешний файл "#workingDir#\DataProcessor\TaxCalculateVAT_TR.epf"
        И я нажимаю на кнопку с именем "FormAddExtDataProc"
        И в поле 'Path to plugin for test' я ввожу текст ''
        И я нажимаю на кнопку 'Save'

# нужно дописать на сохранение файла  на диске
    


