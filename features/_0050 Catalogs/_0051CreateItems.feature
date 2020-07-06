#language: ru
@tree
@Positive


Функционал: filling in catalogs Items

As an owner
I want to fill out items information
To further use it when reflecting in the program of business processes

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


# All indivisible packages of the same product are wound up using Specifiсation with type Set. Then a separate Item key is created for the product, in which the necessary set is specified.
# and a price is set on it. It's the Set that's stored on the remains. In order to break it up you need to run the Unbandling document
# For the simple accounting of goods in the packages of documents (the remnants are stored pieces) usedItem units of measurement pcs. For each product, a different Unit is specified
# like pcs consisting of 6 pieces, 10 pieces, etc. # In this case, the price of the order gets as the price of a piece. There's pcs going through the registers, too. 



Сценарий: _005110 filling in the "UI groups" catalog 
# Catalog "UI group" is designed to create groups of additional attributes for the items. Also provides for the location of the group on the item's form (right or left)
	* Opening the UI groups creation form 
		И я открываю навигационную ссылку "e1cib/list/Catalog.InterfaceGroups"
		И я нажимаю на кнопку с именем 'FormCreate'
	* Creating UI groups: Product information, Accounting information, Purchase and production 
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Product information'
		И в поле 'TR' я ввожу текст 'Product information TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'UI groups (create)' в течение 5 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Accounting information'
		И в поле 'TR' я ввожу текст 'Accounting information TR'
		И я нажимаю на кнопку 'Ok'
		И я меняю значение переключателя с именем 'FormPosition' на 'Right'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'UI groups (create)' в течение 5 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Purchase and production'
		И в поле 'TR' я ввожу текст 'Purchase and production TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'UI groups (create)' в течение 5 секунд
	* Checking for added UI groups in the catalog 
		Тогда В базе появился хотя бы один элемент справочника "InterfaceGroups"
		Тогда я проверяю наличие элемента справочника "InterfaceGroups" со значением поля "Description_en" "Product information"  
		Тогда я проверяю наличие элемента справочника "InterfaceGroups" со значением поля "Description_tr" "Product information TR"
		Тогда я проверяю наличие элемента справочника "InterfaceGroups" со значением поля "Description_en" "Accounting information"  
		Тогда я проверяю наличие элемента справочника "InterfaceGroups" со значением поля "Description_tr" "Accounting information TR"
		Тогда я проверяю наличие элемента справочника "InterfaceGroups" со значением поля "Description_en" "Purchase and production"  
		Тогда я проверяю наличие элемента справочника "InterfaceGroups" со значением поля "Description_tr" "Purchase and production TR"


