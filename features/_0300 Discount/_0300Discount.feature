#language: ru
@tree
@Positive
@Discount


Функционал: special offers

As a sales manager
I want to create a basic system of discounts: price type discount, 5+1 type discount, range discount (manually selected), information message.
For calculating special offers in documents

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _030001 add External data processor SpecialMessage
	И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я буду выбирать внешний файл "#workingDir#\DataProcessor\SpecialOffer_Message.epf"
	И я нажимаю на кнопку с именем "FormAddExtDataProc"
	И в поле 'Path to ext data proc for test' я ввожу текст ''
	И в поле 'Name' я ввожу текст 'ExternalSpecialMessage'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'ExternalSpecialMessage'
	И в поле 'TR' я ввожу текст 'ExternalSpecialMessage'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save and close'
	И я жду закрытия окна 'External data proc (create)' в течение 10 секунд
	Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalSpecialMessage"

Сценарий: _030002 add External data processor DocumentDiscount
	И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я буду выбирать внешний файл "#workingDir#\DataProcessor\DocumentDiscount.epf"
	И я нажимаю на кнопку с именем "FormAddExtDataProc"
	И в поле 'Path to ext data proc for test' я ввожу текст ''
	И в поле 'Name' я ввожу текст 'DocumentDiscount'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'DocumentDiscount'
	И в поле 'TR' я ввожу текст 'DocumentDiscount'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save and close'
	И я жду закрытия окна 'External data proc (create)' в течение 10 секунд
	Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "DocumentDiscount"

Сценарий: _030003 add External data processor SpecialRules
	И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я буду выбирать внешний файл "#workingDir#\DataProcessor\SpecialOfferRules.epf"
	И я нажимаю на кнопку с именем "FormAddExtDataProc"
	И в поле 'Path to ext data proc for test' я ввожу текст ''
	И в поле 'Name' я ввожу текст 'ExternalSpecialOfferRules'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'ExternalSpecialOfferRules'
	И в поле 'TR' я ввожу текст 'ExternalSpecialOfferRules'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save and close'
	И я жду закрытия окна 'External data proc (create)' в течение 10 секунд
	Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalSpecialOfferRules"

Сценарий: _030004 add External data processor RangeDiscount
	И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я буду выбирать внешний файл "#workingDir#\DataProcessor\RangeDiscount.epf"
	И я нажимаю на кнопку с именем "FormAddExtDataProc"
	И в поле 'Path to ext data proc for test' я ввожу текст ''
	И в поле 'Name' я ввожу текст 'ExternalRangeDiscount'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'ExternalRangeDiscount'
	И в поле 'TR' я ввожу текст 'ExternalRangeDiscount'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save and close'
	И я жду закрытия окна 'External data proc (create)' в течение 10 секунд
	Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalRangeDiscount"


Сценарий: _030005 add External data processor FivePlusOne
	* Opening a form to add external data processor
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add external data processor FivePlusOneType
		И я буду выбирать внешний файл "#workingDir#\DataProcessor\FivePlusOne.epf"
		И я нажимаю на кнопку с именем "FormAddExtDataProc"
		И в поле 'Path to ext data proc for test' я ввожу текст ''
		И в поле 'Name' я ввожу текст 'ExternalFivePlusOne'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'ExternalFivePlusOne'
		И в поле 'TR' я ввожу текст 'ExternalFivePlusOne'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Тогда я проверяю наличие элемента справочника "ExternalDataProc" со значением поля "Description_en" "ExternalFivePlusOne"


Сценарий: _030006 create Special Offer Types (price type)
	Когда выбираю обработку для создания типа (вида) скидки
	И в поле 'ENG' я ввожу текст 'Discount Price 1'
	И в поле 'TR' я ввожу текст 'Discount Price 1'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	Когда перехожу к настройкам Price Type
	И в таблице "List" я перехожу к строке:
		| 'Description'            |
		| 'Discount Price TRY 1' |
	И в таблице "List" я выбираю текущую строку
	Когда сохраняю настройки скидки
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Discount Price 1"
	Когда выбираю обработку для создания типа (вида) скидки
	И в поле 'ENG' я ввожу текст 'Discount Price 2'
	И в поле 'TR' я ввожу текст 'Discount Price 2'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	Когда перехожу к настройкам Price Type
	И в таблице "List" я перехожу к строке:
		| 'Description'            |
		| 'Discount Price TRY 2' |
	И в таблице "List" я выбираю текущую строку
	Когда сохраняю настройки скидки
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Discount Price 2"
	Когда выбираю обработку для создания типа (вида) скидки
	И в поле 'ENG' я ввожу текст 'Discount 1 without Vat'
	И в поле 'TR' я ввожу текст 'Discount 1 without Vat'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	Когда перехожу к настройкам Price Type
	И в таблице "List" я перехожу к строке:
		| 'Description'            |
		| 'Discount 1 TRY without VAT' |
	И в таблице "List" я выбираю текущую строку
	Когда сохраняю настройки скидки
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Discount 1 without Vat"
	Когда выбираю обработку для создания типа (вида) скидки
	И в поле 'ENG' я ввожу текст 'Discount 2 TRY without VAT'
	И в поле 'TR' я ввожу текст 'Discount 2 TRY without VAT'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	Когда перехожу к настройкам Price Type
	И в таблице "List" я перехожу к строке:
		| 'Description'            |
		| 'Discount 2 TRY without VAT' |
	И в таблице "List" я выбираю текущую строку
	Когда сохраняю настройки скидки
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Discount 2 TRY without VAT"

