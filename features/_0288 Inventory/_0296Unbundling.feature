#language: ru
@tree
@Positive

Функционал: Unbundling

As a sales manager
I want to create Unbundling
For sale of products from a Bundle separately

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.



Сценарий: _029601 create Unbundling on a product with a specification (specification created in advance, Store doesn't use Shipment confirmation and Goods receipt)
# the fill button on the specification. The specification specifies all additional properties
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	* Create Unbundling for Dress/A-8, all item keys were created in advance
		И я нажимаю на кнопку с именем 'FormCreate'
		* Change number
			И в поле 'Number' я ввожу текст '1'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '1'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Dress | Dress/A-8 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
		И я нажимаю на кнопку 'Post and close'
	* Checking the creation of Unbundling
		Тогда таблица "List" содержит строки:
			| Item key bundle | Company      |
			| Dress/A-8       | Main Company |
	И Я закрыл все окна клиентского приложения
	
Сценарий: _029602 checking Bundling posting (store doesn't use Shipment confirmation and Goods receipt) by register Stock Balance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key'                            |
		| '2,000'    | 'Unbundling 1*'              | 'Store 01' | 'S/Yellow'                            |
		| '2,000'    | 'Unbundling 1*'              | 'Store 01' | 'XS/Blue'                             |
		| '4,000'    | 'Unbundling 1*'              | 'Store 01' | 'L/Green'                             |
		| '4,000'    | 'Unbundling 1*'              | 'Store 01' | 'M/Brown'                             |
		| '2,000'    | 'Unbundling 1*'              | 'Store 01' | 'Dress/A-8'                           |
	И Я закрыл все окна клиентского приложения

Сценарий: _029603 checking Bundling posting (store doesn't use Shipment confirmation and Goods receipt) by register Stock Reservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                    | 'Store'     | 'Item key'                                                            |
		| '2,000'    | 'Unbundling 1*'               | 'Store 01'  | 'S/Yellow'                                                            |
		| '2,000'    | 'Unbundling 1*'               | 'Store 01'  | 'XS/Blue'                                                             |
		| '4,000'    | 'Unbundling 1*'               | 'Store 01'  | 'L/Green'                                                             |
		| '4,000'    | 'Unbundling 1*'               | 'Store 01'  | 'M/Brown'                                                             |
		| '2,000'    | 'Unbundling 1*'               | 'Store 01'  | 'Dress/A-8'                                                           |
	И Я закрыл все окна клиентского приложения

Сценарий: _029604 create Unbundling on a product with a specification (specification created in advance, Store use Shipment confirmation and Goods receipt)
	Когда creating a purchase invoice for the purchase of sets and dimensional grids at the tore 02
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	* Create Unbundling for Boots/S-8, all item keys were created in advance
		И я нажимаю на кнопку с именем 'FormCreate'
		* Change number
			И в поле 'Number' я ввожу текст '2'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '2'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Boots       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Boots | Boots/S-8 |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 02  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
		И я нажимаю на кнопку 'Post and close'
	* Checking the creation of Unbundling
		Тогда таблица "List" содержит строки:
			| Item key bundle | Company      |
			| Boots/S-8       | Main Company |
	И Я закрыл все окна клиентского приложения

Сценарий: _029605 checking the absence posting of Unbundling (store use Shipment confirmation and Goods receipt) by register Stock Balance
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
	Тогда таблица "List" не содержит строки:
		| 'Recorder'                   |
		| 'Unbundling 2*'              |
	И Я закрыл все окна клиентского приложения

Сценарий: _029606 checking Bundling posting (store use Shipment confirmation and Goods receipt) by register Stock Reservation
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
	Тогда таблица "List" содержит строки:
		| 'Quantity'   | 'Recorder'                  | 'Store'        | 'Item key'                                                            |
		| '2,000'    | 'Unbundling 2*'               | 'Store 02'     | 'Boots/S-8'                                                           |
	И Я закрыл все окна клиентского приложения

Сценарий: _029607 checking Bundling posting (store use Shipment confirmation and Goods receipt) by register GoodsInTransitOutgoing
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
	Тогда таблица "List" содержит строки:
		| 'Quantity' | 'Recorder'                   | 'Shipment basis'        | 'Store'    | 'Item key'  |
		| '2,000'    | 'Unbundling 2*'              | 'Unbundling 2*'         | 'Store 02' | 'Boots/S-8' |
	И Я закрыл все окна клиентского приложения

Сценарий: _029608 checking Bundling posting (store use Shipment confirmation and Goods receipt) by register GoodsInTransitIncoming
	И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
	Тогда таблица "List" содержит строки:
		| 'Quantity'   | 'Recorder'                | 'Receipt basis'       | 'Store'    | 'Item key'  |
		| '2,000'      | 'Unbundling 2*'         | 'Unbundling 2*'         | 'Store 02' | '36/18SD'                             |
		| '2,000'      | 'Unbundling 2*'         | 'Unbundling 2*'         | 'Store 02' | '37/18SD'                             |
		| '2,000'      | 'Unbundling 2*'         | 'Unbundling 2*'         | 'Store 02' | '38/18SD'                             |
		| '2,000'      | 'Unbundling 2*'         | 'Unbundling 2*'         | 'Store 02' | '39/18SD'                             |
	И Я закрыл все окна клиентского приложения

Сценарий: _029609 create Goods receipt and Shipment confirmation based on Unbundling
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	* Create Goods receipt and Shipment confirmation
		И в таблице "List" я перехожу к строке:
			| Company      | Item key bundle | Number |
			| Main Company | Boots/S-8       | 2      |
		И я нажимаю на кнопку с именем 'FormDocumentShipmentConfirmationGenerateShipmentConfirmation'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		* Change number Shipment confirmation to 152
			И в поле 'Number' я ввожу текст '152'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '152'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormDocumentGoodsReceiptGenerateGoodsReceipt'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		* Change number Goods receipt to 153
			И в поле 'Number' я ввожу текст '153'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '153'
		И я нажимаю на кнопку 'Post and close'
		И Пауза 5
		И Я закрыл все окна клиентского приложения
	* Check postings
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockBalance'
		Тогда таблица "List" содержит строки:
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key'                            |
			| '2,000'    | 'Goods receipt 153*'         | 'Store 02' | '36/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'         | 'Store 02' | '37/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'         | 'Store 02' | '38/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'         | 'Store 02' | '39/18SD'                             |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.StockReservation'
		Тогда таблица "List" содержит строки:
			| 'Quantity'   | 'Recorder'                    | 'Store'    | 'Item key'                          |
			| '2,000'    | 'Goods receipt 153*'            | 'Store 02' | '36/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'            | 'Store 02' | '37/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'            | 'Store 02' | '38/18SD'                             |
			| '2,000'    | 'Goods receipt 153*'            | 'Store 02' | '39/18SD'                             |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
		Тогда таблица "List" содержит строки:
			| 'Quantity'   | 'Recorder'                   | 'Shipment basis'       | 'Store'    | 'Item key'  |
			| '2,000'      | 'Shipment confirmation 152*' | 'Unbundling 2*'        | 'Store 02' | 'Boots/S-8' |
		И Я закрыл все окна клиентского приложения
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitIncoming'
		Тогда таблица "List" содержит строки:
		| 'Quantity'   | 'Recorder'                | 'Receipt basis'        |  'Store'    | 'Item key'  |
		| '2,000'        | 'Goods receipt 153*'    | 'Unbundling 2*'         | 'Store 02' | '36/18SD'                             |
		| '2,000'        | 'Goods receipt 153*'    | 'Unbundling 2*'         | 'Store 02' | '37/18SD'                             |
		| '2,000'        | 'Goods receipt 153*'    | 'Unbundling 2*'         | 'Store 02' | '38/18SD'                             |
		| '2,000'        | 'Goods receipt 153*'    | 'Unbundling 2*'         | 'Store 02' | '39/18SD'                             |
		И Я закрыл все окна клиентского приложения


Сценарий: _029610 create Unbundling (+check postings) for bundl which was created independently
# When creating a Unbundling based on bundle from a vendor, the missing item key is additionally created. 
# For example, there is a cola+chocolate bandle. When creating Unbundling on this bundle is created to unpack  2 items (Coke and Chocolate) and also item keys 
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	* Create Unbundling for Bundle Dress+Shirt
		И я нажимаю на кнопку с именем 'FormCreate'
		* Change number
			И в поле 'Number' я ввожу текст '3'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '3'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Shirt       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
		И я нажимаю на кнопку 'Post and close'
		* Checking the creation of Unbundling
			Тогда таблица "List" содержит строки:
				| Item key bundle | Company      |
				| Bound Dress+Shirt/Dress+Shirt       | Main Company |
		И Я закрыл все окна клиентского приложения

Сценарий: _029611 create Unbundling (+check postings) for bundl (there is a Bundling document) for which the specification was changed
# the missing item key on the items is created automatically
	* Change specification Dress+Trousers
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		И в таблице "List" я перехожу к строке:
			| Description | Type |
			| Trousers    | Set  |
		И в таблице "List" я перехожу к строке:
			| Description    | Type   |
			| Dress+Trousers | Bundle |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю на кнопку с именем 'FormTable*'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| Description |
			| M           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| Description |
			| White       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле с именем "Quantity*"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Create Unbundling for item Dress+Trousers
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
		* Change number
			И в поле 'Number' я ввожу текст '4'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '4'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Trousers       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Trousers | Bound Dress+Trousers/Dress+Trousers |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 01  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By bundle content'
		И     таблица "ItemList" содержит строки:
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' |
			| 'Dress'    | '2,000'    | 'XS/Blue'   | 'pcs' |
			| 'Trousers' | '2,000'    | '36/Yellow' | 'pcs' |
		И я нажимаю на кнопку 'Post and close'
		* Checking the creation of Unbundling
			Тогда таблица "List" содержит строки:
				| Item key bundle | Company      |
				| Bound Dress+Trousers/Dress+Trousers       | Main Company |
		И Я закрыл все окна клиентского приложения

Сценарий: _029612 create Unbundling (Store use Goods receipt and doesn't use Shipment confirmation)
	* Opening the creation form Unbundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Change number
			И в поле 'Number' я ввожу текст '8'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '8'
	* Filling in details
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Shirt       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 07  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
	* Check postings
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Unbundling 8*'                         | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'                 | 'Item key' | 'Row key' |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 07'   | 'Unbundling 8*'                 | 'XS/Blue'  | '*'       |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 07'   | 'Unbundling 8*'                 | '36/Red'   | '*'       |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''         | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 07'   | 'Bound Dress+Shirt/Dress+Shirt' | ''         | ''        |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''           | ''                              | ''         | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''         | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''         | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 07'   | 'Bound Dress+Shirt/Dress+Shirt' | ''         | ''        |
		И Я закрыл все окна клиентского приложения
	
	Сценарий: _029613 create Unbundling (Store use Shipment confirmation and doesn't use Goods receipt)
	* Opening the creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Change number
			И в поле 'Number' я ввожу текст '9'
			Тогда открылось окно '1C:Enterprise'
			И я нажимаю на кнопку 'Yes'
			И в поле 'Number' я ввожу текст '9'
	* Filling in details
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| Description  |
			| Main Company |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item bundle"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Shirt       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item key bundle"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs      |
		И в таблице "List" я выбираю текущую строку
		И в поле с именем 'Quantity' я ввожу текст '2,000'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Store 08  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Item list"
		И в таблице "ItemList" я нажимаю на кнопку 'By specification'
	* Check postings
		И я нажимаю на кнопку 'Post'
		И Пауза 5
		И я нажимаю на кнопку 'Registrations report'
		Тогда табличный документ "ResultTable" равен по шаблону:
			| 'Unbundling 9*'                         | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Shipment basis'                | 'Item key'                      | 'Row key' |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | 'Unbundling 9*'                 | 'Bound Dress+Shirt/Dress+Shirt' | '*'       |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | 'XS/Blue'                       | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | '36/Red'                        | ''                              | ''        |
			| ''                                      | 'Expense'     | '*'      | '2'         | 'Store 08'   | 'Bound Dress+Shirt/Dress+Shirt' | ''                              | ''        |
			| ''                                      | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''           | ''                              | ''                              | ''        |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                              | ''                              | ''        |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                      | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | 'XS/Blue'                       | ''                              | ''        |
			| ''                                      | 'Receipt'     | '*'      | '2'         | 'Store 08'   | '36/Red'                        | ''                              | ''        |
		И Я закрыл все окна клиентского приложения