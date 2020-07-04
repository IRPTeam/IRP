#language: ru
@tree
@Positive


Функционал: filling in customer contact information

As an owner
I want there to be a mechanism for entering customer contact information
To specify: address, phone, e-mail, gps coordinate on the map


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
   


Сценарий: _010001 add external data processing for entering addresses
	* Opening a form to add external data processing
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Adding external data processing 
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
	* Check adding external data processing
		Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalInputAddress"

Сценарий: _010002 add external data processing for GPS
	* Opening a form to add external data processing
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Adding external data processing 
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
	* Check adding external data processing
		Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalCoordinates"

Сценарий: _010003 add external data processing for phone
	* Opening a form to add external data processing
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the 'External Input Phone Ukraine' and adding it to the database
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
	* Add processing Phone TR
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

Сценарий: _010004 creating ID Info Type - Addresses
	* Opening a form to add external data processing
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Google Addreses'
		И в поле 'TR' я ввожу текст 'Google Addreses TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'	
		И в поле 'Unique ID' я ввожу текст 'Adr_10'
		И я изменяю флаг 'Show on form'
		И я изменяю флаг 'Read only'
	* Adding external data processing for addresses
		И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Ukraine'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProcess" я активизирую поле "External data proc"
		И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
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

Сценарий: _010004 verification of UNIQ ID uniqueness control in IDInfoTypes
	* Create one more item with ID Adr_10
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Test'
		И в поле 'TR' я ввожу текст 'Test'
		И я нажимаю на кнопку 'Ok'
		И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'	
		И в поле 'Unique ID' я ввожу текст 'Adr_10'
		И я изменяю флаг 'Show on form'
		И я изменяю флаг 'Read only'
		И я нажимаю на кнопку 'Save and close'
		И Я закрываю окно предупреждения
	* Checking message by non-unique ID
		Затем я жду, что в сообщениях пользователю будет подстрока "Value is not unique" в течение 30 секунд
		И Я закрыл все окна клиентского приложения

Сценарий: _010005 creating company for Partners (Ferron, Kalipso, Lomaniti)
	* Opening the form for filling in Company
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Companies'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Filling in company data 'Company Ferron BP'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Company Ferron BP'
		И в поле 'TR' я ввожу текст 'Company Ferron BP TR'
		И я нажимаю на кнопку 'Ok'
		И в поле "Country" я ввожу текст 'Turkey'
		И в поле "Partner" я ввожу текст 'Ferron BP'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Checking the availability of the created company  "Company Ferron BP"
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_en" "Company Ferron BP" 
		Тогда я проверяю наличие элемента справочника "Companies" со значением поля "Description_tr" "Company Ferron BP TR"
	* Creating "Company Kalipso"
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
	* Creating "Company Lomaniti"
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

Сценарий: _010006 creating a structure of partners (partners), 1 main partner and several subordinates
	* Opening the form for filling in partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Creating partners: 'Alians', 'MIO', 'Seven Brand'
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
	* Checking for created partners: 'Alians', 'MIO', 'Seven Brand'
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Alians" 
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "MIO"
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Seven Brand" 
	* Subordination of partners 'Alians', 'MIO' to the main partner 'Seven Brand'
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
	* Structure check
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

Сценарий: _010007 adding additional details for partners "Business region"
	* Opening a form for adding additional attributes for partners
		И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| Catalog_Partners          |
		И в таблице "List" я выбираю текущую строку
	* Filling in the name of the settings for adding additional details for partners
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Partners'
		И в поле 'TR' я ввожу текст 'Partners TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
	* Adding additional attribute Business region
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Business region'
		И в поле 'TR' я ввожу текст 'Business region TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Unique ID' я ввожу текст 'BusinessRegion'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormChoose'
	* Create an interface group for additional attribute
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
	* Filling in the created additional attribute for partners
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


Сценарий: _010008 creating of a partner structure (Partners), 1 main partner, under which a 2nd level partner and under which 2 3rd level partners
	* Opening the catalog Partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Filling in the "Seven Brand" partner Kalipso as the main partner
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
	* Checking the subordination of "Seven Brand" (together with the "Alians" and "MIO" subordinates) to Kalipso partner
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

Сценарий: _010009 adding phones to ID info type
	* Opening the form for filling in ID Info Types
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
	* Creation Company phone
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
			И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                      |
				| 'ExternalInputPhoneUkraine' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProcess" я завершаю редактирование строки
			И в таблице "ExternalDataProcess" я активизирую поле "Country"
			И в таблице "ExternalDataProcess" я выбираю текущую строку
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ukraine   |
			И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProcess" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
			И я ввожу значение поля UniqueID для телефона String
	* Checking for created "Company phone"
		И таблица "List" содержит строки
		| 'Description'     |
		| 'Company phone' |
	* Creation Partner phone
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
			И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                      |
				| 'ExternalInputPhoneUkraine' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProcess" я завершаю редактирование строки
			И в таблице "ExternalDataProcess" я активизирую поле "Country"
			И в таблице "ExternalDataProcess" я выбираю текущую строку
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ukraine   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
			И я ввожу значение поля UniqueID для телефона партнера String
	* Checking for created Partner phone
		И таблица "List" содержит строки
			| 'Description'     |
			| 'Partner phone' |

