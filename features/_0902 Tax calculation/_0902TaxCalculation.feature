#language: ru
@tree
@Positive

Функционал: tax calculation check


# individually applying Tax types

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _0902000 preparation
	* Create item type
		* Open a creation form ItemTypes
			И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Создание видов номенклатуры: Bags
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле с именем 'Description_en' я ввожу текст 'Bags'
			И в поле с именем 'Description_tr' я ввожу текст 'Bags TR'
			И я нажимаю на кнопку 'Ok'
			И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
			И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Producer'    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AvailableAttributes" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И я закрыл все окна клиентского приложения
	* Create Item Bag
		* Open a creation form Items
			И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
			И я нажимаю на кнопку с именем 'FormCreate'
		* Create Item Bag
			И я нажимаю на кнопку открытия поля с именем "Description_en"
			И в поле с именем 'Description_en' я ввожу текст 'Bag'
			И в поле с именем 'Description_tr' я ввожу текст 'Bag TR'
			И я нажимаю на кнопку 'Ok'
			И я нажимаю кнопку выбора у поля  с именем "ItemType"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Bags'       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Unit"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Save'
	* Create item key for Bag
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Producer"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Producer'      | 'ODS'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Producer"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Producer'      | 'PZU'         |
		И в таблице "List" я активизирую поле "Add attribute"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	* Filling tax rates for Item key in the register
		И я открываю навигационную ссылку "e1cib/list/InformationRegister.TaxSettings"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя 'RecordType' на 'Item key'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Tax"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Reference' |
			| 'VAT'         | 'VAT'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item' | 'Item key' |
			| 'Bag'  | 'ODS'      |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Tax rate" я выбираю точное значение '0%'
		И в поле 'Period' я ввожу текст '01.01.2020'
		И я нажимаю на кнопку 'Save and close'
	* Filling tax rates for Item in the register
		И я открываю навигационную ссылку "e1cib/list/InformationRegister.TaxSettings"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя 'RecordType' на 'Item'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Tax"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Reference' |
			| 'VAT'         | 'VAT'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Bag'         |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Tax rate" я выбираю точное значение '18%'
		И в поле 'Period' я ввожу текст '01.01.2020'
		И я нажимаю на кнопку 'Save and close'
	* Filling tax rates for Item type in the register
		И я открываю навигационную ссылку "e1cib/list/InformationRegister.TaxSettings"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя 'RecordType' на 'Item type'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Tax"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Reference' |
			| 'VAT'         | 'VAT'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Bags'         |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Tax rate" я выбираю точное значение '18%'
		И в поле 'Period' я ввожу текст '01.01.2020'
		И я нажимаю на кнопку 'Save and close'
	И я закрыл все окна клиентского приложения


Сценарий: _090200 activating Sales Tax calculation in Sales order and Sales invoice documents
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Tax types'
	И в таблице "List" я перехожу к строке:
		| 'Description' | 'Reference' |
		| 'SalesTax'    | 'SalesTax'  |
	И в таблице "List" я выбираю текущую строку
	И я перехожу к закладке "Use documents"
	И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
	И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Sales order'
	И в таблице "UseDocuments" я завершаю редактирование строки
	И в таблице "UseDocuments" я нажимаю на кнопку с именем 'UseDocumentsAdd'
	И в таблице "UseDocuments" из выпадающего списка "Document name" я выбираю точное значение 'Sales invoice'
	И в таблице "UseDocuments" я завершаю редактирование строки
	И я нажимаю на кнопку 'Save and close'

Сценарий: _090201 VAT and Sales Tax calculation in Sales order (Price include tax box is set)
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Adding items to Sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Check the calculation of VAT and Sales Tax
		И     таблица "ItemList" содержит строки:
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Q'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
		| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '1,000' | '64,98'      | '1%'       | 'pcs'  | '335,02'     | '400,00'       |
		И     таблица "TaxTree" содержит строки:
		| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
		| 'VAT'      | ''         | ''         | ''          | ''          | '61,02'  | '61,02'         |
		| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '61,02'  | '61,02'         |
		| 'SalesTax' | ''         | ''         | ''          | ''          | '3,96'   | '3,96'          |
		| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '3,96'   | '3,96'          |
	* Add one more line and check the calculation of VAT and Sales Tax
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '64,98'      | '1%'       | '335,02'     | '400,00'       |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | '2,000' | '227,42'     | '1%'       | '1 172,58'   | '1 400,00'     |
		И     таблица "TaxTree" содержит строки:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | '274,58' | '274,58'        |
			| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '61,02'  | '61,02'         |
			| 'VAT'      | '18%'      | 'Boots'    | '37/18SD'   | ''          | '213,56' | '213,56'        |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '17,82'  | '17,82'         |
			| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '3,96'   | '3,96'          |
			| 'SalesTax' | '1%'       | 'Boots'    | '37/18SD'   | ''          | '13,86'  | '13,86'         |
	* Deleting the row and checking the VAT and Sales Tax recalculation
		И в таблице "ItemList" я перехожу к строке:
		| 'Item'     | 'Item key'  |
		| 'Trousers' | '38/Yellow' |
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице 'ItemList' я удаляю строку
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'SalesTax' | 'Net amount' | 'Total amount' |
			| '700,00' | 'Boots' | '18%' | '37/18SD'  | '2,000' | '227,42'     | '1%'       | '1 172,58'   | '1 400,00'     |
		И     таблица "TaxTree" стала равной:
			| 'Tax'      | 'Tax rate' | 'Item' | 'Item key' | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''     | ''         | ''          | '213,56' | '213,56'        |
			| 'SalesTax' | ''         | ''     | ''         | ''          | '13,86'  | '13,86'         |
		И я закрыл все окна клиентского приложения

