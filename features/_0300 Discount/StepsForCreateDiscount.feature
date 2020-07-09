#language: ru
@ExportScenarios
@IgnoreOnCIMainBuild

Функционал: экспортные сценарии

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.

Сценарий: select the plugin to create the type of special offer 
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Plugins"
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"

Сценарий: select the plugin to create the rule of special offer 
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferRules'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Plugins"
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"


Сценарий: move on to the Price Type settings
	И я нажимаю на кнопку 'Set settings'
	И я нажимаю кнопку выбора у поля "Price type"

Сценарий: save the special offer setting
	И я нажимаю на кнопку 'Save settings'
	И Пауза 2
	И я нажимаю на кнопку 'Save and close'
	И Пауза 5

Сценарий: choose the plugin to create a special offer type (message)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Plugins"
	И в таблице "List" я перехожу к строке:
		| 'Description'           | 
		| 'ExternalSpecialMessage' | 
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"


Сценарий: choose the plugin to create a special offer
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку с именем 'FormCreateFolder'
	И я нажимаю кнопку выбора у поля "Special offer type"
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Plugins"
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"

Сценарий: open a special offer window
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Special offer type"
	И Пауза 2

Сценарий: enter the discount period this month
	И в поле "Start of" я ввожу начало текущего месяца
	И в поле "End of" я ввожу конец текущего месяца

Сценарий: add a special offer rule
	И в таблице "Rules" я нажимаю на кнопку с именем 'RulesAdd'
	И в таблице "Rules" я нажимаю кнопку выбора у реквизита "Rule"
	И Пауза 1

Сценарий: save the rule for a special offer
	И в таблице "List" я выбираю текущую строку
	И Пауза 1
	И в таблице "Rules" я завершаю редактирование строки
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10

Сценарий: move the Discount 2 without Vat special offer from Maximum to Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 2 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuLevelDown'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '2'        | 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move Discount 2 without Vat and Discount 1 without Vat discounts from the group Minimum to the group Maximum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'
	Тогда открылось окно 'Special offers'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 2 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице "List" я перехожу к строке:
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: transfer Discount 2 without Vat and Discount 1 without Vat discounts from Maximum to Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'
	Тогда открылось окно 'Special offers'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 2 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: transfer the Discount Price 2 discount to the Minimum group
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 2' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: change the Discount Price 2 manual
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 2' |
	И в таблице "List" я выбираю текущую строку
	И я устанавливаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "Yes"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'


Сценарий: change the manual setting of the Discount Price 1 discount.
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я выбираю текущую строку
	И я устанавливаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "Yes"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: change the auto setting of the Discount Price 2
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 2' |
	И в таблице "List" я выбираю текущую строку
	И я снимаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "No"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'


Сценарий: change the auto setting of the special offer Discount Price 1
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я выбираю текущую строку
	И я снимаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "No"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий:  move the Discount Price 1 to Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий:  move the Discount Price 1 to Maximum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий:  move the Discount Price 2 special offer to Maximum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 2' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the special offer Discount Price 2 to Minimum (for test)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 2' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the Discount Price 1 to Sum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Sum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the Discount Price 2 special offer to Sum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 2' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Sum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: change the priority Discount Price 1 from 1 to 3
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '3'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 2


Сценарий: change the priority Discount Price 1 to 1
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '1'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 2

Сценарий: change the priority special offer Discount Price 2 from 4 to 2
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 2' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '2'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 2

Сценарий: move the Discount 1 without Vat discount to Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the Discount 2 without Vat discount to the Minimum group
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 2 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the Discount 1 without Vat discount to the Sum group
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Sum'            |
	И я нажимаю на кнопку с именем 'FormChoose'


