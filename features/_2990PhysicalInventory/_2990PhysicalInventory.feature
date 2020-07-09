#language: ru
@tree
@Positive


Функционал: product inventory

Как разработчик
Я хочу добавить функционал по списанию недостач и оприходованию излишков товаров
Для работы с товаром


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий:_2990000 preparation
	* Создание ордерного склада Store 05
		И я открываю навигационную ссылку "e1cib/list/Catalog.Stores"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Store 05'
		И в поле с именем 'Description_tr' я ввожу текст 'Store 05 TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'UseGoodsReceipt'
		И я устанавливаю флаг с именем 'UseShipmentConfirmation'
		И     элемент формы с именем "Transit" стал равен 'No'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Создание неордерного склада Store 06
		И я открываю навигационную ссылку "e1cib/list/Catalog.Stores"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Store 06'
		И в поле с именем 'Description_tr' я ввожу текст 'Store 06 TR'
		И я нажимаю на кнопку 'Ok'
		И я снимаю флаг с именем 'UseGoodsReceipt'
		И я снимаю флаг с именем 'UseShipmentConfirmation'
		И     элемент формы с именем "Transit" стал равен 'No'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Добавление остатков по созданным складам (Opening entry)
		* Open document form для ввода начального остатка
			И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Заполнение информации о компании
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Заполнение номера документа
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '8'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '8'
		* Filling in the tabular part по остаткам товара
			И я перехожу к закладке "Inventory"
			И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| Item  | Item key |
				| Dress | XS/Blue  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 05    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я активизирую поле "Quantity"
			И в таблице "Inventory" в поле 'Quantity' я ввожу текст '200,000'
			И в таблице "Inventory" я завершаю редактирование строки
			И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| Item  | Item key |
				| Dress | S/Yellow |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я активизирую поле "Store"
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 05    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я активизирую поле "Quantity"
			И в таблице "Inventory" в поле 'Quantity' я ввожу текст '120,000'
			И в таблице "Inventory" я завершаю редактирование строки
			И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| Item  | Item key |
				| Dress | XS/Blue  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я активизирую поле "Store"
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 06    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я завершаю редактирование строки
			И в таблице "Inventory" я активизирую поле "Quantity"
			И в таблице "Inventory" я выбираю текущую строку
			И в таблице "Inventory" в поле 'Quantity' я ввожу текст '400,000'
			И в таблице "Inventory" я завершаю редактирование строки
			И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Trousers'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| Item  | Item key |
				| Trousers | 36/Yellow  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я активизирую поле "Store"
			И в таблице "Inventory" я нажимаю кнопку выбора у реквизита "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 06    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "Inventory" я завершаю редактирование строки
			И в таблице "Inventory" я активизирую поле "Quantity"
			И в таблице "Inventory" я выбираю текущую строку
			И в таблице "Inventory" в поле 'Quantity' я ввожу текст '400,000'
			И в таблице "Inventory" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post and close'


Сценарий: _2990001 filling in the status guide for PhysicalInventory and PhysicalCountByLocation
	* Open a creation form ObjectStatuses
		И я открываю навигационную ссылку "e1cib/list/Catalog.ObjectStatuses"
	* Присвоение предопределенному элементу PhysicalInventory наименования 
		И в таблице "List" я разворачиваю строку:
			| 'Description'     |
			| 'Objects status historyes' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| PhysicalInventory         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Physical inventory'
		И в поле 'TR' я ввожу текст 'Physical inventory TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	* Добавление статуса "Prepared"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Physical inventory' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Prepared'
		И в поле 'TR' я ввожу текст 'Prepared TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг 'Set by default'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
	* Добавление статуса "In processing"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Physical inventory' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'In processing'
		И в поле 'TR' я ввожу текст 'In processing TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
	* Добавление статуса "Done"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Physical inventory' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Done'
		И в поле 'TR' я ввожу текст 'Done TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
	* Присвоение предопределенному элементу PhysicalCountByLocation наименования 
		И в таблице "List" я разворачиваю строку:
			| 'Description'     |
			| 'Objects status historyes' |
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| PhysicalCountByLocation         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Physical сount by location'
		И в поле 'TR' я ввожу текст 'Physical сount by location TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	* Добавление статуса "Prepared"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Physical сount by location' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Prepared'
		И в поле 'TR' я ввожу текст 'Prepared TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг 'Set by default'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
	* Добавление статуса "In processing"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Physical сount by location' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'In processing'
		И в поле 'TR' я ввожу текст 'In processing TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
	* Добавление статуса "Done"
		И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Physical сount by location' |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю флаг 'Posting'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Done'
		И в поле 'TR' я ввожу текст 'Done TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2



