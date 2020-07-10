#language: ru
@tree
@Positive


Функционал: check setting item prices for Item

As a sales manager.
I want to put a price on the Item and the properties
In order to have the same price applied to all item key of one Item, and also to be able to set prices for the properties of

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _150000 preparation
	* Select in Item type properties that will affect the price
		* For item type Сlothes
			И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Сlothes     |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AvailableAttributes" я перехожу к строке:
				| Attribute |
				| Color     |
			И в таблице "AvailableAttributes" я устанавливаю флаг 'Affect pricing'
			И в таблице "AvailableAttributes" я завершаю редактирование строки
			И в таблице "AvailableAttributes" я перехожу к строке:
				| Attribute |
				| Size      |
			И в таблице "AvailableAttributes" я устанавливаю флаг 'Affect pricing'
			И в таблице "AvailableAttributes" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
		* For item type Shoes
			И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
			И в таблице "List" я перехожу к строке:
				| Description |
				| Shoes     |
			И в таблице "List" я выбираю текущую строку
			И в таблице "AvailableAttributes" я перехожу к строке:
				| Attribute |
				| Size      |
			И в таблице "AvailableAttributes" я устанавливаю флаг 'Affect pricing'
			И в таблице "AvailableAttributes" я завершаю редактирование строки
			И я нажимаю на кнопку 'Save and close'
			И Пауза 5
		И Я закрыл все окна клиентского приложения


Сценарий: _150001 basic price entry by properties (including VAT)
	* Create price list by property for item type Сlothes
		И я открываю навигационную ссылку "e1cib/list/Document.PriceList"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in price list
		И я перехожу к закладке "Other"
		И в поле 'Description' я ввожу текст 'Basic price'
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price Types'  |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда открылось окно 'Price list (create) *'
		И в поле 'Number' я ввожу текст '107'
		И в поле "Date" я ввожу начало текущего месяца
	* Filling in tabular part
		И я меняю значение переключателя 'Set price' на 'By Properties'
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Сlothes     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'PriceKeyListAdd'
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		# И в таблице "PriceKeyList" я активизирую поле с именем "PriceKeyListUnit"
		# И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Unit"
		# И в таблице "List" я перехожу к строке:
		# 	| Description |
		# 	| pcs         |
		# И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" я активизирую поле "Size"
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| Additional attribute | Description |
			| Size          | L           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" я активизирую поле "Color"
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| Additional attribute | Description |
			| Color         | Green       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" в поле 'Price' я ввожу текст '350,00'
		И в таблице "PriceKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'PriceKeyListAdd'
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		# И в таблице "PriceKeyList" я активизирую поле с именем "PriceKeyListUnit"
		# И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Unit"
		# И в таблице "List" я перехожу к строке:
		# 	| Description |
		# 	| pcs         |
		# И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" я активизирую поле "Size"
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| Additional attribute | Description |
			| Size          | S           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" я активизирую поле "Color"
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| Additional attribute | Description |
			| Color         | Yellow       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" в поле 'Price' я ввожу текст '300,00'
		И в таблице "PriceKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'PriceKeyListAdd'
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		# И в таблице "PriceKeyList" я активизирую поле с именем "PriceKeyListUnit"
		# И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Unit"
		# И в таблице "List" я перехожу к строке:
		# 	| Description |
		# 	| pcs         |
		# И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" я активизирую поле "Size"
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| Additional attribute | Description |
			| Size          | M           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" я активизирую поле "Color"
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| Additional attribute | Description |
			| Color         | Yellow       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" в поле 'Price' я ввожу текст '415,00'
		И в таблице "PriceKeyList" я завершаю редактирование строки
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда открылось окно 'Price list (create) *'
		И в поле 'Number' я ввожу текст '107'
		И в поле "Date" я ввожу начало текущего месяца
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10
	* Create Price key for Dress
		И я открываю навигационную ссылку "e1cib/list/Catalog.PriceKeys"
		Тогда таблица "List" содержит строки:
			| 'Price key'|
			| 'L/Green'  |
			| 'S/Yellow' |
			| 'M/Yellow' |
		* PriceKeys MD5 completion check
			И в таблице "List" я перехожу к строке:
			| 'Price key'|
			| 'S/Yellow' |
			И в таблице "List" я выбираю текущую строку
			И поле "Affect pricing MD5" заполнено
		И Я закрыл все окна клиентского приложения