Сценарий: _005111 filling in the "Add attribute and property" catalog 
	* Opening the Add attribute and property creation form 
		И я открываю навигационную ссылку "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 5
	* Creating additional attribute Type
		И я нажимаю кнопку выбора у поля с именем "ValueType"
		И Пауза 2
		И в таблице "*" я перехожу к строке:
				| ''       |
				| 'String' |
		И я нажимаю на кнопку с именем 'OK'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Type'
		И в поле с именем 'Description_tr' я ввожу текст 'Type TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку с именем 'FormWrite'
		И в поле с именем 'UniqueID' я ввожу текст 'V123445'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Creating additional attribute Brand
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 5
		И я нажимаю кнопку выбора у поля с именем "ValueType"
		И Пауза 2
		И в таблице "" я перехожу к строке:
				| ''       |
				| 'Additional attribute value' |
		И я нажимаю на кнопку с именем 'OK'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Brand'
		И в поле с именем 'Description_tr' я ввожу текст 'Brand TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку с именем 'FormWrite'
		И в поле с именем 'UniqueID' я ввожу текст 'V123446'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Creating additional attribute producer 
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 5
		И я нажимаю кнопку выбора у поля с именем "ValueType"
		И Пауза 2
		И в таблице "" я перехожу к строке:
				| ''       |
				| 'Additional attribute value' |
		И я нажимаю на кнопку с именем 'OK'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Producer'
		И в поле с именем 'Description_tr' я ввожу текст 'Producer TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку с именем 'FormWrite'
		И в поле с именем 'UniqueID' я ввожу текст 'V123447'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Creating additional attribute Size
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 5
		И я нажимаю кнопку выбора у поля с именем "ValueType"
		И Пауза 2
		И в таблице "" я перехожу к строке:
				| ''       |
				| 'Additional attribute value' |
		И я нажимаю на кнопку с именем 'OK'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Size'
		И в поле с именем 'Description_tr' я ввожу текст 'Size TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку с именем 'FormWrite'
		И в поле с именем 'UniqueID' я ввожу текст 'Size1'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Creating additional attribute Color
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 5
		И я нажимаю кнопку выбора у поля с именем "ValueType"
		И Пауза 2
		И в таблице "" я перехожу к строке:
				| ''       |
				| 'Additional attribute value' |
		И я нажимаю на кнопку с именем 'OK'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Color'
		И в поле с именем 'Description_tr' я ввожу текст 'Color TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку с именем 'FormWrite'
		И в поле с именем 'UniqueID' я ввожу текст 'Color1'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Creating additional property article
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 5
		И я нажимаю кнопку выбора у поля с именем "ValueType"
		И Пауза 2
		И в таблице "" я перехожу к строке:
				| ''       |
				| 'String' |
		И в таблице "" я выбираю текущую строку
		И я нажимаю на кнопку с именем 'OK'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Article'
		И в поле с именем 'Description_tr' я ввожу текст 'Article TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку с именем 'FormWrite'
		И в поле с именем 'UniqueID' я ввожу текст 'V123448'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Creating additional property country of consignment
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 5
		И я нажимаю кнопку выбора у поля с именем "ValueType"
		И Пауза 2
		И в таблице "" я перехожу к строке:
				| ''       |
				| 'Additional attribute value' |
		И я нажимаю на кнопку с именем 'OK'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Country of consignment'
		И в поле с именем 'Description_tr' я ввожу текст 'Country of consignment TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку с именем 'FormWrite'
		И в поле с именем 'UniqueID' я ввожу текст 'V123449'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Creating additional property season
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 5
		И я нажимаю кнопку выбора у поля с именем "ValueType"
		И Пауза 2
		И в таблице "" я перехожу к строке:
				| ''       |
				| 'Additional attribute value' |
		И я нажимаю на кнопку с именем 'OK'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Season'
		И в поле с именем 'Description_tr' я ввожу текст 'Season TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку с именем 'FormWrite'
		И в поле с именем 'UniqueID' я ввожу текст 'V123450'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я жду закрытия окна 'Add attribute and property (create) *' в течение 20 секунд	

Сценарий: _005112 filling in Additional attribute values with type Additional attribute values
# the value of additional attributes (Producer, Color, Size,Season, Country of consignment)
	* Opening the Add attribute and property form
		И я открываю навигационную ссылку "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
	* Adding value Size
		И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Size'      |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Additional attribute values'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'S'
		И в поле 'TR' я ввожу текст 'S'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'XS'
		И в поле 'TR' я ввожу текст 'XS'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'M'
		И в поле 'TR' я ввожу текст 'M'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'L'
		И в поле 'TR' я ввожу текст 'L'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'XL'
		И в поле 'TR' я ввожу текст 'XL'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'XXL'
		И в поле 'TR' я ввожу текст 'XXL'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст '36'
		И в поле 'TR' я ввожу текст '36'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст '37'
		И в поле 'TR' я ввожу текст '37'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст '38'
		И в поле 'TR' я ввожу текст '38'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст '39'
		И в поле 'TR' я ввожу текст '39'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И Я нажимаю на кнопку 'Save and close'
	* Adding value Color
		И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Color'      |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Additional attribute values'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Yellow'
		И в поле 'TR' я ввожу текст 'Yellow TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Blue'
		И в поле 'TR' я ввожу текст 'Blue TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Brown'
		И в поле 'TR' я ввожу текст 'Brown TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'White'
		И в поле 'TR' я ввожу текст 'White TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Red'
		И в поле 'TR' я ввожу текст 'Red TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Green'
		И в поле 'TR' я ввожу текст 'Green TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Black'
		И в поле 'TR' я ввожу текст 'Black TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И Я нажимаю на кнопку 'Save and close'
	* Adding value Season
		И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Season'      |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Additional attribute values'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст '18SD'
		И в поле 'TR' я ввожу текст '18SD'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст '19SD'
		И в поле 'TR' я ввожу текст '19SD'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст '20SD'
		И в поле 'TR' я ввожу текст '20SD'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
	* Adding value Country of consignment
		И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Country of consignment'      |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Additional attribute values'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Turkey'
		И в поле 'TR' я ввожу текст 'Turkey TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Romania'
		И в поле 'TR' я ввожу текст 'Romania TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Ukraine'
		И в поле 'TR' я ввожу текст 'Ukraine TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Poland'
		И в поле 'TR' я ввожу текст 'Poland TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
	* Adding value Producer
		И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Producer'      |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Additional attribute values'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'UNIQ'
		И в поле 'TR' я ввожу текст 'UNIQ'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'PZU'
		И в поле 'TR' я ввожу текст 'PZU'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'ODS'
		И в поле 'TR' я ввожу текст 'ODS'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
	* Adding value Brand
		И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'Brand'      |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Additional attribute values'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'York'
		И в поле 'TR' я ввожу текст 'York'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Gir'
		И в поле 'TR' я ввожу текст 'Gir'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Rose'
		И в поле 'TR' я ввожу текст 'Rose'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Montel'
		И в поле 'TR' я ввожу текст 'Montel'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 2
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'