Сценарий: _030007 create Special Offer Types special message (Notification)
	Когда выбираю обработку для создания типа скидки (сообщение)
	И в поле 'ENG' я ввожу текст 'Special Message Notification'
	И в поле 'TR' я ввожу текст 'Special Message Notification'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И из выпадающего списка "Message type" я выбираю точное значение 'Notification'
	И в поле 'Message Description_en' я ввожу текст 'Message Notification'
	И в поле 'Message Description_tr' я ввожу текст 'Message Notification'
	Когда сохраняю настройки скидки
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Special Message Notification"


Сценарий: _030008 create Special Offer Rule RangeDiscount
	* Selecting external processor to create a special offer rule RangeDiscount
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferRules'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalRangeDiscount' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		* Filling the rule name
			И в поле 'ENG' я ввожу текст 'Range Discount Basic (Dress)'
			И в поле 'TR' я ввожу текст 'Range Discount Basic (Dress)'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save'
	* Filling special offer rule: Basic Agreements TRY, Dress,3
		И я нажимаю на кнопку 'Set settings'
		И я нажимаю кнопку выбора у поля "Agreements"
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ValueList" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ValueList" я завершаю редактирование строки
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку с именем 'ItemKeysTableAdd'
		И я нажимаю на кнопку открытия поля "Item key"
		И в таблице "ItemKeysTable" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key'      |
			| 'S/Yellow' |
		И я нажимаю на кнопку с именем 'FormChoose'
		Тогда открылось окно 'Range discount'
		И в таблице "ItemKeysTable" я завершаю редактирование строки
		И в таблице "ItemKeysTable" я нажимаю на кнопку с именем 'ItemKeysTableAdd'
		И в таблице "ItemKeysTable" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key'      |
			| 'XS/Blue' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save settings'
		И Пауза 10
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOfferRules" со значением поля "Description_en" "Range Discount Basic (Dress)"
	* Selecting external processor to create a special offer rule RangeDiscount
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferRules'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalRangeDiscount' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		* Filling the rule name
			И в поле 'ENG' я ввожу текст 'Range Discount Basic (Trousers)'
			И в поле 'TR' я ввожу текст 'Range Discount Basic (Trousers)'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save'
	* Filling special offer rule: Basic Agreements TRY, Trousers
		И я нажимаю на кнопку 'Set settings'
		И я нажимаю кнопку выбора у поля "Agreements"
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ValueList" я нажимаю кнопку выбора у реквизита "Value"
		И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ValueList" я завершаю редактирование строки
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку с именем 'ItemKeysTableAdd'
		И я нажимаю на кнопку открытия поля "Item key"
		И в таблице "ItemKeysTable" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key'      |
			| '36/Yellow' |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "ItemKeysTable" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save settings'
		И Пауза 10
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOfferRules" со значением поля "Description_en" "Range Discount Basic (Trousers)"
	

