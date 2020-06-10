#language: ru
@tree
@Positive


Функционал: внесение контактной информации по клиенту

Как Разработчик
Я хочу добавить механизм по внесению контактной информации по клиентам
Чтобы можно было указать: адрес, телефон, e-mail, gps координату на карте


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
   


Сценарий: _010001 добавление обработок для внесения адресов
	* Открытие формы для добавления обработки
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных по обработке и добавление её в базу
		И я буду выбирать внешний файл "#workingDir#\DataProcessor\InputAddress.epf"
		И я нажимаю на кнопку с именем "FormAddExtDataProc"
		И в поле 'Path to ext data proc for test' я ввожу текст ''
		И в поле 'Name' я ввожу текст 'ExternaInputAddress'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'ExternalInputAddress'
		И в поле 'TR' я ввожу текст 'ExternalInputAddress'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Проверка добавления обработки
		Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalInputAddress"

Сценарий: _010002 добавление обработок для внесения координат
	* Открытие формы для добавления обработки
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных по обработке и добавление её в базу
		И я буду выбирать внешний файл "#workingDir#\DataProcessor\Coordinates.epf"
		И я нажимаю на кнопку с именем "FormAddExtDataProc"
		И в поле 'Path to ext data proc for test' я ввожу текст ''
		И в поле 'Name' я ввожу текст 'ExternalCoordinates'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'ExternalCoordinates'
		И в поле 'TR' я ввожу текст 'ExternalCoordinates'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Проверка добавления обработки
		Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalCoordinates"

Сценарий: _010003 добавление обработок для внесения телефонов
	* Открытие формы для добавления обработки
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение данных по обработке 'External Input Phone Ukraine' и добавление её в базу
		И я буду выбирать внешний файл "#workingDir#\DataProcessor\InputPhoneUkraine.epf"
		И я нажимаю на кнопку с именем "FormAddExtDataProc"
		И в поле 'Path to ext data proc for test' я ввожу текст ''
		И в поле 'Name' я ввожу текст 'ExternalInputPhoneUkraine'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'ExternalInputPhoneUkraine'
		И в поле 'TR' я ввожу текст 'ExternalInputPhoneUkraine'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalInputPhoneUkraine"
	* Добавление обработки Phone TR
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я буду выбирать внешний файл "#workingDir#\DataProcessor\InputPhoneUkraine.epf"
		И я нажимаю на кнопку с именем "FormAddExtDataProc"
		И в поле 'Path to ext data proc for test' я ввожу текст ''
		И в поле 'Name' я ввожу текст 'PhoneTR'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Phone TR'
		И в поле 'TR' я ввожу текст 'Phone TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "Phone TR"

Сценарий: _010004 создание ID Info Type - Adreses
	* Открытие формы для добавления обработки
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Google Addreses'
		И в поле 'TR' я ввожу текст 'Google Addreses TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'	
		И в поле 'Unique ID' я ввожу текст 'Adr_10'
		И я изменяю флаг 'Show on form'
		И я изменяю флаг 'Read only'
	* Добавление обработки по адресам
		И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Ukraine'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProces" я активизирую поле "External data proc"
		И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
		Тогда открылось окно 'External data proc'
		И в таблице "List" я перехожу к строке:
			| 'Description'                |
			| 'ExternalInputAddress' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда таблица "List" содержит строки:
		| 'Description' |
		| 'Google Addreses'  |