Сценарий: _005113 filling in the "Item types" catalog 
	* Clearing the Item types catalog 
		И я удаляю все элементы Справочника "ItemTypes"
		И в базе нет элементов Справочника "ItemTypes"
	* Opening the form for filling in Item types
		И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Creating item types: Сlothes, Box, Shoes
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Сlothes'
		И в поле с именем 'Description_tr' я ввожу текст 'Сlothes TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда В базе появился хотя бы один элемент справочника "ItemTypes"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Box'
		И в поле с именем 'Description_tr' я ввожу текст 'Box TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Shoes'
		И в поле с именем 'Description_tr' я ввожу текст 'Shoes TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
	* Checking for created elements
		Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля "Description_en" "Сlothes"  
		Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля "Description_tr" "Сlothes TR"
		Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля "Description_en" "Shoes"  
		Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля "Description_tr" "Shoes TR"
		Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля "Description_en" "Box"  
		Тогда я проверяю наличие элемента справочника "ItemTypes" со значением поля "Description_tr" "Box TR"


Сценарий: _005114 adding general additional attributes for Item
# AddAttributeAndPropertySets (Catalog_Items)
	* Opening the form for adding additional attributes for Items
		И я открываю навигационную ссылку "e1cib/list/Catalog.AddAttributeAndPropertySets"
		И в таблице "List" я перехожу к строке:
			| 'Predefined data item name' |
			| 'Catalog_Items'      |
		И в таблице "List" я выбираю текущую строку
	* Adding additional attributes
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Producer'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Article'   |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Brand'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в таблице "Attributes" я нажимаю на кнопку с именем 'AttributesAdd'
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Country of consignment' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в таблице "Attributes" я перехожу к строке:
			| 'Attribute' |
			| 'Producer'  |
	* Distribution of added additional attributes by UI groups
		И в таблице "Attributes" я активизирую поле "UI group"
		И в таблице "Attributes" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "UI group"
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Purchase and production' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в таблице "Attributes" я перехожу к строке:
			| 'Attribute' |
			| 'Article'   |
		И в таблице "Attributes" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "UI group"
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Accounting information' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в таблице "Attributes" я перехожу к строке:
			| 'Attribute' |
			| 'Brand'     |
		И в таблице "Attributes" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "UI group"
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Product information' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И в таблице "Attributes" я перехожу к строке:
			| 'Attribute'              |
			| 'Country of consignment' |
		И в таблице "Attributes" я выбираю текущую строку
		И в таблице "Attributes" я нажимаю кнопку выбора у реквизита "UI group"
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Product information' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Attributes" я завершаю редактирование строки
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Items'
		И в поле 'TR' я ввожу текст 'Items'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'