Сценарий: _030009 create Special Offer Rule Present Discount
	* Selecting external processor to create a special offer rule 5+1
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferRules'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalFivePlusOne' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
	* Filling the rule name
		И в поле 'ENG' я ввожу текст 'All items 5+1, Discount on Basic Agreements'
		И в поле 'TR' я ввожу текст 'All items 5+1 TR, Discount on Basic Agreements'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save'
	* Filling special offer rule: Basic Agreements TRY, весь товар, 5+1, кратна 
		И я нажимаю на кнопку с именем "FormSetSettings"
		И я нажимаю кнопку выбора у поля "Agreements"
		И я нажимаю на кнопку с именем 'Assortment'
		И в таблице "List" я перехожу к строке:
			| Description                   |
			| Personal Agreements, $ |
		И в таблице "List" я выбираю текущую строку
		И в таблице "List" я перехожу к строке:
			| Description                   |
			| Basic Agreements, TRY |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'FormChoose'
		И Я закрываю окно 'Agreements'
		И я нажимаю на кнопку 'OK'
		И в поле 'QuantityMoreThan' я ввожу текст '5'
		И в поле 'QuantityFree' я ввожу текст '1'
		И я изменяю флаг 'ForEachCase'
		И я нажимаю кнопку выбора у поля "ItemKeys"
		И я нажимаю на кнопку с именем 'Assortment'
		Тогда в таблице "List" я выделяю все строки
		И я нажимаю на кнопку с именем 'FormChoose'
		И Я закрываю окно 'Item keys'
		Тогда открылось окно 'Value list'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Save settings'
		И Пауза 10
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOfferRules" со значением поля "Description_en" "All items 5+1, Discount on Basic Agreements"
	* Create rule Basic Agreements TRY, Dress and Trousers 4+1, multiple
		* Select external data processor for special offer rule 4+1
			И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferRules'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                 |
				| 'ExternalFivePlusOne' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля с именем "Description_en"
		* Filling the rule name
			И в поле 'ENG' я ввожу текст 'Dress and Trousers 4+1, Discount on Basic Agreements'
			И в поле 'TR' я ввожу текст 'Dress and Trousers 4+1 TR, Discount on Basic Agreements'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save'
		* Filling special offer rule: Basic Agreements TRY, товар 1, 2, 4+1, кратна 
			И я нажимаю на кнопку с именем "FormSetSettings"
			И я нажимаю кнопку выбора у поля "Agreements"
			И я нажимаю на кнопку с именем 'Assortment'
			Тогда открылось окно 'Agreements'
			И в таблице "List" я перехожу к строке:
				| 'Description'              |
				| 'Personal Agreements, $' |
			И в таблице "List" я перехожу к строке:
				| 'Description'             |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
			И Я закрываю окно 'Agreements'
			И я нажимаю на кнопку 'OK'
			И в поле 'QuantityMoreThan' я ввожу текст '4'
			И в поле 'QuantityFree' я ввожу текст '1'
			И я изменяю флаг 'ForEachCase'
			И я нажимаю кнопку выбора у поля "ItemKeys"
			И я нажимаю на кнопку с именем 'Assortment'
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| 'XS/Blue'   |
			И я нажимаю на кнопку с именем 'FormChoose'
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| '36/Yellow' |
			И я нажимаю на кнопку с именем 'FormChoose'
			И Я закрываю окно 'Item keys'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Save settings'
			И Пауза 10
			И я нажимаю на кнопку 'Save and close'
			И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOfferRules" со значением поля "Description_en" "Dress and Trousers 4+1, Discount on Basic Agreements"
	* Create rule Basic Agreements TRY, Dress and Trousers 3+1, not multiple
		* Select external data processor for special offer rule 3+1
			И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferRules'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                 |
				| 'ExternalFivePlusOne' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля с именем "Description_en"
		* Filling the rule name
			И в поле 'ENG' я ввожу текст 'Dress and Trousers 3+1, Discount on Basic Agreements'
			И в поле 'TR' я ввожу текст 'Dress and Trousers 3+1 TR, Discount on Basic Agreements'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save'
		* Filling special offer rule: Basic Agreements TRY
			И я нажимаю на кнопку с именем "FormSetSettings"
			И я нажимаю кнопку выбора у поля "Agreements"
			И я нажимаю на кнопку с именем 'Assortment'
			И в таблице "List" я перехожу к строке:
				| 'Description'              |
				| 'Personal Agreements, $' |
			И в таблице "List" я перехожу к строке:
				| 'Description'             |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
			И Я закрываю окно 'Agreements'
			И я нажимаю на кнопку 'OK'
			И в поле 'QuantityMoreThan' я ввожу текст '3'
			И в поле 'QuantityFree' я ввожу текст '1'
			И я нажимаю кнопку выбора у поля "ItemKeys"
			И я нажимаю на кнопку с именем 'Assortment'
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| 'XS/Blue'   |
			И я нажимаю на кнопку с именем 'FormChoose'
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| '36/Yellow' |
			И я нажимаю на кнопку с именем 'FormChoose'
			И Я закрываю окно 'Item keys'
			Тогда открылось окно 'Value list'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Save settings'
			И Пауза 10
			И я нажимаю на кнопку 'Save and close'
			И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOfferRules" со значением поля "Description_en" "Dress and Trousers 3+1, Discount on Basic Agreements"


Сценарий: _030010 create Special Offer Types special message (DialogBox)
	Когда выбираю обработку для создания типа скидки (сообщение)
	И в поле 'ENG' я ввожу текст 'Special Message DialogBox'
	И в поле 'TR' я ввожу текст 'Special Message DialogBox'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И из выпадающего списка "Message type" я выбираю точное значение 'DialogBox'
	И в поле 'Message Description_en' я ввожу текст 'Message 2'
	И в поле 'Message Description_tr' я ввожу текст 'Message 2'
	Когда сохраняю настройки скидки
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Special Message DialogBox"
	И Я закрыл все окна клиентского приложения