Сценарий: _010004 проверка контроля уникальности UNIQ ID в элементах плана вида характеристик IDInfoTypes
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-278' с именем 'IRP-278'
	* Создание еще одного элемента с ID Adr_10
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Test'
		И в поле 'TR' я ввожу текст 'Test'
		И я нажимаю на кнопку 'Ok'
		И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'	
		И в поле 'Unique ID' я ввожу текст 'Adr_10'
		И я изменяю флаг 'Show on form'
		И я изменяю флаг 'Read only'
		И я нажимаю на кнопку 'Save and close'
		И Я закрываю окно предупреждения
	* Проверка сообщения по неуникальнольму ID
		Затем я жду, что в сообщениях пользователю будет подстрока "Value is not unique" в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _010005 создание контрагентов для Partners (Ferron, Kalipso, Lomaniti)
	* Открытие формы для создания контрагентов
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Companies'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Заполнение данных по контрагенту 'Company Ferron BP'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Company Ferron BP'
		И в поле 'TR' я ввожу текст 'Company Ferron BP TR'
		И я нажимаю на кнопку 'Ok'
		И в поле "Country" я ввожу текст 'Turkey'
		И в поле "Partner" я ввожу текст 'Ferron BP'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Проверка создания контрагента "Company Ferron BP"
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_en" "Company Ferron BP" 
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_tr" "Company Ferron BP TR"
	* Создание контрагента "Company Kalipso"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Company Kalipso'
		И в поле 'TR' я ввожу текст 'Company Kalipso TR'
		И я нажимаю на кнопку 'Ok'
		И в поле "Country" я ввожу текст 'Ukraine'
		И в поле "Partner" я ввожу текст 'Kalipso'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_en" "Company Kalipso" 
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_tr" "Company Kalipso TR" 
	* Создание контрагента "Company Lomaniti"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Company Lomaniti'
		И в поле 'TR' я ввожу текст 'Company Lomaniti TR'
		И я нажимаю на кнопку 'Ok'
		И в поле "Country" я ввожу текст 'Ukraine'
		И в поле "Partner" я ввожу текст 'Lomaniti'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_en" "Company Lomaniti" 
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_tr" "Company Lomaniti TR"

Сценарий: _010006 создание структуры партнеров (Partners), 1 главный партнер и несколько подчиненных
	* Открытие формы для создания партнеров
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Создание партнеров: 'Alians', 'MIO', 'Seven Brand'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Alians'
		И в поле 'TR' я ввожу текст 'Alians TR'
		И я нажимаю на кнопку 'Ok'
		И я изменяю флаг 'Customer'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'MIO'
		И в поле 'TR' я ввожу текст 'MIO TR'
		И я нажимаю на кнопку 'Ok'
		И я изменяю флаг 'Customer'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Seven Brand'
		И в поле 'TR' я ввожу текст 'Seven Brand TR'
		И я нажимаю на кнопку 'Ok'
		И я изменяю флаг 'Customer'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Проверка создания партнеров: 'Alians', 'MIO', 'Seven Brand'
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Alians" 
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "MIO"
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Seven Brand" 
	* Подчинение партнеров 'Alians', 'MIO' главному партнеру 'Seven Brand'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Alians'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Main partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Seven Brand'  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Parent" стал равен 'Seven Brand'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда открылось окно 'Partners'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'MIO'  |
		И в таблице "List" я выбираю текущую строку	
		И я нажимаю кнопку выбора у поля "Main partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Seven Brand'  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Parent" стал равен 'Seven Brand'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Проверка структуры
		И таблица  "List" не содержит строки:
			| 'Description' |
			| 'MIO' |
			| 'Alians'  |
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Seven Brand'  |
		И в таблице  "List" я перехожу на один уровень вниз
		Тогда таблица "List" стала равной:
			| 'Description' |
			| 'Seven Brand' |
			| 'Alians' |
			| 'MIO' |

Сценарий: _010007 добавление доп реквизита по партнерам "Business region"
	* Открытие формы добавления доп реквизитов для партнеров
		И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| Catalog_Partners          |
		И в таблице "List" я выбираю текущую строку
	* Заполнение имени настройки добаления дор реквизитов для партнеров
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Partners'
		И в поле 'TR' я ввожу текст 'Partners TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
	* Добавление доп реквизита Business region
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Business region'
		И в поле 'TR' я ввожу текст 'Business region TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Unique ID' я ввожу текст 'BusinessRegion'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormChoose'
	* Создание для доп реквизита интерфейсной группы
		И в таблице "Attributes" я активизирую поле "Interface group"
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Interface group"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Main information'
		И в поле 'TR' я ввожу текст 'Main information TR'
		И я нажимаю на кнопку 'Ok'
		И я меняю значение переключателя 'Form position' на 'Left'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "Attributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И Я закрыл все окна клиентского приложения
	* Заполнение у партнеров созданного доп реквизита
		И я открываю навигационную ссылку "e1cib/list/Catalog.Partners"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Business region"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Region Turkey'
		И в поле 'TR' я ввожу текст 'Turkey TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Region Ukraine'
		И в поле 'TR' я ввожу текст 'Ukraine TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region Ukraine     |
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| Description |
			| Lomaniti   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Business region"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region Ukraine     |
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| Description |
			| Kalipso   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Business region"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region Ukraine     |
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Alians   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Business region"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region Turkey     |
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| Description |
			| MIO   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Business region"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region Turkey     |
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2


