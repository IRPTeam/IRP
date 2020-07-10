#language: ru
@tree
@Positive
Функционал: check form of selection of item in store documents



Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

Сценарий: _3001001 check the form of selection of items in the document StockAdjustmentAsWriteOff
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
			| 'Store 05'      |
		И в таблице "List" я выбираю текущую строку
	* Check the form of selection items
		Когда check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	И Я закрыл все окна клиентского приложения


Сценарий: _3001002 check the form of selection of items in the document StockAdjustmentAsSurplus
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
	* Check the form of selection items
		Когда check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	И Я закрыл все окна клиентского приложения

Сценарий: 3001003 check the form of selection of items in the document PhysicalInventory
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'      |
		И в таблице "List" я выбираю текущую строку
	* Check the form of selection items
		Когда check the product selection form in PhysicalInventory
	И Я закрыл все окна клиентского приложения

Сценарий: 3001004 check the form of selection of items in the document PhysicalCountByLocation
	* Open document form
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'      |
		И в таблице "List" я выбираю текущую строку
	* Check the form of selection items
		Когда check the product selection form in PhysicalInventory
	И Я закрыл все окна клиентского приложения



Сценарий: 3001005 check the form Pick Up items Inventory Transfer Order
	* Open form to create Inventory Transfer Order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header Inventory Transfer Order
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 06'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Check the form of selection items
		Когда check the product selection form in InventoryTransferOrder/InventoryTransfer
	И Я закрыл все окна клиентского приложения


Сценарий: 3001006 check the form Pick Up items Inventory Transfer
	* Open form to create Inventory Transfer Order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header Inventory Transfer
		И я нажимаю кнопку выбора у поля "Store sender"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Store receiver"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 06'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Check the form of selection items
		Когда check the product selection form in InventoryTransferOrder/InventoryTransfer
	И Я закрыл все окна клиентского приложения

Сценарий: 3001007 check the form Pick Up items Internal supply request
	* Open form to create Internal supply request
		И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling the document header Internal supply request
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 05'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
	* Check the form of selection items
		Когда check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	И Я закрыл все окна клиентского приложения