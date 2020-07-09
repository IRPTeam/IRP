
#language: ru
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Функционал: export scenarios

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: creating a catalog element with the name Test.

	И Пауза 2
	И я нажимаю на кнопку с именем 'FormCreate'
	И Пауза 2
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	# И я перехожу к закладке "< >"
	И в поле с именем 'Description_en' я ввожу текст 'Test ENG'
	И в поле с именем 'Description_tr' я ввожу текст 'Test TR'
	И я нажимаю на кнопку 'Ok'
	И я нажимаю на кнопку с именем 'FormWrite'
	И Пауза 5