Сценарий: _010008 создание структуры партнеров (Partners), 1 главный партнер, под ним партнер 2-го уровня и под ним 2 партнера 3-го уровня
	* Открытие справочника Partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Указание у партнера "Seven Brand" партнера "Kalipso" как главного
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Seven Brand'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Main partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'  |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "Parent" стал равен 'Kalipso'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Проверка подчиненности "Seven Brand" (вместе с подчиненными "Alians" и "MIO" ) партнеру "Kalipso"
		И я нажимаю на кнопку 'Hierarchical list'
		И таблица  "List" содержит строки:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'  |
		И в таблице  "List" я перехожу на один уровень вниз
		И в таблице  "List" я перехожу на один уровень вниз
		Тогда таблица "List" стала равной:
			| 'Description' |
			| 'Kalipso' |
			| 'Alians' |
			| 'MIO' |

Сценарий: _010009 добавление телефонов в ID info type
	* Открытие формы для создания типов контактной информации
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
	* Создание элемента Company phone
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Value type"
		И я заполняю наименование и тип данных
			И в таблице "" я перехожу к строке:
				| ''       |
				| 'String' |
			И я нажимаю на кнопку 'OK'
			И в поле 'Unique ID' я ввожу текст 'Phone_1'
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Company phone'
			И в поле 'TR' я ввожу текст 'Company phone TR'
			И я нажимаю на кнопку 'Ok'
			И я изменяю флаг 'Show on form'
			И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                      |
				| 'ExternalInputPhoneUkraine' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProces" я завершаю редактирование строки
			И в таблице "ExternalDataProces" я активизирую поле "Country"
			И в таблице "ExternalDataProces" я выбираю текущую строку
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ukraine   |
			И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProces" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
			И я ввожу значение поля UniqueID для телефона String
	* Проверка наличия созданного элемента плана вида характеристик "IDInfoTypes" "Company phone"
		И таблица "List" содержит строки
		| 'Description'     |
		| 'Company phone' |
	* Создание элемента Partner phone
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю наименование и тип данных
			Тогда открылось окно 'ID Info types (create)'
			И я нажимаю кнопку выбора у поля "Value type"
			Тогда открылось окно 'Edit data type'
			И в таблице "" я перехожу к строке:
				| ''       |
				| 'String' |
			И я нажимаю на кнопку 'OK'
			И в поле 'Unique ID' я ввожу текст 'Phone_2'
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			# И я перехожу к закладке "< >"
			И в поле 'ENG' я ввожу текст 'Partner phone'
			И в поле 'TR' я ввожу текст 'Partner phone'
			И я нажимаю на кнопку 'Ok'
			И я изменяю флаг 'Show on form'
			И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                      |
				| 'ExternalInputPhoneUkraine' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProces" я завершаю редактирование строки
			И в таблице "ExternalDataProces" я активизирую поле "Country"
			И в таблице "ExternalDataProces" я выбираю текущую строку
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ukraine   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
			И я ввожу значение поля UniqueID для телефона партнера String
	* Проверка наличия элемента Partner phone
		И таблица "List" содержит строки
			| 'Description'     |
			| 'Partner phone' |

