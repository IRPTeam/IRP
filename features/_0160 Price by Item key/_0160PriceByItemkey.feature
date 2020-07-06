#language: ru
@tree
@Positive



Функционал: item key pricing

As commercial director 
I want to fill in the prices
To sell and purchase goods and services


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _016001 base price fill (incl. VAT)
	* Opening  price list
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the price list by item key
		И я меняю значение переключателя 'Set price' на 'By Item keys'
		И я перехожу к закладке "Other"
		И в поле 'Description' я ввожу текст 'Basic price'
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price Types'  |
		И в таблице "List" я выбираю текущую строку
		Когда изменяю номер прайс-листа
		И в поле 'Number' я ввожу текст '100'
		И в поле 'Date' я ввожу текст '01.11.2018  12:32:21'
	* Filling in prices by item key by price type Basic Price Types
		И я перехожу к закладке "Item keys"
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '550,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '520,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '520,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '550,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XL/Green' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '550,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '400,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '400,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '350,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '350,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '700,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '700,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '650,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '650,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '500,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/19SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '540,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'Boots/S-8'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '5 000,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'Dress/A-8'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '3 000,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
	* Posting document
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10
	* Checking document saving
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Price list type'     | 'Price type'                 | 'Description' | 'Reference'       |
		| '100'    | 'Price by item keys'  | 'Basic Price Types'          | 'Basic price' | 'Price list 100*' |
		И Я закрыл все окна клиентского приложения

Сценарий: _016005 check postings of the price list document by item key in register Prices by item keys
	* Opening register Prices by item keys
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PricesByItemKeys'
	* Checking Price list 100 postings 
		Тогда таблица "List" содержит строки:
		| 'Price'    | 'Recorder'                                 | 'Price type'        | 'Item key'  |
		| '550,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'S/Yellow'  |
		| '520,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'XS/Blue'   |
		| '520,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'M/White'   |
		| '550,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'L/Green'   |
		| '550,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'XL/Green'  |
		| '400,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '36/Yellow' |
		| '400,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '38/Yellow' |
		| '350,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '36/Red'    |
		| '350,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '38/Black'  |
		| '700,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '36/18SD'   |
		| '700,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '37/18SD'   |
		| '650,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '38/18SD'   |
		| '650,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '39/18SD'   |
		| '500,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '39/19SD'   |
		| '540,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '37/19SD'   |
		| '3 000,00' | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'Dress/A-8' |
		| '5 000,00' | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'Boots/S-8' |


Сценарий: _016002 base price fill and special price fill (not incl. VAT)
	* Opening  price list
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the price list by item key Basic Price without VAT
		И я меняю значение переключателя 'Set price' на 'By Item keys'
		И я перехожу к закладке "Other"
		И в поле 'Description' я ввожу текст 'Basic price'
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price without VAT'  |
		И в таблице "List" я выбираю текущую строку
		Когда изменяю номер прайс-листа
		И в поле 'Number' я ввожу текст '103'
		И в поле 'Date' я ввожу текст '01.11.2018  12:32:21'
		И я перехожу к закладке "Item keys"
	* Filling in prices by item key by price type Basic Price without VAT
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '466,10'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '440,68'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '440,68'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '466,10'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XL/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '466,10'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '338,98'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '338,98'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '296,61'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '296,61'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '648,15'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '648,15'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '601,85'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '601,85'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '462,96'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/19SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '648,15'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the price list by item key Discount 1 TRY without VAT
		И я меняю значение переключателя 'Set price' на 'By Item keys'
		И я перехожу к закладке "Other"
		И в поле 'Description' я ввожу текст 'Basic price'
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Discount 1 TRY without VAT'  |
		И в таблице "List" я выбираю текущую строку
		Когда изменяю номер прайс-листа
		И в поле 'Number' я ввожу текст '104'
		И в поле 'Date' я ввожу текст '01.11.2018  12:32:21'
	* Filling in prices by item key by price type Discount 1 TRY without VAT
		И я перехожу к закладке "Item keys"
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И я перехожу к следующему реквизиту
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '442,80'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '418,65'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '418,65'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '442,80'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XL/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '442,80'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '271,18'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '271,18'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '237,29'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '237,29'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '615,74'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '615,74'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '571,75'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the price list by item key Discount 2 TRY without VAT
		И я меняю значение переключателя 'Set price' на 'By Item keys'
		И я перехожу к закладке "Other"
		И в поле 'Description' я ввожу текст 'Basic price'
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Discount 2 TRY without VAT'  |
		И в таблице "List" я выбираю текущую строку
		Когда изменяю номер прайс-листа
		И в поле 'Number' я ввожу текст '105'
		И в поле 'Date' я ввожу текст '01.11.2018  12:32:21'
	* Filling in prices by item key by price type Discount 2 TRY without VAT
		И я перехожу к закладке "Item keys"
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '349,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '330,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '330,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '350,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XL/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '350,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '240,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '240,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '207,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '207,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '583,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '583,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '540,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10
	* Save verification
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Price list type'     | 'Price type'                 | 'Reference'       |
		| '103'    | 'Price by item keys'  | 'Basic Price without VAT'    | 'Price list 103*' |
		| '104'    | 'Price by item keys'  | 'Discount 1 TRY without VAT' | 'Price list 104*' |
		| '105'    | 'Price by item keys'  | 'Discount 2 TRY without VAT' | 'Price list 105*' |