Сценарий: _2990002 create Stock adjustment as surplus
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Main Company'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'      |
		И в таблице "List" я выбираю текущую строку
	* Filling in the tabular part
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '8,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Distribution department'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Revenue type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Delivery'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Check filling inтаблицы
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'           | 'Unit' | 'Revenue type' | 'Basis document' |
		| 'Dress' | '8,000'    | 'M/White'  | 'Distribution department' | 'pcs'  | 'Delivery'     | ''               |
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Post document
		И я нажимаю на кнопку 'Post'
	* Check movements
		И я нажимаю на кнопку 'Registrations report'
		# заменить после себестоимости
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as surplus 1*' | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records' | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'  | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'     | 'Company'                 | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'            | 'Main Company'            | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'     | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'            | 'Store 02'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Revenues turnovers"' | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''             | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                               | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                               | '*'           | ''          | 'Main Company' | 'Distribution department' | 'Delivery'     | 'M/White'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                               | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock balance"'      | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'     | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'            | 'Store 02'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		И Я закрыл все окна клиентского приложения
	* Проверка изменения проводок при перевыборе склада (неордерный) и компании
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Store 01' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as surplus 1*' | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records' | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'  | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'       | 'Company'                 | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'              | 'Second Company'          | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'       | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'              | 'Store 01'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Revenues turnovers"' | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'     | ''                        | ''             | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                               | ''            | 'Amount'    | 'Company'        | 'Business unit'           | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                               | '*'           | ''          | 'Second Company' | 'Distribution department' | 'Delivery'     | 'M/White'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                               | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock balance"'      | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'       | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'              | 'Store 01'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		И Я закрыл все окна клиентского приложения

Сценарий: _2990003 create Stock adjustment as write off
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Main Company'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'      |
		И в таблице "List" я выбираю текущую строку
	* Filling in the tabular part
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '8,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Distribution department'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Delivery'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Check filling inтаблицы
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'           | 'Unit' | 'Expense type' | 'Basis document' |
		| 'Dress' | '8,000'    | 'M/White'  | 'Distribution department' | 'pcs'  | 'Delivery'     | ''               |
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Post document
		И я нажимаю на кнопку 'Post'
	* Check movements
		И я нажимаю на кнопку 'Registrations report'
		# заменить после себестоимости
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as write-off 1*' | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'   | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'    | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'     | 'Company'                 | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'            | 'Main Company'            | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Expenses turnovers"'   | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''             | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                 | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Expense type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                 | '*'           | ''          | 'Main Company' | 'Distribution department' | 'Delivery'     | 'M/White'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                                 | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock reservation"'    | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'     | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'            | 'Store 02'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock balance"'        | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'     | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'            | 'Store 02'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		И Я закрыл все окна клиентского приложения
	* Проверка изменения проводок при перевыборе склада (неордерный) и компании
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку "Decoration group title collapsed picture"
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Second Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description'    |
			| 'Store 01' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as write-off 1*' | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'   | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'    | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'       | 'Company'                 | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'              | 'Second Company'          | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Expenses turnovers"'   | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Period'      | 'Resources' | 'Dimensions'     | ''                        | ''             | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                 | ''            | 'Amount'    | 'Company'        | 'Business unit'           | 'Expense type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                 | '*'           | ''          | 'Second Company' | 'Distribution department' | 'Delivery'     | 'M/White'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                                 | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock reservation"'    | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'       | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'              | 'Store 01'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock balance"'        | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'       | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'              | 'Store 01'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		И Я закрыл все окна клиентского приложения