Сценарий: _030011 create Special Offer Types Present Discount
	Когда выбираю обработку для создания типа скидки 5+1
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalFivePlusOne' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
	И я заполняю наименование типа
		И в поле 'ENG' я ввожу текст 'All items 5+1, Discount on Basic Agreements'
		И в поле 'TR' я ввожу текст 'All items 5+1 TR, Discount on Basic Agreements'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save'
	И я заполняю тип: Basic Agreements TRY, весь товар, 5+1, кратна 
		И я нажимаю на кнопку с именем "FormSetSettings"
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Agreements"
		И я нажимаю на кнопку с именем 'Assortment'
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Personal Agreements, $' |
		И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		И Я закрываю окно 'Agreements'
		И я нажимаю на кнопку 'OK'
		И Пауза 2
		И в поле 'QuantityMoreThan' я ввожу текст '5'
		И в поле 'QuantityFree' я ввожу текст '1'
		И я изменяю флаг 'ForEachCase'
		И я нажимаю кнопку выбора у поля "ItemKeys"
		И я нажимаю на кнопку с именем 'Assortment'
		Тогда открылось окно 'Item keys'
		Тогда в таблице "List" я выделяю все строки
		И я нажимаю на кнопку с именем 'FormChoose'
		И Я закрываю окно 'Item keys'
		И я нажимаю на кнопку 'OK'
		И Пауза 2
		И я нажимаю на кнопку 'Save settings'
		И Пауза 10
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "All items 5+1, Discount on Basic Agreements"
	И я создаю тип Basic Agreements TRY, Dress and Trousers 4+1, кратна
		Когда выбираю обработку для создания типа скидки 4+1
			И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                 |
				| 'ExternalFivePlusOne' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля с именем "Description_en"
		И я заполняю наименование типа
			И в поле 'ENG' я ввожу текст 'Dress,2 4+1, Discount on Basic Agreements'
			И в поле 'TR' я ввожу текст 'Dress,2 4+1 TR, Discount on Basic Agreements'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save'
		И я заполняю тип: Basic Agreements TRY, весь товар, 4+1, кратна 
			И я нажимаю на кнопку с именем "FormSetSettings"
			И Пауза 2
			И я нажимаю кнопку выбора у поля "Agreements"
			И я нажимаю на кнопку с именем 'Assortment'
			Тогда открылось окно 'Agreements'
			И в таблице "List" я перехожу к строке:
				| 'Description'              |
				| 'Personal Agreements, $' |
			И в таблице "List" я перехожу к строке:
				| 'Description'             |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
			И Я закрываю окно 'Agreements'
			И я нажимаю на кнопку 'OK'
			И Пауза 2
			И в поле 'QuantityMoreThan' я ввожу текст '4'
			И в поле 'QuantityFree' я ввожу текст '1'
			И я изменяю флаг 'ForEachCase'
			И я нажимаю кнопку выбора у поля "ItemKeys"
			И я нажимаю на кнопку с именем 'Assortment'
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| 'XS/Blue'   |
			И я нажимаю на кнопку с именем 'FormChoose'
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| '36/Yellow' |
			И я нажимаю на кнопку с именем 'FormChoose'
			И Я закрываю окно 'Item keys'
			И я нажимаю на кнопку 'OK'
			И Пауза 2
			И я нажимаю на кнопку 'Save settings'
			И Пауза 10
			И я нажимаю на кнопку 'Save and close'
			И Пауза 10
		Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Dress,2 4+1, Discount on Basic Agreements"
	И я создаю тип Basic Agreements TRY, товар А, В, 3+1, не кратна
		Когда выбираю обработку для создания типа скидки 4+1
			И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                 |
				| 'ExternalFivePlusOne' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля с именем "Description_en"
		И я заполняю наименование типа
			И в поле 'ENG' я ввожу текст 'Dress,2 3+1, Discount on Basic Agreements'
			И в поле 'TR' я ввожу текст 'Dress,2 3+1 TR, Discount on Basic Agreements'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save'
		И я заполняю тип: Basic Agreements TRY, весь товар, 4+1, кратна 
			И я нажимаю на кнопку с именем "FormSetSettings"
			И Пауза 2
			И я нажимаю кнопку выбора у поля "Agreements"
			И я нажимаю на кнопку с именем 'Assortment'
			Тогда открылось окно 'Agreements'
			И в таблице "List" я перехожу к строке:
				| 'Description'              |
				| 'Personal Agreements, $' |
			И в таблице "List" я перехожу к строке:
				| 'Description'             |
				| 'Basic Agreements, TRY' |
			И в таблице "List" я выбираю текущую строку
			И Я закрываю окно 'Agreements'
			И я нажимаю на кнопку 'OK'
			И Пауза 2
			И в поле 'QuantityMoreThan' я ввожу текст '3'
			И в поле 'QuantityFree' я ввожу текст '1'
			И я нажимаю кнопку выбора у поля "ItemKeys"
			И я нажимаю на кнопку с именем 'Assortment'
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| 'XS/Blue'   |
			И я нажимаю на кнопку с именем 'FormChoose'
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| '36/Yellow' |
			И я нажимаю на кнопку с именем 'FormChoose'
			И Я закрываю окно 'Item keys'
			И я нажимаю на кнопку 'OK'
			И Пауза 2
			И я нажимаю на кнопку 'Save settings'
			И Пауза 10
			И я нажимаю на кнопку 'Save and close'
			И Пауза 10
		Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Dress,2 3+1, Discount on Basic Agreements"

Сценарий: _030012 create Special Offer Types Range Discount
	Когда выбираю обработку для создания типа скидки Range Discount
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "External data proc"
		И в таблице "List" я перехожу к строке:
			| 'Description'                 |
			| 'ExternalRangeDiscount' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
	И я заполняю наименование типа
		И в поле 'ENG' я ввожу текст 'Range Discount Basic (Dress)'
		И в поле 'TR' я ввожу текст 'Range Discount Basic (Dress)'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save'
	И я заполняю тип: Basic Agreements TRY, Dress,3
		И я нажимаю на кнопку 'Set settings'
		И в таблице "ItemKeysTable" я нажимаю на кнопку с именем 'ItemKeysTableAdd'
		И в таблице "ItemKeysTable" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeysTable" в поле 'Min percent' я ввожу текст '3'
		И в таблице "ItemKeysTable" я активизирую поле "Max percent"
		И в таблице "ItemKeysTable" в поле 'Max percent' я ввожу текст '10'
		И в таблице "ItemKeysTable" я завершаю редактирование строки
		И в таблице "ItemKeysTable" я нажимаю на кнопку с именем 'ItemKeysTableAdd'
		И в таблице "ItemKeysTable" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| 'S/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeysTable" в поле 'Min percent' я ввожу текст '4'
		И в таблице "ItemKeysTable" я активизирую поле "Max percent"
		И в таблице "ItemKeysTable" в поле 'Max percent' я ввожу текст '8'
		И в таблице "ItemKeysTable" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save settings'
		И Пауза 2
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Range Discount Basic (Dress)"
	И я создаю Types Range Discount Basic (Trousers)
		Когда выбираю обработку для создания типа скидки Range Discount
			И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "External data proc"
			И в таблице "List" я перехожу к строке:
				| 'Description'                 |
				| 'ExternalRangeDiscount' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку открытия поля с именем "Description_en"
		И я заполняю наименование типа
			И в поле 'ENG' я ввожу текст 'Range Discount Basic (Trousers)'
			И в поле 'TR' я ввожу текст 'Range Discount Basic (Trousers)'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save'
		И я заполняю тип: Basic Agreements TRY, Dress,3
			И я нажимаю на кнопку 'Set settings'
			И в таблице "ItemKeysTable" я нажимаю на кнопку с именем 'ItemKeysTableAdd'
			И в таблице "ItemKeysTable" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key'  |
				| '36/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к следующему реквизиту
			И в таблице "ItemKeysTable" в поле 'Min percent' я ввожу текст '5'
			И в таблице "ItemKeysTable" я активизирую поле "Max percent"
			И в таблице "ItemKeysTable" в поле 'Max percent' я ввожу текст '7'
			И в таблице "ItemKeysTable" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save settings'
			И Пауза 2
			И я нажимаю на кнопку 'Save and close'
			И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOfferTypes" со значением поля "Description_en" "Range Discount Basic (Trousers)"	