Сценарий: _010010 добавление адресов в ID info type
	* Открытие формы для создания типов контактной информации
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
	* Добавление элемента фактического адреса для партнеров
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю вид и тип данных
			И я нажимаю кнопку выбора у поля "Value type"
			Тогда открылось окно 'Edit data type'
			И в таблице "" я перехожу к строке:
				| ''                |
				| 'ID Info address' |
			И я нажимаю на кнопку 'OK'
			И в поле 'Unique ID' я ввожу текст 'Adr_1'
			И я изменяю флаг 'Show on form'
			# И я устанавливаю флаг с именем "ReadOnly"
		И я заполняю наименование реквизита адреса
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Location address (Partner)'
			И в поле 'TR' я ввожу текст 'Location address (Partner) TR'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
	* Добавление элемента фактического адреса для компании
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю вид и тип данных
			И я нажимаю кнопку выбора у поля "Value type"
			Тогда открылось окно 'Edit data type'
			И в таблице "" я перехожу к строке:
				| ''                |
				| 'ID Info address' |
			И я нажимаю на кнопку 'OK'
			И в поле 'Unique ID' я ввожу текст 'Adr_2'
			И я изменяю флаг 'Show on form'
			И я устанавливаю флаг с именем "ReadOnly"
		И я заполняю наименование реквизита адреса
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Billing address (Company)'
			И в поле 'TR' я ввожу текст 'Billing address (Company) TR'
			И я нажимаю на кнопку 'Ok'
			И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'
		И я добавляю обработку для указания адреса для Украины
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ukraine     |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description'                |
				| 'ExternalInputAddress' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProces" я завершаю редактирование строки
		И я добавляю обработку для указания фактического адреса для Турции
			И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Turkey     |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description'                |
				| 'ExternalInputAddress' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProces" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
	* Добавление элемента юридического адреса для компании
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю вид и тип данных
			И я нажимаю кнопку выбора у поля "Value type"
			Тогда открылось окно 'Edit data type'
			И в таблице "" я перехожу к строке:
				| ''                |
				| 'ID Info address' |
			И я нажимаю на кнопку 'OK'
			И в поле 'Unique ID' я ввожу текст 'Adr_3'
			И я изменяю флаг 'Show on form'
			И я устанавливаю флаг с именем "ReadOnly"
		И я заполняю наименование реквизита адреса
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Registered address  (Company)'
			И в поле 'TR' я ввожу текст 'Registered address (Company) TR'
			И я нажимаю на кнопку 'Ok'
			И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'
		И я добавляю обработку для указания адреса для Украины
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ukraine     |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description'                |
				| 'ExternalInputAddress' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProces" я завершаю редактирование строки
		И я добавляю обработку для указания фактического адреса для Турции
			И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Turkey     |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description'                |
				| 'ExternalInputAddress' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProces" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
		И по адресу Location address (Partner) я указываю произвольную структуру
			И я ввожу значение поля UniqueID для адреса партнера String
		И я проверяю наличие созданных элементов
			Тогда таблица "List" содержит строки
				| 'Description'                     |
				| 'Location address (Partner)'    |
				| 'Billing address (Company)'    |
				| 'Registered address  (Company)' |


