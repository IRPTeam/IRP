#language: ru
@tree
@Positive



Функционал: terms of cooperation with partners

As an accountant
I want to add a mechanism for partner Partner terms
To specify the commercial terms of cooperation


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _012001 adding partners (customers) to a segment (register)
	* Opening a register for Partner segments content
		И Я закрыл все окна клиентского приложения 
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
	* Adding partner Ferron BP to the Retail Segment
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'  |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Partner"
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И таблица "List" содержит строки:
			| Segment | Partner |
			| Retail | Ferron BP |
	* Adding partner Kalipso to the Dealer Segment
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dealer'  |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Partner"
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И таблица "List" содержит строки:
			| Segment | Partner |
			| Dealer | Kalipso |
	* Adding partner Seven Brand to the Retail Segment
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'  |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Partner"
		И я нажимаю на кнопку с именем "FormList"
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Seven Brand' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Adding partner MIO to the Retail Segment
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'  |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Partner"
		И я нажимаю на кнопку с именем "FormList"
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'MIO' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Adding partner Lomaniti to the Retail Segment
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Retail'  |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Partner"
		И я нажимаю на кнопку с именем "FormList"
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Lomaniti' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5

Сценарий: _012002 adding partners (customers) to 2 segments at the same time (register)
# Ferron BP client is included in the retail and dealership segment
	* Opening a register for Partner segments content
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
	* Adding partner Ferron BP to the Dealer Segment
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dealer'  |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Partner"
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	* Checking to add a Ferron BP partner to 2 segments at the same time
		И таблица "List" содержит строки:
			| Segment | Partner |
			| Retail | Ferron BP |
			| Dealer | Ferron BP |

Сценарий: _012003 filling in the segment of managers in the customers
	* Opening the partner catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Filling Manager segment for partner Ferron BP
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Manager segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Region 1'  |
		И в таблице "List" я выбираю текущую строку		
		И я нажимаю на кнопку 'Save and close'
	* Filling Manager segment for partner Kalipso
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Manager segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Region 2'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	* Filling Manager segment for partner Lomaniti
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Lomaniti' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Manager segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Region 2'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	* Filling Manager segment for partner Seven Brand
		И я нажимаю на кнопку с именем "FormList"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Seven Brand' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Manager segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Region 1'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	* Filling Manager segment for partner MIO
		И я нажимаю на кнопку с именем "FormList"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'MIO' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Manager segment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Region 2'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'


Сценарий: _012004 creating common Partner term
	* Opening an Partner term catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
	* Creating and checking customer Partner term Basic Partner terms, TRY
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Customer'
		И я меняю значение переключателя 'AP/AR posting detail' на 'By documents'
		И в поле 'Number' я ввожу текст '20'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'TRY'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price Types'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'       |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И Пауза 3
		И я изменяю флаг 'Price include tax'
		И в поле 'Number days before delivery' я ввожу текст '4'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 01'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Basic Partner terms, TRY'
		И в поле 'TR' я ввожу текст 'Basic Partner terms, TRY'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Basic Partner terms, TRY'
	* Creating and checking customer Partner term Basic Partner terms, $
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Customer'
		И я меняю значение переключателя 'AP/AR posting detail' на 'By documents'
		И в поле 'Number' я ввожу текст '21'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'USD'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price Types'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'       |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И Пауза 3
		И в поле 'Number days before delivery' я ввожу текст '5'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Basic Partner terms, $'
		И в поле 'TR' я ввожу текст 'Basic Partner terms, $'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Basic Partner terms, $'
	* Creating and checking customer Partner term Basic Partner terms, without VAT
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Customer'
		И я меняю значение переключателя 'AP/AR posting detail' на 'By documents'
		И в поле 'Number' я ввожу текст '22'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'TRY'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		Тогда открылось окно 'Price types'
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price without VAT'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'       |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И Пауза 3
		И в поле 'Number days before delivery' я ввожу текст '4'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Basic Partner terms, without VAT'
		И в поле 'TR' я ввожу текст 'Basic Partner terms, without VAT'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Basic Partner terms, without VAT'

