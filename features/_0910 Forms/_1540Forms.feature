#language: ru
@tree
@Positive

Функционал: forms check

I want to check the form display and autofill documents


Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _0154000 preparation
	* Create one more legal name for Ferron
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ferron BP   |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Second Company Ferron BP'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку открытия поля "ENG"
		И в поле 'TR' я ввожу текст 'Second Company Ferron BP TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
	* Create one more own company Second Company
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Companies'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Second Company'
		И я нажимаю на кнопку открытия поля "ENG"
		И в поле 'TR' я ввожу текст 'Second Company TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Country"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Ukraine      |
		И в таблице "List" я выбираю текущую строку
		И я устанавливаю флаг 'Our'
		* Filling in Currency info (Local currency and Reporting currency)
			И я перехожу к закладке "Currencies"
			* Create and add Local currency
				И в таблице "Currencies" я нажимаю на кнопку с именем 'CurrenciesAdd'
				И в таблице "Currencies" я нажимаю кнопку выбора у реквизита "Movement type"
				И я нажимаю на кнопку с именем 'FormCreate'
				И в поле 'ENG' я ввожу текст 'Local currency UA'
				И я нажимаю кнопку выбора у поля "Currency"
				И в таблице "List" я перехожу к строке:
					| 'Code' |
					| 'UAH'  |
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Source"
				И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Bank UA' |
				И в таблице "List" я выбираю текущую строку
				И из выпадающего списка "Type" я выбираю точное значение 'Legal'
				И я нажимаю на кнопку 'Save and close'
				И Пауза 5
				И я нажимаю на кнопку с именем 'FormChoose'
				И в таблице "Currencies" я завершаю редактирование строки
			* Create and add Reporting currency
				И в таблице "Currencies" я нажимаю на кнопку с именем 'CurrenciesAdd'
				И в таблице "Currencies" я нажимаю кнопку выбора у реквизита "Movement type"
				И я нажимаю на кнопку с именем 'FormCreate'
				И я нажимаю кнопку выбора у поля "Currency"
				И в таблице "List" я перехожу к строке:
					| 'Code' |
					| 'EUR'  |
				И в таблице "List" я активизирую поле "Description"
				И в таблице "List" я выбираю текущую строку
				И я нажимаю кнопку выбора у поля "Source"
				И в таблице "List" я перехожу к строке:
					| 'Description'  |
					| 'Bank UA' |
				И в таблице "List" я выбираю текущую строку
				И из выпадающего списка "Type" я выбираю точное значение 'Reporting'
				И в поле 'ENG' я ввожу текст 'Reporting currency UA'
				И я нажимаю на кнопку 'Save and close'
				И Пауза 5
				И я нажимаю на кнопку с именем 'FormChoose'
				И в таблице "Currencies" я завершаю редактирование строки
				И я нажимаю на кнопку 'Save and close'



Сценарий: _0154001 check that additional attributes are displayed on the form without re-opening (catalog Item key)
	* Create item type
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Test'
		И я нажимаю на кнопку открытия поля "ENG"
		И в поле 'TR' я ввожу текст 'Test TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	* Create item
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Test'
		И я нажимаю на кнопку открытия поля "ENG"
		И в поле 'TR' я ввожу текст 'Test TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Unit"
		И в таблице "List" я перехожу к строке:
			| Description |
			| pcs         |
		И в таблице "List" я выбираю текущую строку
	Then I go into the item key and check that additional properties are not displayed on it (not specified in the item type)
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'OK'
		И я нажимаю на кнопку с именем 'FormCreate'
		Тогда элемент формы с именем "Item" стал равен 'Test'
		И     элемент формы с именем "ItemType" стал равен 'Test'
		И     элемент формы с именем "InheritUnit" стал равен 'pcs'
		И     элемент формы с именем "SpecificationMode" стал равен 'No'
	* Add a new attribute to the item type without re-open the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemTypes'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
		И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Test'
		И я нажимаю на кнопку открытия поля "ENG"
		И в поле 'TR' я ввожу текст 'Test TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Unique ID' я ввожу текст '_a154'
		И я нажимаю на кнопку 'Save and close'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И я нажимаю на кнопку с именем 'FormChoose'
		И в таблице "AvailableAttributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form for item key
		И Я нажимаю кнопку командного интерфейса 'Test (Item)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий: _0154002 check that additional attributes are displayed on the form without re-opening (catalog Item)
	Тогда я проверяю наличие элемента справочника "Items" со значением поля "Description_en" "Test"
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open Item form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Items'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И элемент формы "Test" отсутствует на форме
	* Adding by selected Item additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name |
			| Catalog_Items             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я активизирую поле "Interface group"
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Interface group"
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Main information |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Я нажимаю кнопку командного интерфейса 'Test (Item)'
	* Checking that the additional Test attribute has been displayed on the form
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _0154003 check that additional attributes are displayed on the form without re-opening (catalog Item type)
	Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля "Description_en" "Test"
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open Item form type
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ItemTypes'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И элемент формы "Test" отсутствует на форме
	* Adding by selected Item type additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Catalog_ItemTypes             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Item types'
		И я нажимаю на кнопку 'Save and close'
		И Я нажимаю кнопку командного интерфейса 'Item types'
	* Checking that the additional Test attribute has been displayed on the form
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения
		