Сценарий: _010011 добавление gps в ID info type
	* Открытие формы для создания типов контактной информации
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
	* Добавление ID info gps  координаты для партнеров в Украине
		И я нажимаю на кнопку с именем 'FormCreate'
		Тогда открылось окно 'ID Info types (create)'
		И я нажимаю кнопку выбора у поля "Value type"
		Тогда открылось окно 'Edit data type'
		И в таблице "" я перехожу к строке:
			| ''       |
			| 'String' |
		И в таблице "" я выбираю текущую строку:
		И я нажимаю на кнопку 'OK'
		И в поле 'Unique ID' я ввожу текст 'GPS'
		И я изменяю флаг 'Show on form'
		И я устанавливаю флаг с именем "ReadOnly"
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		# И я перехожу к закладке "< >"
		И в поле 'ENG' я ввожу текст 'GPS Ukraine'
		И в поле 'TR' я ввожу текст 'GPS Ukraine TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'
		И в таблице "ExternalDataProces" я активизирую поле "External data proc"
		И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalCoordinates'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProces" я выбираю текущую строку
		И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ukraine   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProces" я завершаю редактирование строки
	* Добавление структуры адреса по gps для Украины
		И в таблице "ExternalDataProces" я нажимаю на кнопку 'Set settings'
		Тогда открылось окно 'Coordinates'
		И я указываю адрес который будет перезаполнятся при выборе gps
			И я нажимаю кнопку выбора у поля "Structured address"
			Тогда открылось окно 'ID Info types'
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Google Addreses |
			И в таблице "List" я выбираю текущую строку
		И в таблице "Levels" я нажимаю на кнопку 'Get all levels'
		И в поле 'Lat' я ввожу текст '46,477400'
		И в поле 'Lng' я ввожу текст '30,732872'
		И в таблице "AllLevels" я перехожу к строке:
			| Level     |
			| political |
		И в таблице "AllLevels" я перехожу к строке:
			| Level   |
			| country |
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я перехожу к строке:
			| Level    |
			| locality |
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я перехожу к строке:
			| Level |
			| route |
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveDown'
		И в таблице "AllLevels" я перехожу к строке:
			| Level     |
			| political |
		И в таблице 'AllLevels' я удаляю строку
		И в таблице 'AllLevels' я удаляю строку
		И в таблице 'AllLevels' я удаляю строку
		И в таблице 'AllLevels' я удаляю строку
		И я нажимаю на кнопку 'Ok'
		Тогда открылось окно 'Coordinates'
		И я нажимаю на кнопку 'Ok'
	* Заполнение настроек по определению gps
		И я перехожу к закладке "Related values"
		И в таблице "RelatedValues" я нажимаю на кнопку с именем 'RelatedValuesAdd'
		И в таблице "RelatedValues" я нажимаю кнопку выбора у реквизита "ID Info type"
		Тогда открылось окно 'ID Info types'
		И в таблице "List" я перехожу к строке:
			| 'Description'                  |
			| 'Location address (Partner)' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 1
		И в таблице "RelatedValues" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И я ввожу значение поля UniqueID String
	* Проверка наличия созданных элементов
		Тогда таблица "List" содержит строки
		| 'Description'                     |
		| 'GPS Ukraine'    |
	* Добавление ID info gps координаты для партнеров в Турции
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Value type"
		И в таблице "" я перехожу к строке:
			| ''       |
			| 'String' |
		И в таблице "" я выбираю текущую строку:
		И я нажимаю на кнопку 'OK'
		И в поле 'Unique ID' я ввожу текст 'GPSTurkey'
		И я изменяю флаг 'Show on form'
		И я устанавливаю флаг с именем "ReadOnly"
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'GPS Turkey'
		И в поле 'TR' я ввожу текст 'GPS Turkey TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "ExternalDataProces" я нажимаю на кнопку с именем 'ExternalDataProcesAdd'
		И в таблице "ExternalDataProces" я активизирую поле "External data proc"
		И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalCoordinates'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProces" я выбираю текущую строку
		И в таблице "ExternalDataProces" я нажимаю кнопку выбора у реквизита "Country"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Turkey   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProces" я завершаю редактирование строки
	* Добавление структуры адреса по gps для Турции
		И в таблице "ExternalDataProces" я нажимаю на кнопку 'Set settings'
		И я указываю адрес который будет перезаполнятся при выборе gps
			И я нажимаю кнопку выбора у поля "Structured address"
			Тогда открылось окно 'ID Info types'
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Google Addreses |
			И в таблице "List" я выбираю текущую строку
		И в таблице "Levels" я нажимаю на кнопку 'Get all levels'
		И в поле 'Lat' я ввожу текст '40,983577'
		И в поле 'Lng' я ввожу текст '29,078498'
		И в таблице "AllLevels" я перехожу к строке:
		| Level   | Value  |
		| country | Turkey |
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я перехожу к строке:
			| Level                       |
			| administrative_area_level_1 |
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я перехожу к строке:
			| Level                       |
			| administrative_area_level_2 |
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я перехожу к строке:
			| Level | Value            |
			| route | Hafız İmam Sokak |
		И в таблице "AllLevels" я нажимаю на кнопку с именем 'AllLevelsMoveUp'
		И в таблице "AllLevels" я перехожу к строке:
			| Level                       |
			| administrative_area_level_4 |
		И в таблице 'AllLevels' я удаляю строку
		И в таблице 'AllLevels' я удаляю строку
		И в таблице 'AllLevels' я удаляю строку
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Ok'
	* Внесение настроек по определению gps
		И я перехожу к закладке "Related values"
		И в таблице "RelatedValues" я нажимаю на кнопку с именем 'RelatedValuesAdd'
		И в таблице "RelatedValues" я нажимаю кнопку выбора у реквизита "ID Info type"
		Тогда открылось окно 'ID Info types'
		И в таблице "List" я перехожу к строке:
			| 'Description'                  |
			| 'Location address (Partner)' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 1
		И в таблице "RelatedValues" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И я ввожу значение поля UniqueID для GPS Turkey String
	* Проверка наличия созданных элементов
		Тогда таблица "List" содержит строки
		| 'Description'                     |
		| 'GPS Turkey'    |