Сценарий: _030013 create Special Offer Rules (agreement)
	Когда выбираю обработку для создания правила скидки
	И в поле 'ENG' я ввожу текст 'Discount on Basic Agreements'
	И в поле 'TR' я ввожу текст 'Discount on Basic Agreements'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И в поле "Name" я ввожу текст 'Agreements in list '
	И из выпадающего списка "Rule type" я выбираю точное значение 'Agreements in list'
	И я нажимаю кнопку выбора у поля "Agreements"
	И Пауза 2
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ValueList" я нажимаю кнопку выбора у реквизита "Value"
	И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Basic Agreements, TRY' |
	И в таблице "List" я выбираю текущую строку
	И Пауза 1
	И в таблице "ValueList" я завершаю редактирование строки
	И я нажимаю на кнопку 'OK'
	Когда сохраняю настройки скидки
	Тогда я проверяю наличие элемента справочника "SpecialOfferRules" со значением поля "Description_en" "Discount on Basic Agreements"
	Когда выбираю обработку для создания правила скидки
	И в поле 'ENG' я ввожу текст 'Discount on Basic Agreements without Vat'
	И в поле 'TR' я ввожу текст 'Discount on Basic Agreements without Vat'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И из выпадающего списка "Rule type" я выбираю точное значение 'Agreements in list'
	И я нажимаю кнопку выбора у поля "Agreements"
	И Пауза 2
	И я нажимаю на кнопку с именем 'Add'
	И в таблице "ValueList" я нажимаю кнопку выбора у реквизита "Value"
	И в таблице "List" я перехожу к строке:
		| 'Description'             |
		| 'Basic Agreements, without VAT' |
	И в таблице "List" я выбираю текущую строку
	И Пауза 1
	И в таблице "ValueList" я завершаю редактирование строки
	И я нажимаю на кнопку 'OK'
	Когда сохраняю настройки скидки
	Тогда я проверяю наличие элемента справочника "SpecialOfferRules" со значением поля "Description_en" "Discount on Basic Agreements"

# Сценарий: create Special Offer Rules (вхождение клиента в сегмент)

Сценарий: _030014 create Special Offer (group Maximum by row/Special Offers Maximum by row)
	Когда выбираю обработку для создания скидки
	И в поле 'ENG' я ввожу текст 'Special Offers'
	И в поле 'TR' я ввожу текст 'Special Offers'
	И я нажимаю на кнопку 'Ok'
	И я изменяю флаг 'Group types'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И Пауза 2
	И из выпадающего списка "Type joining" я выбираю точное значение 'Maximum by row'
	Когда сохраняю настройки скидки
	И я нажимаю на кнопку с именем 'FormChoose'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Special Offers'
	И в поле 'TR' я ввожу текст 'Special Offers'
	И я нажимаю на кнопку 'Ok'
	И в поле 'Priority' я ввожу текст '1'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Special Offers"
	Когда выбираю обработку для создания скидки
	И в поле 'ENG' я ввожу текст 'Maximum'
	И в поле 'TR' я ввожу текст 'Maximum'
	И я нажимаю на кнопку 'Ok'
	И я изменяю флаг 'Group types'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И Пауза 2
	И из выпадающего списка "Type joining" я выбираю точное значение 'Maximum by row'
	Когда сохраняю настройки скидки
	И я нажимаю на кнопку с именем 'FormChoose'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Maximum'
	И в поле 'TR' я ввожу текст 'Maximum'
	И я нажимаю на кнопку 'Ok'
	И в поле 'Priority' я ввожу текст '3'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Maximum"

Сценарий: _030015 create Special Offer (group Sum )
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку с именем 'FormCreateFolder'
	И я нажимаю кнопку выбора у поля "Special offer type"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "External data proc"
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Sum'
	И в поле 'TR' я ввожу текст 'Sum'
	И я нажимаю на кнопку 'Ok'
	И я изменяю флаг 'Group types'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И Пауза 2
	И из выпадающего списка "Type joining" я выбираю точное значение 'Sum'
	Когда сохраняю настройки скидки
	И я нажимаю на кнопку с именем 'FormChoose'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Sum'
	И в поле 'TR' я ввожу текст 'Sum'
	И я нажимаю на кнопку 'Ok'
	И в поле 'Priority' я ввожу текст '1'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Sum"