Сценарий: _2990004 create Physical inventory (store use GR and SC)
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Status" я выбираю точное значение 'Done'
	* Check filling inдокумента остатками по складу
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Fill exp. count'
		И Пауза 2
		Тогда в таблице "ItemList" количество строк "меньше или равно" 2
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' |
		| 'Dress' | '-120,000'   | 'S/Yellow' | '120,000'    | 'pcs'  |
		| 'Dress' | '-200,000'   | 'XS/Blue'  | '200,000'    | 'pcs'  |
	* Заполнение фактического остатка
		И в таблице "ItemList" я перехожу к строке:
			| 'Difference' | 'Exp. count' | 'Item'  | 'Item key' | 'Unit' |
			| '-200,000'   | '200,000'    | 'Dress' | 'XS/Blue'  | 'pcs'  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '198,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Difference' | 'Exp. count' | 'Item'  | 'Item key' | 'Unit' |
			| '-120,000'   | '120,000'    | 'Dress' | 'S/Yellow' | 'pcs'  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '125,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '1'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '1'
	* Posting the documentинвентаризации
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Physical inventory 1*'                     | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Document registrations records'            | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as surplus"'   | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'Physical inventory 1*' | 'S/Yellow' |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock reservation"'             | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 05'   | 'XS/Blue'               | ''         |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'Physical inventory 1*' | 'XS/Blue'  |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 05'   | 'XS/Blue'               | ''         |
		И Я закрыл все окна клиентского приложения
	* Clear postings документа инвентаризации и проверка отмены проводок
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '1'       |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Physical inventory 1*' |
		| 'Document registrations records'                |
		И Я закрыл все окна клиентского приложения
	* Повторное проведение документа инвентаризации и проверка его движений
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '1'       |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Physical inventory 1*'                     | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Document registrations records'            | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as surplus"'   | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'Physical inventory 1*' | 'S/Yellow' |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock reservation"'             | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 05'   | 'XS/Blue'               | ''         |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'Physical inventory 1*' | 'XS/Blue'  |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 05'   | 'XS/Blue'               | ''         |
		И Я закрыл все окна клиентского приложения