Сценарий: _010012 настройки отображение контактной информации в карточках Stores, Partners, Company
	* Внесение настроек для отображения контактной информации по Partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.IDInfoSets'
		И в таблице "List" я перехожу к строке:
		| 'Predefined data item name' |
		| 'Catalog_Partners'          |
		И в таблице "List" я выбираю текущую строку
		Тогда элемент формы с именем "PredefinedDataName" стал равен 'Catalog_Partners'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Partners'
		И в поле 'TR' я ввожу текст 'Partners TR'
		И я нажимаю на кнопку 'OK'
		И в таблице "IDInfoTypes" я нажимаю на кнопку с именем 'IDInfoTypesAdd'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		И в таблице "List" я перехожу к строке:
			| Description                  |
			| Location address (Partner) |
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И в таблице "IDInfoTypes" я нажимаю на кнопку с именем 'IDInfoTypesAdd'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		И в таблице "List" я перехожу к строке:
			| Description                  |
			| Google Addreses |
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И в таблице "IDInfoTypes" я нажимаю на кнопку с именем 'IDInfoTypesAdd'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		И в таблице "List" я перехожу к строке:
			| Description   |
			| GPS Ukraine |
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И в таблице "IDInfoTypes" я нажимаю на кнопку 'Set condition'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в таблице "SettingsFilter" я нажимаю на кнопку с именем 'SettingsFilterAddFilterItem'
		И в таблице "SettingsFilter" я нажимаю кнопку выбора у реквизита "Field"
		И в таблице "Source" я разворачиваю строку:
			| Available fields |
			| Reference        |
		И в таблице "Source" я перехожу к строке:
			| Available fields |
			| Business region  |
		И в таблице "Source" я выбираю текущую строку
		И в таблице "SettingsFilter" я активизирую поле "Value"
		И в таблице "SettingsFilter" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region Ukraine     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "SettingsFilter" я завершаю редактирование строки
		И я нажимаю на кнопку 'Ok'
		И в таблице "IDInfoTypes" я нажимаю на кнопку 'Add'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		Тогда открылось окно 'ID Info types'
		И в таблице "List" я перехожу к строке:
			| Description  |
			| GPS Turkey |
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И в таблице "IDInfoTypes" я нажимаю на кнопку 'Set condition'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в таблице "SettingsFilter" я нажимаю на кнопку с именем 'SettingsFilterAddFilterItem'
		И в таблице "SettingsFilter" я нажимаю кнопку выбора у реквизита "Field"
		Тогда открылось окно 'Select field'
		И в таблице "Source" я разворачиваю строку:
			| Available fields |
			| Reference        |
		И в таблице "Source" я перехожу к строке:
			| Available fields |
			| Business region  |
		И в таблице "Source" я выбираю текущую строку
		И в таблице "SettingsFilter" я активизирую поле "Value"
		И в таблице "SettingsFilter" я нажимаю кнопку выбора у реквизита "Value"
		Тогда открылось окно 'Add attribute and property values'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Region Turkey      |
		И в таблице "List" я выбираю текущую строку
		И в таблице "SettingsFilter" я завершаю редактирование строки
		И я нажимаю на кнопку 'Ok'
		И в таблице "IDInfoTypes" я нажимаю на кнопку 'Add'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		И в таблице "List" я перехожу к строке:
			| Description     |
			| Partner phone |
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Partners (ID Info sets) *' в течение 20 секунд
	* Внесение настроек для отображения контактной информации по Company
		И в таблице "List" я перехожу к строке:
			| 'Predefined data item name' |
			| 'Catalog_Companies'          |
		И в таблице "List" я выбираю текущую строку
		Тогда элемент формы с именем "PredefinedDataName" стал равен 'Catalog_Companies'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Company'
		И в поле 'TR' я ввожу текст 'Company TR'
		И я нажимаю на кнопку 'OK'
		И в таблице "IDInfoTypes" я нажимаю на кнопку с именем 'IDInfoTypesAdd'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		Тогда открылось окно 'ID Info types'
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И в таблице "IDInfoTypes" я нажимаю на кнопку с именем 'IDInfoTypesAdd'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		Тогда открылось окно 'ID Info types'
		И в таблице "List" я перехожу к строке:
			| 'Description'                  |
			| 'Billing address (Company)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И в таблице "IDInfoTypes" я нажимаю на кнопку с именем 'IDInfoTypesAdd'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		Тогда открылось окно 'ID Info types'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Registered address  (Company)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Внесение настроек для отображения контактной информации по Stores
		И в таблице "List" я перехожу к строке:
			| 'Predefined data item name' |
			| 'Catalog_Stores'          |
		И в таблице "List" я выбираю текущую строку
		Тогда элемент формы с именем "PredefinedDataName" стал равен 'Catalog_Stores'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Stores'
		И в поле 'TR' я ввожу текст 'Stores TR'
		И я нажимаю на кнопку 'OK'
		И в таблице "IDInfoTypes" я нажимаю на кнопку с именем 'IDInfoTypesAdd'
		И в таблице "IDInfoTypes" я нажимаю кнопку выбора у реквизита "ID Info type"
		Тогда открылось окно 'ID Info types'
		И в таблице "List" я перехожу к строке:
			| 'Description'                  |
			| 'Location address (Partner)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "IDInfoTypes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'en descriptions is empty (ID Info sets) *' в течение 20 секунд
		

