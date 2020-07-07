#language: ru
@tree
@Positive
Функционал: auto создание item key при Unbundling по спецификации


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _300301 preparation
	* Создание item для bundle
		* Open a creation form Items
			И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Создание тестовой номенклатуры Сhewing gum
			И я нажимаю на кнопку открытия поля с именем "Description_tr"
			И в поле с именем 'Description_en' я ввожу текст 'Сhewing gum'
			И в поле с именем 'Description_tr' я ввожу текст 'Сhewing gum TR'
			И я нажимаю на кнопку 'Ok'
			* Создание и выбор вида номенклатуры для конфет
				И я нажимаю кнопку выбора у поля "Item type"
				И я нажимаю на кнопку с именем 'FormCreate'
				И в поле 'TR' я ввожу текст 'Сhewing gum'
				И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
				И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
				И я нажимаю на кнопку с именем 'FormCreate'
				И в поле 'TR' я ввожу текст 'Сhewing gum taste'
				И я нажимаю на кнопку 'Save and close'
				И я нажимаю на кнопку с именем 'FormCreate'
				И в поле 'TR' я ввожу текст 'Сhewing gum brand'
				И я нажимаю на кнопку 'Save and close'
				И Пауза 5
				И я нажимаю на кнопку с именем 'FormChoose'
				И в таблице "AvailableAttributes" я завершаю редактирование строки
				И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
				И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Сhewing gum taste' |
				И я нажимаю на кнопку с именем 'FormChoose'
				И в таблице "AvailableAttributes" я завершаю редактирование строки
				И я нажимаю на кнопку 'Save and close'
				И Пауза 5
				И я нажимаю на кнопку с именем 'FormChoose'
			* Выбор единицы измерения
				И я нажимаю кнопку выбора у поля "Unit"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'adet'         |
				И в таблице "List" я выбираю текущую строку
			И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
			И Пауза 5
	* Внесение значений доп реквизита Сhewing gum brand и Сhewing gum taste
		И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'TR' я ввожу текст 'Cherry'
		И я нажимаю кнопку выбора у поля "Additionsl attribute"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сhewing gum taste' |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'TR' я ввожу текст 'Mango'
		И я нажимаю кнопку выбора у поля "Additionsl attribute"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сhewing gum taste' |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'TR' я ввожу текст 'Mint'
		И я нажимаю кнопку выбора у поля "Additionsl attribute"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сhewing gum brand' |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Создание спецификации
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		* Создание спецификации Сhewing gum
			И я нажимаю на кнопку с именем "FormCreate"
			И я меняю значение переключателя 'Type' на 'Set'
			И я нажимаю кнопку выбора у поля "Item type"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Сhewing gum'     |
			И в таблице "List" я выбираю текущую строку
			И в таблице "FormTable*" я нажимаю на кнопку 'Add'
			И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Сhewing gum taste"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Mango'          |
			И в таблице "List" я выбираю текущую строку
			И в таблице "FormTable*" я активизирую поле "Сhewing gum brand"
			И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Сhewing gum brand"
			И в таблице "List" я выбираю текущую строку
			И в таблице "FormTable*" я активизирую поле "Quantity"
			И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '10,000'
			И в таблице "FormTable*" я завершаю редактирование строки
			И в таблице "FormTable*" я нажимаю на кнопку 'Add'
			И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Сhewing gum taste"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Cherry'          |
			И в таблице "List" я выбираю текущую строку
			И в таблице "FormTable*" я активизирую поле "Сhewing gum brand"
			И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Сhewing gum brand"
			И в таблице "List" я выбираю текущую строку
			И в таблице "FormTable*" я активизирую поле "Quantity"
			И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '10,000'
			И в таблице "FormTable*" я завершаю редактирование строки
			И я нажимаю на кнопку открытия поля с именем "Description_tr"
			И в поле 'ENG' я ввожу текст 'Сhewing gum'
			И в поле 'TR' я ввожу текст 'Сhewing gum'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю на кнопку 'Save'
			И я закрыл все окна клиентского приложения
	* Создание item key для Сhewing gum Specifications
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Сhewing gum TR'          |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг с именем 'SpecificationMode'
		И я нажимаю кнопку выбора у поля с именем "Specification"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
		И я закрыл все окна клиентского приложения

Сценарий: _300302 создание документа Unbundling и create item key
	* Заполнение шапки документа Unbundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company TR |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Сhewing gum TR       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item key  |
			| Сhewing gum TR/Сhewing gum |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| adet      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01 TR' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
		И     таблица "ItemList" содержит строки:
			| 'Item'           | 'Quantity' | 'Item key'    | 'Unit' |
			| 'Сhewing gum TR' | '10,000'   | 'Mint/Mango'  | 'adet' |
			| 'Сhewing gum TR' | '10,000'   | 'Mint/Cherry' | 'adet' |
		И я нажимаю на кнопку 'Post and close'
	* create недостающих item key
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemKeys'
		Тогда таблица "List" содержит строки:
		| 'Item key'                                     |
		| 'Mint/Mango'                                   |
		| 'Mint/Cherry'                                  |
		И я закрыл все окна клиентского приложения
	* Проверка того, что при повторном создании Unbundling строки не задублируются
		* Create one more Unbundling
			И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company TR |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Item bundle"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Сhewing gum TR       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Item key bundle"
			И в таблице "List" я перехожу к строке:
				| Item key  |
				| Сhewing gum TR/Сhewing gum |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Unit"
			И в таблице "List" я перехожу к строке:
				| Description |
				| adet      |
			И в таблице "List" я выбираю текущую строку
			И в поле с именем 'Quantity' я ввожу текст '2,000'
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01 TR' |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Item list"
			И в таблице "ItemList" я нажимаю на кнопку 'By specification'
			И     таблица "ItemList" содержит строки:
				| 'Item'           | 'Quantity' | 'Item key'    | 'Unit' |
				| 'Сhewing gum TR' | '10,000'   | 'Mint/Mango'  | 'adet' |
				| 'Сhewing gum TR' | '10,000'   | 'Mint/Cherry' | 'adet' |
			И я нажимаю на кнопку 'Post and close'
		* Проверка, что item key не задублировались
			И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Сhewing gum TR'          |
			И в таблице "List" я выбираю текущую строку
			И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
			Тогда в таблице  "List" количество строк "меньше или равно" 3
			И я закрыл все окна клиентского приложения

