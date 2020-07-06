#language: ru
@tree
@Positive

Функционал: information messages


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: message when trying to create a Sales invoice by Sales order with Shipment confirmation before Sales invoice (Shipment confirmation has not been created yet)
	* Create Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку 'Create'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Company Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
		Когда добавляю товар в заказ клиента (Dress и Trousers)
	* Click Shipment confirmation before Sales invoice
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Shipment confirmations before sales invoice'
	* Check the information message display when trying to create Sales invoice
		И я перехожу к закладке "Item list"
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Sales invoice'
		Тогда появилось предупреждение, содержащее текст "Please, at first create Shipment confirmation or uncheck the box Shipment confirmation before Sales invoice on the tab Other"
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to create a Purchase invoice by Purchase order with Goods receipt before Purchase invoice (Goods receipt has not been created yet)
	* Create Purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the necessary details
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor's info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, USD |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			Тогда открылось окно 'Items'
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
			И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
	* Click Goods receipt before Purchase invoice
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Goods receipt before purchase invoice'
	* Check the information message display when trying to create Sales invoice
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку 'Purchase invoice'
		Тогда появилось предупреждение, содержащее текст "Please, at first create Goods receipt or uncheck the box Goods receipt before Purchase invoice on the tab Other"
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to create Sales returm order based on Sales invoice when all products have already been returned
	* Create Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Select Store
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 2000
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2000'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2000'
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
	* Create Sales return order based on Sales invoice
			И я нажимаю на кнопку 'Sales return order'
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И я нажимаю на кнопку 'Post and close'
	* Check the message output when creating Sales return order or Sales return again
			И я нажимаю на кнопку 'Sales return order'
			Тогда появилось предупреждение, содержащее текст "Lines on which you may create return are missed in the Sales invoice. All products are already returned."
			И я нажимаю на кнопку 'OK'
			Тогда открылось окно 'Sales invoice * dated *'
			И я нажимаю на кнопку 'Sales return'
			Тогда появилось предупреждение, содержащее текст "Lines on which you may create return are missed in the Sales invoice. All products are already returned."
			И я нажимаю на кнопку 'OK'
			И я закрыл все окна клиентского приложения

Сценарий: message when trying to create Purchase return order and Purchase return based on Purchase invoice document if all products have already been returned.
	* Create Purchase invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the necessary details
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company |
			И в таблице "List" я выбираю текущую строку
		* Filling in vendor's info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, USD |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			Тогда открылось окно 'Items'
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
			И в таблице "ItemList" я завершаю редактирование строки
		* Change the document number to 2000
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2000'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2000'
		И я нажимаю на кнопку 'Post'
	* Create Purchase return based on Purchase invoice
			И я нажимаю на кнопку 'Purchase return'
			И я нажимаю на кнопку 'Post and close'
	* Check the message output when Purchase return or Purchase return order is created again
			И я нажимаю на кнопку 'Purchase return order'
			Тогда появилось предупреждение, содержащее текст "Lines on which you may create return are missed in the Purchase invoice. All products are already returned."
			И я нажимаю на кнопку 'OK'
			Тогда открылось окно 'Purchase invoice * dated *'
			И я нажимаю на кнопку 'Purchase return'
			Тогда появилось предупреждение, содержащее текст "Lines on which you may create return are missed in the Purchase invoice. All products are already returned."
			И я нажимаю на кнопку 'OK'
			И я закрыл все окна клиентского приложения

Сценарий: message when trying to re-create Sales invoice based on Shipment confirmation
	* Create Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку 'Create'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Company Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
		Когда добавляю товар в заказ клиента (Dress и Trousers)
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Shipment confirmations before sales invoice'
		И я меняю номер sales order на 2001
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2001'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2001'
		И я нажимаю на кнопку 'Post'
	* Create Shipment confirmation based on Sales order
		И я нажимаю на кнопку 'Shipment confirmation'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '2001'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2001'
		И я нажимаю на кнопку 'Post'
	* Create Sales invoice based on Shipment confirmation
		И я нажимаю на кнопку 'Sales invoice'
		Тогда открылось окно 'Sales invoice (create)'
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2 001'
		И я нажимаю на кнопку 'Post and close'
		И я жду закрытия окна 'Sales invoice (create)' в течение 20 секунд
	* Checking message display when trying to re-create Sales invoice
		И я нажимаю на кнопку 'Sales invoice'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Sales invoice are missed in the Shipment confirmation."
		И я закрыл все окна клиентского приложения
	* Create Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Select Store
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 2000
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2000'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2000'
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'