Сценарий: _030016 create Special Offer (group Minimum )
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку с именем 'FormCreateFolder'
	И я нажимаю кнопку выбора у поля "Special offer type"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "External data proc"
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Minimum'
	И в поле 'TR' я ввожу текст 'Minimum'
	И я нажимаю на кнопку 'Ok'
	И я изменяю флаг 'Group types'
	И я нажимаю на кнопку 'Save'
	И я нажимаю на кнопку 'Set settings'
	И Пауза 2
	И из выпадающего списка "Type joining" я выбираю точное значение 'Minimum'
	Когда сохраняю настройки скидки
	И я нажимаю на кнопку с именем 'FormChoose'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Minimum'
	И в поле 'TR' я ввожу текст 'Minimum'
	И я нажимаю на кнопку 'Ok'
	И в поле 'Priority' я ввожу текст '2'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10
	Тогда я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Minimum"

Сценарий: _030017 create Special Offer ручное назначение Discount Price 1-2 (discount price, с перемещением в group maximum)
	Когда открываю окно создания скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'        |
		| 'Discount Price 1' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '1'
	И я изменяю флаг 'Manually'
	И я изменяю флаг 'Launch'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Discount Price 1'
	И в поле 'TR' я ввожу текст 'Discount Price 1'
	И я нажимаю на кнопку 'Ok'
	И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
	Когда ввожу срок действия скидки текущий месяц
	Когда добавляю правило скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'                    |
		| 'Discount on Basic Agreements' |
	Когда сохраняю правило в скидке
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И Пауза 1
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'
	Когда открываю окно создания скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'        |
		| 'Discount Price 2' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '2'
	И я изменяю флаг 'Manually'
	И я изменяю флаг 'Launch'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Discount Price 2'
	И в поле 'TR' я ввожу текст 'Discount Price 2'
	И я нажимаю на кнопку 'Ok'
	И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
	Когда ввожу срок действия скидки текущий месяц
	Когда добавляю правило скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'                    |
		| 'Discount on Basic Agreements' |
	Когда сохраняю правило в скидке
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	И Пауза 1
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'
	И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Discount Price 1"
	И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Discount Price 2"

Сценарий: _030018 create Special Offer в виде информационного сообщения (Notification)
	Когда открываю окно создания скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'        |
		| 'Special Message Notification' |
	И в таблице "List" я выбираю текущую строку
	И Пауза 2
	И в поле 'Priority' я ввожу текст '1'
	Когда ввожу срок действия скидки текущий месяц
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Special Message Notification'
	И в поле 'TR' я ввожу текст 'Special Message Notification'
	И я нажимаю на кнопку 'Ok'
	И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
	И я изменяю флаг 'Launch'
	Когда добавляю правило скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'                    |
		| 'Discount on Basic Agreements' |
	Когда сохраняю правило в скидке
	И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Special Message Notification"
	Тогда открылось окно 'Special offers'
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
	| 'Special offer type' |
	| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: _030019 create Special Offer в виде информационного сообщения (DialogBox)
	Когда открываю окно создания скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'        |
		| 'Special Message DialogBox' |
	И в таблице "List" я выбираю текущую строку
	И Пауза 2
	И в поле 'Priority' я ввожу текст '2'
	Когда ввожу срок действия скидки текущий месяц
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Special Message DialogBox'
	И в поле 'TR' я ввожу текст 'Special Message DialogBox'
	И я нажимаю на кнопку 'Ok'
	И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
	И я изменяю флаг 'Launch'
	Когда добавляю правило скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'                    |
		| 'Discount on Basic Agreements without Vat' |
	Когда сохраняю правило в скидке
	И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Special Message DialogBox"
	Тогда открылось окно 'Special offers'
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
	| 'Special offer type' |
	| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'


Сценарий: _030020 create Special Offer автоматическое назначение Discount Price 1-2 without Vat (discount price, в group minimum)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	# И в таблице  "List" я перехожу на один уровень вниз
	# И в таблице "List" я перехожу к строке:
	# 	| 'Description' |
	# 	| 'Minimum'   |
	# И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Special offer type"
	Тогда открылось окно 'Special offer types'
	И в таблице "List" я перехожу к строке:
		| 'Description'        |
		| 'Discount 1 without Vat' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '3'
	И я изменяю флаг 'Launch'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Discount 1 without Vat'
	И в поле 'TR' я ввожу текст 'Discount 1 without Vat'
	И я нажимаю на кнопку 'Ok'
	И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
	Когда ввожу срок действия скидки текущий месяц
	Когда добавляю правило скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'                    |
		| 'Discount on Basic Agreements without Vat' |
	Когда сохраняю правило в скидке
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Special offer type"
	Тогда открылось окно 'Special offer types'
	И в таблице "List" я перехожу к строке:
		| 'Description'        |
		| 'Discount 2 TRY without VAT' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '4'
	И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
	И я изменяю флаг 'Launch'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Discount 2 without Vat'
	И в поле 'TR' я ввожу текст 'Discount 2 without Vat'
	И я нажимаю на кнопку 'Ok'
	Когда ввожу срок действия скидки текущий месяц
	Когда добавляю правило скидки
	И в таблице "List" я перехожу к строке:
		| 'Description'                    |
		| 'Discount on Basic Agreements without Vat' |
	Когда сохраняю правило в скидке
	Когда переношу скидку Discount 1 without Vat в минимум
	Когда переношу скидку Discount 2 without Vat в группу минимум 
	И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Discount 2 without Vat"
	И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Discount 1 without Vat"


