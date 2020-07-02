#language: ru
@tree
@Positive
Функционал: Sales order document form


As a sales manager
I want the Sales order document form convenient
For fast data entry


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий



Сценарий: _023101 displaying in the Sales order only available valid agreements for the selected customer
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	Тогда таблица "List" стала равной:
		| 'Description'                   |
		| 'Basic Agreements, TRY'         |
		| 'Basic Agreements, $'           |
		| 'Basic Agreements, without VAT' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	Тогда таблица "List" стала равной:
		| 'Description'            |
		| 'Personal Agreements, $' |
	И я закрываю текущее окно
	И Я закрываю текущее окно
	И я нажимаю на кнопку 'No'
	* Сhecking that expired agreements are not displayed in the selection list
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И в таблице "List" я перехожу к строке:
		| 'Description'           |
		| 'Basic Agreements, $' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'End of use' я ввожу текст '02.11.2018'
		И я нажимаю на кнопку 'Save and close'
		И я закрываю текущее окно
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		Тогда таблица "List" стала равной:
			| 'Description'                   |
			| 'Basic Agreements, TRY'         |
			| 'Basic Agreements, without VAT' |
		И Я закрываю текущее окно
		И Я закрываю текущее окно
		И я нажимаю на кнопку 'No'
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Agreements, $' |
		И в таблице "List" я выбираю текущую строку
		И в поле 'End of use' я ввожу текст '02.11.2019'
		И я нажимаю на кнопку 'Save and close'
		И я закрываю текущее окно

Сценарий: _023102 select only your own companies in the Company field
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
		| 'Description'           |
		| 'Basic Agreements, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Company"
	Тогда таблица "List" стала равной:
		| 'Description'  |
		| 'Main Company' |
	И я закрываю текущее окно
	И Я закрываю текущее окно
	И я нажимаю на кнопку 'No'

Сценарий: _023103 filling in Company field from the agreement
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
		| 'Description'           |
		| 'Basic Agreements, TRY' |
	И в таблице "List" я выбираю текущую строку
	И элемент формы с именем "Company" стал равен 'Main Company'
	И Я закрываю текущее окно
	И я нажимаю на кнопку 'No'


Сценарий: _023104 filling in Store field from the agreement
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
		| 'Description'       |
		| 'Basic Agreements, without VAT' |
	И в таблице "List" я выбираю текущую строку
	И     элемент формы с именем "Store" стал равен 'Store 02'
	И я нажимаю кнопку выбора у поля "Agreement"
	И в таблице "List" я перехожу к строке:
		| 'Description'       |
		| 'Basic Agreements, TRY' |
	И в таблице "List" я выбираю текущую строку
	И     элемент формы с именем "Store" стал равен 'Store 01'
	И Я закрываю текущее окно
	И я нажимаю на кнопку 'No'

Сценарий: _023105 check that the Account field is missing from the order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И элемент формы "Account" отсутствует на форме


Сценарий: _023106 checking the form of selection of items (sales order)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	* Filling in the details
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
				| 'Description'       |
				| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Company Ferron BP'  |
		И в таблице "List" я выбираю текущую строку
	Когда проверяю форму подбора товара с информацией по ценам в Sales order
	И в таблице "ItemList" я нажимаю на кнопку '% Offers'
	И в таблице "Offers" я нажимаю на кнопку с именем 'FormOK'
	И я нажимаю на кнопку 'Post and close'
	* Checking Sales order Saving
		Тогда таблица "List" содержит строки:
		| 'Currency'  | 'Partner'     | 'Status'   | 'Σ'         |
		| 'TRY'       | 'Ferron BP'   | 'Approved' | '2 050,00'  |
	И я закрыл все окна клиентского приложения




Сценарий: _023113 checking totals in the document Sales order
	* Open list form Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	* Select Sales order
		И в таблице "List" я перехожу к строке:
		| Number |
		| 1      |
		И в таблице "List" я выбираю текущую строку
	* Check for document results
		И     элемент формы с именем "ItemListTotalOffersAmount" стал равен '0,00'
		И     элемент формы с именем "ItemListTotalNetAmount" стал равен '3 686,44'
		И     элемент формы с именем "ItemListTotalTaxAmount" стал равен '663,56'
		И     элемент формы с именем "ItemListTotalTotalAmount" стал равен '4 350,00'
		И     элемент формы с именем "CurrencyTotalAmount" стал равен 'TRY'
