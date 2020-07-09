#language: ru
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Функционал: export scenarios

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.



Сценарий: finishing adding a line to the price list
	И в таблице "ItemList" я завершаю редактирование строки
	И в таблице "ItemList" я нажимаю на кнопку 'Add'
	И в таблице "ItemList" я нажимаю кнопку выбора у реквизита "Item key"

Сценарий: changing the price list number
	И в поле 'Number' я ввожу текст '0'
	Тогда открылось окно '1C:Enterprise'
	И я нажимаю на кнопку 'Yes'
	Тогда открылось окно 'Price list (create) *'

Сценарий: open the form to create a price list
	И я открываю навигационную ссылку 'e1cib/list/Document.PriceList'
	И Пауза 2
	И я нажимаю на кнопку с именем 'FormCreate'
	И Пауза 2


