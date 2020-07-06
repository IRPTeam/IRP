#language: ru
@ExportScenarios
@IgnoreOnCIMainBuild

Функционал: экспортные сценарии

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: выбираю обработку для создания типа (вида) скидки 
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Plugins"
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"

Сценарий: выбираю обработку для создания правила скидки 
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferRules'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Plugins"
	И в таблице "List" я перехожу к строке:
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"


Сценарий: перехожу к настройкам Price Type
	И я нажимаю на кнопку 'Set settings'
	И я нажимаю кнопку выбора у поля "Price type"

Сценарий: сохраняю настройки скидки
	И я нажимаю на кнопку 'Save settings'
	И Пауза 2
	И я нажимаю на кнопку 'Save and close'
	И Пауза 5

Сценарий: выбираю обработку для создания типа скидки (сообщение)
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOfferTypes'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Plugins"
	И в таблице "List" я перехожу к строке:
		| 'Description'           | 
		| 'ExternalSpecialMessage' | 
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку открытия поля с именем "Description_en"


Сценарий: выбираю обработку для создания скидки
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

Сценарий: открываю окно создания скидки
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку с именем 'FormCreate'
	И я нажимаю кнопку выбора у поля "Special offer type"
	И Пауза 2

Сценарий: ввожу срок действия скидки текущий месяц
	И в поле "Start of" я ввожу начало текущего месяца
	И в поле "End of" я ввожу конец текущего месяца

Сценарий: добавляю правило скидки
	И в таблице "Rules" я нажимаю на кнопку с именем 'RulesAdd'
	И в таблице "Rules" я нажимаю кнопку выбора у реквизита "Rule"
	И Пауза 1

Сценарий: сохраняю правило в скидке
	И в таблице "List" я выбираю текущую строку
	И Пауза 1
	И в таблице "Rules" я завершаю редактирование строки
	И я нажимаю на кнопку 'Save and close'
	И Пауза 10

Сценарий: переношу скидку Discount 2 without Vat из группы Maximum в Minimum
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

Сценарий: переношу скидки Discount 2 without Vat и Discount 1 without Vat из группы Minimum в группу Maximum
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

Сценарий: переношу скидки Discount 2 without Vat и Discount 1 without Vat из Maximum в Minimum
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

Сценарий: переношу скидку Discount Price 2 в группу Minimum
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

Сценарий: меняю ручное проведение Discount Price 2
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


Сценарий: меняю ручное проведение скидки Discount Price 1
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

Сценарий: меняю auto проведение Discount Price 2
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


Сценарий: меняю auto проведение скидки Discount Price 1
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

Сценарий: переношу скидку Discount Price 1 в Minimum
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

Сценарий: переношу скидку Discount Price 1 в Maximum
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

Сценарий: переношу скидку Discount Price 2 в группу Maximum
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

Сценарий: переношу Discount Price 2 в группу Minimum
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

Сценарий: переношу скидку Discount Price 1 в Sum
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

Сценарий: переношу скидку Discount Price 2 в группу Sum
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

Сценарий: меняю priority Discount Price 1 с 1 на 3
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '3'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 2


Сценарий: меняю priority Discount Price 1 на 1
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount Price 1' |
	И в таблице "List" я выбираю текущую строку
	И в поле 'Priority' я ввожу текст '1'
	И я нажимаю на кнопку 'Save and close'
	И Пауза 2


Сценарий: переношу скидку Discount 1 without Vat в Minimum
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

Сценарий: переношу скидку Discount 2 without Vat в группу Minimum
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

Сценарий: переношу скидку Discount 1 without Vat в группу Sum
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


Сценарий: переношу скидку Discount 2 without Vat в группу Sum in Minimum
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

Сценарий: переношу группу Sum in Minimum в Minimum
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

Сценарий: переношу скидку Discount 1 without Vat в Sum in Minimum
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

Сценарий: переношу скидку Discount 2 without Vat в Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 2 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: переношу Discount 1 without Vat в Special Offers
	И я открываю навигационную ссылку 'e1cib/list/Catalog.SpecialOffers'
	И я нажимаю на кнопку 'List'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Discount 1 without Vat' |
	И в таблице "List" я нажимаю на кнопку с именем 'ListContextMenuMoveItem'
	Тогда открылось окно 'Special offers'
	И в таблице  "List" я перехожу на один уровень вниз
	И я нажимаю на кнопку с именем 'FormChoose'

Сценарий: меняю автоматическое проведение скидки 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms
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

Сценарий: меняю автоматическое проведение 4+1 Dress and Trousers, Discount on Basic Partner terms
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

Сценарий: меняю автоматическое проведение скидки All items 5+1, Discount on Basic Partner terms
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

Сценарий: меняю ручное проведение 4+1 Dress and Trousers, Discount on Basic Partner terms
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

Сценарий: меняю ручное проведение скидки 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms
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

Сценарий: меняю ручное проведение скидки All items 5+1, Discount on Basic Partner terms
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

Сценарий: переношу скидку All items 5+1, Discount on Basic Partner terms в группу Minimum
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

Сценарий: переношу скидку 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms в группу Minimum
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

Сценарий: переношу скидку 4+1 Dress and Trousers, Discount on Basic Partner terms в группу Minimum
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

Сценарий: переношу скидку All items 5+1, Discount on Basic Partner terms в группу Sum
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

Сценарий: переношу скидку 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms в группу Sum
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

Сценарий: переношу скидку 4+1 Dress and Trousers, Discount on Basic Partner terms в группу Sum
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

Сценарий: меняю Type joing in the group Maximum на Maximum
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

Сценарий: меняю Type joing in the group Maximum на MaximumInRow
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

Сценарий: переношу скидку All items 5+1, Discount on Basic Partner terms в группу Special Offers
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

Сценарий: переношу скидку 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms в группу Special Offers
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

Сценарий: переношу скидку 4+1 Dress and Trousers, Discount on Basic Partner terms в группу Special Offers
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

Сценарий: переношу Discount Price 1 в Special Offers
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

Сценарий: переношу скидку Discount Price 2 в Special Offers
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

Сценарий: переношу скидку All items 5+1, Discount on Basic Partner terms в группу Maximum
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

Сценарий: переношу скидку 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms в группу Maximum
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

Сценарий: переношу скидку 4+1 Dress and Trousers, Discount on Basic Partner terms в группу Maximum
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


	
