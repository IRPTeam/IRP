#language: ru
@tree
@Positive
Функционал: create Purchase invoices and Sales invoices based on Goods receipt and Shipment confirmation


Как Разработчик
Я хочу добавить возможность создавать инвойс based on расходного и приходного ордера 
Чтобы упростить ввод документов

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


# Непрямая схема отгрузки Sales order - Purchase order - Goods reciept - Purchase invoice - Shipment confirmation - Sales invoice
Сценарий: _090501 creation of Sales invoice based on Shipment confirmation (one to one)
	И я тестово создаю Sales order и на его основании Shipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
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
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг "Shipment confirmations before sales invoice"
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Shipment confirmation'
		И я нажимаю на кнопку 'Post'
	И я созданию Sales invoice based on Shipment confirmation
		И я нажимаю на кнопку 'Sales invoice'
	И я проверяю заполнение Sales invoice
		И     таблица "ItemList" содержит строки:
		| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount'  | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Sales order'                   | 'Shipment confirmation'      |
		| '*'          | 'Trousers' | '*'      | '38/Yellow' | '5,000' | ''               | '*'          | 'pcs'  | '*'            | 'Store 02' | '*'             | '*'                             | '*'                          |
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения

Сценарий: _090502 creating a purchase invoice based on Goods reciept (one to one)
	И я тестово создаю Purchase order и на его основании Goods reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
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
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
		И я нажимаю на кнопку 'Post'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Goods receipt'
		И я нажимаю на кнопку 'Post'
	И я создаю Purchase invoice based on Goods receipt
		И я нажимаю на кнопку 'Purchase invoice'
	И я проверяю заполнение Purchase invoice
		И     таблица "ItemList" содержит строки:
		| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      |
		| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | '*'                  |
		И я нажимаю на кнопку 'Post and close'

Сценарий: _090503 creating Sales invoice based on several Shipment confirmation
	И я тестово создаю первый заказ и Shipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
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
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг "Shipment confirmations before sales invoice"
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Shipment confirmation'
		* Change the document number to 458
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '458'
		И я нажимаю на кнопку 'Post and close'
	И я тестово создаю второй заказ и Shipment confirmation на того же клиента и по тем же коммерческим условиям
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
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
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг "Shipment confirmations before sales invoice"
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Shipment confirmation'
		* Change the document number to 459
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '459'
		И я нажимаю на кнопку 'Post and close'
	И я тестово создаю третий заказ и Shipment confirmation на другого клиента
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'     |
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
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг "Shipment confirmations before sales invoice"
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Shipment confirmation'
		* Change the document number to 460
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '460'
		И я нажимаю на кнопку 'Post and close'
	И based on созданных Shipment confirmation я создаю Sales invoice - должно создаться 2
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '458'    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Shipment confirmation'      |
			| '*'          | 'Trousers' | '*'      | '36/Yellow' | '10,000' | ''              | '*'          | 'pcs'  | '*'            | 'Store 02' | '*'             | 'Shipment confirmation 460*' |
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
		И Пауза 2
		И     элемент формы с именем "Partner" стал равен 'Kalipso'
		И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		И     элемент формы с именем "Agreement" стал равен 'Basic Partner terms, TRY'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Shipment confirmation'      |
			| '*'          | 'Trousers' | '*'      | '38/Yellow' | '5,000' | ''              | '*'          | 'pcs'  | '*'            | 'Store 02' | '*'             | 'Shipment confirmation 458*' |
			| '*'          | 'Trousers' | '*'      | '36/Yellow' | '5,000' | ''              | '*'          | 'pcs'  | '*'            | 'Store 02' | '*'             | 'Shipment confirmation 459*' |
		И я нажимаю на кнопку 'Post and close'
	И я закрыл все окна клиентского приложения