Сценарий: _010013 заполнение телефонов по партнеру
	* Открытие формы справочника партнеров
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Заполнение телефона по партнеру Ferron BP
		И я нажимаю на кнопку с именем "FormList"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+305500077043'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Заполнение телефона по партнеру Kalipso
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+305300040042'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Заполнение телефона по партнеру Lomaniti
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Lomaniti' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+30560105055'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Заполнение телефона по партнеру Alians
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Alians' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+30920107011'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Заполнение телефона по партнеру Seven Brand
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Seven Brand' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+30420209012'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Заполнение телефона по партнеру MIO
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'MIO' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+30330309077'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'



Сценарий: _010014 заполнение адреса по партнеру
		# И Я устанавливаю ссылку 'https://bilist.atlassian.net/projects/IRP/issues/IRP-166' с именем 'BugIRP-166'
	* Открытие формы справочника партнеров
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Заполнение адреса по партнеру Kalipso
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
	* Проверка отображения контактной информации
		И     элемент формы с именем "_Adr_1" присутствует на форме
		И     элемент формы с именем "_Adr_10" присутствует на форме
		И     элемент формы с именем "_GPS" присутствует на форме
		И     элемент формы с именем "_Phone_2" присутствует на форме
	* Заполнение адреса
		И в поле 'Location address (Partner)' я ввожу текст 'Odessa, Bunina, 2, №32'
	* Проверка отображения адреса
		И элемент формы с именем "_Adr_1" стал равен 'Odessa, Bunina, 2, №32'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	