Сценарий:  _0154004 check that additional attributes are displayed on the form without re-opening (catalog Partners)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Create Partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И я нажимаю на кнопку с именем 'FormCreate'
		И в поле 'ENG' я ввожу текст 'Test'
		И я устанавливаю флаг 'Customer'
		И я нажимаю на кнопку 'Save and close'
	* Open Partners form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И элемент формы "Test" отсутствует на форме
	* Adding by selected Partners additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Catalog_Partners              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Interface group"
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Main information |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Test (Partner)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _0154006 check that additional attributes are displayed on the form without re-opening (document Sales invoice)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Sales Invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding by selected Sales invoice additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_SalesInvoice              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Sales invoice'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Sales invoice (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _01540060 check that additional attributes are displayed on the form without re-opening (document PurchaseInvoice)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create PurchaseInvoice
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_PurchaseInvoice              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Purchase Invoice'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Purchase invoice (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _01540061 check that additional attributes are displayed on the form without re-opening (document SalesOrder)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create SalesOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_SalesOrder              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Sales Order'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Sales order (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _01540062 check that additional attributes are displayed on the form without re-opening (document Purchase Order)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create PurchaseOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_PurchaseOrder              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Purchase Order'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Purchase order (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _01540063 check that additional attributes are displayed on the form without re-opening (Catalog_ExpenseAndRevenueTypes)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Catalog_ExpenseAndRevenueTypes
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ExpenseAndRevenueTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_ExpenseAndRevenueTypes     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Expense and revenue types'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Expense and revenue types'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _01540063 check that additional attributes are displayed on the form without re-opening (Catalog_BusinessUnits)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Catalog_BusinessUnits
		И я открываю навигационную ссылку 'e1cib/list/Catalog.BusinessUnits'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_BusinessUnits     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Business Units'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Business units'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _01540064 check adding additional properties for Specifications (Catalog_Specifications)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Specifications     |
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Properties"
		И в таблице "Properties" я нажимаю на кнопку с именем 'PropertiesAdd'
		И в таблице "Properties" я нажимаю кнопку выбора у реквизита "Property"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Properties" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Specifications'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Specifications'
		И в таблице "List" я выбираю текущую строку 
		И я нажимаю на кнопку 'Add properties'
		Тогда таблица "Properties" содержит строки:
		| 'Property' | 'Value' |
		| 'Test'     | ''      |
	И я закрыл все окна клиентского приложения

Сценарий:  _01540064 check that additional attributes are displayed on the form without re-opening (Catalog_ChequeBonds)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Catalog_ChequeBonds
		И я открываю навигационную ссылку 'e1cib/list/Catalog.ChequeBonds'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_ChequeBonds     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Cheque Bonds'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Cheque bonds'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400640 check that additional attributes are displayed on the form without re-opening (Catalog_Agreements)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Agreements
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Agreements     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Agreements'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Agreements'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400641 check that additional attributes are displayed on the form without re-opening (Catalog_Cash accounts)
Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create CashAccounts
		И я открываю навигационную ссылку 'e1cib/list/Catalog.CashAccounts'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_CashAccounts     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Cash accounts'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Cash accounts'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400642 check that additional attributes are displayed on the form without re-opening (Catalog_Companies)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Companies
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Companies'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Companies     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Companies'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Companies'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400643 check that additional attributes are displayed on the form without re-opening (Catalog_Company types)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create CompanyTypes
		И я открываю навигационную ссылку 'e1cib/list/Catalog.CompanyTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_CompanyTypes     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Company types'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Company types'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400644 check that additional attributes are displayed on the form without re-opening (Catalog_Countries)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Countries
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Countries'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Countries     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Countries'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Countries'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения




Сценарий:  _015400645 check that additional attributes are displayed on the form without re-opening (Catalog_Currencies)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Currencies
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Currencies'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Currencies     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Currencies'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Currencies'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400646 check that additional attributes are displayed on the form without re-opening (Catalog_Price types)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create PriceTypes
		И я открываю навигационную ссылку 'e1cib/list/Catalog.PriceTypes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_PriceTypes     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Price types'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Price types'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400647 check that additional attributes are displayed on the form without re-opening (Catalog_Serial lot numbers)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create SerialLotNumbers
		И я открываю навигационную ссылку 'e1cib/list/Catalog.SerialLotNumbers'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_SerialLotNumbers     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Serial lot numbers'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Serial lot numbers'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения




Сценарий:  _015400648 check that additional attributes are displayed on the form without re-opening (Catalog_Stores)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Stores
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Stores'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Stores     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Stores'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Stores'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400649 check that additional attributes are displayed on the form without re-opening (Catalog_Taxes)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Taxes
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Taxes'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Taxes     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Taxes'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Taxes'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400650 check that additional attributes are displayed on the form without re-opening (Catalog_Units)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Units
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Units'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Units     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Units'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Units'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400651 check that additional attributes are displayed on the form without re-opening (Catalog_Users)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Users
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Users'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name          |
			| Catalog_Users     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Users'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И В панели открытых я выбираю 'Users'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400652 check that additional attributes are displayed on the form without re-opening (document Bank payment)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create BankPayment
		И я открываю навигационную ссылку 'e1cib/list/Document.BankPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_BankPayment              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Bank payment'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Bank payment (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400653 check that additional attributes are displayed on the form without re-opening (document Bank receipt)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create BankReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.BankReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_BankReceipt              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Bank receipt'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Bank receipt (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400655 check that additional attributes are displayed on the form without re-opening (document Bundling)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Bundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_Bundling              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Bundling'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Bundling (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400656 check that additional attributes are displayed on the form without re-opening (document Cash expense)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create CashExpense
		И я открываю навигационную ссылку 'e1cib/list/Document.CashExpense'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_CashExpense              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Cash expense'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Cash expense (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400657 check that additional attributes are displayed on the form without re-opening (document Cash payment)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create CashPayment
		И я открываю навигационную ссылку 'e1cib/list/Document.CashPayment'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_CashPayment              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Cash payment'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Cash payment (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400658 check that additional attributes are displayed on the form without re-opening (document Cash receipt)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create CashReceipt
		И я открываю навигационную ссылку 'e1cib/list/Document.CashReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_CashReceipt              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Cash receipt'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Cash receipt (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения




Сценарий:  _015400659 check that additional attributes are displayed on the form without re-opening (document Cash revenue)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create CashRevenue
		И я открываю навигационную ссылку 'e1cib/list/Document.CashRevenue'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_CashRevenue              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Cash revenue'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Cash revenue (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400660 check that additional attributes are displayed on the form without re-opening (document Cash transfer order)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create CashTransferOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.CashTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_CashTransferOrder              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Cash transfer order'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Cash transfer order (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400661 check that additional attributes are displayed on the form without re-opening (document Cheque bond transaction)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create ChequeBondTransaction
		И я открываю навигационную ссылку 'e1cib/list/Document.ChequeBondTransaction'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_ChequeBondTransaction              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Cheque bond transaction'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Cheque bond transaction (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400662 check that additional attributes are displayed on the form without re-opening (document Goods receipt)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Goods receipt
		И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_GoodsReceipt              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Goods receipt'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Goods receipt (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400663 check that additional attributes are displayed on the form without re-opening (document Incoming payment order)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create IncomingPaymentOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.IncomingPaymentOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_IncomingPaymentOrder              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Incoming payment order'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Incoming payment order (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400664 check that additional attributes are displayed on the form without re-opening (document Inventory transfer)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Inventory transfer
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_InventoryTransfer              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Inventory transfer'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Inventory transfer (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400665 check that additional attributes are displayed on the form without re-opening (document Inventory transfer order)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Inventory transfer order
		И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_InventoryTransferOrder              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Inventory transfer order'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Inventory transfer order (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения




Сценарий:  _015400667 check that additional attributes are displayed on the form without re-opening (document Invoice match)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create InvoiceMatch
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_InvoiceMatch              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Invoice match'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Invoice match (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400668 check that additional attributes are displayed on the form without re-opening (document Labeling)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Labeling
		И я открываю навигационную ссылку 'e1cib/list/Document.Labeling'
		И я нажимаю на кнопку с именем 'FormCreate'
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_Labeling              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Labeling'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Labeling (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400669 check that additional attributes are displayed on the form without re-opening (document Opening entry)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create OpeningEntry
		И я открываю навигационную ссылку 'e1cib/list/Document.OpeningEntry'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_OpeningEntry              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Opening entry'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Opening entry (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения





Сценарий:  _015400670 check that additional attributes are displayed on the form without re-opening (document Outgoing payment order)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create OutgoingPaymentOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.OutgoingPaymentOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_OutgoingPaymentOrder              |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Outgoing payment order'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Outgoing payment order (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения




Сценарий:  _015400671 check that additional attributes are displayed on the form without re-opening (document Physical count by location)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create PhysicalCountByLocation
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalCountByLocation'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_PhysicalCountByLocation             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Physical count by location'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Physical count by location (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400672 check that additional attributes are displayed on the form without re-opening (document Physical inventory)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create PhysicalInventory
		И я открываю навигационную ссылку 'e1cib/list/Document.PhysicalInventory'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_PhysicalInventory             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Physical inventory'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Physical inventory (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400673 check that additional attributes are displayed on the form without re-opening (document Price list)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create PriceList
		И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_PriceList             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Price list'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Price list (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400674 check that additional attributes are displayed on the form without re-opening (document Purchase return)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create PurchaseReturn
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_PurchaseReturn             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Purchase return'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Purchase return (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400675 check that additional attributes are displayed on the form without re-opening (document Purchase return order)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create PurchaseReturnOrder
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_PurchaseReturnOrder             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Purchase return order'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Purchase return order (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения




Сценарий:  _015400676 check that additional attributes are displayed on the form without re-opening (document Reconciliation statement)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create ReconciliationStatement
		И я открываю навигационную ссылку 'e1cib/list/Document.ReconciliationStatement'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_ReconciliationStatement             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Reconciliation statement'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Reconciliation statement (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400677 check that additional attributes are displayed on the form without re-opening (document Sales return)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Sales return
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_SalesReturn             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Sales return'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Sales return (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400678 check that additional attributes are displayed on the form without re-opening (document Sales return order)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Sales return order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_SalesReturnOrder             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Sales return order'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Sales return order (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения



Сценарий:  _015400679 check that additional attributes are displayed on the form without re-opening (document Shipment confirmation)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create ShipmentConfirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_ShipmentConfirmation             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Shipment confirmation'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Shipment confirmation (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400680 check that additional attributes are displayed on the form without re-opening (document Stock adjustment as surplus)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create StockAdjustmentAsSurplus
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsSurplus'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_StockAdjustmentAsSurplus             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Stock adjustment as surplus'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Stock adjustment as surplus (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения

Сценарий:  _015400681 check that additional attributes are displayed on the form without re-opening (document Stock adjustment as write-off)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create StockAdjustmentAsWriteOff
		И я открываю навигационную ссылку 'e1cib/list/Document.StockAdjustmentAsWriteOff'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_StockAdjustmentAsWriteOff             |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Stock adjustment as write off'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Stock adjustment as write-off (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _015400683 check that additional attributes are displayed on the form without re-opening (document Unbundling)
	Тогда я проверяю наличие элемента плана вида характеристик "AddAttributeAndPropertyValues" со значением поля Description Eng "Test"
	* Open a form to create Unbundling
		И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я перехожу к закладке "Other"
		И элемент формы "Test" отсутствует на форме
	* Adding additional Test attribute without closing the form
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
		И в таблице "List" я перехожу к строке:
			| Predefined data item name     |
			| Document_Unbundling           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Test        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в поле 'ENG' я ввожу текст 'Unbundling'
		И я нажимаю на кнопку 'Save and close'
	* Checking that the additional Test attribute has been displayed on the form
		И Я нажимаю кнопку командного интерфейса 'Unbundling (create)'
		И элемент формы "Test" присутствует на форме
	И я закрыл все окна клиентского приложения


Сценарий:  _0154007 delete Test attribute
	И я открываю навигационную ссылку 'e1cib/list/Catalog.AddAttributeAndPropertySets'
	И в таблице "List" я перехожу к строке:
		| Description |
		| Items       |
	И в таблице "List" я выбираю текущую строку
	И в таблице "Attributes" я перехожу к строке:
		| Attribute | 
		| Test      |
	И в таблице "Attributes" я активизирую поле "Attribute"
	И в таблице 'Attributes' я удаляю строку
	И я нажимаю на кнопку 'Save and close'
	И в таблице "List" я перехожу к строке:
		| Predefined data item name |
		| Catalog_ItemTypes         |
	И в таблице "List" я выбираю текущую строку
	И в таблице "Attributes" я активизирую поле "Attribute"
	И в таблице "Attributes" я перехожу к строке:
		| Attribute |
		| Test      |
	И в таблице "Attributes" я активизирую поле "Attribute"
	И в таблице 'Attributes' я удаляю строку
	И я нажимаю на кнопку 'Save and close'
	И в таблице "List" я перехожу к строке:
		| Predefined data item name |
		| Document_SalesInvoice     |
	И в таблице "List" я выбираю текущую строку
	И в таблице "Attributes" я активизирую поле "Attribute"
	И в таблице "Attributes" я перехожу к строке:
		| Attribute |
		| Test      |
	И в таблице "Attributes" я активизирую поле "Attribute"
	И в таблице 'Attributes' я удаляю строку
	И я нажимаю на кнопку 'Save and close'
	И в таблице "List" я перехожу к строке:
		| Predefined data item name |
		| Catalog_Partners          |
	И в таблице "List" я выбираю текущую строку
	И в таблице "Attributes" я перехожу к строке:
		| Attribute |
		| Test      |
	И в таблице "Attributes" я активизирую поле "Attribute"
	И в таблице 'Attributes' я удаляю строку
	И я нажимаю на кнопку 'Save and close'
	И я удаляю элемент справочника "Items" со значением поля Description_en "Test"
	И я удаляю элемент справочника "ItemTypes" со значением поля Description_en "Test"
	И я удаляю элемент справочника "Partners" со значением поля Description_en "Test"

Сценарий:  _0154008 check autofilling the agreement field in Purchase order
	Когда создание тестового партнера с одним соглашением поставщика и с одним соглашением клиента
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю автозаполнение соглашения в документах закупки/возвратов по признаку поставщик
	И я закрыл все окна клиентского приложения

Сценарий:  _0154009 check autofilling the agreement field in Purchase invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю автозаполнение соглашения в документах закупки/возвратов по признаку поставщик
	И я закрыл все окна клиентского приложения

Сценарий: _0154010 check autofilling the agreement field in Purchase return
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю автозаполнение соглашения в документах закупки/возвратов по признаку поставщик
	И я закрыл все окна клиентского приложения

Сценарий: _0154011  check autofilling the agreement field in Purchase return order
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю автозаполнение соглашения в документах закупки/возвратов по признаку поставщик
	И я закрыл все окна клиентского приложения


Сценарий: _0154012 check autofilling the agreement field in Sales order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю автозаполнение соглашения в документах продажи/возвратов по признаку клиент
	И я закрыл все окна клиентского приложения

Сценарий: _0154013 check autofilling the agreement field in Sales invoice
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю автозаполнение соглашения в документах продажи/возвратов по признаку клиент
	И я закрыл все окна клиентского приложения

Сценарий: _0154014 check autofilling the agreement field in Sales return order
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю автозаполнение соглашения в документах продажи/возвратов по признаку клиент
	И я закрыл все окна клиентского приложения

Сценарий: _0154015 check autofilling the agreement field in Sales return
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда проверяю автозаполнение соглашения в документах продажи/возвратов по признаку клиент
	И я закрыл все окна клиентского приложения

Сценарий: _0154016 check autofilling item key in Sales order by item only with one item key
	Когда созданию тестовый Item с одним item key
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in sales/returns documents for an item that has only one item key

Сценарий: _0154017 check autofilling item key in Sales invoice by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in sales/returns documents for an item that has only one item key

Сценарий: _0154018 check autofilling item key in Sales return order by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in sales/returns documents for an item that has only one item key

Сценарий: _0154019 check autofilling item key in Sales return by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Сценарий: _0154020 check autofilling item key in Shipment Confirmation by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Сценарий: _0154021 check autofilling item key in GoodsReceipt by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.GoodsReceipt'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Сценарий: _0154022 check autofilling item key in Purchase order by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Сценарий: _0154023 check autofilling item key in Purchase invoice by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseInvoice'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Сценарий: _0154024 check autofilling item key in Purchase return by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturn'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Сценарий: _0154025 check autofilling item key in Purchase return order by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseReturnOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key


Сценарий: _0154026 check autofilling item key in Bundling by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.Bundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in bundling/transfer documents for an item that has only one item key

Сценарий: _0154027 check autofilling item key in Unbundling by item only with one item key
	И я открываю навигационную ссылку 'e1cib/list/Document.Unbundling'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in bundling/transfer documents for an item that has only one item key



Сценарий: _0154030 check autofilling item key in Inventory transfer by item only with one item key 
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransfer'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Сценарий: _0154031 check autofilling item key in Inventory transfer order by item only with one item key 
	И я открываю навигационную ссылку 'e1cib/list/Document.InventoryTransferOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in bundling/transfer documents for an item that has only one item key

Сценарий: _0154032 check autofilling item key in Internal Supply Request у которых только один item key 
	И я открываю навигационную ссылку 'e1cib/list/Document.InternalSupplyRequest'
	И я нажимаю на кнопку с именем 'FormCreate'
	Когда check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key




Сценарий: _0154033 check if the Partner form contains an option to include a partner in the segment
	И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Select partner
		И в таблице "List" я перехожу к строке:
			| Description |
			| Seven Brand |
		И в таблице "List" я выбираю текущую строку
	* Add a test partner to the Dealer segment
		И В текущем окне я нажимаю кнопку командного интерфейса 'Partner segments'
		Тогда таблица "List" не содержит строки:
		| Segment | Partner     |
		| Dealer  | Seven Brand |
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Segment"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dealer      |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
	* Add a test partner to the Retail segment
		И в таблице "List" я перехожу к строке:
			| Partner     | Segment |
			| Seven Brand | Retail  |
		И в таблице "List" я перехожу к строке:
			| Partner     | Segment |
			| Seven Brand | Dealer  |
	* Delete added record
		И в таблице 'List' я удаляю строку
		Тогда открылось окно '1C:Enterprise'
		И я нажимаю на кнопку 'Yes'
	Тогда я закрыл все окна клиентского приложения


Сценарий:  _0154034 check item key selection in the form of item key
	* Open the item key selection form from the Sales order document.
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Partner Kalipso     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Dress       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	* Check the selection by properties
	# Single item key + item key specifications that contain this property should be displayed
		И из выпадающего списка "Color" я выбираю по строке 'yellow'
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я перехожу к строке:
			| Add attribute | Description |
			| Color         | Yellow      |
		И в таблице "List" я выбираю текущую строку
		И     таблица "List" стала равной:
			| Item key  | Item  |
			| S/Yellow  | Dress |
			| Dress/A-8 | Dress |
	* Checking the filter by single item key and by specifications
		И я меняю значение переключателя 'IsSpecificationFilter' на 'Single'
		И     таблица "List" стала равной:
			| Item key  | Item  |
			| S/Yellow  | Dress |
		И я меняю значение переключателя 'IsSpecificationFilter' на 'Specification'
		И     таблица "List" стала равной:
			| Item key  | Item  |
			| Dress/A-8 | Dress |
		И я меняю значение переключателя 'IsSpecificationFilter' на 'All'
		И     таблица "List" стала равной:
			| Item key  | Item  |
			| S/Yellow  | Dress |
			| Dress/A-8 | Dress |
	И я закрыл все окна клиентского приложения


Сценарий:  _0154035 search the item key selection list
	* Open the Sales order creation form
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку 'Create'
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
	* General search check including All/Single/Specification switch selection
		И в поле 'SearchString' я ввожу текст 's'
		Тогда таблица "List" не содержит строки:
		| 'Item key'  | 'Item'  |
		| 'M/White'   | 'Dress' |
		| 'L/Green'   | 'Dress' |
		| 'XL/Green'  | 'Dress' |
		| 'XXL/Red'   | 'Dress' |
		| 'M/Brown'   | 'Dress' |
		И я нажимаю кнопку очистить у поля "SearchString"
		И я меняю значение переключателя 'IsSpecificationFilter' на 'Single'
		И в поле 'SearchString' я ввожу текст 'gr'
		Тогда таблица "List" не содержит строки:
		| 'Item key'  | 'Item'  |
		| 'S/Yellow'  | 'Dress' |
		| 'XS/Blue'   | 'Dress' |
		| 'M/White'   | 'Dress' |
		| 'Dress/A-8' | 'Dress' |
		| 'XXL/Red'   | 'Dress' |
		| 'M/Brown'   | 'Dress' |
		И я нажимаю кнопку очистить у поля "SearchString"
		И я меняю значение переключателя 'IsSpecificationFilter' на 'Specification'
		Тогда таблица "List" не содержит строки:
		| 'Item key'  | 'Item'  |
		| 'S/Yellow'  | 'Dress' |
		| 'XS/Blue'   | 'Dress' |
		| 'M/White'   | 'Dress' |
		| 'L/Green'   | 'Dress' |
		| 'XL/Green'  | 'Dress' |
		| 'XXL/Red'   | 'Dress' |
		| 'M/Brown'   | 'Dress' |
		И я нажимаю кнопку очистить у поля "SearchString"
		И я меняю значение переключателя 'IsSpecificationFilter' на 'All'
		И из выпадающего списка "Size" я выбираю по строке 's'
		Тогда таблица "List" не содержит строки:
		| 'Item key'  | 'Item'  |
		| 'XS/Blue'   | 'Dress' |
		| 'M/White'   | 'Dress' |
		| 'L/Green'   | 'Dress' |
		| 'XL/Green'  | 'Dress' |
		| 'XXL/Red'   | 'Dress' |
		| 'M/Brown'   | 'Dress' |
	* Сheck search by properties
		И я нажимаю кнопку очистить у поля "Size"
		И из выпадающего списка "Color" я выбираю по строке 'gr'
		Тогда таблица "List" не содержит строки:
		| 'Item key'  | 'Item'  |
		| 'S/Yellow'  | 'Dress' |
		| 'XS/Blue'   | 'Dress' |
		| 'M/White'   | 'Dress' |
		| 'XXL/Red'   | 'Dress' |
		| 'M/Brown'   | 'Dress' |
		И я меняю значение переключателя 'IsSpecificationFilter' на 'Single'
		И из выпадающего списка "Color" я выбираю по строке 'gr'
		Тогда таблица "List" не содержит строки:
		| 'Item key'  | 'Item'  |
		| 'S/Yellow'  | 'Dress' |
		| 'XS/Blue'   | 'Dress' |
		| 'M/White'   | 'Dress' |
		| 'Dress/A-8' | 'Dress' |
		| 'XXL/Red'   | 'Dress' |
		| 'M/Brown'   | 'Dress' |
		И я меняю значение переключателя 'IsSpecificationFilter' на 'Specification'
		И из выпадающего списка "Color" я выбираю по строке 'Black'
		Тогда в таблице "List" количество строк "равно" 0
		И я закрыл все окна клиентского приложения


Сценарий:  _0154036 check the Deleting of the store field value by line with the service in a document Sales order
	* Open a creation form Sales Order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Service
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Service'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Service' | 'Rent'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'     | 'Store'    |
		| 'Service'  | 'Rent'      | '1,000' | 'Store 01' |
	* Deleting of the store field value by line with the service
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Check that the store field has been cleared
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'     | 'Store'    |
		| 'Service'  | 'Rent'      | '1,000' | ''         |
		И я закрыл все окна клиентского приложения

Сценарий:  _0154037 check impossibility deleting of the store field by line with the product in a Sales order
	* Open a creation form Sales Order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
		И я закрыл все окна клиентского приложения
	
Сценарий:  _0154038 check the Deleting of the store field value by line with the service in a document Sales invoice
	* Open a creation form Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Service
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Service'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Service' | 'Rent'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'     | 'Store'    |
		| 'Service'  | 'Rent'      | '1,000' | 'Store 01' |
	* Deleting of the store field value by line with the service
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Check that the store field has been cleared
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'     | 'Store'    |
		| 'Service'  | 'Rent'      | '1,000' | ''         |
		И я закрыл все окна клиентского приложения

Сценарий:  _0154039 check impossibility deleting of the store field by line with the product in a Sales invoice
	* Open a creation form Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
		И я закрыл все окна клиентского приложения
	
Сценарий:  _0154040 check the Deleting of the store field value by line with the service in a document Purchase order
	* Open a creation form Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Service
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Service'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Service' | 'Rent'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'     | 'Store'    |
		| 'Service'  | 'Rent'      | '1,000' | 'Store 01' |
	* Deleting of the store field value by line with the service
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Check that the store field has been cleared
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'     | 'Store'    |
		| 'Service'  | 'Rent'      | '1,000' | ''         |
		И я закрыл все окна клиентского приложения

Сценарий:  _0154041 check impossibility deleting of the store field by line with the product in a Purchase Order
	* Open a creation form Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
		И я закрыл все окна клиентского приложения	
		
Сценарий:  _0154042 check the Deleting of the store field value by line with the service in a document Purchase invoice
	* Open a creation form Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Service
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Service'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Service' | 'Rent'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'     | 'Store'    |
		| 'Service'  | 'Rent'      | '1,000' | 'Store 01' |
	* Deleting of the store field value by line with the service
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Check that the store field has been cleared
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  | 'Q'     | 'Store'    |
		| 'Service'  | 'Rent'      | '1,000' | ''         |
		И я закрыл все окна клиентского приложения

Сценарий:  _0154043 check impossibility deleting of the store field by line with the product in a Purchase invoice
	* Open a creation form Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
		И я закрыл все окна клиентского приложения	

Сценарий:  _0154044 check impossibility deleting of the store field by line with the product in a Sales return order
	* Open a creation form Sales Return Order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesReturnOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
		И я закрыл все окна клиентского приложения	

Сценарий:  _0154045 check impossibility deleting of the store field by line with the product in a Sales return
	* Open a creation form Sales Return
		И я открываю навигационную ссылку "e1cib/list/Document.SalesReturn"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
		И я закрыл все окна клиентского приложения	

Сценарий:  _0154046 check impossibility deleting of the store field by line with the product in a Purchase return
	* Open a creation form Purchase Return
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturn"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
		И я закрыл все окна клиентского приложения
	
Сценарий:  _0154047 check impossibility deleting of the store field by line with the product in a Purchase return order
	* Open a creation form Purchase Return order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturnOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 01'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Q'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 01' |
		И я закрыл все окна клиентского приложения

Сценарий:  _0154048 check impossibility deleting of the store field by line with the product in a Goods receipt
	* Open a creation form Goods receipt
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Quantity'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 02' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Quantity'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 02' |
		И я закрыл все окна клиентского приложения

Сценарий:  _0154049 check impossibility deleting of the store field by line with the product in a  ShipmentConfirmation
	* Open a creation form ShipmentConfirmation
		И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Add to the table part of the product with the item type - Product
		И я нажимаю кнопку выбора у поля с именем "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Dress'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'    | 'Item key' |
			| 'Dress'   | 'M/White'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Quantity'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 02' |
	* Delete store field by product line 
		И в таблице "ItemList" я активизирую поле с именем "ItemListStore"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку очистить у поля "Store"
		И в таблице "ItemList" я завершаю редактирование строки
	* Checking that the store field is still filled
		Тогда таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'     | 'Quantity'     | 'Store'    |
		| 'Dress'    | 'M/White'      | '1,000' | 'Store 02' |
		И я закрыл все окна клиентского приложения
			
		
		
Сценарий:  _0154050 check item and item key input by search in line in a document Sales order (in english)
	* Open a creation form Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения
	

Сценарий:  _0154051 check item and item key input by search in line in a document Sales invoice (in english)
	* Open a creation form Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154052 check item and item key input by search in line in a document Sales return order (in english)
	* Open a creation form Sales return order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesReturnOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154053 check item and item key input by search in line in a document Sales return (in english)
	* Open a creation form Sales return 
		И я открываю навигационную ссылку "e1cib/list/Document.SalesReturn"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154054 check item and item key input by search in line in a document Purchase invoice (in english)
	* Open a creation form Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.Purchaseinvoice"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154055 check item and item key input by search in line in a document Purchase order (in english)
	* Open a creation form Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154056 check item and item key input by search in line in a document Goods Receipt (in english)
	* Open a creation form Goods Receipt
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154057 check item and item key input by search in line in a document Shipment confirmation (in english)
	* Open a creation form Shipment confirmation
		И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154058 check item and item key input by search in line in a document InternalSupplyRequest (in english)
	* Open a creation form Internal Supply Request
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И в таблице "ItemList" я нажимаю на кнопку 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154059 check item and item key input by search in line in a document InventoryTransferOrder (in english)
	* Open a creation form Inventory Transfer Order
		И я открываю навигационную ссылку "e1cib/list/Document.InventoryTransferOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154060 check item and item key input by search in line in a document InventoryTransfer (in english)
	* Open a creation form Inventory Transfer
		И я открываю навигационную ссылку "e1cib/list/Document.InventoryTransfer"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154061 check item and item key input by search in line in a document Bundling (in english)
	* Open a creation form Bundling
		И я открываю навигационную ссылку "e1cib/list/Document.Bundling"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154062 check item and item key input by search in line in a document UnBundling (in english)
	* Open a creation form UnBundling
		И я открываю навигационную ссылку "e1cib/list/Document.Unbundling"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения


Сценарий: _015406401 check item and item key input by search in line in a document StockAdjustmentAsSurplus (in english)
	* Open a creation form StockAdjustmentAsSurplus
		И я открываю навигационную ссылку "e1cib/list/Document.StockAdjustmentAsSurplus"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _015406402 check item and item key input by search in line in a document StockAdjustmentAsWriteOff (in english)
	* Open a creation form StockAdjustmentAsWriteOff
		И я открываю навигационную ссылку "e1cib/list/Document.StockAdjustmentAsWriteOff"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _015406403 check item and item key input by search in line in a document PhysicalInventory (in english)
	* Open a creation form PhysicalInventory
		И я открываю навигационную ссылку "e1cib/list/Document.PhysicalInventory"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _015406404 check item and item key input by search in line in a document PhysicalCountByLocation (in english)
	* Open a creation form PhysicalCountByLocation
		И я открываю навигационную ссылку "e1cib/list/Document.PhysicalCountByLocation"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Item and item key input by search in line
		И я нажимаю на кнопку 'Add'
		И в таблице "ItemList" из выпадающего списка "Item" я выбираю по строке 'boo'
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154065 check item, item key and properties input by search in line in a document Price list (in english)
	И я закрыл все окна клиентского приложения
	* Open a creation form Price List
		И я открываю навигационную ссылку "e1cib/list/Document.PriceList"
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя 'Set price' на 'By Item keys'
	* Item and item key input by search in line
		И я нажимаю на кнопку с именем 'ItemKeyListAdd'
		И в таблице "ItemKeyList" из выпадающего списка "Item" я выбираю по строке 'tr'
		И в таблице "ItemKeyList" я активизирую поле "Item key"
		И в таблице "ItemKeyList" из выпадающего списка "Item key" я выбираю по строке '36'
	* Checking entered values
		И     таблица "ItemKeyList" содержит строки:
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |

	

Сценарий: _0154066 check partner, legal name, agreement, company and store input by search in line in a document Sales order (in english)
	* Open a creation form Sales order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Agreement input by search in line
		И из выпадающего списка "Agreement" я выбираю по строке 'TRY'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий: _0154066 check partner, legal name, company, currency input by search in line in a document Reconcilation statement (in english)
	* Open a creation form Reconciliation Statement
		И я открываю навигационную ссылку "e1cib/list/Document.ReconciliationStatement"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Currency input by search in line
		И из выпадающего списка с именем "Currency" я выбираю по строке 't'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Currency" стал равен 'TRY'
	И я закрыл все окна клиентского приложения

Сценарий: _0154067 check partner, legal name, agreement, company and store input by search in line in a document Sales invoice (in english)
	* Open a creation form Sales invoice
		И я открываю навигационную ссылку "e1cib/list/Document.SalesInvoice"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Agreement input by search in line
		И из выпадающего списка "Agreement" я выбираю по строке 'TRY'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий: _0154068 check partner, legal name, agreement, company and store input by search in line in a document Sales return (in english)
	* Open a creation form Sales return
		И я открываю навигационную ссылку "e1cib/list/Document.SalesReturn"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Agreement input by search in line
		И из выпадающего списка "Agreement" я выбираю по строке 'TRY'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий: _0154069 check partner, legal name, agreement, company and store input by search in line in a document Sales return order (in english)
	* Open a creation form Sales return order
		И я открываю навигационную ссылку "e1cib/list/Document.SalesReturnOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Agreement input by search in line
		И из выпадающего списка "Agreement" я выбираю по строке 'TRY'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Basic Agreements, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий: _0154070 check partner, legal name, agreement, company and store input by search in line in a document Purchase order (in english)
	* Open a creation form Purchase order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Agreement input by search in line
		И из выпадающего списка "Agreement" я выбираю по строке 'TRY'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий: _0154071 check partner, legal name, agreement, company and store input by search in line in a document Purchase invoice (in english)
	* Open a creation form Purchase invoice
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseInvoice"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Agreement input by search in line
		И из выпадающего списка "Agreement" я выбираю по строке 'TRY'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий: _0154072 check partner, legal name, agreement, company and store input by search in line in a document Purchase return (in english)
	* Open a creation form Purchase return
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturn"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Agreement input by search in line
		И из выпадающего списка "Agreement" я выбираю по строке 'TRY'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий: _0154073 check partner, legal name, agreement, company and store input by search in line in a document Purchase return order (in english)
	* Open a creation form Purchase return order
		И я открываю навигационную ссылку "e1cib/list/Document.PurchaseReturnOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Agreement input by search in line
		И из выпадающего списка "Agreement" я выбираю по строке 'TRY'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Agreement" стал равен 'Vendor Ferron, TRY'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения

Сценарий: _0154074 check partner, legal name, company, store input by search in line in a document Goods Receipt (in english)
	* Open a creation form Goods Receipt
		И я открываю навигационную ссылку "e1cib/list/Document.GoodsReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Purchase'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '02'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	И я закрыл все окна клиентского приложения

Сценарий: _0154075 check partner, legal name, company, store input by search in line in a document Shipment confirmation (in english)
	* Open a creation form Shipment confirmation
		И я открываю навигационную ссылку "e1cib/list/Document.ShipmentConfirmation"
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'com'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '02'
	* Checking entered values
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Company Ferron BP'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 02'
	И я закрыл все окна клиентского приложения

Сценарий: _0154076 check company, store input by search in line in a document InternalSupplyRequest (in english)
	* Open a creation form InternalSupplyRequest
		И я открываю навигационную ссылку "e1cib/list/Document.InternalSupplyRequest"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
	И я закрыл все окна клиентского приложения



Сценарий: _0154077 check partner, legal name, company, store input by search in line in a document InventoryTransferOrder (in english)
	* Open a creation form InventoryTransferOrder
		И я открываю навигационную ссылку "e1cib/list/Document.InventoryTransferOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "StoreSender" я выбираю по строке '01'
		И из выпадающего списка с именем "StoreReceiver" я выбираю по строке '02'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "StoreSender" стал равен 'Store 01'
		И     элемент формы с именем "StoreReceiver" стал равен 'Store 02'
	И я закрыл все окна клиентского приложения


Сценарий: _0154078 check company, store input by search in line in a InventoryTransfer (in english)
	* Open a creation form InventoryTransfer
		И я открываю навигационную ссылку "e1cib/list/Document.InventoryTransfer"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "StoreSender" я выбираю по строке '01'
		И из выпадающего списка с именем "StoreReceiver" я выбираю по строке '02'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "StoreSender" стал равен 'Store 01'
		И     элемент формы с именем "StoreReceiver" стал равен 'Store 02'
	И я закрыл все окна клиентского приложения



Сценарий: _0154081 check company, store, item bundle input by search in line in a Bundling (in english)
	* Open a creation form Bundling
		И я открываю навигационную ссылку "e1cib/list/Document.Bundling"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Ввод по строке Item bundle
		И из выпадающего списка с именем "ItemBundle" я выбираю по строке 'Trousers'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
		И     элемент формы с именем "ItemBundle" стал равен 'Trousers'
	И я закрыл все окна клиентского приложения

Сценарий:  _0154082 check company, store, item box input by search in line in a UnBundling (in english)
	* Open a creation form Unbundling
		И я открываю навигационную ссылку "e1cib/list/Document.Unbundling"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Store input by search in line
		И из выпадающего списка с именем "Store" я выбираю по строке '01'
	* Item bundle input by search in line
		И из выпадающего списка "Item bundle" я выбираю по строке 'Trousers'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Store" стал равен 'Store 01'
		И     элемент формы с именем "ItemBundle" стал равен 'Trousers'
	И я закрыл все окна клиентского приложения

Сценарий: _0154083 check company, cash account, transaction type, currency, partner, payee, agreement input by search in line in a Cash payment (in english)
	* Open a creation form Cash payment
		И я открываю навигационную ссылку "e1cib/list/Document.CashPayment"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Cash account input by search in line
		И из выпадающего списка "Cash account" я выбираю по строке '3'
	* Transaction type input by search in line
		И из выпадающего списка "Transaction type" я выбираю по строке 'vendor'
	* Currency input by search in line
		И из выпадающего списка с именем "Currency" я выбираю по строке 'T'
	* Partner input by search in line
		И в таблице "PaymentList" я нажимаю на кнопку 'Add'
		И в таблице "PaymentList" из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Payee input by search in line
		И в таблице "PaymentList" я активизирую поле "Payee"
		И в таблице "PaymentList" из выпадающего списка "Payee" я выбираю по строке 'co'
	* Agreement input by search in line
		И в таблице "PaymentList" я активизирую поле "Agreement"
		И в таблице "PaymentList" из выпадающего списка "Agreement" я выбираю по строке 'tr'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "CashAccount" стал равен 'Cash desk №3'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И     элемент формы с именем "Currency" стал равен 'TRY'
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Payee'             | 'Agreement'             |
		| 'Ferron BP' | 'Company Ferron BP' | 'Basic Agreements, TRY' |
	И я закрыл все окна клиентского приложения


Сценарий: _0154084 check company, cash account, transaction type, currency, partner, payee, agreement input by search in line in a Bank payment (in english)
	* Open a creation form Bank payment
		И я открываю навигационную ссылку "e1cib/list/Document.BankPayment"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Cash account input by search in line
		И из выпадающего списка "Account" я выбираю по строке 'usd'
	* Transaction type input by search in line
		И из выпадающего списка "Transaction type" я выбираю по строке 'vendor'
	* Currency input by search in line
		И из выпадающего списка с именем "Currency" я выбираю по строке 'dol'
	* Partner input by search in line
		И в таблице "PaymentList" я нажимаю на кнопку 'Add'
		И в таблице "PaymentList" из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Payee input by search in line
		И в таблице "PaymentList" я активизирую поле "Payee"
		И в таблице "PaymentList" из выпадающего списка "Payee" я выбираю по строке 'co'
	* Agreement input by search in line
		И в таблице "PaymentList" я активизирую поле "Agreement"
		И в таблице "PaymentList" из выпадающего списка "Agreement" я выбираю по строке 'tr'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Bank account, USD'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "TransactionType" стал равен 'Payment to the vendor'
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Payee'             | 'Agreement'             |
		| 'Ferron BP' | 'Company Ferron BP' | 'Basic Agreements, TRY' |
	И я закрыл все окна клиентского приложения

Сценарий: _0154085 check company, cash account, transaction type, currency, partner, payee, input by search in line in a Bank receipt (in english)
	* Open a creation form Bank receipt
		И я открываю навигационную ссылку "e1cib/list/Document.BankReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Cash account input by search in line
		И из выпадающего списка "Account" я выбираю по строке 'usd'
	* Transaction type input by search in line
		И из выпадающего списка "Transaction type" я выбираю по строке 'customer'
	* Currency input by search in line
		И из выпадающего списка с именем "Currency" я выбираю по строке 'dol'
	* Partner input by search in line
		И в таблице "PaymentList" я нажимаю на кнопку 'Add'
		И в таблице "PaymentList" из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Payee input by search in line
		И в таблице "PaymentList" я активизирую поле "Payer"
		И в таблице "PaymentList" из выпадающего списка "Payer" я выбираю по строке 'co'
	* Agreement input by search in line
		И в таблице "PaymentList" я активизирую поле "Agreement"
		И в таблице "PaymentList" из выпадающего списка "Agreement" я выбираю по строке 'usd'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Bank account, USD'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Payer'             | 'Agreement'             |
		| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' |
	И я закрыл все окна клиентского приложения

Сценарий: _0154086 check company, cash account, transaction type, currency, partner, payee, input by search in line in a Cash receipt (in english)
	* Open a creation form Cash receipt
		И я открываю навигационную ссылку "e1cib/list/Document.CashReceipt"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Cash account input by search in line
		И из выпадающего списка "Cash account" я выбираю по строке '3'
	* Transaction type input by search in line
		И из выпадающего списка "Transaction type" я выбираю по строке 'customer'
	* Currency input by search in line
		И из выпадающего списка с именем "Currency" я выбираю по строке 'dol'
	* Partner input by search in line
		И в таблице "PaymentList" я нажимаю на кнопку 'Add'
		И в таблице "PaymentList" из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Payee input by search in line
		И в таблице "PaymentList" я активизирую поле "Payer"
		И в таблице "PaymentList" из выпадающего списка "Payer" я выбираю по строке 'co'
	* Agreement input by search in line
		И в таблице "PaymentList" я активизирую поле "Agreement"
		И в таблице "PaymentList" из выпадающего списка "Agreement" я выбираю по строке 'usd'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "CashAccount" стал равен 'Cash desk №3'
		И     элемент формы с именем "Description" стал равен 'Click for input description'
		И     элемент формы с именем "TransactionType" стал равен 'Payment from customer'
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Payer'             | 'Agreement'             |
		| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' |
	И я закрыл все окна клиентского приложения




Сценарий: _0154087 check company, sender, receiver, send currency, receive currency, cash advance holder input by search in line in a Cash Transfer Order (in english)
	* Open a creation form Cash Transfer Order
		И я открываю навигационную ссылку "e1cib/list/Document.CashTransferOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Sender input by search in line
		И из выпадающего списка "Sender" я выбираю по строке '3'
	* Ввод по строке Receiver
		И из выпадающего списка "Receiver" я выбираю по строке '1'
	* Currency input by search in line
		И из выпадающего списка "Send currency" я выбираю по строке 'dol'
		И из выпадающего списка "Receive currency" я выбираю по строке 'EUR'
	* Cash advance holder input by search in line
		И из выпадающего списка "Cash advance holder" я выбираю по строке 'ari'
	* Checking entered values
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Sender" стал равен 'Cash desk №3'
		И     элемент формы с именем "SendCurrency" стал равен 'USD'
		И     элемент формы с именем "CashAdvanceHolder" стал равен 'Arina Brown'
		И     элемент формы с именем "Receiver" стал равен 'Cash desk №1'
		И     элемент формы с именем "ReceiveCurrency" стал равен 'EUR'
		И я закрыл все окна клиентского приложения

Сценарий: _0154088 check company, operation type, partner, legal name, agreement, business unit, expence type input by search in line in a CreditDebitNote (in english)
	* Open a creation form CreditDebitNote
		И я открываю навигационную ссылку "e1cib/list/Document.CreditDebitNote"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Operation type input by search in line
		И из выпадающего списка "Operation type" я выбираю по строке 'Recei'
	* Partner input by search in line
		И из выпадающего списка "Partner" я выбираю по строке 'fer'
	* Legal name input by search in line
		И из выпадающего списка "Legal name" я выбираю по строке 'second'
	* Filling the tabular part by searching the value by line
		И в таблице "Transactions" я нажимаю на кнопку 'Add'
		И в таблице "Transactions" я активизирую поле "Partner"
		И в таблице "Transactions" из выпадающего списка "Partner" я выбираю по строке 'fer'
		И в таблице "Transactions" я активизирую поле "Agreement"
		И в таблице "Transactions" из выпадающего списка "Agreement" я выбираю по строке 'without'
		И в таблице "Transactions" из выпадающего списка "Currency" я выбираю по строке 'lir'
		И в таблице "Transactions" я активизирую поле "Business unit"
		И в таблице "Transactions" я выбираю текущую строку
		И в таблице "Transactions" из выпадающего списка "Business unit" я выбираю по строке 'lo'
		И в таблице "Transactions" я активизирую поле "Expense type"
		И в таблице "Transactions" из выпадающего списка "Expense type" я выбираю по строке 'fu'
	* Filling check
		И     элемент формы с именем "OperationType" стал равен 'Receivable'
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Partner" стал равен 'Ferron BP'
		И     элемент формы с именем "LegalName" стал равен 'Second Company Ferron BP'
			И     таблица "Transactions" содержит строки:
		| 'Partner'   | 'Agreement'                     | 'Business unit'        | 'Currency' | 'Expense type' |
		| 'Ferron BP' | 'Basic Agreements, without VAT' | 'Logistics department' | 'TRY'      | 'Fuel'         |
		И я закрыл все окна клиентского приложения

Сценарий: _0154089 check company, account, currency input by search in line in Incoming payment order (in english)
	* Open a creation form IncomingPaymentOrder
		И я открываю навигационную ссылку "e1cib/list/Document.IncomingPaymentOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Ввод по строке Account
		И из выпадающего списка "Account" я выбираю по строке '2'
	* Currency input by search in line
		И из выпадающего списка "Currency" я выбираю по строке 'dol'
	* Filling the tabular part by searching the value by line
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" из выпадающего списка "Partner" я выбираю по строке 'fer'
		И в таблице "PaymentList" я активизирую поле "Payer"
		И в таблице "PaymentList" из выпадающего списка "Payer" я выбираю по строке 'se'
	* Filling check
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Cash desk №2'
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Payer'                    |
		| 'Ferron BP' | 'Second Company Ferron BP' |
		И я закрыл все окна клиентского приложения

Сценарий: _0154090 check company, account, currency input by search in line in Outgoing payment order (in english)
	* Open a creation form OutgoingPaymentOrder
		И я открываю навигационную ссылку "e1cib/list/Document.OutgoingPaymentOrder"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Ввод по строке Account
		И из выпадающего списка "Account" я выбираю по строке '2'
	* Currency input by search in line
		И из выпадающего списка "Currency" я выбираю по строке 'dol'
	* Filling the tabular part by searching the value by line
		И в таблице "PaymentList" я нажимаю на кнопку с именем 'PaymentListAdd'
		И в таблице "PaymentList" из выпадающего списка "Partner" я выбираю по строке 'fer'
		И в таблице "PaymentList" я активизирую поле "Payee"
		И в таблице "PaymentList" из выпадающего списка "Payee" я выбираю по строке 'se'
	* Filling check
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Cash desk №2'
		И     элемент формы с именем "Currency" стал равен 'USD'
		И     таблица "PaymentList" содержит строки:
		| 'Partner'   | 'Payee'                    |
		| 'Ferron BP' | 'Second Company Ferron BP' |
		И я закрыл все окна клиентского приложения


Сценарий: _0154091 check company, account, currency input by search in line in ChequeBondTransaction (in english)
	* Open a creation form ChequeBondTransaction
		И я открываю навигационную ссылку "e1cib/list/Document.ChequeBondTransaction"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Currency input by search in line
		И из выпадающего списка "Currency" я выбираю по строке 'lir'
	* Filling the tabular part by searching the value by line (partner and legal name)
		И в таблице "ChequeBonds" я нажимаю на кнопку с именем 'ChequeBondsAdd'
		И в таблице "ChequeBonds" я активизирую поле "Partner"
		И в таблице "ChequeBonds" из выпадающего списка "Partner" я выбираю по строке 'fer'
		И в таблице "ChequeBonds" из выпадающего списка "Legal name" я выбираю по строке 'se'
	* Check filling inданных
		Тогда элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Currency" стал равен 'TRY'
		И     таблица "ChequeBonds" содержит строки:
		| 'Legal name'               | 'Partner'   |
		| 'Second Company Ferron BP' | 'Ferron BP' |
		И я закрыл все окна клиентского приложения


Сценарий: _0154092 check store, responsible person input by search in line in PhysicalCountByLocation (in english)
	* Open a creation form PhysicalCountByLocation
		И я открываю навигационную ссылку "e1cib/list/Document.PhysicalCountByLocation"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Store input by search in line
		И из выпадающего списка "Store" я выбираю по строке '02'
	* Responsible person input by search in line
		И из выпадающего списка "Responsible person" я выбираю по строке 'Anna'
	* Check filling inданных
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     элемент формы с именем "ResponsiblePerson" стал равен 'Anna Petrova'
		И я закрыл все окна клиентского приложения


Сценарий: _0154093 check store input by search in line in PhysicalInventory (in english)
	* Open a creation form PhysicalInventory
		И я открываю навигационную ссылку "e1cib/list/Document.PhysicalInventory"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Store input by search in line
		И из выпадающего списка "Store" я выбираю по строке '02'
	* Check filling inданных
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И я закрыл все окна клиентского приложения


Сценарий: _0154094 check store, company, tabular part input by search in line in StockAdjustmentAsWriteOff (in english)
	* Open a creation form StockAdjustmentAsWriteOff
		И я открываю навигационную ссылку "e1cib/list/Document.StockAdjustmentAsWriteOff"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Store input by search in line
		И из выпадающего списка "Store" я выбираю по строке '02'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'Main'
	* Check filling in
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Business unit, expence type input by search in line
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я активизирую поле "Business unit"
		И в таблице "ItemList" из выпадающего списка "Business unit" я выбираю по строке 'log'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я активизирую поле "Expense type"
		И в таблице "ItemList" из выпадающего списка "Expense type" я выбираю по строке 'fu'
	* Check filling in
		И     таблица "ItemList" содержит строки:
		| 'Business unit'        | 'Expense type' |
		| 'Logistics department' | 'Fuel'         |
		И я закрыл все окна клиентского приложения


Сценарий: _0154095 check store, company, tabular part input by search in line in StockAdjustmentAsSurplus (in english)
	* Open a creation form StockAdjustmentAsSurplus
		И я открываю навигационную ссылку "e1cib/list/Document.StockAdjustmentAsSurplus"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Store input by search in line
		И из выпадающего списка "Store" я выбираю по строке '02'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'Main'
	* Check filling in
		И     элемент формы с именем "Store" стал равен 'Store 02'
		И     элемент формы с именем "Company" стал равен 'Main Company'
	* Business unit, expence type input by search in line
		И я нажимаю на кнопку с именем 'Add'
		И в таблице "ItemList" я активизирую поле "Business unit"
		И в таблице "ItemList" из выпадающего списка "Business unit" я выбираю по строке 'log'
		И я перехожу к следующему реквизиту
		И в таблице "ItemList" я активизирую поле "Revenue type"
		И в таблице "ItemList" из выпадающего списка "Revenue type" я выбираю по строке 'fu'
	* Check filling in
		И     таблица "ItemList" содержит строки:
		| 'Business unit'        | 'Revenue type' |
		| 'Logistics department' | 'Fuel'         |
		И я закрыл все окна клиентского приложения


Сценарий: _0154096 check company, account, currency input by search in line in Opening Entry (in english)
	* Open a creation form OpeningEntry
		И я открываю навигационную ссылку "e1cib/list/Document.OpeningEntry"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line
		И из выпадающего списка "Company" я выбираю по строке 'main'
	* Filling the tabular part by searching the value by line Inventory
		И я перехожу к закладке "Inventory"
		И в таблице "Inventory" я нажимаю на кнопку с именем 'InventoryAdd'
		И в таблице "Inventory" из выпадающего списка "Item" я выбираю по строке 'dress'
		И в таблице "Inventory" я активизирую поле "Item key"
		И в таблице "Inventory" из выпадающего списка "Item key" я выбираю по строке 'L'
		И в таблице "Inventory" я активизирую поле "Store"
		И в таблице "Inventory" из выпадающего списка "Store" я выбираю по строке '01'
		И в таблице "Inventory" я активизирую поле "Quantity"
		И в таблице "Inventory" в поле 'Quantity' я ввожу текст '2,000'
	* Filling the tabular part by searching the value by line Account balance
		И я перехожу к закладке "Account balance"
		И в таблице "AccountBalance" я нажимаю на кнопку с именем 'AccountBalanceAdd'
		И в таблице "AccountBalance" из выпадающего списка 'Account' я выбираю по строке '№1'
		И в таблице "AccountBalance" из выпадающего списка 'Currency' я выбираю по строке 't'
	* Filling the tabular part by searching the value by line Advance
		И я перехожу к закладке "Advance"
		И в таблице "AdvanceFromCustomers" я нажимаю на кнопку с именем 'AdvanceFromCustomersAdd'
		И в таблице "AdvanceFromCustomers" из выпадающего списка "Partner" я выбираю по строке 'fer'
		И я перехожу к следующему реквизиту
		И в таблице "AdvanceFromCustomers" я активизирую поле с именем "AdvanceFromCustomersLegalName"
		И в таблице "AdvanceFromCustomers" из выпадающего списка "Legal name" я выбираю по строке 'se'
		И в таблице "AccountBalance" из выпадающего списка 'Currency' я выбираю по строке 't'
		И я перехожу к закладке "To suppliers"
		И в таблице "AdvanceToSuppliers" я нажимаю на кнопку с именем 'AdvanceToSuppliersAdd'
		И в таблице "AdvanceToSuppliers" из выпадающего списка "Partner" я выбираю по строке 'fer'
		И я перехожу к следующему реквизиту
		И в таблице "AdvanceFromCustomers" я активизирую поле с именем "AdvanceFromCustomersLegalName"
		И в таблице "AdvanceToSuppliers" из выпадающего списка "Legal name" я выбираю по строке 'se'
		И в таблице "AdvanceToSuppliers" из выпадающего списка 'Currency' я выбираю по строке 't'
	* Filling the tabular part by searching the value by line Account payable
		* By agreements
			И я перехожу к закладке "Account payable"
			И в таблице "AccountPayableByAgreements" я нажимаю на кнопку с именем 'AccountPayableByAgreementsAdd'
			И в таблице "AccountPayableByAgreements" из выпадающего списка с именем "AccountPayableByAgreementsPartner" я выбираю по строке 'fer'
			И я перехожу к следующему реквизиту
			И в таблице "AccountPayableByAgreements" из выпадающего списка с именем "AccountPayableByAgreementsLegalName" я выбираю по строке 'sec'
			И в таблице "AccountPayableByAgreements" из выпадающего списка с именем "AccountPayableByAgreementsAgreement" я выбираю по строке 'usd'
			И в таблице "AccountPayableByAgreements" из выпадающего списка с именем "AccountPayableByAgreementsCurrency" я выбираю по строке 't'
		* By documents
			И я перехожу к закладке с именем "GroupAccountPayableByDocuments"
			И в таблице "AccountPayableByDocuments" я нажимаю на кнопку с именем 'AccountPayableByDocumentsAdd'
			И в таблице "AccountPayableByDocuments" из выпадающего списка с именем "AccountPayableByDocumentsPartner" я выбираю по строке 'fer'
			И я перехожу к следующему реквизиту
			И в таблице "AccountPayableByDocuments" из выпадающего списка с именем "AccountPayableByDocumentsLegalName" я выбираю по строке 's'
			И в таблице "AccountPayableByDocuments" я активизирую поле с именем "AccountPayableByDocumentsAgreement"
			И в таблице "AccountPayableByDocuments" из выпадающего списка с именем "AccountPayableByDocumentsAgreement" я выбираю по строке 've'
			И в таблице "AccountPayableByDocuments" из выпадающего списка с именем "AccountPayableByDocumentsCurrency" я выбираю по строке 't'
			И в таблице "AccountPayableByDocuments" я завершаю редактирование строки
	* Filling the tabular part by searching the value by line Account receivable
		* By agreements
			И я перехожу к закладке "Account receivable"
			И в таблице "AccountReceivableByAgreements" я нажимаю на кнопку с именем 'AccountReceivableByAgreementsAdd'
			И в таблице "AccountReceivableByAgreements" из выпадающего списка с именем "AccountReceivableByAgreementsPartner" я выбираю по строке 'DF'
			И я перехожу к следующему реквизиту
			И в таблице "AccountReceivableByAgreements" из выпадающего списка с именем "AccountReceivableByAgreementsLegalName" я выбираю по строке 'DF'
			# И в таблице "AccountReceivableByAgreements" из выпадающего списка с именем "AccountReceivableByAgreementsAgreement" я выбираю по строке 'DF'
			И в таблице "AccountReceivableByAgreements" из выпадающего списка с именем "AccountReceivableByAgreementsCurrency" я выбираю по строке 't'
		* By documents
			И я перехожу к закладке с именем "GroupAccountReceivableByDocuments"
			И в таблице "AccountReceivableByDocuments" я нажимаю на кнопку с именем 'AccountReceivableByDocumentsAdd'
			И в таблице "AccountReceivableByDocuments" из выпадающего списка с именем "AccountReceivableByDocumentsPartner" я выбираю по строке 'DF'
			И я перехожу к следующему реквизиту
			И в таблице "AccountReceivableByDocuments" из выпадающего списка с именем "AccountReceivableByDocumentsLegalName" я выбираю по строке 'DF'
			# И в таблице "AccountReceivableByDocuments" я активизирую поле с именем "AccountReceivableByDocumentsAgreement"
			# И в таблице "AccountReceivableByDocuments" из выпадающего списка с именем "AccountReceivableByDocumentsAgreement" я выбираю по строке 'DF'
			И в таблице "AccountReceivableByDocuments" из выпадающего списка с именем "AccountReceivableByDocumentsCurrency" я выбираю по строке 't'
			И в таблице "AccountReceivableByDocuments" я завершаю редактирование строки
	* Filling check
		И Пауза 2
		И     таблица "Inventory" содержит строки:
		| 'Item'  | 'Quantity' | 'Item key' | 'Store'    |
		| 'Dress' | '2,000'    | 'S/Yellow' | 'Store 01' |
		И     таблица "AccountBalance" содержит строки:
			| 'Account'      | 'Currency' |
			| 'Cash desk №1' | 'TRY'      |
		И     таблица "AdvanceFromCustomers" содержит строки:
			| 'Partner'   | 'Legal name'               |
			| 'Ferron BP' | 'Second Company Ferron BP' |
		И     таблица "AdvanceToSuppliers" содержит строки:
			| 'Partner'   | 'Legal name'               |
			| 'Ferron BP' | 'Second Company Ferron BP' |
		И     таблица "AccountPayableByAgreements" содержит строки:
			| 'Partner'   | 'Agreement'          | 'Legal name'               | 'Currency' |
			| 'Ferron BP' | 'Vendor Ferron, USD' | 'Second Company Ferron BP' | 'TRY'      |
		И     таблица "AccountPayableByDocuments"  содержит строки:
			| 'Partner'   | 'Agreement'          | 'Legal name'               | 'Currency' |
			| 'Ferron BP' | 'Vendor Ferron, TRY' | 'Second Company Ferron BP' | 'TRY'      |
		И     таблица "AccountReceivableByAgreements" содержит строки:
			| 'Partner' | 'Legal name' | 'Currency' |
			| 'DFC'     | 'DFC'        | 'TRY'      |
		И     таблица "AccountReceivableByDocuments"  содержит строки:
			| 'Partner' | 'Legal name' | 'Currency' |
			| 'DFC'     | 'DFC'        | 'TRY'      |
	И Я закрыл все окна клиентского приложения

Сценарий: _0154097 check company and account (in english) input by search in line in Cash revenue
	* Open a creation form Cash revenue
		И я открываю навигационную ссылку "e1cib/list/Document.CashRevenue"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line и account
		И из выпадающего списка "Company" я выбираю по строке 'main'
		И из выпадающего списка "Account" я выбираю по строке 'TRY'
	* Filling check
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Bank account, TRY'
	И я закрыл все окна клиентского приложения



Сценарий: _0154098 check company и account (in english) input by search in line in CashExpense
	* Open a creation form CashExpense
		И я открываю навигационную ссылку "e1cib/list/Document.CashExpense"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Company input by search in line и account
		И из выпадающего списка "Company" я выбираю по строке 'main'
		И из выпадающего списка "Account" я выбираю по строке 'TRY'
	* Filling check
		И     элемент формы с именем "Company" стал равен 'Main Company'
		И     элемент формы с именем "Account" стал равен 'Bank account, TRY'
	И я закрыл все окна клиентского приложения

Сценарий: _0154099 check partner и legal name (in english) input by search in line in Invoice Match
	И я закрыл все окна клиентского приложения
	* Opening a document form
		И я открываю навигационную ссылку 'e1cib/list/Document.InvoiceMatch'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Checking the filter when typing by Partner/Legal name
		И в таблице "Transactions" я нажимаю на кнопку с именем 'TransactionsAdd'
		И в таблице "Transactions" из выпадающего списка с именем "TransactionsPartner" я выбираю по строке 'MIO'
		И в таблице "Transactions" из выпадающего списка с именем "TransactionsLegalName" я выбираю по строке 'Company Kalipso'
	* Checking that there is only one legal name available for selection
		И в таблице "Transactions" я нажимаю кнопку выбора у реквизита с именем "TransactionsLegalName"
		Тогда таблица "List" стала равной:
		| 'Description' |
		| 'Company Kalipso'         |
		И Я закрыл все окна клиентского приложения




Сценарий: _010018 check the display on the Partners Description ENG form after changes (without re-open)
	* Open catalog Partners
		И я открываю навигационную ссылку "e1cib/list/Catalog.Partners"
	* Select Anna Petrova
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Anna Petrova'         |
		И в таблице "List" я выбираю текущую строку
	* Changing Description_en to Anna Petrova1 and display checking
		И в поле 'ENG' я ввожу текст 'Anna Petrova1'
		И я нажимаю на кнопку 'Save'
		Тогда элемент формы с именем "Description_en" стал равен 'Anna Petrova1'
	* Changing Description_en back and display checking
		И в поле 'ENG' я ввожу текст 'Anna Petrova'
		И я нажимаю на кнопку 'Save'
		Тогда элемент формы с именем "Description_en" стал равен 'Anna Petrova'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _010019 check the display on the Company Description ENG form after changes (without re-open)
	* Open catalog Companies
		И я открываю навигационную ссылку "e1cib/list/Catalog.Companies"
	* Select Company Lomaniti
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Lomaniti'         |
		И в таблице "List" я выбираю текущую строку
	* Changing Description_en to Company Lomaniti1 and display checking
		И в поле 'ENG' я ввожу текст 'Company Lomaniti1'
		И я нажимаю на кнопку 'Save'
		Тогда элемент формы с именем "Description_en" стал равен 'Company Lomaniti1'
		И в поле 'ENG' я ввожу текст 'Company Lomaniti'
		И я нажимаю на кнопку 'Save'
	* Changing Description_en back and display checking
		Тогда элемент формы с именем "Description_en" стал равен 'Company Lomaniti'
		И я нажимаю на кнопку 'Save and close'


Сценарий: _010017 check the move to the Company tab from the Partner (shows the partner's Legal name)
	* Open catalog Partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Select Ferron BP
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
	* Check the move to the Company tab
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		Тогда таблица "List" стала равной:
			| 'Description'       |
			| 'Company Ferron BP' |
			| 'Second Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И я проверяю отображение информации по Company
			Тогда элемент формы с именем "Country" стал равен 'Turkey'
			И     элемент формы с именем "Partner" стал равен 'Ferron BP'
			И     элемент формы с именем "Description_en" стал равен 'Company Ferron BP'
		И Я закрываю текущее окно
		И Я закрываю текущее окно

Сценарий: _005034 Check filling in обязательных полей в справочнике "Items"
	И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
	Когда создаю элемент справочника с наименованием Test
	Если в текущем окне есть сообщения пользователю Тогда
	И     Я закрываю текущее окно
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'No'


Сценарий: _005035 Check filling inобязательных полей в справочнике "AddAttributeAndPropertyValues"
	И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertyValues"
	Когда создаю элемент справочника с наименованием Test
	Если в текущем окне есть сообщения пользователю Тогда
	И     Я закрываю текущее окно
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'No'



Сценарий: _005037 Check filling inобязательных полей в справочнике "Users"
	И я открываю навигационную ссылку "e1cib/list/Catalog.Users"
	Когда создаю элемент справочника с наименованием Test
	И Я закрываю текущее окно
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'No'


Сценарий: _005118 check the display on the Items Description ENG form after changes (without re-open)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-214' с именем 'IRP-214'
	* Открытие формы элемента Box справочника Items
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Box'         |
		И в таблице "List" я выбираю текущую строку
	* * Changing Description_en to Box1 and display checking
		И в поле 'ENG' я ввожу текст 'Box1'
		И я нажимаю на кнопку 'Save'
		Тогда элемент формы с именем "Description_en" стал равен 'Box1'
		И в поле 'ENG' я ввожу текст 'Box'
		И я нажимаю на кнопку 'Save'
	* Замена Description_en на первоначальное значение
		Тогда элемент формы с именем "Description_en" стал равен 'Box'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _012008 check the display on the  Agreement Description ENG form after changes (without re-open)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-214' с именем 'IRP-214'
	* Открытие формы элемента Personal Agreements, $ справочника Agreements
		И я открываю навигационную ссылку "e1cib/list/Catalog.Agreements"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Personal Agreements, $'         |
		И в таблице "List" я выбираю текущую строку
	* * Changing Description_en to Personal Agreements, $ 1 and display checking
		И в поле 'ENG' я ввожу текст 'Personal Agreements, $ 1'
		И я нажимаю на кнопку 'Save'
		Тогда элемент формы с именем "Description_en" стал равен 'Personal Agreements, $ 1'
	* Замена Description_en на первоначальное значение
		И в поле 'ENG' я ввожу текст 'Personal Agreements, $'
		И я нажимаю на кнопку 'Save'
		Тогда элемент формы с именем "Description_en" стал равен 'Personal Agreements, $'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _012009 проверка перехода в раздел Agreements из карточки Partner (отображает доступные соглашения по партнеру)
	# И Я устанавливаю ссылку 'https://bilist.atlassian.net/browse/IRP-170' с именем 'IRP-170'
	* Открытие формы элемента Ferron BP справочника Partners
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
	* Переход в раздел Agreements
		И В текущем окне я нажимаю кнопку командного интерфейса 'Agreements'
	* Проверка отображения только доступных соглашений
		И я запоминаю количество строк таблицы "List" как "QS"
		Тогда переменная "QS" имеет значение 8
		Тогда таблица "List" содержит строки:
			| Description                     |
			| Basic Agreements, TRY         |
			| Basic Agreements, $           |
			| Basic Agreements, without VAT |
			| Vendor Ferron, TRY            |
			| Vendor Ferron, USD            |
			| Vendor Ferron, EUR            |
			| Sale autum, TRY               |
			| Ferron, USD               |
		И Я закрываю текущее окно
	

Сценарий: проверка фильтра по полю Company и Legal name в форме элемента справочника Agreement
	* Open a creation form Agreement
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
	* И я проверяю фильтр по Company
		И я нажимаю кнопку выбора у поля "Company"
		Тогда таблица "List" стала равной:
			| 'Description'              |
			| 'Main Company'             |
			| 'Second Company'           |
		И в таблице "List" я выбираю текущую строку
	* И я проверяю фильтр по Legal name без заполнения партнера
		И я нажимаю кнопку выбора у поля "Legal name"
		Тогда таблица "List" не содержит строки:
			| 'Description'              |
			| 'Main Company'             |
			| 'Second Company'           |
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
	* И я проверяю фильтр по Legal name с заполнением партнера
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		Тогда таблица "List" не содержит строки:
		| 'Description'              |
		| 'Company Ferron BP'        |
		| 'DFC'                      |
		| 'Big foot'                 |
		| 'Second Company Ferron BP' |
		И я закрыл все окна клиентского приложения

Сценарий: проверка фильтра по Partner segment в элементе справочника Agreement
	* Open a creation form Agreement
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я меняю значение переключателя 'Type' на 'Customer'
	* И я проверяю фильтр по Partner segment
		И я нажимаю кнопку выбора у поля "Partner segment"
		Тогда таблица "List" содержит строки:
			| 'Description' |
			| 'Retail'      |
			| 'Dealer'      |
		Тогда таблица "List" не содержит строки:
			| 'Description' |
			| 'Region 1'    |
			| 'Region 2'    |
		И я закрыл все окна клиентского приложения
	

Сценарий: невозможность создания собственной компании из карточки Partner
	* Открытие карточки партнера
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Ferron BP'   |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Company'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Проверка на то что галочка Our не доступна
		Если элемент "Our" не доступен для редактирования Тогда

Сценарий: проверка выбора менеджера сегмента в заказе клиента
	* Open the Sales order creation form
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение партнера и Legal name
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я выбираю текущую строку
		И я перехожу к закладке "Other"
		И я разворачиваю группу "More"
		И я нажимаю кнопку выбора у поля "Manager segment"
	* Проверка отображения сегментов менеджеров
		Тогда таблица "List" стала равной:
		| 'Description' |
		| 'Region 1'    |
		| 'Region 2'    |



Сценарий: проверка row key при клонировании строки в Sales order
	* Filling in the details of the documentsales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'Basic Agreements, without VAT' |
		И в таблице "List" я выбираю текущую строку
	* Заполнение Sales order
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
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле с именем "ItemListItem"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuCopy'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
	* Проверка что row key по строкам не совпадают
		И я нажимаю на кнопку 'Registrations report'
		И я запоминаю значение ячейки табличного документа "ResultTable" "R34C8" в переменную "Rov1"
		И я запоминаю значение ячейки табличного документа "ResultTable" "R35C8" в переменную "Rov2"
		И я вывожу значение переменной "Rov1"
		И я вывожу значение переменной "Rov2"
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.OrderBalance'
		И в таблице "List" я перехожу к строке:
		| 'Row key' |
		| '$Rov1$'    |
		И в таблице "List" я активизирую поле "Row key"
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuFindByCurrentValue'
		Тогда в таблице "List" количество строк "меньше или равно" 1

Сценарий: проверка row key при клонировании строки в Sales invoice
	* Filling in the details of the documentSales invoice
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesInvoice'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'                   |
			| 'Basic Agreements, without VAT' |
		И в таблице "List" я выбираю текущую строку
	* Заполнение Sales invoice
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
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле с именем "ItemListItem"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuCopy'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
	* Проверка что row key по строкам не совпадают
		И я нажимаю на кнопку 'Registrations report'
		И я запоминаю значение ячейки табличного документа "ResultTable" "R19C8" в переменную "Rov1"
		И я запоминаю значение ячейки табличного документа "ResultTable" "R20C8" в переменную "Rov2"
		И я вывожу значение переменной "Rov1"
		И я вывожу значение переменной "Rov2"
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
		И в таблице "List" я перехожу к строке:
		| 'Row key' |
		| '$Rov1$'    |
		И в таблице "List" я активизирую поле "Row key"
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuFindByCurrentValue'
		Тогда в таблице "List" количество строк "меньше или равно" 1

Сценарий: проверка row key при клонировании строки в Purchase order
	* Filling in the details of the documentPurchase order
		И я открываю навигационную ссылку 'e1cib/list/Document.PurchaseOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Ferron BP'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
		И из выпадающего списка "Status" я выбираю точное значение 'Approved'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Store 02'     |
		И в таблице "List" я выбираю текущую строку
	* Заполнение Purchase order
		И я нажимаю на кнопку с именем 'Add'
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
		И в таблице "ItemList" я активизирую поле "Price"
		И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле с именем "ItemListItem"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuCopy'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
	* Проверка что row key по строкам не совпадают
		И я нажимаю на кнопку 'Registrations report'
		И я запоминаю значение ячейки табличного документа "ResultTable" "R6C9" в переменную "Rov1"
		И я запоминаю значение ячейки табличного документа "ResultTable" "R7C9" в переменную "Rov2"
		И я вывожу значение переменной "Rov1"
		И я вывожу значение переменной "Rov2"
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsReceiptSchedule'
		И в таблице "List" я перехожу к строке:
		| 'Row key' |
		| '$Rov1$'    |
		И в таблице "List" я активизирую поле "Row key"
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuFindByCurrentValue'
		Тогда в таблице "List" количество строк "меньше или равно" 1

Сценарий: проверка row key при клонировании строки в Shipment confirmation
	* Filling in the details of the documentShipment confirmation
		И я открываю навигационную ссылку 'e1cib/list/Document.ShipmentConfirmation'
		И я нажимаю на кнопку с именем 'FormCreate'
		И из выпадающего списка "Transaction type" я выбираю точное значение 'Sales'
		И я нажимаю кнопку выбора у поля "Store"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Store 02'    |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Company"
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'Main Company' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| 'Description'   |
			| 'Ferron BP'     |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Legal name"
		И в таблице "List" я перехожу к строке:
			| 'Description'       |
			| 'Company Ferron BP' |
		И в таблице "List" я выбираю текущую строку
	* Заполнение Shipment confirmation
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
		И в таблице "ItemList" я активизирую поле "Quantity"
		И в таблице "ItemList" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле с именем "ItemListItem"
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListContextMenuCopy'
		И в таблице "ItemList" я завершаю редактирование строки
		И я нажимаю на кнопку 'Post'
	* Проверка что row key по строкам не совпадают
		И я нажимаю на кнопку 'Registrations report'
		И я запоминаю значение ячейки табличного документа "ResultTable" "R6C8" в переменную "Rov1"
		И я запоминаю значение ячейки табличного документа "ResultTable" "R7C8" в переменную "Rov2"
		И я вывожу значение переменной "Rov1"
		И я вывожу значение переменной "Rov2"
		И я открываю навигационную ссылку 'e1cib/list/AccumulationRegister.GoodsInTransitOutgoing'
		И в таблице "List" я перехожу к строке:
		| 'Row key' |
		| '$Rov1$'    |
		И в таблице "List" я активизирую поле "Row key"
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuFindByCurrentValue'
		Тогда в таблице "List" количество строк "меньше или равно" 1






Сценарий: Check filling inProcurement method через кнопку заполнить в SO
	* Open a creation form заказа Sales order
		И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Заполнение общих реквизитов Sales order
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
		И я нажимаю кнопку выбора у поля "Agreement"
		И в таблице "List" я перехожу к строке:
			| 'Description'           |
			| 'Basic Agreements, TRY' |
		И в таблице "List" я выбираю текущую строку
	* Adding items to Sales order (4 строки)
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shirt'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я выбираю текущую строку
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		И в таблице "List" я перехожу к строке:
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		И в таблице "List" я активизирую поле "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '8,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		И в таблице "List" я активизирую поле "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '2,000'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
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
		И в таблице "List" я активизирую поле "Item"
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '3,000'
		И в таблице "ItemList" я завершаю редактирование строки
	* Проверка работы кнопки "Procurement"
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'     |
			| 'Shirt' | '38/Black' | '5,000' |
		И В таблице  "ItemList" я перехожу на одну строку вниз с выделением
		И в таблице "ItemList" я нажимаю на кнопку 'Procurement'
		И я устанавливаю флаг 'Stock'
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'       | 'Item key' | 'Q'     |
			| 'High shoes' | '37/19SD'  | '2,000' |
		И В таблице  "ItemList" я перехожу на одну строку вниз с выделением
		И в таблице "ItemList" я нажимаю на кнопку 'Procurement'
		И я изменяю флаг 'Purchase'
		И я нажимаю на кнопку 'OK'
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'  | 'Item key' | 'Q'     |
			| 'Boots' | '38/18SD'  | '8,000' |
		И В таблице  "ItemList" я перехожу на одну строку вниз с выделением
		И в таблице "ItemList" я нажимаю на кнопку 'Procurement'
		И я изменяю флаг 'Repeal'
		И я нажимаю на кнопку 'OK'
	* Check filling inProcurement method в созданном Sales order
		И     таблица "ItemList" содержит строки:
		| 'Item'       | 'Item key'  | 'Procurement method' | 'Q'     |
		| 'Shirt'      | '38/Black'  | 'Stock'              | '5,000' |
		| 'Boots'      | '38/18SD'   | 'Repeal'             | '8,000' |
		| 'High shoes' | '37/19SD'   | 'Repeal'             | '2,000' |
		| 'Trousers'   | '38/Yellow' | 'Purchase'           | '3,000' |
	* Добавление строки с услугой
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Service'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита с именем "ItemListItemKey"
		И в таблице "List" я перехожу к строке:
			| 'Item'     | 'Item key'  |
			| 'Service'  | 'Rent' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" в поле 'Price' я ввожу текст '100,00'
		И в таблице "ItemList" я завершаю редактирование строки
	* Проверка очистки procurement method по строке с услугой и проведении заказа
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'    | 'Item key' | 'Procurement method' |
			| 'Service' | 'Rent'     | 'Stock'              |
		И в таблице "ItemList" я активизирую поле "Procurement method"
		И в таблице "ItemList" я выбираю текущую строку
		И В таблице "ItemList" я нажимаю кнопку очистить у поля "Procurement method"
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Procurement method' |
			| 'Trousers' | '38/Yellow' | 'Purchase'           |
		И     таблица "ItemList" содержит строки:
			| 'Item'       | 'Item key'  | 'Procurement method' |
			| 'Shirt'      | '38/Black'  | 'Stock'              |
			| 'Boots'      | '38/18SD'   | 'Repeal'             |
			| 'High shoes' | '37/19SD'   | 'Repeal'             |
			| 'Trousers'   | '38/Yellow' | 'Purchase'           |
			| 'Service'    | 'Rent'      | ''                   |
		И я нажимаю на кнопку 'Post'
	* Проверка очистки procurement method по строке с товаром и невозможности проведения заказа
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'     | 'Item key'  | 'Procurement method' |
			| 'Trousers' | '38/Yellow' | 'Purchase'           |
		И В таблице "ItemList" я нажимаю кнопку очистить у поля "Procurement method"
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я перехожу к строке:
			| 'Item'       | 'Item key' | 'Procurement method' |
			| 'High shoes' | '37/19SD'  | 'Repeal'             |
		И я нажимаю на кнопку 'Post'
		Затем я жду, что в сообщениях пользователю будет подстрока "Field: [Procurement method] is empty" в течение 30 секунд
		И я закрыл все окна клиентского приложения


Сценарий: Check filling inpartner и признака customer/vendor при создании Agreement из карточки партнера
	* Открытие карточки партнера-клиента
		И я открываю навигационную ссылку "e1cib/list/Catalog.Partners"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Kalipso' |
		И в таблице "List" я выбираю текущую строку
	* Open a creation form Agreement
		И В текущем окне я нажимаю кнопку командного интерфейса 'Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inPartner и признака Customer
		И     элемент формы с именем "Partner" стал равен 'Kalipso'
		И     элемент формы с именем "Type" стал равен 'Customer'
	* Открытие карточки партнера-поставщика
		И я открываю навигационную ссылку "e1cib/list/Catalog.Partners"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Veritas' |
		И в таблице "List" я выбираю текущую строку
	* Open a creation form Agreement
		И В текущем окне я нажимаю кнопку командного интерфейса 'Agreements'
		И я нажимаю на кнопку с именем 'FormCreate'
	* Check filling inPartner и признака Customer
		И     элемент формы с именем "Partner" стал равен 'Veritas'
		И     элемент формы с именем "Type" стал равен 'Vendor'
	И я закрыл все окна клиентского приложения