Сценарий: _012005 creation of an individual Partner term in USD 
	* Opening an Partner term catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
	* Creating and checking customer Partner term Personal Partner terms, $
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Customer'
		И я меняю значение переключателя 'AP/AR posting detail' на 'By documents'
		И в поле 'Number' я ввожу текст '31'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'USD'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		Тогда открылось окно 'Price types'
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price Types'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Kalipso'       |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И я изменяю флаг 'Price include tax'
		И в поле 'Number days before delivery' я ввожу текст '2'
		И я нажимаю кнопку выбора у поля "Store"
		Тогда открылось окно 'Stores'
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Store 02'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Personal Partner terms, $'
		И в поле 'TR' я ввожу текст 'Personal Partner terms, $'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Personal Partner terms, $'
	* Creating and checking vendor Partner term Vendor Ferron, TRY
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Vendor'
		И я меняю значение переключателя 'AP/AR posting detail' на 'By documents'
		И в поле 'Number' я ввожу текст '31'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'TRY'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| Description         |
				| Vendor price, TRY |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
				| Description |
				| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И я изменяю флаг 'Price include tax'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Vendor Ferron, TRY'
		И в поле 'TR' я ввожу текст 'Vendor Ferron, TRY TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Vendor Ferron, TRY'
	* Creating and checking vendor Partner term Vendor Ferron, USD
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Vendor'
		И в поле 'Number' я ввожу текст '31'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'USD'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
			| Description         |
			| Vendor price, USD |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И я изменяю флаг 'Price include tax'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Vendor Ferron, USD'
		И в поле 'TR' я ввожу текст 'Vendor Ferron, USD TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Vendor Ferron, USD'
	* Creating and checking vendor Partner term Vendor Ferron, EUR
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Vendor'
		И в поле 'Number' я ввожу текст '31'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'EUR'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
			| Description         |
			| Vendor price, EUR |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И я изменяю флаг 'Price include tax'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Vendor Ferron, EUR'
		И в поле 'TR' я ввожу текст 'Vendor Ferron, EUR TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Vendor Ferron, EUR'

	

Сценарий: _012007 creating common Partner term with Item Segment
	* Opening an Partner term catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
	* Creating common Partner term with Item Segment
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Customer'
		И я меняю значение переключателя 'AP/AR posting detail' на 'By documents'
		И в поле 'Number' я ввожу текст '23'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'EUR'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price Types'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Sale autum'       |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И в поле 'End of Use' я ввожу текст '01.11.2018'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Sale autum, TRY'
		И в поле 'TR' я ввожу текст 'Sale autum, TRY'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Checking the creation of the Partner term
		Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Sale autum, TRY'



Сценарий: _012010 creating Partner term without currency (negative test)
	* Opening an Partner term catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
	* Сreating Partner term without currency
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Customer'
		И в поле 'Number' я ввожу текст '302'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Price type"
		Тогда открылось окно 'Price types'
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Basic Price Types'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Sale autum'       |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Currency, TRY'
		И в поле 'TR' я ввожу текст 'Currency, TRY'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	* Checking that the Partner term without currency is not created
		Если в текущем окне есть сообщения пользователю Тогда
		И Я закрыл все окна клиентского приложения
		Когда Проверяю шаги на Исключение:
			|'Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Currency, TRY''|

Сценарий: _012011 creating Partner term without price type (negative test)
	* Opening an Partner term catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
	* Creating Partner term without price type
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя с именем "Type" на 'Customer'
		И в поле 'Number' я ввожу текст '301'
		И в поле 'Date' я ввожу текст '01.11.2018'
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Main Company'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Multi currency movement type"
		И в таблице "List" я перехожу к строке:
			| 'Currency' | 'Type'      |
			| 'TRY'      | 'Partner term' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Retail'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item segment"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Sale autum'       |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Start using' я ввожу текст '01.11.2018'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Price Type, TRY'
		И в поле 'TR' я ввожу текст 'Price Type, TRY'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	*  Checking that the Partner term without price type is not created
		Если в текущем окне есть сообщения пользователю Тогда
		И Я закрыл все окна клиентского приложения
		Когда Проверяю шаги на Исключение:
			|'Тогда я проверяю наличие элемента справочника "Agreements" со значением поля "Description_en" 'Price Type, TRY''|
