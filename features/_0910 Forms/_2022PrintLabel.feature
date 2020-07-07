#language: ru
@tree
@Positive

Функционал: label processing



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
	
Сценарий: create print layout
	* Opening the constructor
		И я открываю навигационную ссылку 'e1cib/list/Catalog.PrintTemplates'
	* Create Label 1
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку 'Get default'
		И в поле 'ENG' я ввожу текст 'Label 1'
		И в поле 'Labels in row' я ввожу текст '2'
		И в поле 'Labels in column' я ввожу текст '4'
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Barcode picture'  |
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Barcode'          |
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Item key'         |
		И в табличном документе 'TemplateSpreadsheet' я перехожу к ячейке "R4C1"
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И в табличном документе 'TemplateSpreadsheet' я перехожу к ячейке "R7C2"
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Item picture'     |
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И в табличном документе 'TemplateSpreadsheet' я перехожу к ячейке "R7C1"
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Price'            |
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	* Create Label 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку 'Get default'
		И в поле 'ENG' я ввожу текст 'Label 2'
		И в поле 'Labels in row' я ввожу текст '2'
		И в поле 'Labels in column' я ввожу текст '4'
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Barcode picture'  |
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Barcode'          |
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Item key'         |
		И в табличном документе 'TemplateSpreadsheet' я перехожу к ячейке "R4C1"
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И в табличном документе 'TemplateSpreadsheet' я перехожу к ячейке "R7C2"
		И в таблице "OrderOrderAvailableFields" я перехожу к строке:
			| 'Available fields' |
			| 'Item picture'     |
		И в таблице "OrderOrderAvailableFields" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'



Сценарий: adding items to label printing processing
	* Open the processing form
		И я открываю навигационную ссылку 'e1cib/app/DataProcessor.PrintLabels'
	* Add items and selecting labels by lines
		И из выпадающего списка с именем "BarcodeType" я выбираю точное значение 'Auto'
		И я нажимаю кнопку выбора у поля с именем "PriceType"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Basic Price Types' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '2'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Template"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Template"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Label 1'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Template"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Template"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Label 2'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Template' |
		| 'Dress'    | 'Label 1'  |
		| 'Trousers' | 'Label 2'  |
	* Reselect the label for all lines in the processing header
		И из выпадающего списка "Label template" я выбираю точное значение 'Label 1'
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Template' |
		| 'Dress'    | 'Label 1'  |
		| 'Trousers' | 'Label 1'  |
	* Print line selection
		И в таблице "ItemList" я перехожу к строке:
			| 'Barcode'    | 'Barcode type' | 'Item'  | 'Item key' | 'Price'  | 'Price type'        | 'Print' | 'Quantity' | 'Template' | 'Unit' |
			| '2202283713' | 'Auto'         | 'Dress' | 'S/Yellow' | '550,00' | 'Basic Price Types' | 'No'    | '2'        | 'Label 1'  | 'pcs'  |
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю на кнопку 'Check print for selected rows'
		И     таблица "ItemList" содержит строки:
			| 'Print' | 'Price type'        | 'Item'     | 'Quantity' | 'Price'  | 'Item key'  | 'Unit' | 'Barcode'    | 'Barcode type' | 'Template' |
			| 'Yes'   | 'Basic Price Types' | 'Dress'    | '2'        | '550,00' | 'S/Yellow'  | 'pcs'  | '2202283713' | 'Auto'         | 'Label 1'  |
		И в таблице "ItemList" я нажимаю на кнопку 'Uncheck print for selected rows'
		И     таблица "ItemList" содержит строки:
			| 'Print' | 'Price type'        | 'Item'     | 'Quantity' | 'Price'  | 'Item key'  | 'Unit' | 'Barcode'    | 'Barcode type' | 'Template' |
			| 'No'   | 'Basic Price Types' | 'Dress'    | '2'        |  '550,00' | 'S/Yellow'  | 'pcs'  | '2202283713' | 'Auto'         | 'Label 1'  |
		И в таблице "ItemList" я нажимаю на кнопку 'Check print for selected rows'
	* Print output check
		И я нажимаю на кнопку 'Print'
		Тогда табличный документ "" равен:
			| ''           | '' | '' | '' | '' | '' | '2202283713' |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| '36/Yellow'  | '' | '' | '' | '' | '' | 'S/Yellow'   |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| '400'        | '' | '' | '' | '' | '' | '550'        |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| '2202283713' | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| 'S/Yellow'   | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| '550'        | '' | '' | '' | '' | '' | ''           |