Сценарий: _150002 basic price entry by items (including VAT)
	И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in price list by item key
		И я перехожу к закладке "Other"
		И в поле 'Description' я ввожу текст 'Basic price'
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Basic Price Types'  |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Number' я ввожу текст '0'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
		Тогда открылось окно 'Price list (create) *'
		И в поле 'Number' я ввожу текст '110'
		И в поле "Date" я ввожу начало текущего месяца
	И я перехожу к закладке "Item keys"
	И я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Dress'       |
	И в таблице "List" я выбираю текущую строку
	# И в таблице "ItemList" я активизирую поле "Unit"
	# И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	# И в таблице "List" я перехожу к строке:
	# 	| Description |
	# 	| pcs         |
	# И в таблице "List" я выбираю текущую строку
	И я перехожу к следующему реквизиту
	И в таблице "ItemList" в поле 'Price' я ввожу текст '700,00'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Trousers'       |
	И в таблице "List" я выбираю текущую строку
	# И в таблице "ItemList" я активизирую поле "Unit"
	# И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	# И в таблице "List" я перехожу к строке:
	# 	| Description |
	# 	| pcs         |
	# И в таблице "List" я выбираю текущую строку
	И я перехожу к следующему реквизиту
	И в таблице "ItemList" в поле 'Price' я ввожу текст '500,00'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Shirt'       |
	И в таблице "List" я выбираю текущую строку
	# И в таблице "ItemList" я активизирую поле "Unit"
	# И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	# И в таблице "List" я перехожу к строке:
	# 	| Description |
	# 	| pcs         |
	# И в таблице "List" я выбираю текущую строку
	И я перехожу к следующему реквизиту
	И в таблице "ItemList" в поле 'Price' я ввожу текст '400,00'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Boots'       |
	И в таблице "List" я выбираю текущую строку
	# И в таблице "ItemList" я активизирую поле "Unit"
	# И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	# И в таблице "List" я перехожу к строке:
	# 	| Description |
	# 	| pcs         |
	# И в таблице "List" я выбираю текущую строку
	И я перехожу к следующему реквизиту
	И в таблице "ItemList" в поле 'Price' я ввожу текст '600,00'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку с именем 'ItemListAdd'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'High shoes'       |
	И в таблице "List" я выбираю текущую строку
	# И в таблице "ItemList" я активизирую поле "Unit"
	# И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Unit"
	# И в таблице "List" я перехожу к строке:
	# 	| Description |
	# 	| pcs         |
	# И в таблице "List" я выбираю текущую строку
	И я перехожу к следующему реквизиту
	И в таблице "ItemList" в поле 'Price' я ввожу текст '400,00'
	И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post and close'
	И Пауза 10