Сценарий: _090202 VAT and Sales Tax calculation in Sales order (Price include tax box isn't set)
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я снимаю флаг 'Price include tax'
	* Adding items to Sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Check the calculation of VAT and Sales Tax
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '76,00'      | '1%'       | 'pcs'  | '400,00'     | '476,00'       |
		И     таблица "TaxTree" содержит строки:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | '72,00'  | '72,00'         |
			| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '72,00'  | '72,00'         |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '4,00'   | '4,00'          |
			| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '4,00'   | '4,00'          |
	* Add one more line and check the calculation of VAT and Sales Tax
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Q'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '1,000' | '76,00'      | '1%'       | 'pcs'  | '400,00'     | '476,00'       |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | 'Stock'              | '2,000' | '266,00'     | '1%'       | 'pcs'  | '1 400,00'   | '1 666,00'     |
		И     таблица "TaxTree" содержит строки:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | '324,00' | '324,00'        |
			| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '72,00'  | '72,00'         |
			| 'VAT'      | '18%'      | 'Boots'    | '37/18SD'   | ''          | '252,00' | '252,00'        |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '18,00'  | '18,00'         |
			| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '4,00'   | '4,00'          |
			| 'SalesTax' | '1%'       | 'Boots'    | '37/18SD'   | ''          | '14,00'  | '14,00'         |
	* Deleting the row and checking the VAT and Sales Tax recalculation
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице 'ItemList' я удаляю строку
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | '2,000' | ''              | '266,00'     | '1%'       | 'pcs'  | '1 400,00'   | '1 666,00'     |
		И     таблица "TaxTree" стала равной:
			| 'Tax'      | 'Tax rate' | 'Item' | 'Item key' | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''     | ''         | ''          | '252,00' | '252,00'        |
			| 'SalesTax' | ''         | ''     | ''         | ''          | '14,00'  | '14,00'         |
		И я закрыл все окна клиентского приложения

Сценарий: _090203 manual tax correction in Sales order
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я снимаю флаг 'Price include tax'
	* Adding items to Sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "TaxTree" я завершаю редактирование строки
	* Manual tax correction and check display
		И я перехожу к закладке "Tax list"
		И в таблице "TaxTree" я перехожу к строке:
			| 'Amount' | 'Item'     |
			| '72,00'  | 'Trousers' |
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" в поле 'Manual amount' я ввожу текст '71,00'
		И Пауза 60
		И в таблице "TaxTree" я разворачиваю текущую строку
		И я перехожу к закладке "Item list"
	* Save verification
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '75,00'      | '1%'       | 'pcs'  | '400,00'     | '475,00'       |
		И     таблица "TaxTree" стала равной:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | '72,00'  | '71,00'         |
			| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '72,00'  | '71,00'         |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '4,00'   | '4,00'          |
			| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '4,00'   | '4,00'          |
	* Check deleting manual correction when quantity changes
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount'  | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | '152,00'      | '1%'       | 'pcs'   | '800,00'      | '952,00'     |
		И     таблица "TaxTree" содержит строки:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | '144,00' | '144,00'        |
			| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '144,00' | '144,00'        |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '8,00'   | '8,00'          |
			| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '8,00'   | '8,00'          |
	* Check deleting manual correction when price changes
		И я перехожу к закладке "Tax list"
		И в таблице "TaxTree" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Tax' | 'Tax rate' |
			| 'Trousers' | '38/Yellow' | 'VAT' | '18%'      |
		И в таблице "TaxTree" я активизирую поле с именем "TaxTreeAmount"
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" я активизирую поле "Manual amount"
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" в поле 'Manual amount' я ввожу текст '142,00'
		И в таблице "TaxTree" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| 'Trousers' | '18%' | '38/Yellow' | '2,000' | '150,00'     | '1%'       | 'pcs'  | '800,00'     | '950,00'     |
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '510,00'
		И     таблица "TaxTree" содержит строки:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | '183,60' | '183,60'        |
			| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '183,60' | '183,60'        |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '10,20'  | '10,20'         |
			| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '10,20'  | '10,20'         |
	* Check deleting manual correction when iten key changes
		И я перехожу к закладке "Tax list"
		И в таблице "TaxTree" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Tax' | 'Tax rate' |
			| 'Trousers' | '38/Yellow' | 'VAT' | '18%'      |
		И в таблице "TaxTree" я активизирую поле с именем "TaxTreeAmount"
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" я активизирую поле "Manual amount"
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" в поле 'Manual amount' я ввожу текст '182,00'
		И в таблице "TaxTree" я завершаю редактирование строки
		И я перехожу к закладке "Item list"
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '510,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | '192,20'     | '1%'       | 'pcs'  | '1 020,00'   | '1 212,20'     |
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И     таблица "TaxTree" содержит строки:
		| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
		| 'VAT'      | ''         | ''         | ''          | ''          | '144,00' | '144,00'        |
		| 'VAT'      | '18%'      | 'Trousers' | '36/Yellow' | ''          | '144,00' | '144,00'        |
		| 'SalesTax' | ''         | ''         | ''          | ''          | '8,00'   | '8,00'          |
		| 'SalesTax' | '1%'       | 'Trousers' | '36/Yellow' | ''          | '8,00'   | '8,00'          |
	* Manual selection of tax rate
		И в таблице "ItemList" я активизирую поле "VAT"
		И в таблице "ItemList" из выпадающего списка "VAT" я выбираю точное значение '0%'
		И     таблица "TaxTree" стала равной:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | ''       | ''              |
			| 'VAT'      | '0%'       | 'Trousers' | '36/Yellow' | ''          | ''       | ''              |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '8,00'   | '8,00'          |
			| 'SalesTax' | '1%'       | 'Trousers' | '36/Yellow' | ''          | '8,00'   | '8,00'          |
	И я закрыл все окна клиентского приложения


Сценарий: _090204 check tax transfer in Sales invoice when it is created based on
	* Create Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Price type'        | 'Q'     | 'Unit' | 'SalesTax' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Basic Price Types' | '1,000' | 'pcs'  | '1%'       | '64,98'      | '335,02'     | '400,00'       |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | 'Basic Price Types' | '2,000' | 'pcs'  | '1%'       | '227,42'     | '1 172,58'   | '1 400,00'     |
		И     таблица "TaxTree" содержит строки:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | '274,58' | '274,58'        |
			| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '61,02'  | '61,02'         |
			| 'VAT'      | '18%'      | 'Boots'    | '37/18SD'   | ''          | '213,56' | '213,56'        |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '17,82'  | '17,82'         |
			| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '3,96'   | '3,96'          |
			| 'SalesTax' | '1%'       | 'Boots'    | '37/18SD'   | ''          | '13,86'  | '13,86'         |
		И в таблице "TaxTree" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Tax' | 'Tax rate' |
			| 'Trousers' | '38/Yellow' | 'VAT' | '18%'      |
		И в таблице "TaxTree" я активизирую поле с именем "TaxTreeAmount"
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" я активизирую поле "Manual amount"
		И в таблице "TaxTree" я выбираю текущую строку
		И в таблице "TaxTree" в поле 'Manual amount' я ввожу текст '62,00'
		И в таблице "TaxTree" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '3 000'
		И я нажимаю на кнопку 'Post'
	* Create Sales invoice based on Sales order and check filling Tax types
		И я нажимаю на кнопку 'Sales invoice'
		И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'SalesTax' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | 'pcs'  | '1%'       | '65,96'      | '334,04'     | '400,00'       | 'Store 01' |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | '2,000' | 'pcs'  | '1%'       | '227,42'     | '1 172,58'   | '1 400,00'     | 'Store 01' |
		И     таблица "TaxTree" содержит строки:
			| 'Tax'      | 'Tax rate' | 'Item'     | 'Item key'  | 'Analytics' | 'Amount' | 'Manual amount' |
			| 'VAT'      | ''         | ''         | ''          | ''          | '274,58' | '275,56'        |
			| 'VAT'      | '18%'      | 'Trousers' | '38/Yellow' | ''          | '61,02'  | '62,00'         |
			| 'VAT'      | '18%'      | 'Boots'    | '37/18SD'   | ''          | '213,56' | '213,56'        |
			| 'SalesTax' | ''         | ''         | ''          | ''          | '17,82'  | '17,82'         |
			| 'SalesTax' | '1%'       | 'Trousers' | '38/Yellow' | ''          | '3,96'   | '3,96'          |
			| 'SalesTax' | '1%'       | 'Boots'    | '37/18SD'   | ''          | '13,86'  | '13,86'         |
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения

Сценарий: _090205 priority tax rate check on the example of Sales order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the document Sales order
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Check the tax rate for Item key Bag ODS
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Bag'         |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item' | 'Item key' |
			| 'Bag'  | 'ODS'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item' | 'VAT' | 'Item key' | 'Q'     |
			| 'Bag'  | '0%'  | 'ODS'      | '1,000' |
	* Check the tax rate by item
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Bag'         |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле с именем "ItemListItemKey"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item' | 'Item key' |
			| 'Bag'  | 'PZU'      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "ItemList" содержит строки:
			| 'Item' | 'VAT' | 'Item key' | 'Q'     |
			| 'Bag'  | '18%'  | 'PZU'      | '1,000' |
	И я закрыл все окна клиентского приложения
		




	