Сценарий: move the Discount 1 without Vat discount to the Sum in Minimum group
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 2 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Sum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the group Sum in Minimum to Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'      |
		| 'Sum in Minimum' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the Discount 1 without Vat discount to Sum in Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Sum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the Discount 2 without Vat discount to Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 2 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move Discount 1 without Vat в Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: change auto setting 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	И в таблице "List" я выбираю текущую строку
	И я снимаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "No"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: change auto setting 4+1 Dress and Trousers, Discount on Basic Partner terms
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	И в таблице "List" я выбираю текущую строку
	И я снимаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "No"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: change auto setting All items 5+1, Discount on Basic Partner terms
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	И в таблице "List" я выбираю текущую строку
	И я снимаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "No"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: change manually setting 4+1 Dress and Trousers, Discount on Basic Partner terms
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	И в таблице "List" я выбираю текущую строку
	И я устанавливаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "Yes"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: change manually setting 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	И в таблице "List" я выбираю текущую строку
	И я устанавливаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "Yes"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: change manually setting All items 5+1, Discount on Basic Partner terms
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	И в таблице "List" я выбираю текущую строку
	И я устанавливаю флаг 'Manually'
	И я нажимаю на кнопку 'Save'
	И Пауза 2
	И  флаг "Manually" равен "Yes"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'

Сценарий: move the discount All items 5+1, Discount on Basic Partner terms to the group Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Minimum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Minimum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount All items 5+1, Discount on Basic Partner terms to the group Sum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Sum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Sum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Sum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Sum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Sum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: change Type joing in the group Maximum to Maximum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Maximum' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuChange'
		И я нажимаю на кнопку открытия поля "Special offer type"
		И я нажимаю на кнопку 'Set settings'
		Тогда открылось окно 'Special offer rules'
		И из выпадающего списка "Type joining" я выбираю точное значение 'Maximum'
		И я нажимаю на кнопку 'Save settings'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10

Сценарий: change Type joing in the group Maximum to MaximumInRow
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
		И я нажимаю на кнопку 'List'
		И в таблице "List" я перехожу к строке:
			| 'Description'      |
			| 'Maximum' |
		И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuChange'
		И я нажимаю на кнопку открытия поля "Special offer type"
		И я нажимаю на кнопку 'Set settings'
		Тогда открылось окно 'Special offer rules'
		И из выпадающего списка "Type joining" я выбираю точное значение 'Maximum by row'
		И я нажимаю на кнопку 'Save settings'
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10
		И я нажимаю на кнопку 'Save and close'
		И Пауза 10

Сценарий: move the discount All items 5+1, Discount on Basic Partner terms to the group Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move Discount Price 1 to Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move Discount Price 1 to the group Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 2' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount All items 5+1, Discount on Basic Partner terms to the group Maximum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И я нажимаю на кнопку 'List'
	# И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Maximum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И я нажимаю на кнопку 'List'
	# И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Maximum
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И я нажимаю на кнопку 'List'
	# И в таблице  "List" я перехожу на один уровень вниз
	И в таблице "List" я перехожу к строке:
		| 'Special offer type' |
		| 'Maximum'            |
	И я нажимаю на кнопку с именем 'FormChoose'


	

Сценарий: creating an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	И я открываю навигационную ссылку 'e1cib/list/Document.SalesOrder'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Partner"
	И в таблице "List" я перехожу к строке:
			| 'Description'             |
			| 'Lomaniti' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Partner term"
	И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Basic Partner terms, TRY' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля "Legal name"
	И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Company Lomaniti'  |
	И в таблице "List" я выбираю текущую строку
	* Adding items to sales order
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Dress' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| 'XS/Blue'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '5,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
		И в таблице "ItemList" я нажимаю на кнопку с именем 'ItemListAdd'
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item"
		Тогда открылось окно 'Items'
		И в таблице "List" я перехожу к строке:
			| 'Description'                     |
			| 'Boots' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Item key"
		И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"
		Тогда открылось окно 'Item keys'
		И в таблице "List" я перехожу к строке:
			| 'Item key' |
			| '36/18SD'  |
		И в таблице "List" я выбираю текущую строку
		И в таблице "ItemList" я активизирую поле "Q"
		И в таблице "ItemList" в поле 'Q' я ввожу текст '1,000'
		И в таблице "ItemList" из выпадающего списка "Procurement method" я выбираю точное значение 'Stock'
		И в таблице "ItemList" я завершаю редактирование строки
	И я нажимаю на кнопку 'Post'




Сценарий: changing the manual apply of Discount 2 without Vat for test
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
			| 'Description'              |
			| 'Discount 2 without Vat' |
	И в таблице "List" я выбираю текущую строку
	И Пауза 2
	И я устанавливаю флаг с именем 'Manually'
	И  флаг "Manually" равен "Yes"
	И я нажимаю на кнопку "Save and close"
	И Я закрываю окно 'Special offers'