Сценарий: _150003 check that the current prices are displayed in the Item
	* OPen item Dress
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
	* Open price report (tab Price info)
		И В текущем окне я нажимаю кнопку командного интерфейса 'Price info'
		Тогда табличный документ "Result" равен по шаблону:
			| 'Prices on*'           | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Item'                 | 'Item Key'   | 'Basic Price Types' | ''                        | 'Discount Price TRY 1' | ''                     | 'Discount Price TRY 2' | ''                     | 'Basic Price without VAT' | ''                     | 'Discount 1 TRY without VAT' | ''                     | 'Discount 2 TRY without VAT' | ''                     | 'Dependent Price' | ''                        |
			| ''                     | ''          | 'Price'             | 'Reason'                  | 'Price'                | 'Reason'               | 'Price'                | 'Reason'               | 'Price'                   | 'Reason'               | 'Price'                      | 'Reason'               | 'Price'                      | 'Reason'               | 'Price'           | 'Reason'                  |
			| 'Dress'                | 'S/Yellow'  | '550'               | 'Item key =  S/Yellow'    | '522,5'                | 'Item key =  S/Yellow' | '411'                  | 'Item key =  S/Yellow' | '466,1'                   | 'Item key =  S/Yellow' | '442,8'                      | 'Item key =  S/Yellow' | '349'                        | 'Item key =  S/Yellow' | '605'             | 'Item key =  S/Yellow'    |
			| 'Dress'                | 'XS/Blue'   | '520'               | 'Item key =  XS/Blue'     | '494'                  | 'Item key =  XS/Blue'  | '389'                  | 'Item key =  XS/Blue'  | '440,68'                  | 'Item key =  XS/Blue'  | '418,65'                     | 'Item key =  XS/Blue'  | '330'                        | 'Item key =  XS/Blue'  | '572'             | 'Item key =  XS/Blue'     |
			| 'Dress'                | 'M/White'   | '520'               | 'Item key =  M/White'     | '494'                  | 'Item key =  M/White'  | '389'                  | 'Item key =  M/White'  | '440,68'                  | 'Item key =  M/White'  | '418,65'                     | 'Item key =  M/White'  | '330'                        | 'Item key =  M/White'  | '572'             | 'Item key =  M/White'     |
			| 'Dress'                | 'L/Green'   | '550'               | 'Item key =  L/Green'     | '522,5'                | 'Item key =  L/Green'  | '413'                  | 'Item key =  L/Green'  | '466,1'                   | 'Item key =  L/Green'  | '442,8'                      | 'Item key =  L/Green'  | '350'                        | 'Item key =  L/Green'  | '605'             | 'Item key =  L/Green'     |
			| 'Dress'                | 'XL/Green'  | '550'               | 'Item key =  XL/Green'    | '522,5'                | 'Item key =  XL/Green' | '413'                  | 'Item key =  XL/Green' | '466,1'                   | 'Item key =  XL/Green' | '442,8'                      | 'Item key =  XL/Green' | '350'                        | 'Item key =  XL/Green' | '605'             | 'Item key =  XL/Green'    |
			| 'Dress'                | 'Dress/A-8' | '3 000'             | 'Specification Dress/A-8' | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    | '3 300'           | 'Specification Dress/A-8' |
			| 'Dress'                | 'XXL/Red'   | '700'               | 'Item =  Dress'           | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    | ''                | ' '                       |
			| 'Dress'                | 'M/Brown'   | '500'               | 'Item key =  M/Brown'     | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    | ''                | ' '                       |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'All prices'          | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Item'                 | 'Item Key'   | 'Basic Price Types' | ''                        | 'Discount Price TRY 1' | ''                     | 'Discount Price TRY 2' | ''                     | 'Basic Price without VAT' | ''                     | 'Discount 1 TRY without VAT' | ''                     | 'Discount 2 TRY without VAT' | ''                     | 'Dependent Price' | ''                        |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| '1. By item keys'      | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'S/Yellow'  | '550'               | ''                        | '522,5'                | ''                     | '411'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '349'                        | ''                     | '605'             | ''                        |
			| 'Dress'                | 'XS/Blue'   | '520'               | ''                        | '494'                  | ''                     | '389'                  | ''                     | '440,68'                  | ''                     | '418,65'                     | ''                     | '330'                        | ''                     | '572'             | ''                        |
			| 'Dress'                | 'M/White'   | '520'               | ''                        | '494'                  | ''                     | '389'                  | ''                     | '440,68'                  | ''                     | '418,65'                     | ''                     | '330'                        | ''                     | '572'             | ''                        |
			| 'Dress'                | 'L/Green'   | '550'               | ''                        | '522,5'                | ''                     | '413'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '350'                        | ''                     | '605'             | ''                        |
			| 'Dress'                | 'XL/Green'  | '550'               | ''                        | '522,5'                | ''                     | '413'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '350'                        | ''                     | '605'             | ''                        |
			| 'Dress'                | 'M/Brown'   | '500'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| '2. By properties'     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'S/Yellow'  | '300'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'L/Green'   | '350'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| '3. By items'          | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'S/Yellow'  | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'XS/Blue'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'M/White'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'L/Green'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'XL/Green'  | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'XXL/Red'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'M/Brown'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
		* Check to display the current prices at an earlier date
			И в поле 'on date' я ввожу текст '12.12.2019'
			И я нажимаю на кнопку 'Refresh'
			Тогда табличный документ "Result" равен по шаблону:
			| 'Prices on 12.12.2019' | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| 'Item'                 | 'Item Key'   | 'Basic Price Types' | ''                        | 'Discount Price TRY 1' | ''                     | 'Discount Price TRY 2' | ''                     | 'Basic Price without VAT' | ''                     | 'Discount 1 TRY without VAT' | ''                     | 'Discount 2 TRY without VAT' | ''                     |
			| ''                     | ''          | 'Price'             | 'Reason'                  | 'Price'                | 'Reason'               | 'Price'                | 'Reason'               | 'Price'                   | 'Reason'               | 'Price'                      | 'Reason'               | 'Price'                      | 'Reason'               |
			| 'Dress'                | 'S/Yellow'  | '550'               | 'Item key =  S/Yellow'    | '522,5'                | 'Item key =  S/Yellow' | '411'                  | 'Item key =  S/Yellow' | '466,1'                   | 'Item key =  S/Yellow' | '442,8'                      | 'Item key =  S/Yellow' | '349'                        | 'Item key =  S/Yellow' |
			| 'Dress'                | 'XS/Blue'   | '520'               | 'Item key =  XS/Blue'     | '494'                  | 'Item key =  XS/Blue'  | '389'                  | 'Item key =  XS/Blue'  | '440,68'                  | 'Item key =  XS/Blue'  | '418,65'                     | 'Item key =  XS/Blue'  | '330'                        | 'Item key =  XS/Blue'  |
			| 'Dress'                | 'M/White'   | '520'               | 'Item key =  M/White'     | '494'                  | 'Item key =  M/White'  | '389'                  | 'Item key =  M/White'  | '440,68'                  | 'Item key =  M/White'  | '418,65'                     | 'Item key =  M/White'  | '330'                        | 'Item key =  M/White'  |
			| 'Dress'                | 'L/Green'   | '550'               | 'Item key =  L/Green'     | '522,5'                | 'Item key =  L/Green'  | '413'                  | 'Item key =  L/Green'  | '466,1'                   | 'Item key =  L/Green'  | '442,8'                      | 'Item key =  L/Green'  | '350'                        | 'Item key =  L/Green'  |
			| 'Dress'                | 'XL/Green'  | '550'               | 'Item key =  XL/Green'    | '522,5'                | 'Item key =  XL/Green' | '413'                  | 'Item key =  XL/Green' | '466,1'                   | 'Item key =  XL/Green' | '442,8'                      | 'Item key =  XL/Green' | '350'                        | 'Item key =  XL/Green' |
			| 'Dress'                | 'Dress/A-8' | '3 000'             | 'Specification Dress/A-8' | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    |
			| 'Dress'                | 'M/Brown'   | '500'               | 'Item key =  M/Brown'     | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| 'All prices'          | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| 'Item'                 | 'Item Key'   | 'Basic Price Types' | ''                        | 'Discount Price TRY 1' | ''                     | 'Discount Price TRY 2' | ''                     | 'Basic Price without VAT' | ''                     | 'Discount 1 TRY without VAT' | ''                     | 'Discount 2 TRY without VAT' | ''                     |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| '1. By item keys'      | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| 'Dress'                | 'S/Yellow'  | '550'               | ''                        | '522,5'                | ''                     | '411'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '349'                        | ''                     |
			| 'Dress'                | 'XS/Blue'   | '520'               | ''                        | '494'                  | ''                     | '389'                  | ''                     | '440,68'                  | ''                     | '418,65'                     | ''                     | '330'                        | ''                     |
			| 'Dress'                | 'M/White'   | '520'               | ''                        | '494'                  | ''                     | '389'                  | ''                     | '440,68'                  | ''                     | '418,65'                     | ''                     | '330'                        | ''                     |
			| 'Dress'                | 'L/Green'   | '550'               | ''                        | '522,5'                | ''                     | '413'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '350'                        | ''                     |
			| 'Dress'                | 'XL/Green'  | '550'               | ''                        | '522,5'                | ''                     | '413'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '350'                        | ''                     |
			| 'Dress'                | 'M/Brown'   | '500'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| '2. By properties'    | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| '3. By items'          | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |





Сценарий: _150004 check the price calculation according to the specification (based on the Item and properties price) in Sales order document
	* Unpost Basic Price list by item key
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		И в таблице "List" я перехожу к строке:
		| Description | Number | Price list type    |
		| Basic price | 100    | Price by item keys |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuUndoPosting'
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	Тогда открылось окно 'Partner terms'
	И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	* Add item
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item  | Item key  |
			| Dress | Dress/A-8 |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Check price calculation
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'    | 'Item key'  | 'Store'    | 'Q'     | 'Unit' |
		| 'Dress' | '3 100,00' | 'Dress/A-8' | 'Store 01' | '1,000' | 'pcs'  |
	И Я закрыл все окна клиентского приложения

Сценарий: _150004 check the price calculation for the bandle (based on the properties price) in the Sales order document
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	Тогда открылось окно 'Partner terms'
	И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	* Add item
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Bound Dress+Shirt       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item              | Item key  |
			| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Check price calculation
		И     таблица "ItemList" содержит строки:
		| 'Item'              | 'Price'    | 'Item key'                      | 'Store'    | 'Q'     | 'Unit'  |
		| 'Bound Dress+Shirt' | '1 100,00' | 'Bound Dress+Shirt/Dress+Shirt' | 'Store 01' | '1,000' |  'pcs'  |
	И Я закрыл все окна клиентского приложения