Сценарий: _016003 Discount Price TRY 1 fill and Discount Price TRY 2 fill
	* Opening  price list
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details of the price list by item key Discount Price TRY 1
		И я меняю значение переключателя 'Set price' на 'By Item keys'
		И я перехожу к закладке "Other"
		И в поле 'Description' я ввожу текст 'Basic price'
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Discount Price TRY 1'  |
		И в таблице "List" я выбираю текущую строку
		Когда изменяю номер прайс-листа
		И в поле 'Number' я ввожу текст '101'
		И в поле 'Date' я ввожу текст '03.11.2018  10:24:21'
	* Filling in prices by item key by price type Discount Price TRY 1
		И я перехожу к закладке "Item keys"
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '522,50'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '494,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '494,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '522,50'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XL/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '522,50'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '320,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '320,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '280,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '280,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '600,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '600,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '250,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10
	* Filling in the details of the price list by item key Discount Price TRY 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я заполняю данные прайс листа по item key
			И я меняю значение переключателя 'Set price' на 'By Item keys'
			И я перехожу к закладке "Other"
			И в поле 'Description' я ввожу текст 'Basic price'
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Discount Price TRY 2'  |
			И в таблице "List" я выбираю текущую строку
			Когда изменяю номер прайс-листа
			И в поле 'Number' я ввожу текст '102'
			И в поле 'Date' я ввожу текст '05.11.2018  10:24:21'
	* Filling in prices by item key by price type Discount Price TRY 2
		И я перехожу к закладке "Item keys"
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '411,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '389,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M/White'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '389,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L/Green'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '413,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XL/Green' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '413,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '283,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Trousers'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key'  |
			| '38/Yellow' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '283,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '244,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '244,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Price"
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '550,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '550,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemKeyList" в поле 'Price' я ввожу текст '240,00'
		И в таблице "ItemKeyList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post and close'
		И Пауза 10	
	* Checking document saving
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		Тогда таблица "List" содержит строки:
		| 'Number' | 'Price list type'     | 'Price type'                 | 'Reference'       |
		| '101'    | 'Price by item keys'  | 'Discount Price TRY 1'       | 'Price list 101*' |
		| '102'    | 'Price by item keys'  | 'Discount Price TRY 2'       | 'Price list 102*' |

Сценарий: _016010 check dependent prices calculation
	* Adding Pluginsessing
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExternalDataProc'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я буду выбирать внешний файл "#workingDir#\DataProcessor\SalesPriceCalculation.epf"
		И я нажимаю на кнопку с именем "FormAddExtDataProc"
		И в поле 'Path to ext data proc for test' я ввожу текст ''
		И в поле 'Name' я ввожу текст 'SalesPriceCalculation'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'SalesPriceCalculation'
		И в поле 'TR' я ввожу текст 'SalesPriceCalculation'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Plugins (create)' в течение 10 секунд
	* Creating price type that will use external processing
		И я открываю навигационную ссылку "e1cib/list/Catalog.PriceTypes"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Dependent Price'
		И в поле с именем 'Description_tr' я ввожу текст 'Dependent Price TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Currency"
		И в таблице "List" я перехожу к строке:
			| Code |
			| TRY  |
		И в таблице "List" я выбираю текущую строку
	* Adding external processing to the price type and filling in the settings
		И я нажимаю кнопку выбора у поля "Plugins"
		И в таблице "List" я перехожу к строке:
			| 'Description'         |
			| 'SalesPriceCalculation' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Settings'
		И в таблице "PriceTypes" я нажимаю на кнопку с именем 'PriceTypesAdd'
		И в таблице "PriceTypes" я нажимаю кнопку выбора у реквизита "Purchase price type"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Basic Price Types' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "PriceTypes" я активизирую поле "Сalculation formula for sales price"
		И в таблице "PriceTypes" в поле 'Сalculation formula for sales price' я ввожу текст 'SalesPrice=PurchasePrice + (PurchasePrice /100 * 10)'
		И в таблице "PriceTypes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Dependent Price (Price type) *' в течение 20 секунд
	* Checking dependent prices calculation
		* Opening price list
			И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
			И я нажимаю на кнопку с именем 'FormCreate'
		* Filling in the details of the price list by item key Discount Price TRY 1
			И я меняю значение переключателя 'Set price' на 'By Item keys'
			И я перехожу к закладке "Other"
			И в поле 'Description' я ввожу текст 'Basic price'
			И я нажимаю кнопку выбора у поля "Price type"
			И в таблице "List" я перехожу к строке:
					| 'Description' |
					| 'Dependent Price'  |
			И в таблице "List" я выбираю текущую строку
		* Filling in price list
			И я нажимаю на кнопку 'Fill by rules'
			И Пауза 2
			И я меняю значение переключателя 'PriceListType' на 'By Item keys'
			И в таблице "PriceTypes" я изменяю флаг 'Use'
			И в таблице "PriceTypes" я завершаю редактирование строки
			И я нажимаю на кнопку 'Ok'
		* Check filling in
			И     таблица "ItemKeyList" содержит строки:
			| 'Item'       | 'Price'    | 'Item key'  |
			| 'Dress'      | '605,00'   | 'S/Yellow'  |
			| 'Dress'      | '572,00'   | 'XS/Blue'   |
			Когда изменяю номер прайс-листа
			И в поле 'Number' я ввожу текст '200'
		И я нажимаю на кнопку 'Post and close'
		