Сценарий: _010010 adding addresses to an ID info type
	* Opening the form for filling in ID Info Types
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
	* Adding an actual address for partners
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
		* Filling in the name of the address
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Location address (Partner)'
			И в поле 'TR' я ввожу текст 'Location address (Partner) TR'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
	* Adding an actual address for company
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
		* Filling in the name of the address
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Billing address (Company)'
			И в поле 'TR' я ввожу текст 'Billing address (Company) TR'
			И я нажимаю на кнопку 'Ok'
			И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'
		* Adding external data processing to specify the address for Ukraine
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ukraine     |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description'                |
				| 'ExternalInputAddress' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProcess" я завершаю редактирование строки
		* Adding external data processing to specify the address for Turkey
			И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Turkey     |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description'                |
				| 'ExternalInputAddress' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProcess" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
	* Adding a legal address for a company
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
		* Filling in the name of the address detail
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст 'Registered address  (Company)'
			И в поле 'TR' я ввожу текст 'Registered address (Company) TR'
			И я нажимаю на кнопку 'Ok'
			И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'
		* Adding external data processing to specify the address for Ukraine
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ukraine     |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description'                |
				| 'ExternalInputAddress' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProcess" я завершаю редактирование строки
		* Adding external data processing to specify the address for Turkey
			И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Turkey     |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
			Тогда открылось окно 'External data proc'
			И в таблице "List" я перехожу к строке:
				| 'Description'                |
				| 'ExternalInputAddress' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ExternalDataProcess" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
		* Specify an arbitrary structure at Location address (Partner)
			И я ввожу значение поля UniqueID для адреса партнера String
		* Checking for created
			Тогда таблица "List" содержит строки
				| 'Description'                     |
				| 'Location address (Partner)'    |
				| 'Billing address (Company)'    |
				| 'Registered address  (Company)' |


Сценарий: _010011 adding gps to an ID info type
	* Opening the form for filling in ID Info Types
		И я открываю навигационную ссылку 'e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes'
	* Adding ID info gps coordinates for partners in Ukraine
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
		И в поле 'ENG' я ввожу текст 'GPS Ukraine'
		И в поле 'TR' я ввожу текст 'GPS Ukraine TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'
		И в таблице "ExternalDataProcess" я активизирую поле "External data proc"
		И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalCoordinates'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProcess" я выбираю текущую строку
		И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ukraine   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProcess" я завершаю редактирование строки
	* Adding address structure by gps for Ukraine
		И в таблице "ExternalDataProcess" я нажимаю на кнопку 'Set settings'
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
	* Filling in settings for gps coordinates
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
	* Checking for created items
		Тогда таблица "List" содержит строки
		| 'Description'                     |
		| 'GPS Ukraine'    |
	* Adding ID info gps coordinates for partners in Turkey
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
		И в таблице "ExternalDataProcess" я нажимаю на кнопку с именем 'ExternalDataProcessAdd'
		И в таблице "ExternalDataProcess" я активизирую поле "External data proc"
		И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalCoordinates'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProcess" я выбираю текущую строку
		И в таблице "ExternalDataProcess" я нажимаю кнопку выбора у реквизита "Country"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Turkey   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ExternalDataProcess" я завершаю редактирование строки
	* Adding gps address structure for Turkey
		И в таблице "ExternalDataProcess" я нажимаю на кнопку 'Set settings'
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
	* Filling in gps coordinates settings
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
	* Checking for created items
		Тогда таблица "List" содержит строки
		| 'Description'                     |
		| 'GPS Turkey'    |


Сценарий: _010012 settings for displaying contact information in Stores, Partners, Company
	* Complete settings to display contact information for Partners
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
	* Fill in the settings for displaying Company contact information
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
	* Fill in the settings for displaying Store contact information
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
		

Сценарий: _010013 filling phones for partners
	* Opening a partner catalog form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Filling a phone for partner Ferron BP
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
	* Filling a phone for partner Kalipso
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+305300040042'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Filling a phone for partner Lomaniti
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Lomaniti' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+30560105055'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Filling a phone for partner Alians
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Alians' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+30920107011'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Filling a phone for partner Seven Brand
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Seven Brand' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+30420209012'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Filling a phone for partner MIO
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'MIO' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
		И я нажимаю на кнопку открытия поля "Partner phone"
		И в поле 'Phone' я ввожу текст '+30330309077'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'



Сценарий: _010014 partner address filling
	* Opening a partner catalog form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Filling address partner Kalipso
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Contact information"
	* Checking the display of contact information
		И     элемент формы с именем "_Adr_1" присутствует на форме
		И     элемент формы с именем "_Adr_10" присутствует на форме
		И     элемент формы с именем "_GPS" присутствует на форме
		И     элемент формы с именем "_Phone_2" присутствует на форме
	* Address Filling
		И в поле 'Location address (Partner)' я ввожу текст 'Odessa, Bunina, 2, №32'
	* Checking address display
		И элемент формы с именем "_Adr_1" стал равен 'Odessa, Bunina, 2, №32'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	
Сценарий: _010015 address structure input
	* Opening a company catalog form
		И я открываю навигационную ссылку "e1cib/list/Catalog.Companies"
	* Filling in address structure for companies
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
	* Checking to save the address structure for Billing address (Company)
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


Сценарий: _010016 gps coordinates on the map for clients from different countries and filling in the address from Google map
	* Opening the catalog Partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Filling in gps coordinates for Kalipso client by searching for the address on the map (Ukraine)
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
	* Checking gps coordinates saved
		И     элемент формы с именем "_GPS" стал равен '46.48082,30.748159'
		И поле с именем "_Adr_10" заполнено
		И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения
	* Filling in gps coordinates for Alians client by searching for the address on the map (Ukraine)
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
	* Checking gps coordinates saved
		И поле с именем "_GPSTurkey" заполнено
		И поле с именем "_Adr_10" заполнено
		И я нажимаю на кнопку 'Save and close'
		И Я закрыл все окна клиентского приложения
	


		