Сценарий: _030021 перемещение скидки из одной группы в другую
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку "Hierarchical list"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Maximum'   |
	И в таблице "List" я выбираю текущую строку
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '2'        | 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вверх
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Minimum'   |
	И в таблице "List" я выбираю текущую строку
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'
	Когда переношу скидку Discount Price 1 в максимум

Сценарий: _030022 create группы скидкок внутри группы скидок
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'Hierarchical list'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Minimum'   |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormCreateFolder'
	И Пауза 2
	И я нажимаю кнопку выбора у поля "Special offer type"
	И в таблице "List" я перехожу к строке:
		| Description |
		| Sum         |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '10'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	И в поле 'ENG' я ввожу текст 'Sum in Minimum'
	И в поле 'TR' я ввожу текст 'Sum in Minimum'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И я запоминаю значение поля "Parent" как "Minimum"
	И поле с именем "Parent" равно переменной "Minimum"
	И я нажимаю на кнопку 'Save and close'

Сценарий: _030023 перемещение группы скидок во внутрь другой группы скидок (изменение Parent)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'      |
		| 'Sum in Minimum' |
	И я нажимаю на кнопку 'Edit'
	И я запоминаю значение поля "Parent" как "Sum"
	И поле с именем "Parent" равно переменной "Sum"
	И я нажимаю на кнопку 'Save and close'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Minimum'   |
	И я нажимаю на кнопку 'Move to folder'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Special Offers'     |
	И я нажимаю на кнопку с именем 'FormChoose'
	Тогда открылось окно 'Special offers'
	# И я нажимаю на кнопку 'Move to folder'
	# Тогда открылось окно 'Special offers'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Maximum'   |
	И я нажимаю на кнопку 'Move to folder'
	Тогда открылось окно 'Special offers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Special Offers'     |
	И я нажимаю на кнопку с именем 'FormChoose'
	Тогда открылось окно 'Special offers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Sum'            |
	И я нажимаю на кнопку 'Move to folder'
	Тогда открылось окно 'Special offers'
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Special Offers'     |
	И я нажимаю на кнопку с именем 'FormChoose'
	Тогда открылось окно 'Special offers'
	И я нажимаю на кнопку 'Move to folder'
	И Я закрываю текущее окно

Сценарий: _030024 create скидки Present Discount
	Когда открываю окно создания скидки
	И я заполняю данные скидки 5+1 (ручное назначение)
		И в таблице "List" я перехожу к строке:
			| 'Description'                                   |
			| 'All items 5+1, Discount on Basic Agreements' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Priority' я ввожу текст '4'
		Когда ввожу срок действия скидки текущий месяц
		И я изменяю флаг 'Manually'
		И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
		И я устанавливаю флаг 'Launch'
		И в таблице "Rules" я нажимаю на кнопку с именем 'RulesAdd'
		И в таблице "Rules" я нажимаю кнопку выбора у реквизита "Rule"
		И в таблице "List" я перехожу к строке:
			| 'Description'                                   |
			| 'All items 5+1, Discount on Basic Agreements' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Rules" я завершаю редактирование строки
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'All items 5+1, Discount on Basic Agreements'
		И в поле 'TR' я ввожу текст 'All items 5+1, Discount on Basic Agreements'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	И я создаю скидку 4+1, кратна, товар 1 и 2
		Когда открываю окно создания скидки
		И я заполняю данные скидки 4+1 (ручное назначение)
			И в таблице "List" я перехожу к строке:
				| 'Description'                                   |
				| 'Dress,2 4+1, Discount on Basic Agreements' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Priority' я ввожу текст '4'
			Когда ввожу срок действия скидки текущий месяц
			И я изменяю флаг 'Manually'
			И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
			И я устанавливаю флаг 'Launch'
			И в таблице "Rules" я нажимаю на кнопку с именем 'RulesAdd'
			И в таблице "Rules" я нажимаю кнопку выбора у реквизита "Rule"
			И в таблице "List" я перехожу к строке:
				| 'Description'                                   |
				| 'Dress and Trousers 4+1, Discount on Basic Agreements' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Rules" я завершаю редактирование строки
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст '4+1 Dress and Trousers, Discount on Basic Agreements'
			И в поле 'TR' я ввожу текст '4+1 Dress and Trousers TR, Discount on Basic Agreements'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 10
	И я создаю скидку 3+1, не кратна, товар 1 и 2
		Когда открываю окно создания скидки
		И я заполняю данные скидки 3+1 (ручное назначение)
			И в таблице "List" я перехожу к строке:
				| 'Description'                                   |
				| 'Dress,2 3+1, Discount on Basic Agreements' |
			И в таблице "List" я выбираю текущую строку
			И в поле 'Priority' я ввожу текст '4'
			Когда ввожу срок действия скидки текущий месяц
			И я изменяю флаг 'Manually'
			И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
			И я устанавливаю флаг 'Launch'
			И в таблице "Rules" я нажимаю на кнопку с именем 'RulesAdd'
			И в таблице "Rules" я нажимаю кнопку выбора у реквизита "Rule"
			И в таблице "List" я перехожу к строке:
				| 'Description'                                   |
				| 'Dress and Trousers 3+1, Discount on Basic Agreements' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Rules" я завершаю редактирование строки
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле 'ENG' я ввожу текст '3+1 Dress and Trousers (not multiplicity), Discount on Basic Agreements'
			И в поле 'TR' я ввожу текст '3+1 Dress and Trousers (not multiplicity) TR, Discount on Basic Agreements'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save and close'
			И Пауза 10
	И я проверяю наличие созданных скидок
		И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "3+1 Dress and Trousers (not multiplicity), Discount on Basic Agreements"
		И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "4+1 Dress and Trousers, Discount on Basic Agreements"
		И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "All items 5+1, Discount on Basic Agreements"
	И я перемещаю созданные скидки в группу Максимум
		Когда переношу скидку All items 5+1, Discount on Basic Agreements в группу Maximum
		Когда переношу скидку 3+1 Dress and Trousers (not multiplicity), Discount on Basic Agreements в группу Maximum
		Когда переношу скидку 4+1 Dress and Trousers, Discount on Basic Agreements в группу Maximum