Сценарий: _150005 price check by properties in Sales order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	Тогда открылось окно 'Partner terms'
	И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	* Add item
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| Item     | Item key  |
			| Dress    | L/Green |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Check price calculation
		И     таблица "ItemList" содержит строки:
		| 'Item'  | 'Price'  | 'Item key'| 'Store'    | 'Q'     | 'Unit'  |
		| 'Dress' | '350,00' | 'L/Green' | 'Store 01' | '1,000' |  'pcs'  |
	И Я закрыл все окна клиентского приложения

Сценарий: _150006 check the redrawing of columns in the price list for additional properties when re-selecting the type of items
	* Open Price list with price variant by properties
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя 'Set price' на 'By Properties'
	* Checking the addition of properties for item type Clothes
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Сlothes     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'PriceKeyListAdd'
		И     таблица "PriceKeyList" стала равной:
			| 'Item' | 'Size' | 'Color' | 'Price' |
			| ''     | ''     | ''      | ''      |
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита с именем "PriceKeyListItem"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" я активизирую поле "Size"
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Size'          | 'M'           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" я активизирую поле "Color"
		И в таблице "PriceKeyList" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я перехожу к строке:
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'Brown'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceKeyList" в поле 'Price' я ввожу текст '200,00'
		И в таблице "PriceKeyList" я завершаю редактирование строки
	* Checking the addition of properties for item type Clothes
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Shoes     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'PriceKeyListAdd'
		И     таблица "PriceKeyList" стала равной:
			| 'Item' | 'Size' | 'Price' |
			| ''     | ''     | ''      |
	И Я закрыл все окна клиентского приложения


Сценарий: check input by line in the price list for additional properties
	И я закрыл все окна клиентского приложения
	* Open a creation form Price List
		И я открываю навигационную ссылку "e1cib/list/Document.PriceList"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Input additionel properties by string 
		И я меняю значение переключателя 'Set price' на 'By Properties'
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сlothes'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'PriceKeyListAdd'
		И в таблице "PriceKeyList" из выпадающего списка с именем "PriceKeyListItem" я выбираю по строке 'dress'
		И в таблице "PriceKeyList" я активизирую поле "Size"
		И в таблице "PriceKeyList" из выпадающего списка "Size" я выбираю по строке '36'
		И в таблице "PriceKeyList" я активизирую поле "Color"
		И в таблице "PriceKeyList" из выпадающего списка "Color" я выбираю по строке 'bla'
	* Check entered values
		И     таблица "PriceKeyList" содержит строки:
		| 'Item'  | 'Size' | 'Color' |
		| 'Dress' | '36'   | 'Black' |
	И Я закрыл все окна клиентского приложения