Сценарий: _010015 ввод структуры адреса
#  Billing address (Company)
	* Открытие справочника компаний
		И я открываю навигационную ссылку "e1cib/list/Catalog.Companies"
	* Задание структуры адреса для компаний
		И в таблице "List" я перехожу к строке:
			| Description       |
			| Company Ferron BP |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Сontact information"
		И я нажимаю на кнопку открытия поля "Billing address (Company)"
		И в таблице "CountryTable" я перехожу к строке:
		| Country |
		| Ukraine |
		И в таблице "CountryTable" я выбираю текущую строку
		И в поле 'InputLevel_1' я ввожу текст 'Country'
		И я нажимаю на кнопку с именем 'ButtonAdd_2'
		И в поле 'InputLevel_2' я ввожу текст 'Region'
		И я нажимаю на кнопку с именем 'ButtonAdd_3'
		И в поле 'InputLevel_3' я ввожу текст 'City'
		И я нажимаю на кнопку с именем 'ButtonAdd_4'
		И в поле 'InputLevel_4' я ввожу текст 'Street'
		И в поле 'InputValue_1' я ввожу текст 'Ukraine'
		И в поле 'InputValue_2' я ввожу текст 'Odesska oblast'
		И в поле 'InputValue_3' я ввожу текст 'Odessa'
		И в поле 'InputValue_4' я ввожу текст 'Kanatna'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Проверка сохранения структуры адреса для Billing address (Company)
		И в таблице "List" я перехожу к строке:
		| Description     |
		| Company Kalipso |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Сontact information"
		И я нажимаю на кнопку открытия поля "Billing address (Company)"
		И в таблице "CountryTable" я перехожу к строке:
		| Country |
		| Ukraine |
		И в таблице "CountryTable" я выбираю текущую строку
		И из выпадающего списка "InputLevel_1" я выбираю по строке 'С'
		И я нажимаю на кнопку с именем 'ButtonAdd_2'
		И я нажимаю на кнопку с именем 'ButtonAdd_3'
		И я нажимаю на кнопку с именем 'ButtonAdd_4'
		И в поле 'InputValue_4' я ввожу текст 'Bunina'
		И     элемент формы с именем "InputLevel_1" стал равен 'Country'
		И     элемент формы с именем "InputValue_1" стал равен 'Ukraine'
		И     элемент формы с именем "InputLevel_2" стал равен 'Region'
		И     элемент формы с именем "InputValue_2" стал равен 'Odesska oblast'
		И     элемент формы с именем "InputLevel_3" стал равен 'City'
		И     элемент формы с именем "InputValue_3" стал равен 'Odessa'
		И     элемент формы с именем "InputLevel_4" стал равен 'Street'
		И     элемент формы с именем "InputValue_4" стал равен 'Bunina'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'


Сценарий: _010016 определение gps координаты на карте по клиентам из разных стран и заполнение адреса с гугл карты
# Поиск координаты осуществляется по Location adress, для каждой страны своя структура адреса
	* Открытие справочника Partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Заполнение gps координаты по клиенту Kalipso путем поиска адреса на карте (Украина)
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "GPS Ukraine"
		И Пауза 5
		И я нажимаю на кнопку 'Update address by GPS'
		И Пауза 10
		И я нажимаю на кнопку 'Ok'
		И Пауза 10
	* Проверка сохранения gps координаты
		И     элемент формы с именем "_GPS" стал равен '46.48082,30.748159'
		И поле с именем "_Adr_10" заполнено
		И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения
	* Заполнение gps координаты по клиенту Alians путем поиска адреса на карте (Украина)
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Alians' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И в поле 'Location address (Partner)' я ввожу текст 'Park sok, 15, Yenikapi, Antalya, Turkey'
		И я нажимаю на кнопку 'Save'
		И я нажимаю на кнопку открытия поля "GPS Turkey"
		И я нажимаю на кнопку 'Update address by GPS'
		И Пауза 10
		И я нажимаю на кнопку 'Ok'
		И Пауза 10
	* Проверка сохранения gps координаты
		И поле с именем "_GPSTurkey" заполнено
		И поле с именем "_Adr_10" заполнено
		И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения
	


		