Сценарий: _2990004 create Physical inventory (store doesn't use GR and SC)
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Status" я выбираю точное значение 'Done'
	* Check filling inдокумента остатками по складу
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 06'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Fill exp. count'
		И Пауза 2
		Тогда в таблице "ItemList" количество строк "меньше или равно" 2
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Difference' | 'Item key'   | 'Exp. count' | 'Unit' |
		| 'Dress'    | '-400,000'   | 'XS/Blue'    | '400,000'    | 'pcs'  |
		| 'Trousers' | '-400,000'   | '36/Yellow'  | '400,000'    | 'pcs'  |
	* Заполнение фактического остатка
		И в таблице "ItemList" я перехожу к строке:
			| 'Difference' | 'Exp. count' | 'Item'  | 'Item key' | 'Unit' |
			| '-400,000'   | '400,000'    | 'Dress' | 'XS/Blue'  | 'pcs'  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '398,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Difference' | 'Exp. count' | 'Item'     | 'Item key'  | 'Unit' |
			| '-400,000'   | '400,000'    | 'Trousers' | '36/Yellow' | 'pcs'  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '405,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '2'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	* Posting the documentинвентаризации
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Physical inventory 2*'                     | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Document registrations records'            | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Register  "Stock adjustment as surplus"'   | ''            | ''       | ''          | ''           | ''                      | ''          |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key'  |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 06'   | 'Physical inventory 2*' | '36/Yellow' |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Register  "Stock reservation"'             | ''            | ''       | ''          | ''           | ''                      | ''          |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''          |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 06'   | '36/Yellow'             | ''          |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 06'   | 'XS/Blue'               | ''          |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                      | ''          |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key'  |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 06'   | 'Physical inventory 2*' | 'XS/Blue'   |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                      | ''          |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''          |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 06'   | '36/Yellow'             | ''          |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 06'   | 'XS/Blue'               | ''          |
		И Я закрыл все окна клиентского приложения

Сценарий: _2990005 create Stock adjustment as surplus based on Physical inventory
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'    |
	* Create a document StockAdjustmentAsSurplus и проверка его заполнения
		И я нажимаю на кнопку с именем 'FormDocumentStockAdjustmentAsSurplusGenerateStockAdjustmentAsSurplus'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| 'Logistics department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Revenue type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Delivery'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Check filling inдокумента
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'        | 'Unit' | 'Revenue type' | 'Basis document'        |
		| 'Dress' | '5,000'    | 'S/Yellow' | 'Logistics department' | 'pcs'  | 'Delivery'     | 'Physical inventory 1*' |
		Тогда в таблице "ItemList" количество строк "меньше или равно" 1
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда открылось окно 'Stock adjustment as surplus (create) *'
		И в поле 'Number' я ввожу текст '2'
	* Posting the documentи проверка его движений
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as surplus 2*'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock adjustment as surplus"' | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | 'Quantity'     | 'Store'                | 'Basis document'        | 'Item key' | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Expense'     | '*'         | '5'            | 'Store 05'             | 'Physical inventory 1*' | 'S/Yellow' | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'           | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | 'Quantity'     | 'Company'              | 'Item key'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Receipt'     | '*'         | '5'            | 'Main Company'         | 'S/Yellow'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Revenues turnovers"'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Period'      | 'Resources' | 'Dimensions'   | ''                     | ''                      | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                        | ''            | 'Amount'    | 'Company'      | 'Business unit'        | 'Revenue type'          | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                        | '*'           | ''          | 'Main Company' | 'Logistics department' | 'Delivery'              | 'S/Yellow' | ''         | ''                    | ''                       | 'No'                   |
		И Я закрыл все окна клиентского приложения
	* Clear postings документа оприходования излишков и проверка отмены проводок
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '2'       |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as surplus 2*'          |
		| 'Document registrations records'                |
		И Я закрыл все окна клиентского приложения
	* Повторное проведение документа инвентаризации и проверка его движений
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '2'       |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as surplus 2*'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock adjustment as surplus"' | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | 'Quantity'     | 'Store'                | 'Basis document'        | 'Item key' | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Expense'     | '*'         | '5'            | 'Store 05'             | 'Physical inventory 1*' | 'S/Yellow' | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'           | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | 'Quantity'     | 'Company'              | 'Item key'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Receipt'     | '*'         | '5'            | 'Main Company'         | 'S/Yellow'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Revenues turnovers"'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Period'      | 'Resources' | 'Dimensions'   | ''                     | ''                      | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                        | ''            | 'Amount'    | 'Company'      | 'Business unit'        | 'Revenue type'          | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                        | '*'           | ''          | 'Main Company' | 'Logistics department' | 'Delivery'              | 'S/Yellow' | ''         | ''                    | ''                       | 'No'                   |
		И Я закрыл все окна клиентского приложения
	

Сценарий: _2990007 create Stock adjustment as write off based on Physical inventory
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '1'    |
	* Create a document StockAdjustmentAsWriteOff и проверка его заполнения
		И я нажимаю на кнопку с именем 'FormDocumentStockAdjustmentAsWriteOffGenerateStockAdjustmentAsWriteOff'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| 'Logistics department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Delivery'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Check filling inдокумента
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'        | 'Unit' | 'Expense type' | 'Basis document'        |
		| 'Dress' | '2,000'    | 'XS/Blue'  | 'Logistics department' | 'pcs'  | 'Delivery'     | 'Physical inventory 1*' |
		Тогда в таблице "ItemList" количество строк "меньше или равно" 1
	* Change the document number
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2'
	* Posting the documentи проверка его движений
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as write-off 2*'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'            | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'             | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | 'Quantity'     | 'Company'              | 'Item key'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Expense'     | '*'         | '2'            | 'Main Company'         | 'XS/Blue'               | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Expenses turnovers"'            | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Period'      | 'Resources' | 'Dimensions'   | ''                     | ''                      | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                          | ''            | 'Amount'    | 'Company'      | 'Business unit'        | 'Expense type'          | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                          | '*'           | ''          | 'Main Company' | 'Logistics department' | 'Delivery'              | 'XS/Blue'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                                          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | 'Quantity'     | 'Store'                | 'Basis document'        | 'Item key' | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Expense'     | '*'         | '2'            | 'Store 05'             | 'Physical inventory 1*' | 'XS/Blue'  | ''         | ''                    | ''                       | ''                     |
		И Я закрыл все окна клиентского приложения
	* Clear postings документа списания недостач и проверка отмены проводок
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '2'       |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as write-off 2*'          |
		| 'Document registrations records'                |
		И Я закрыл все окна клиентского приложения
	* Повторное проведение документа инвентаризации и проверка его движений
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
		И в таблице "List" я перехожу к строке:
			| 'Number'  |
			| '2'       |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuPost'
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Stock adjustment as write-off 2*'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'            | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'             | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | 'Quantity'     | 'Company'              | 'Item key'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Expense'     | '*'         | '2'            | 'Main Company'         | 'XS/Blue'               | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Expenses turnovers"'            | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Period'      | 'Resources' | 'Dimensions'   | ''                     | ''                      | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                          | ''            | 'Amount'    | 'Company'      | 'Business unit'        | 'Expense type'          | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                          | '*'           | ''          | 'Main Company' | 'Logistics department' | 'Delivery'              | 'XS/Blue'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                                          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | 'Quantity'     | 'Store'                | 'Basis document'        | 'Item key' | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Expense'     | '*'         | '2'            | 'Store 05'             | 'Physical inventory 1*' | 'XS/Blue'  | ''         | ''                    | ''                       | ''                     |
		И Я закрыл все окна клиентского приложения

Сценарий: _2990008 create Stock adjustment as surplus and Stock adjustment as write off based on Physical inventory on a partial quantity
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '2'    |
	* Create a document StockAdjustmentAsWriteOff на частичное количество
		И я нажимаю на кнопку с именем 'FormDocumentStockAdjustmentAsWriteOffGenerateStockAdjustmentAsWriteOff'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| 'Logistics department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Delivery'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Изменение количества и проведение документа
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Create a document StockAdjustmentAsWriteOff на оставшееся количество и проверка его заполнения
		И я нажимаю на кнопку с именем 'FormDocumentStockAdjustmentAsWriteOffGenerateStockAdjustmentAsWriteOff'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| 'Logistics department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Expense type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Delivery'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'        | 'Unit' | 'Expense type' | 'Basis document'        |
			| 'Dress' | '1,000'    | 'XS/Blue'  | 'Logistics department' | 'pcs'  | 'Delivery'     | 'Physical inventory 2*' |
		Тогда в таблице "ItemList" количество строк "меньше или равно" 1
		И я нажимаю на кнопку 'Post and close'
	* Create a document StockAdjustmentAsSurplus на частичное количество
		И я нажимаю на кнопку с именем 'FormDocumentStockAdjustmentAsSurplusGenerateStockAdjustmentAsSurplus'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| 'Logistics department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Revenue type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Delivery'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
	* Изменение количества и проведение документа
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
	* Create a document StockAdjustmentAsSurplus на оставшееся количество и проверка его заполнения
		И я нажимаю на кнопку с именем 'FormDocumentStockAdjustmentAsSurplusGenerateStockAdjustmentAsSurplus'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
		И в таблице "List" я перехожу к строке:
			| 'Description'          |
			| 'Logistics department' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Revenue type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Delivery'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'   | 'Business unit'        | 'Unit' | 'Revenue type' | 'Basis document'        |
			| 'Trousers' | '4,000'    | '36/Yellow'  | 'Logistics department' | 'pcs'  | 'Delivery'     | 'Physical inventory 2*' |
		Тогда в таблице "ItemList" количество строк "меньше или равно" 1
		И я нажимаю на кнопку 'Post and close'

Сценарий: _2990009 check for updates Update Exp Count
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inдокумента остатками по складу
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 06'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Fill exp. count'
		И Пауза 2
		Тогда в таблице "ItemList" количество строк "меньше или равно" 2
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Difference' | 'Item key'  | 'Exp. count' | 'Unit' |
			| 'Dress'    | '-398,000'   | 'XS/Blue'   | '398,000'    | 'pcs'  |
			| 'Trousers' | '-405,000'   | '36/Yellow' | '405,000'    | 'pcs'  |
	* Удаление второй строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Difference' | 'Exp. count' | 'Item'     | 'Item key'  | 'Unit' |
			| '-405,000'   | '405,000'    | 'Trousers' | '36/Yellow' | 'pcs'  |
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuDelete'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 1
	* Add one more line по которой нет остатка по складу
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Phys. count"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Проверка обновления
		И я нажимаю на кнопку 'Update exp. count'
		Тогда в таблице "ItemList" количество строк "меньше или равно" 3
		И     таблица "ItemList" содержит строки:
			| 'Phys. count' | 'Item'     | 'Difference' | 'Item key'  | 'Exp. count' | 'Unit' |
			| ''            | 'Trousers' | '-405,000'   | '36/Yellow' | '405,000'    | 'pcs'  |
			| ''            | 'Dress'    | '-398,000'   | 'XS/Blue'   | '398,000'    | 'pcs'  |
			| '2,000'       | 'Boots'    | '2,000'      | '37/18SD'   | ''           | 'pcs'  |
	И Я закрыл все окна клиентского приложения

Сценарий: _2990010 create Physical inventory and Physical count by location with distribution to responsible employees
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнения документа остатками по складу
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Fill exp. count'
		И Пауза 2
		Тогда в таблице "ItemList" количество строк "меньше или равно" 2
		# И     таблица "ItemList" содержит строки:
		# 	| 'Item'     | 'Difference' | 'Item key'  | 'Exp. count' | 'Unit' |
		# 	| 'Dress'    | '-398,000'   | 'XS/Blue'   | '398,000'    | 'pcs'  |
		# 	| 'Trousers' | '-405,000'   | '36/Yellow' | '405,000'    | 'pcs'  |
	* Распределение товара для пересчета на двух сотрудников
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'XS/Blue'  | 'pcs'  |
		И я нажимаю на кнопку 'Set responsible person'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Arina Brown' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Unit' |
			| 'Dress'    | 'S/Yellow'  | 'pcs'  |
		И я нажимаю на кнопку 'Set responsible person'
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Anna Petrova' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Post'
	* Формирование документов пересчета
		И я нажимаю на кнопку 'Physical count by location'
	* Проверка отображения в какие пересчеты попала строка
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Phys. count'    |
			| 'Dress' | '-125,000'   | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date:*'      |
			| 'Dress' | '-198,000'   | 'XS/Blue'  | '198,000'    | 'pcs'  | 'Arina Brown'        | '#2 date:*'      |
	* Check filling inданных о пересчете в табличной части
		И я перехожу к закладке "Physical count by location"
		И     таблица "PhysicalCountByLocationList" содержит строки:
			| 'Responsible person' | 'Status'   |
			| 'Arina Brown'        | 'Prepared' |
			| 'Anna Petrova'       | 'Prepared' |
	* Проведение оприходования излишков товара задним числом
		* Open document form
			И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling the document header
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'      |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 05'      |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part
			* Добавление первой строки
				И я нажимаю на кнопку 'Add'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Item key"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
				И в таблице "List" я перехожу к строке:
					| 'Item key' |
					| 'M/White'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" в поле 'Quantity' я ввожу текст '8,000'
				И в таблице "ItemList" я завершаю редактирование строки
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Distribution department'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Revenue type"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Delivery'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я завершаю редактирование строки
			* Добавление второй строки
				И я нажимаю на кнопку 'Add'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Item key"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
				И в таблице "List" я перехожу к строке:
					| 'Item key' |
					| 'XS/Blue'|
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" в поле 'Quantity' я ввожу текст '8,000'
				И в таблице "ItemList" я завершаю редактирование строки
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Distribution department'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Revenue type"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Delivery'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я завершаю редактирование строки
			* Добавление третей строки
				И я нажимаю на кнопку 'Add'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Shirt'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Item key"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
				И в таблице "List" я перехожу к строке:
					| 'Item key' |
					| '36/Red'|
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" в поле 'Quantity' я ввожу текст '7,000'
				И в таблице "ItemList" я завершаю редактирование строки
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Distribution department'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Revenue type"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Delivery'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я завершаю редактирование строки
			* Добавление четвертой строки
				И я нажимаю на кнопку 'Add'
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Boots'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я активизирую поле "Item key"
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
				И в таблице "List" я перехожу к строке:
					| 'Item key' |
					| '36/18SD'|
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
				И в таблице "ItemList" я завершаю редактирование строки
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Business unit"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Distribution department'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Revenue type"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Delivery'  |
				И в таблице "List" я выбираю текущую строку
				И в таблице "ItemList" я завершаю редактирование строки
			* Изменение даты и проведение документа
				И в поле 'Date' я ввожу начало текущего месяца
				И я нажимаю на кнопку 'Post and close'
	* Проведение Shipment confirmation задним числом
		* Открытие формы Shipment confirmation
			И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
			И я нажимаю на кнопку с именем 'FormCreate'
			И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		* Заполнение Partner
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Nicoletta'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 05'    |
			И в таблице "List" я выбираю текущую строку
		* Добавление товара
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Dress'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Dress'    | 'XS/Blue'   |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '4,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Изменение даты и проведение документа
			И я перехожу к закладке "Other"
			И в поле 'Date' я ввожу начало текущего месяца
			И я нажимаю на кнопку 'Post and close'
		И Я закрыл все окна клиентского приложения
	* Обновление количества в документе инвентаризации при созданных пересчетах
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '3'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Update exp. count'
		И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Phys. count' |
			| 'Dress' | '-8,000'     | 'M/White'  | '8,000'      | 'pcs'  | ''                   | ''               |
			| 'Shirt' | '-7,000'     | '36/Red'   | '7,000'      | 'pcs'  | ''                   | ''               |
			| 'Boots' | '-4,000'     | '36/18SD'  | '4,000'      | 'pcs'  | ''                   | ''               |
			| 'Dress' | '-125,000'   | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date*'       |
			| 'Dress' | '-202,000'   | 'XS/Blue'  | '202,000'    | 'pcs'  | 'Arina Brown'        | '#2 date*'       |
		* Проверка блокировки строк по которым уже был создан пересчет
			* Невозможность удаления строки
				И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
				И в таблице "ItemList" я активизирую поле "Item key"
				И в таблице "ItemList" я удаляю строку
				И     таблица "ItemList" содержит строки:
				| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Phys. count' |
				| 'Dress' | '-125,000'   | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date*'       |
			* Невозможность изменения количества по строке
				И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
				Когда Проверяю шаги на Исключение:
				|И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '2,000'|
		* Проверка доступности добавленных строк
			* Изменение количества
				И в таблице "ItemList" я перехожу к строке:
					| 'Item'  | 'Item key' | 'Unit' |
					| 'Dress' | 'M/White'   | 'pcs'  |
				И в таблице "ItemList" я выбираю текущую строку
				И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '7,000'
				И в таблице "ItemList" я завершаю редактирование строки
			* Удаление строк
				И в таблице "ItemList" я перехожу к строке:
					| 'Item'  | 'Item key' | 'Unit' |
					| 'Shirt' | '36/Red'   | 'pcs'  |
				И в таблице "ItemList" я удаляю строку
				И     таблица "ItemList" не содержит строки:
					| 'Item'  | 'Item key' | 'Unit' |
					| 'Shirt' | '36/Red'   | 'pcs'  |
		* Обновление количества и создание новых пересчетов
			И я нажимаю на кнопку 'Update exp. count'
			И в таблице "ItemList" я перехожу к строке:
				| 'Exp. count' | 'Item'  | 'Item key' | 'Unit' |
				| '4,000'      | 'Boots' | '36/18SD'  | 'pcs'  |
			И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '0,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'   |
			И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '0,000'
			И в таблице "ItemList" я завершаю редактирование строки
			Тогда в таблице "ItemList" я выделяю все строки
			И я нажимаю на кнопку 'Set responsible person'
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Anna Petrova' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Post'
			И я нажимаю на кнопку 'Physical count by location'
		* create новых перерасчетов
			И     таблица "ItemList" содержит строки:
			| 'Item'  | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Phys. count' |
			| 'Dress' | 'M/White'  | '8,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
			| 'Shirt' | '36/Red'   | '7,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
			| 'Boots' | '36/18SD'  | '4,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
			| 'Dress' | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date:*'      |
			| 'Dress' | 'XS/Blue'  | '202,000'    | 'pcs'  | 'Arina Brown'        | '#2 date:*'      |
		* Проверка на невозможность изменить статус на тот который делает проводки при незакрытых пересчетах
			И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
			И из выпадающего списка "Status" я выбираю точное значение 'Done'
			И я нажимаю на кнопку 'Post'
			Затем я жду, что в сообщениях пользователю будет подстрока "Not yet all Physical count by location is closed" в течение 30 секунд
		* Изменение статуса на "In processing" и проведение документа
			И из выпадающего списка "Status" я выбираю точное значение 'In processing'
			И я нажимаю на кнопку 'Post and close'

Сценарий: _2990011 перезаполнение инвентаризации based on данных пересчетов
	* Открытие списков пересчетов
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
	* Заполнение фактического количества в первом пересчете и установка статуса который делает проводки
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Status'   | 'Store'    |
			| '1'      | 'Prepared' | 'Store 05' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Phys. count"
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '124,000'
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
		И из выпадающего списка "Status" я выбираю точное значение 'Done'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
	* Заполнение фактического количества во втором пересчете и установка статуса который не делает проводки
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Status'   | 'Store'    |
			| '2'      | 'Prepared' | 'Store 05' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
		И в таблице "ItemList" я активизирую поле "Phys. count"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '197,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И из выпадающего списка "Status" я выбираю точное значение 'In processing'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
	* Заполнение фактического количества в третьем пересчете и установка статуса который делает проводки
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
		И в таблице "List" я перехожу к строке:
			| 'Number' | 'Status'   | 'Store'    |
			| '3'      | 'Prepared' | 'Store 05' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'M/White'  | 'pcs'  |
		И в таблице "ItemList" я активизирую поле "Phys. count"
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Shirt' | '36/Red'   | 'pcs'  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '7,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '36/18SD'  | 'pcs'  |
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Phys. count' я ввожу текст '4,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
		И из выпадающего списка "Status" я выбираю точное значение 'Done'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И Я закрыл все окна клиентского приложения
	* Заполнение документа инвентаризации итогами первого и третьего перерасчета
		И я открываю навигационную ссылку "e1cib/list/Document.PhysicalInventory"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '3'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Update phys. count'
		И     таблица "ItemList" содержит строки:
		| 'Phys. count' | 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Phys. count' |
		| '10,000'      | 'Dress' | '2,000'      | 'M/White'  | '8,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
		| '7,000'       | 'Shirt' | ''           | '36/Red'   | '7,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
		| '4,000'       | 'Boots' | ''           | '36/18SD'  | '4,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
		| '124,000'     | 'Dress' | '-1,000'     | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date*'       |
		| ''            | 'Dress' | '-202,000'   | 'XS/Blue'  | '202,000'    | 'pcs'  | 'Arina Brown'        | '#2 date*'       |
		И я нажимаю на кнопку 'Save'
	* Проверка на то, что без закрытого перерасчета нельзя закрыть инвентаризацию
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
		И из выпадающего списка "Status" я выбираю точное значение 'Done'
		И я нажимаю на кнопку 'Post'
		Затем я жду, что в сообщениях пользователю будет подстрока "Not yet all Physical count by location is closed" в течение 30 секунд
	* Проверка на то, что повторно перерасчеты не создадуться и их статусы не изменятся
		И из выпадающего списка "Status" я выбираю точное значение 'In processing'
		И я нажимаю на кнопку 'Physical count by location'
		И я перехожу к закладке "Physical count by location"
		И     таблица "PhysicalCountByLocationList" содержит строки:
		| 'Reference'                     | 'Status'        |
		| 'Physical count by location 1*' | 'Done'          |
		| 'Physical count by location 2*' | 'In processing' |
		| 'Physical count by location 3*' | 'Done'          |
		И Я закрыл все окна клиентского приложения
	* Закрытие второго перерасчета и перезаполнение инвентаризации
		И я открываю навигационную ссылку "e1cib/list/Document.PhysicalCountByLocation"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '2'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
		И из выпадающего списка "Status" я выбираю точное значение 'Done'
		И я нажимаю на кнопку 'Save and close'
		И я открываю навигационную ссылку "e1cib/list/Document.PhysicalInventory"
		И в таблице "List" я перехожу к строке:
			| 'Number' |
			| '3'      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Update phys. count'
		И     таблица "ItemList" содержит строки:
		| 'Phys. count' | 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Phys. count' |
		| '10,000'      | 'Dress' | '2,000'      | 'M/White'  | '8,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
		| '7,000'       | 'Shirt' | ''           | '36/Red'   | '7,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
		| '4,000'       | 'Boots' | ''           | '36/18SD'  | '4,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
		| '124,000'     | 'Dress' | '-1,000'     | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date:*'      |
		| '197,000'     | 'Dress' | '-5,000'     | 'XS/Blue'  | '202,000'    | 'pcs'  | 'Arina Brown'        | '#2 date:*'      |
		И я нажимаю на гиперссылку с именем "DecorationGroupTitleCollapsedPicture"
		И из выпадающего списка "Status" я выбираю точное значение 'Done'
		И я нажимаю на кнопку 'Post'
	* Check movements инвентаризации
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
		| 'Physical inventory 3*'                     | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Document registrations records'            | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as surplus"'   | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'Physical inventory 3*' | 'M/White'  |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock reservation"'             | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'M/White'               | ''         |
		| ''                                          | 'Expense'     | '*'      | '1'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '5'         | 'Store 05'   | 'XS/Blue'               | ''         |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '1'         | 'Store 05'   | 'Physical inventory 3*' | 'S/Yellow' |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'Physical inventory 3*' | 'XS/Blue'  |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'M/White'               | ''         |
		| ''                                          | 'Expense'     | '*'      | '1'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '5'         | 'Store 05'   | 'XS/Blue'               | ''         |
		И Я закрыл все окна клиентского приложения

Сценарий: _2990012 check the opening of the status history in Physical inventory and Physical count by location
	* Проверка открытия истории статусов в Physical inventory
		* Открытие нужного документа
			И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
			И в таблице "List" я перехожу к строке:
				| 'Number'  |
				| '3'       |
			И в таблице "List" я выбираю текущую строку
		* Открытие и проверка истории статусов
			И я перехожу к закладке "Other"
			И я нажимаю на гиперссылку "History"
			Тогда таблица "List" содержит строки:
			| 'Period' | 'Object'                | 'Status'        |
			| '*'      | 'Physical inventory 3*' | 'Prepared'      |
			| '*'      | 'Physical inventory 3*' | 'In processing' |
			| '*'      | 'Physical inventory 3*' | 'Done'          |
			И Я закрыл все окна клиентского приложения
	* Проверка открытия истории статусов в Physical inventory
		* Открытие нужного документа
			И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
			И в таблице "List" я перехожу к строке:
				| 'Number'  |
				| '3'       |
			И в таблице "List" я выбираю текущую строку
		* Открытие и проверка истории статусов
			И я перехожу к закладке "Other"
			И я нажимаю на гиперссылку "History"
			Тогда таблица "List" содержит строки:
			| 'Period' | 'Object'                        | 'Status'        |
			| '*'      | 'Physical count by location 3*' | 'Prepared'      |
			| '*'      | 'Physical count by location 3*' | 'Done'          |
			И Я закрыл все окна клиентского приложения
	
Сценарий: _2990013 checking the question of saving Physical inventory before creating Physical count by location
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнения документа остатками по складу
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Fill exp. count'
	* Проверка вывода сообщения
		И я нажимаю на кнопку 'Physical count by location'
		Тогда элемент формы с именем "Message" стал равен 
		|'To run the "Physical count by location" command, you must save your work. Click OK to save and continue, or click Cancel to return.'|
	И Я закрыл все окна клиентского приложения