Сценарий: _030025 create скидки Range Discount
	Когда открываю окно создания скидки
	И я заполняю данные скидки Range Discount Basic (Trousers)
		И в таблице "List" я перехожу к строке:
			| 'Description'                                   |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Priority' я ввожу текст '4'
		Когда ввожу срок действия скидки текущий месяц
		И я изменяю флаг 'Manually'
		И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
		И я изменяю флаг 'Launch'
		И я изменяю флаг 'Manual input value'
		И я меняю значение переключателя 'Type' на 'For row'
		И в таблице "Rules" я нажимаю на кнопку с именем 'RulesAdd'
		И в таблице "Rules" я нажимаю кнопку выбора у реквизита "Rule"
		И в таблице "List" я перехожу к строке:
			| 'Description'                                   |
			| 'Range Discount Basic (Trousers)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Rules" я завершаю редактирование строки
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Range Discount Basic (Trousers)'
		И в поле 'TR' я ввожу текст 'Range Discount Basic (Trousers)'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	Когда открываю окно создания скидки
	И я заполняю данные скидки Range Discount Basic (Dress)
		И в таблице "List" я перехожу к строке:
			| 'Description'                                   |
			| 'Range Discount Basic (Dress)' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Priority' я ввожу текст '4'
		Когда ввожу срок действия скидки текущий месяц
		И я изменяю флаг 'Manually'
		И из выпадающего списка "Document type" я выбираю точное значение 'Sales'
		И я изменяю флаг 'Launch'
		И я изменяю флаг 'Manual input value'
		И я меняю значение переключателя 'Type' на 'For row'
		И в таблице "Rules" я нажимаю на кнопку с именем 'RulesAdd'
		И в таблице "Rules" я нажимаю кнопку выбора у реквизита "Rule"
		И в таблице "List" я перехожу к строке:
			| 'Description'                                   |
			| 'Range Discount Basic (Dress)' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Rules" я завершаю редактирование строки
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Range Discount Basic (Dress)'
		И в поле 'TR' я ввожу текст 'Range Discount Basic (Dress)'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	И я проверяю наличие созданных скидок
		И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Range Discount Basic (Dress)"
		И я проверяю наличие элемента справочника "SpecialOffers" со значением поля "Description_en" "Range Discount Basic (Trousers)"
		И Я закрываю текущее окно

Сценарий: _030026 create скидки DocumentDiscount
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку с именем 'FormCreate'
	И в поле 'ENG' я ввожу текст 'Document discount'
	И я нажимаю на кнопку открытия поля "ENG"
	И в поле 'TR' я ввожу текст 'Document discount TR'
	И я нажимаю на кнопку 'Ok'
	И из выпадающего списка "Document type" я выбираю точное значение 'Purchases and sales'
	И я изменяю флаг 'Launch'
	И я нажимаю кнопку выбора у поля "Special offer type"
	И я нажимаю на кнопку с именем 'FormCreate'
	И в поле 'ENG' я ввожу текст 'Document discount'
	И я нажимаю на кнопку открытия поля "ENG"
	И в поле 'TR' я ввожу текст 'Document discount TR'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю кнопку выбора у поля "External data proc"
	Тогда открылось окно 'External data proc'
	И в таблице "List" я перехожу к строке:
		| Description               |
		| ExternalSpecialOfferRules |
	И в таблице "List" я перехожу к строке:
		| Description      |
		| DocumentDiscount |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку 'Save and close'
	И я жду закрытия окна 'Special offer type (create) *' в течение 20 секунд
	Тогда открылось окно 'Special offer types'
	И я нажимаю на кнопку с именем 'FormChoose'
	И в поле 'Priority' я ввожу текст '5'
	И в поле "Start of" я ввожу текущую дату
	И я изменяю флаг 'Manually'
	И я изменяю флаг 'Manual input value'
	И я нажимаю на кнопку 'Save and close'
	И я жду закрытия окна 'Special offer (create) *' в течение 20 секунд