Сценарий: _090504 creating Purchase invoice based on several Goods reciept
	И я тестово создаю Purchase order и на его основании Goods reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
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
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
		И я нажимаю на кнопку 'Post'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
		* Change the document number to 2023
			И в поле 'Number' я ввожу текст '2023'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2023'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Goods receipt'
		* Change the document number to 471
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '471'
		И я нажимаю на кнопку 'Post and close'
	И я тестово создаю Purchase order и на его основании Goods reciept на того же поставщика
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
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
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Price' я ввожу текст '400,00'
		И я нажимаю на кнопку 'Post'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
		* Change the document number to 2024
			И в поле 'Number' я ввожу текст '2024'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2024'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Goods receipt'
		* Change the document number to 472
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '472'
		И я нажимаю на кнопку 'Post and close'
	И я тестово создаю Purchase order и на его основании Goods reciept на другого поставщика
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Second Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '10,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Price' я ввожу текст '350,00'
		И я нажимаю на кнопку 'Post'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
		* Change the document number to 2025
			И в поле 'Number' я ввожу текст '2025'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2025'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Goods receipt'
		* Change the document number to 473
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '473'
		И я нажимаю на кнопку 'Post and close'
	И based on созданных Goods receipt я создаю Purchase invoice - должно создаться 2
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '471'    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда
			И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
			| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | ''              | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 471*' | ''            |
			| '677,97'     | 'Trousers' | '400,00' | '38/Yellow' | '2,000' | ''              | '122,03'     | 'pcs'  | '800,00'       | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 472*' | ''            |
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда
			И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
			| '2 966,10'   | 'Trousers' | '350,00' | '38/Yellow' | '10,000' | ''              | '533,90'     | 'pcs'  | '3 500,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 473*' | ''            |
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
		И Пауза 2
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "LegalName" имеет значение "Company Ferron BP" тогда
			И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
			| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | ''              | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 471*' | ''            |
			| '677,97'     | 'Trousers' | '400,00' | '38/Yellow' | '2,000' | ''              | '122,03'     | 'pcs'  | '800,00'       | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 472*' | ''            |
		Если поле с именем "LegalName" имеет значение "Second Company Ferron BP" тогда
			И     таблица "ItemList" содержит строки:
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
			| '2 966,10'   | 'Trousers' | '350,00' | '38/Yellow' | '10,000' | ''              | '533,90'     | 'pcs'  | '3 500,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 473*' | ''            |
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения

Сценарий: _090505 creation of Sales invoice based on several Shipment confirmation (different currency)
# должно создаться 2 Sales invoice
	И я тестово создаю первый заказ и Shipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Personal Partner terms, $' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг "Shipment confirmations before sales invoice"
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Shipment confirmation'
		* Change the document number to 465
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '465'
		И я нажимаю на кнопку 'Post and close'
	И я тестово создаю второй заказ и Shipment confirmation на того же клиента и по тем же коммерческим условиям
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
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
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг "Shipment confirmations before sales invoice"
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		Когда открылось окно 'Update item list info'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Shipment confirmation'
		* Change the document number to 466
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '466'
		И я нажимаю на кнопку 'Post and close'
	* Create Sales invoice - должно создаться 2
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '465'    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentSalesInvoiceGenerateSalesInvoice'
		И     элемент формы с именем "Partner" стал равен 'Kalipso'
		И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Agreement" имеет значение "Personal Partner terms, $" тогда
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Price type'        | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'        | 'Shipment confirmation'      |
			| '500,00' | 'Trousers' | '18%' | '38/Yellow' | '5,000' | '406,11'     | '1%'       | 'Basic Price Types' | 'pcs'  | '2 093,89'   | '2 500,00'     | 'Store 02' | 'Sales order 9 010*' | 'Shipment confirmation 465*' |
		Если поле с именем "Agreement" имеет значение "Basic Partner terms, TRY" тогда
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Price type'        | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'        | 'Shipment confirmation'      |
			| '500,00' | 'Trousers' | '18%' | '36/Yellow' | '5,000' | '406,11'     | '1%'       | 'Basic Price Types' | 'pcs'  | '2 093,89'   | '2 500,00'     | 'Store 02' | 'Sales order 9 011*' | 'Shipment confirmation 466*' |
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
		И Пауза 2
		И     элемент формы с именем "Partner" стал равен 'Kalipso'
		И     элемент формы с именем "LegalName" стал равен 'Company Kalipso'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Agreement" имеет значение "Personal Partner terms, $" тогда
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Price type'        | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'        | 'Shipment confirmation'      |
			| '500,00' | 'Trousers' | '18%' | '38/Yellow' | '5,000' | '406,11'     | '1%'       | 'Basic Price Types' | 'pcs'  | '2 093,89'   | '2 500,00'     | 'Store 02' | 'Sales order 9 010*' | 'Shipment confirmation 465*' |
		Если поле с именем "Agreement" имеет значение "Basic Partner terms, TRY" тогда
			И     таблица "ItemList" содержит строки:
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Price type'        | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'        | 'Shipment confirmation'      |
			| '500,00' | 'Trousers' | '18%' | '36/Yellow' | '5,000' | '406,11'     | '1%'       | 'Basic Price Types' | 'pcs'  | '2 093,89'   | '2 500,00'     | 'Store 02' | 'Sales order 9 011*' | 'Shipment confirmation 466*' |
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения


Сценарий: _090506 creating Purchase invoice based on several Goods reciept
	И я тестово создаю Purchase order и на его основании Goods reciept
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
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
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
		И я нажимаю на кнопку 'Post'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Goods receipt'
		* Change the document number to 465
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '465'
		И я нажимаю на кнопку 'Post and close'
	И я тестово создаю Purchase order и на его основании Goods reciept на того же клиента
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
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
			| 'Description'        |
			| 'Vendor Ferron, USD' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" в поле 'Price' я ввожу текст '400,00'
		И я нажимаю на кнопку 'Post'
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Goods receipt'
		* Change the document number to 466
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '466'
		И я нажимаю на кнопку 'Post and close'
	И based on созданных Goods receipt я создаю Purchase invoice - должно создаться 2
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И в таблице "List" я перехожу к строке:
		| 'Number' |
		| '465'    |
		И В таблице  "List" я перехожу на одну строку вниз с выделением
		И я нажимаю на кнопку с именем 'FormDocumentPurchaseInvoiceGeneratePurchaseInvoice'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Agreement" имеет значение "Vendor Ferron, USD" тогда
			И     таблица "ItemList" содержит строки:
				| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
				| '677,97'     | 'Trousers' | '400,00' | '38/Yellow' | '2,000'  | ''              | '122,03'     | 'pcs'  | '800,00'       | 'Store 02' | '*'             | ''             | ''              | '*'                    | 'Goods receipt 466*' | ''            |
		Если поле с именем "Agreement" имеет значение "Vendor Ferron, TRY" тогда
			И     таблица "ItemList" содержит строки:
				| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
				| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | ''              | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 465*' | ''            |
		И я нажимаю на кнопку 'Post and close'
		И Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
		Если поле с именем "Agreement" имеет значение "Vendor Ferron, USD" тогда
			И     таблица "ItemList" содержит строки:
				| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
				| '677,97'     | 'Trousers' | '400,00' | '38/Yellow' | '2,000'  | ''              | '122,03'     | 'pcs'  | '800,00'       | 'Store 02' | '*'             | ''             | ''              | '*'                    | 'Goods receipt 466*' | ''            |
		Если поле с именем "Agreement" имеет значение "Vendor Ferron, TRY" тогда
			И     таблица "ItemList" содержит строки:
				| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
				| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | ''              | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 465*' | ''            |
		И я нажимаю на кнопку 'Post and close'
		И я закрыл все окна клиентского приложения