Сценарий: message when trying to re-create Purchase invoice based on Goods reciept
	* Create Purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the necessary details
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor's info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, USD |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			Тогда открылось окно 'Items'
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
			И в таблице "ItemList" я завершаю редактирование строки
		* Change the document number
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2001'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2001'
			И я устанавливаю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Post'
	* Create Goods receipt based on urchase order
		И я нажимаю на кнопку 'Goods receipt'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '2001'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2001'
		И я нажимаю на кнопку 'Post'
	* Create Purchase invoice based on Goods reciept
		И я нажимаю на кнопку 'Purchase invoice'
		И я перехожу к закладке "Other"
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2 001'
		И я нажимаю на кнопку 'Post and close'
		И я жду закрытия окна 'Purchase invoice (create)' в течение 20 секунд
	* Check message display when you try to re-create Purchase invoice
		И я нажимаю на кнопку 'Purchase invoice'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Purchase invoice are missed in the Goods receipt."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to re-create Purchase invoice based on Purchase order
	* Create Purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the necessary details
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor's info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, USD |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
			И в таблице "ItemList" я завершаю редактирование строки
		* Change the document number
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2006'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2006'
		И я нажимаю на кнопку 'Post'
	* Create Purchase invoice based on Purchase order
		И я нажимаю на кнопку 'Purchase invoice'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '2006'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2006'
		И я нажимаю на кнопку 'Post and close'
	* Check message display when you try to re-create Purchase invoice
		И я нажимаю на кнопку 'Purchase invoice'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Purchase invoice are missed in the Purchase order."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to re-create Goods reciept based on Purchase order
	* Create Purchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the necessary details
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
			И в таблице "List" я выбираю текущую строку
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		* Filling in vendor's info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description       |
				| Company Ferron BP |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| Description        |
				| Vendor Ferron, USD |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			Тогда открылось окно 'Items'
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			Тогда открылось окно 'Item keys'
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я завершаю редактирование строки
			И в таблице "ItemList" я перехожу к строке:
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '40,00'
			И в таблице "ItemList" я завершаю редактирование строки
		* Change the document number
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2007'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2007'
			И я устанавливаю флаг 'Goods receipt before purchase invoice'
		И я нажимаю на кнопку 'Post'
	* Create Goods receipt based on Purchase order
		И я нажимаю на кнопку 'Goods receipt'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '2007'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2007'
		И я нажимаю на кнопку 'Post and close'
	* Check message display when you try to re-create Goods receipt
		И я нажимаю на кнопку 'Goods receipt'
		Тогда появилось предупреждение, содержащее текст "All items in Purchase order(s) are already received by Goods receipt(s)."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to re-create Sales invoice based on Sales order (Sales invoice before Shipment confirmation)
	* Create Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку 'Create'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Company Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
		Когда добавляю товар в заказ клиента (Dress и Trousers)
		И я нажимаю на кнопку 'Save'
	* Change the document number
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '2004'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2004'
		И я нажимаю на кнопку 'Post'
	* Create Sales invoice
		И я нажимаю на кнопку 'Sales invoice'
		И я меняю номер Sales invoice
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2004'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2004'
			И я нажимаю на кнопку 'Post and close'
	* Check message display when you try to re-create Sales invoice
		И я нажимаю на кнопку 'Sales invoice'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Sales invoice are missed in the Sales order."
		И я закрыл все окна клиентского приложения
		
