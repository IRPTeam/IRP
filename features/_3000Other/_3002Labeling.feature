#language: ru
@tree
@Positive
Функционал: product labeling

Как Разработчик
Я хочу создать документ маркировки товара
Для присвоения товарам уникального штрих-кода (серии)

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _300000 user check for Turkish data
	* Открытие спика пользователей
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Users'
	* Изменение кода локализации для пользователя CI
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'CI'          |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Localization code' я ввожу текст 'tr'
		И я нажимаю на кнопку 'Save and close'
	И я закрываю сеанс TESTCLIENT


Сценарий: _300201 add-on plugin to generate unique barcodes
	И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я буду выбирать внешний файл "#workingDir#\DataProcessor\GenerateBarcode.epf"
	И я нажимаю на кнопку с именем "FormAddExtDataProc"
	И в поле 'Path to plugin for test' я ввожу текст ''
	И в поле 'Name' я ввожу текст 'GenerateBarcode'
	И я нажимаю на кнопку открытия поля с именем "Description_tr"
	И в поле 'ENG' я ввожу текст 'GenerateBarcode'
	И в поле 'TR' я ввожу текст 'GenerateBarcodeTR'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save and close'
	И я жду закрытия окна 'Plugins (create)' в течение 10 секунд
	Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "GenerateBarcode"

Сценарий: _300202 setting up barcode generation button display in Purchase order document
	И я вношу настройки в справочник ConfigurationMetadata
		И я открываю навигационную ссылку "e1cib/list/Catalog.ConfigurationMetadata"
		И в таблице  "List" я перехожу на один уровень вниз
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'Description' я ввожу текст 'Labeling'
		И я нажимаю кнопку выбора у поля "Parent"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Documents   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	И я вношу настройка в регистр ExternalCommands
		И я открываю навигационную ссылку "e1cib/list/InformationRegister.ExternalCommands"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Configuration metadata"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Documents   |
		И в таблице  "List" я перехожу на один уровень вниз
		И в таблице "List" я перехожу к строке:
			| Description         |
			| Labeling |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Plugins"
		И в таблице "List" я перехожу к строке:
			| Description       |
			| GenerateBarcodeTR |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	И я проверяю отображение кнопки GenerateBarcode в документе Labeling
		И я открываю навигационную ссылку "e1cib/list/Document.Labeling"
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "GenerateBarcodeTR" присутствует на форме

Сценарий: _300203 create Labeling based on Purchase order
	И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
	И в таблице "List" я перехожу к строке:
		| Number |
		| 101 |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку 'Labeling'
	И я нажимаю на кнопку 'GenerateBarcodeTR'
	И я проверяю заполнение документа
		Тогда таблица "Items" содержит строки:
			| '#'  | 'Item'        | 'Item key'     | 'Item serial/lot number' | 'Barcode' |
			| '1'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '2'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '3'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '4'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '5'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '6'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '7'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '8'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '9'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '10' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '11' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '12' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '13' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '14' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '15' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '16' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '17' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '18' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '19' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '20' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '21' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '22' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '23' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '24' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '25' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '26' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '27' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '28' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '29' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '30' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '31' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '32' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '33' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '34' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '35' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '36' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '37' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '38' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '39' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '40' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '41' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '42' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '43' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '44' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '45' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '46' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '47' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '48' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '49' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '50' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '51' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '52' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '53' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '54' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '55' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '56' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '57' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '58' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '59' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '60' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '61' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '62' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '63' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '64' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '65' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '66' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '67' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '68' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '69' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '70' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
	И я нажимаю на кнопку 'Post and close'