Сценарий: _005115 filling in the "Items" catalog 
	* Clearing the Items catalog 
		И я удаляю все элементы Справочника "Items"
		И в базе нет элементов Справочника "Items"
	* Opening the form for creating Items
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Test item creation Dress
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Dress'
		И в поле с именем 'Description_tr' я ввожу текст 'Dress TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля  с именем "ItemType"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сlothes'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Producer"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'UNIQ'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Brand"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Rose'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Country of consignment"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Poland'      |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Test item creation Trousers
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Trousers'
		И в поле с именем 'Description_tr' я ввожу текст 'Trousers TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля  с именем "ItemType"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Сlothes'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Test item creation Shirt
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Shirt'
		И в поле с именем 'Description_tr' я ввожу текст 'Shirt TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля  с именем "ItemType"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Сlothes'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Test item creation Boots
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Boots'
		И в поле с именем 'Description_tr' я ввожу текст 'Boots TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля  с именем "ItemType"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shoes'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Test item creation High shoes
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'High shoes'
		И в поле с именем 'Description_tr' я ввожу текст 'High shoes TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля  с именем "ItemType"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Shoes'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Test item creation Box
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Box'
		И в поле с именем 'Description_tr' я ввожу текст 'Box TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля  с именем "ItemType"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Box'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я открываю навигационную ссылку "e1cib/list/Catalog.Units"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'box (4 pcs)'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Box'       |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Test item creation на набор Bound Dress+Shirt
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Bound Dress+Shirt'
		И в поле с именем 'Description_tr' я ввожу текст 'Bound Dress+Shirt TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля  с именем "ItemType"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сlothes'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Test item creation на набор Bound Dress+Trousers
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Bound Dress+Trousers'
		И в поле с именем 'Description_tr' я ввожу текст 'Bound Dress+Trousers TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля  с именем "ItemType"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сlothes'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля с именем "Unit"
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5


Сценарий: _005116 filling in the settings for creating ItemKeys for Item type Closets and Shoes
# for clothes specify the color, for shoes - season
# It is indicated through the type of item with duplication in sets
	* Opening the form for filling in Item keys settings 
		И я открываю навигационную ссылку "e1cib/list/Catalog.ItemTypes"
	* Item key creation options for Сlothes
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Сlothes |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
		И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Size      |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я завершаю редактирование строки
		И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
		И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Color      |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
	* Item key creation options for Shoes
		И в таблице "List" я перехожу к строке:
			| Description      |
			| Shoes |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
		И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Size      |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я завершаю редактирование строки
		И в таблице "AvailableAttributes" я нажимаю на кнопку с именем 'AvailableAttributesAdd'
		И в таблице "AvailableAttributes" я нажимаю кнопку выбора у реквизита "Attribute"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Season      |
		И в таблице "List" я выбираю текущую строку
		И в таблице "AvailableAttributes" я завершаю редактирование строки
		И я нажимаю на кнопку 'Save and close'
		И Я закрываю текущее окно