Сценарий: message when trying to re-create Shipment confirmation based on Sales order (Shipment confirmation before Sales invoic)
	* Create Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку 'Create'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Company Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
		Когда добавляю товар в заказ клиента (Dress и Trousers)
		И я нажимаю на кнопку 'Save'
	* Change the document number
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я устанавливаю флаг 'Shipment confirmations before sales invoice'
		И в поле 'Number' я ввожу текст '2005'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2005'
		И я нажимаю на кнопку 'Post'
	* Create Shipment confirmation
		И я нажимаю на кнопку 'Shipment confirmation'
		И я меняю номер Shipment confirmation
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2005'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2005'
			И я нажимаю на кнопку 'Post and close'
	* Check message display when you try to re-create Shipment confirmation
		И я нажимаю на кнопку 'Shipment confirmation'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Shipment confirmation are missed in the Sales order."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to re-create Shipment confirmation based on Sales invoice
	* Create Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Select Store
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
		* Change the document number to2000
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2008'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2008'
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
	* Create Shipment confirmation based on Sales invoice
		И я нажимаю на кнопку 'Shipment confirmation'
		И я меняю номер расходного ордера
			И в поле 'Number' я ввожу текст '2008'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2008'
		И я нажимаю на кнопку 'Post and close'
	* Check message display when you try to re-create Shipment confirmation
		И я нажимаю на кнопку 'Shipment confirmation'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Shipment confirmation are missed in the Sales invoice."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to create Shipment confirmation based on Sales invoice (Stor doesn't use Shipment confirmation)
	* Create Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Select Store
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 2009
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2009'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2009'
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'L/Green'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
	* Check message display when you try to create Shipment confirmation based on Sales invoice (Stor doesn't use Shipment confirmation)
		И я нажимаю на кнопку 'Shipment confirmation'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Shipment confirmation are missed in the Sales invoice."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to create Shipment confirmation based on Sales invoice with Service
	* Create Sales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Select Store
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 2009
			И я перехожу к закладке "Other"
			И я разворачиваю группу "More"
			И в поле 'Number' я ввожу текст '2010'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2010'
		* Filling in items tab
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Service'     |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'Rent'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
	* Check message display when you try to create Shipment confirmation based on Sales invoice with Service
		И я нажимаю на кнопку 'Shipment confirmation'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Shipment confirmation are missed in the Sales invoice."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to create Goods reciept based on Purchase invoice with Service
	* Create Purchase invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'     |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
		* Select Store
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
		* Change the document number to 2015
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '2015'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2015'
		* Filling in items tab
			И я нажимаю на кнопку с именем 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Service'     |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item key' |
				| 'Rent'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post'
	* Check message display when you try to create Goods receipt based on Purchase invoice with Service
		И я нажимаю на кнопку 'Goods receipt'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to create Goods receipt are missed in the Purchase invoice."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to create Purchase order based on Sales order with procurement nethod stock and repeal, with Service
	* Create Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку 'Create'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Company Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И в таблице "ItemList" я нажимаю на кнопку 'Add'
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
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" я нажимаю на кнопку 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Service'     |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'    | 'Item key' |
				| 'Service' | 'Rent'     |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
			И в таблице "ItemList" я нажимаю на кнопку 'Add'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Boots'       |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Repeal'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И я нажимаю на кнопку 'Post'
	* Change the document number
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '2015'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2015'
		И я нажимаю на кнопку 'Post'
	* Check the message that there are no items to order with the vendor
		И я нажимаю на кнопку 'Purchase order'
		Тогда появилось предупреждение, содержащее текст "No lines with properly procurement method."
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Purchase invoice'
		Тогда появилось предупреждение, содержащее текст "No lines with properly procurement method."
		И я закрыл все окна клиентского приложения

Сценарий: message when trying to re-create Purchase order/Inventory transfer order based on Internal supply request
	* Create Internal supply request
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я устанавливаю номер документа
			И в поле 'Number' я ввожу текст '100'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '100'
		* Filling in the details of the document
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я активизирую поле "Description"
			И в таблице "List" я перехожу к строке:
				| Description  |
				| Main Company | 
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 02  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Trousers    |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Item key"
			И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
			И в таблице "List" я перехожу к строке:
				| Item     | Item key          |
				| Trousers | 36/Yellow |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Quantity"
			И в таблице "ItemList" в поле 'Quantity' я ввожу текст '10,000'
			И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
	* Create Purchase order based on созданного Internal supply request
		И я нажимаю на кнопку 'Purchase order'
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
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю на кнопку 'Post and close'
	* Check message display when you try to re-create Purchase order/Inventory transfer order
		И я нажимаю на кнопку 'Purchase order'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to order items from suppliers are missed In the Internal supply request"
		Когда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку 'Inventory transfer order'
		Тогда появилось предупреждение, содержащее текст "Lines on which you need to order items from suppliers are missed In the Internal supply request"
		И я закрыл все окна клиентского приложения


Сценарий: user notification when creating a second partial sales invoice based on sales order
	* Create Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку 'Create'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Company Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И в таблице "ItemList" я нажимаю на кнопку 'Add'
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
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
	* Change the document number
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '2020'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2020'
		И я нажимаю на кнопку 'Post'
	* Create first Sales invoice
		И я нажимаю на кнопку 'Sales invoice'
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И я нажимаю на кнопку 'Post and close'
	* Create second Sales invoice
		И я нажимаю на кнопку 'Sales invoice'
		Затем я жду, что в сообщениях пользователю будет подстрока "Sales invoice is not the same as the Sales order will be due to the fact that there is already another Sales invoice that partially closed this Sales order" в течение 30 секунд
		И я закрыл все окна клиентского приложения

Сценарий: user notification when creating a second partial purchase invoice based on purchase order
	* Create Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И я нажимаю на кнопку 'Create'
		* Filling in customer info
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Vendor Ferron, TRY' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Company Ferron BP'  |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Store"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Store 03  |
			И в таблице "List" я выбираю текущую строку
		* Filling in items table
			И я нажимаю на кнопку с именем 'Add'
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
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" в поле 'Price' я ввожу текст '10,00'
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
	* Change the document number
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И в поле 'Number' я ввожу текст '2020'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		И в поле 'Number' я ввожу текст '2020'
		И я нажимаю на кнопку 'Post'
	* Create first Purchase invoice based on Purchase order
		И я нажимаю на кнопку 'Purchase invoice'
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И я нажимаю на кнопку 'Post and close'
	* Create second Purchase invoice based on Purchase order
		И я нажимаю на кнопку 'Purchase invoice'
		Затем я жду, что в сообщениях пользователю будет подстрока "Purchase invoice is not the same as the Purchase order will be due to the fact that there is already another Purchase invoice that partially closed this Purchase order" в течение 5 секунд

Сценарий: _0154513 check message output for SO when trying to create a purchase order/SC
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in Sales order
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'DFC'         |
		И в таблице "List" я выбираю текущую строку
		И     элемент формы с именем "LegalName" стал равен 'DFC'
		И я нажимаю кнопку выбора у поля "Partner term"
		И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Basic Partner terms, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		* Filling in items tab
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
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
			И в таблице "ItemList" я завершаю редактирование строки
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
				| 'Trousers' | '36/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
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
				| 'Trousers' | '36/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И в таблице "ItemList" я активизирую поле "Procurement method"
			И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
			И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
			И в таблице "ItemList" я завершаю редактирование строки
		* Filling in Manager segment
			И я перехожу к закладке "Other"
			И я нажимаю кнопку выбора у поля "Manager segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Region 2'    |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '3 024'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3 024'
		И я нажимаю на кнопку 'Post'
	* Checking the message output if the order is unposted
		* Change of document status
			И из выпадающего списка "Status" я выбираю точное значение 'Wait'
			И я нажимаю на кнопку 'Post'
		* Checking message output when trying to generate a PO
			И я нажимаю на кнопку 'Purchase order'
			Тогда элемент формы с именем "Field1" стал равен шаблону 'Not properly status of Sales order*'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
		* Checking message output when trying to generate a PI
			И я нажимаю на кнопку 'Purchase invoice'
			Тогда элемент формы с именем "Field1" стал равен шаблону 'Not properly status of Sales order*'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
	* Checking the message output when it is impossible to create SC because the goods have not yet come from the vendor provided that the type of supply "through orders" is selected
		* Change of document status
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И я нажимаю на кнопку 'Post'
		* Checking a tick 'Shipment confirmations before sales invoice'
			И я устанавливаю флаг 'Shipment confirmations before sales invoice'
			И я нажимаю на кнопку 'Post'
		* Create SC for string with procurement method Stock
			И я нажимаю на кнопку 'Shipment confirmation'
			Тогда открылось окно 'Shipment confirmation (create)'
			И я нажимаю на кнопку 'Post and close'
			И Пауза 2
		* Checking message output when trying to generate SC
			И я нажимаю на кнопку 'Shipment confirmation'
			Тогда элемент формы с именем "Field1" стал равен 'Items were not received from supplier according to procurement method.'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
	* Check when trying to create SC when only a PO has been created but the goods have not been delivered
		* Create a partial PO
			И я нажимаю на кнопку 'Purchase order'
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И в таблице "ItemList" я активизирую поле "Price"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '36/Yellow' |
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И я перехожу к закладке "Other"
			И я устанавливаю флаг 'Goods receipt before purchase invoice'
			И в поле 'Number' я ввожу текст '3 024'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3 024'
			И я нажимаю на кнопку 'Post and close'
		* Checking message output when trying to create SC
			И я нажимаю на кнопку 'Shipment confirmation'
			Тогда элемент формы с именем "Field1" стал равен 'Items were not received from supplier according to procurement method.'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			И я закрыл все окна клиентского приложения
		* Create GR and try to re-create SC
			* Create GR
				И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
				И в таблице "List" я перехожу к строке:
				| 'Number' | 'Partner'   |
				| '3 024'  | 'Ferron BP' |
				И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
				И я нажимаю на кнопку 'Post and close'
			* Create SC
				И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
				И в таблице "List" я перехожу к строке:
				| 'Number' | 'Partner'   |
				| '3 024'  | 'DFC'       |
				И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
				И     таблица "ItemList" содержит строки:
				| 'Item'     | 'Quantity' | 'Item key'  | 'Store'    |
				| 'Trousers' | '4,000'    | '38/Yellow' | 'Store 02' |
				| 'Trousers' | '1,000'    | '36/Yellow' | 'Store 02' |
				И я нажимаю на кнопку 'Post and close'
				И я закрыл все окна клиентского приложения
	* Check the message output when the order is already closed by the purchase order
		* Create a PO for the remaining amount
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
			И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner'   |
			| '3 024'  | 'DFC'       |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'Purchase order'
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И я нажимаю кнопку выбора у поля "Partner"
			Тогда открылось окно 'Partners'
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP'   |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
				| 'Description'        |
				| 'Vendor Ferron, TRY' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И в таблице "ItemList" я активизирую поле "Price"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '50,00'
			И в таблице "ItemList" я завершаю редактирование строки
			И я нажимаю на кнопку 'Post and close'
			И я закрыл все окна клиентского приложения
		* Checking the message output when the order is already closed by the purchase order
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
			И в таблице "List" я перехожу к строке:
			| 'Number' | 'Partner'   |
			| '3 024'  | 'DFC'       |
			И я нажимаю на кнопку с именем 'FormDocumentPurchaseOrderGeneratePurchaseOrder'
			Тогда элемент формы с именем "Field1" стал равен 'All items in sales order are already ordered by purchase order(s).'
			И я закрыл все окна клиентского приложения
	* Checking the message when there are no lines in the sales  order with procurement method "purchase"
		* Create SO with procurement method Stock
			И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
			И я нажимаю на кнопку с именем 'FormCreate'
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "LegalName" стал равен 'DFC'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Basic Partner terms, TRY' |
			И в таблице "List" я выбираю текущую строку
			* Add a row of items
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
				И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
				И в таблице "ItemList" я завершаю редактирование строки
				И я перехожу к закладке "Other"
				И я нажимаю кнопку выбора у поля "Manager segment"
				И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Region 2'    |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю на кнопку 'Post'
		* Checking message output when trying to create a PO
			И я нажимаю на кнопку 'Purchase order'
			Тогда элемент формы с именем "Field1" стал равен 'No lines with properly procurement method.'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			И я закрыл все окна клиентского приложения

Сценарий: _0154514 check message output when trying to create a subsequent order document with the status without postings
	* Check the output of messages when creating documents based on SO with the status "unposted"
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку 'Create'
		* Filling in Sales order
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'DFC'         |
			И в таблице "List" я выбираю текущую строку
			И     элемент формы с именем "LegalName" стал равен 'DFC'
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я перехожу к строке:
					| 'Description'       |
					| 'Partner term DFC' |
			И в таблице "List" я выбираю текущую строку
			* Add a row of items
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
				И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Purchase'
				И в таблице "ItemList" в поле 'Q' я ввожу текст '4,000'
				И в таблице "ItemList" я завершаю редактирование строки
				И из выпадающего списка "Status" я выбираю точное значение 'Wait'
		* Fiiling in manager segment
			И я перехожу к закладке "Other"
			И я нажимаю кнопку выбора у поля "Manager segment"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Region 2'    |
			И в таблице "List" я выбираю текущую строку
			И я перехожу к закладке "Other"
			И в поле 'Number' я ввожу текст '3 027'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3 027'
		И я нажимаю на кнопку 'Post'
		* Check message output when trying to create SalesInvoice
			И я нажимаю на кнопку 'Sales invoice'
			Тогда элемент формы с именем "Field1" стал равен шаблону 'Not properly status of Sales order*'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Purchase invoice'
			Тогда элемент формы с именем "Field1" стал равен шаблону 'Not properly status of Sales order*'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Purchase order'
			Тогда элемент формы с именем "Field1" стал равен шаблону 'Not properly status of Sales order*'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Shipment confirmation'
			Тогда элемент формы с именем "Field1" стал равен шаблону 'Not properly status of Sales order*'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			И из выпадающего списка "Status" я выбираю точное значение 'Approved'
			И я нажимаю на кнопку 'Post'
	* Check the output of messages when creating documents on PO with the status "without posting"
			И я нажимаю на кнопку 'Purchase order'
		* Filling in Purchase order
			И я нажимаю кнопку выбора у поля "Partner"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Legal name"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля "Partner term"
			И в таблице "List" я выбираю текущую строку
			И я нажимаю на кнопку 'OK'
			И в таблице "ItemList" я активизирую поле "Price"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '200,00'
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И в таблице "ItemList" я активизирую поле "Q"
			И в таблице "ItemList" я выбираю текущую строку
			И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
			И в таблице "ItemList" я перехожу к строке:
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			И я перехожу к закладке "Other"
			И я устанавливаю флаг 'Goods receipt before purchase invoice'
			И в поле 'Number' я ввожу текст '3 027'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3 027'
			И из выпадающего списка "Status" я выбираю точное значение 'Wait'
			И я нажимаю на кнопку 'Post'
		* Check the message output when trying to create PurchaseInvoice
			И я нажимаю на кнопку 'Purchase invoice'
			Тогда элемент формы с именем "Field1" стал равен шаблону 'Not properly status of Purchase order*'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			И я нажимаю на кнопку 'Goods receipt'
			Тогда элемент формы с именем "Field1" стал равен шаблону 'Not properly status of Purchase order*'
			Когда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'OK'
			И я закрыл все окна клиентского приложения

Сценарий: _0154515 check the message output when trying to uncheck a tick for Store "Use shipment confirmation" and "Use Goods receipt" for which there were already Shipment confirmation and  Goods receipt
	* Open Store 02
		И я открываю навигационную ссылку "e1cib/list/Catalog.Stores"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
	* Check the message output when trying to uncheck a tick for Store "Use Goods receipt"
		И я снимаю флаг 'Use goods receipt'
		Тогда элемент формы с именем "Field1" стал равен 'Unchecking "Use goods receipt" isn`t possible. Goods receipts from store Store 02 have already been created previously.'
	И я закрыл все окна клиентского приложения
	* Open Store 02
		И я открываю навигационную ссылку "e1cib/list/Catalog.Stores"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
	* Check the message output when trying to uncheck a tick for Store "Use shipment confirmation"
		И я снимаю флаг 'Use shipment confirmation'
		Тогда элемент формы с именем "Field1" стал равен 'Unchecking "Use shipment confirmation" isn`t possible. Shipment confirmations from store Store 02 have already been created previously.'
		И я закрыл все окна клиентского приложения


Сценарий: _0154516 notification when trying to post a Sales order without filling procurement method
	* Create Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in details
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
			И я нажимаю кнопку выбора у поля "Company"
			И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Main Company' |
			И в таблице "List" я выбираю текущую строку
			И я нажимаю кнопку выбора у поля с именем "Store"
			И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'    |
			И в таблице "List" я выбираю текущую строку
		* Filling in the tabular part по товарам
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
			И я нажимаю кнопку очистить у поля "Procurement method"
			И я перехожу к следующему реквизиту
			И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
			И в таблице "ItemList" я завершаю редактирование строки
	* Check message output
		И я нажимаю на кнопку 'Post'
		Затем я жду, что в сообщениях пользователю будет подстрока "Field: [Procurement method] is empty" в течение 10 секунд
		И я закрыл все окна клиентского приложения