Сценарий: _005117 fill in Item keys
# Dress, Trousers, Shirt, Boots, High shoes, Box
	И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
	* Filling in Item keys for Dress
		И в таблице "List" я перехожу к строке:
		| 'Description'      |
		| 'Dress' |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item keys (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'XS'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'M'           |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'L'           |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'XL'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'S'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Blue'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'XS (Item key) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'M'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'White'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'M (Item key) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'L'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Green'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'L (Item key) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XL'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Green'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'XL (Item key) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Dress (Item)' в течение 20 секунд
	* Filling in Item keys for Trousers
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Item type' |
			| 'Trousers'    | 'Сlothes'   |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '36'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '38'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Trousers (Item)' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Item type' |
			| 'Shirt'       | 'Сlothes'   |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '36'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '38'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Red'         |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Color"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Black'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		Тогда открылось окно 'Shirt (Item)'
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Item type' |
			| 'Boots'       | 'Shoes'     |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '36'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '37'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '38'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '39'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Season"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '37'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Season"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '38'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Season"
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '39'       |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Season"
		И я нажимаю на кнопку с именем 'FormChoose'
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Item type' |
			| 'High shoes'  | 'Shoes'     |
		И в таблице "List" я выбираю текущую строку
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '39'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Season"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '19SD'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю кнопку выбора у поля "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '37'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна 'Item key (create) *' в течение 20 секунд
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Season"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '19SD'        |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И я жду закрытия окна '* (Item key) *' в течение 20 секунд
		И В текущем окне я нажимаю кнопку командного интерфейса 'Main'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5

		

Сценарий: _005119 packaging for High shoes
	* Opening the form for creatingItem units
		И я открываю навигационную ссылку "e1cib/list/Catalog.Units"
	* Create packaging High shoes box (8 pcs)
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'High shoes box (8 pcs)'
		И в поле 'TR' я ввожу текст 'High shoes box (8 adet) TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'High shoes'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Basis unit"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'pcs'      |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Quantity' я ввожу текст '8'
		И я нажимаю на кнопку 'Save and close'
	* Create packaging Boots (12 pcs)
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'Boots (12 pcs)'
		И в поле 'TR' я ввожу текст 'Boots (12 adet) TR'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю кнопку выбора у поля "Item"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Boots'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Basis unit"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'pcs'      |
		И в таблице "List" я выбираю текущую строку
		И в поле 'Quantity' я ввожу текст '12'
		И я нажимаю на кнопку 'Save and close'
	И Я закрываю текущее окно

Сценарий: _005120 set Closets/Shoes specification creation
# Set is a dimensional grid, set to the type of item
	* Create a specification for Сlothes
		И я открываю навигационную ссылку "e1cib/list/Catalog.Specifications"
		И я нажимаю на кнопку с именем "FormCreate"
		И я меняю значение переключателя 'Type' на 'Set'
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Сlothes'     |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'XS'          |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Blue'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'M'           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Brown'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'L'           |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Color"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Color"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Green'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '2,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'A-8'
		И в поле 'TR' я ввожу текст 'A-8'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
	* Create a specification for Shoes
		И я открываю навигационную ссылку "e1cib/list/Catalog.Specifications"
		И я нажимаю на кнопку с именем "FormCreate"
		И я меняю значение переключателя 'Type' на 'Set'
		И я нажимаю кнопку выбора у поля "Item type"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Shoes'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| Description |
			| 36          |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Season"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Season"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '18SD'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '37'          |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Season"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Season"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '18SD'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '38'          |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Season"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Season"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '18SD'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И в таблице "FormTable*" я нажимаю на кнопку 'Add'
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Size"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '39'          |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Season"
		И в таблице "FormTable*" я нажимаю кнопку выбора у реквизита "Season"
		Тогда открылось окно 'Additional attribute values'
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| '18SD'        |
		И в таблице "List" я выбираю текущую строку
		И в таблице "FormTable*" я активизирую поле "Quantity"
		И в таблице "FormTable*" в поле 'Quantity' я ввожу текст '1,000'
		И в таблице "FormTable*" я завершаю редактирование строки
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле 'ENG' я ввожу текст 'S-8'
		И в поле 'TR' я ввожу текст 'S-8'
		И я нажимаю на кнопку 'Ok'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10

Сценарий: _005121 filling item key according to specification for set
	* Opening the Dress element in the Items catalog
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Item type' |
			| 'Dress'       | 'Сlothes'   |
		И в таблице "List" я выбираю текущую строку
	* Creating for Dress a new item key for the specification
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я изменяю флаг 'Specification'
		И я нажимаю кнопку выбора у поля с именем "Specification"
		И таблица "List" не содержит строки:
			| 'Description' | 'Type' |
			| 'S-8'         | 'Set'  |
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Type' |
			| 'A-8'         | 'Set'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда таблица "List" содержит строки:
			| 'Item key'   |
			| 'Dress/A-8'  |
		И Я закрываю текущее окно
	* Opening the Boots element in the Items catalog
		И я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Item type' |
			| 'Boots'       | 'Shoes'   |
		И в таблице "List" я выбираю текущую строку
	* Creating for Boots a new item key for the specification
		И В текущем окне я нажимаю кнопку командного интерфейса 'Item keys'
		И я нажимаю на кнопку с именем 'FormCreate'
		И я изменяю флаг 'Specification'
		И я нажимаю кнопку выбора у поля с именем "Specification"
		И таблица "List" не содержит строки:
			| 'Description' | 'Type' |
			| 'A-8'         | 'Set'  |
		И в таблице "List" я перехожу к строке:
			| 'Description' | 'Type' |
			| 'S-8'         | 'Set'  |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку 'Save and close'
		И Пауза 5
		Тогда таблица "List" содержит строки:
			| 'Item key'   |
			| 'Boots/S-8'  |
		И Я закрываю текущее окно