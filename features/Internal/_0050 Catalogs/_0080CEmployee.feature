#language: ru
@tree
@Positive
@Test

Функционал: access rights

As an owner
I want to create groups, User access profiles and users
To restrict user access rights

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий.


Сценарий: _008001 adding employees to the Partners catalog
	* Opening the form for filling in Partners
		И я открываю навигационную ссылку "e1cib/list/Catalog.Partners"
		И Пауза 2
	* Creating test partners for employees: Alexander Orlov, Anna Petrova, David Romanov, Arina Brown
		И я нажимаю на кнопку с именем 'FormCreate'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Alexander Orlov'
		И в поле с именем 'Description_tr' я ввожу текст 'Alexander Orlov TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'Employee'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Anna Petrova'
		И в поле с именем 'Description_tr' я ввожу текст 'Anna Petrova TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'Employee'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'David Romanov'
		И в поле с именем 'Description_tr' я ввожу текст 'David Romanov TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'Employee'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Arina Brown'
		И в поле с именем 'Description_tr' я ввожу текст 'Arina Brown TR'
		И я нажимаю на кнопку 'Ok'
		И я устанавливаю флаг с именем 'Employee'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Checking for created elements
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Alexander Orlov"
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Anna Petrova"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "David Romanov"
		И Пауза 2
		Тогда я проверяю наличие элемента справочника "Partners" со значением поля "Description_en" "Arina Brown"




Сценарий: _008002 User access groups creation
	* Opening the form for filling in User access groups
		И я открываю навигационную ссылку "e1cib/list/Catalog.AccessGroups"
	* Access group creation Commercial Agent
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Commercial Agent'
		И в поле с именем 'Description_tr' я ввожу текст 'Commercial Agent TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Access group creation "Manager"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Manager'
		И в поле с именем 'Description_tr' я ввожу текст 'Manager TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Access group creation "Administrators"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Administrators'
		И в поле с именем 'Description_tr' я ввожу текст 'Administrators TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Access group creation "Financier"
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Financier'
		И в поле с именем 'Description_tr' я ввожу текст 'Financier TR'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Checking for created elements
		Тогда В базе появился хотя бы один элемент справочника "AccessGroups"
		Тогда я проверяю наличие элемента справочника "AccessGroups" со значением поля "Description_en" "Commercial Agent"  
		Тогда я проверяю наличие элемента справочника "AccessGroups" со значением поля "Description_tr" "Commercial Agent TR"
		Тогда я проверяю наличие элемента справочника "AccessGroups" со значением поля "Description_en" "Manager"  
		Тогда я проверяю наличие элемента справочника "AccessGroups" со значением поля "Description_en" "Administrators"  
		Тогда я проверяю наличие элемента справочника "AccessGroups" со значением поля "Description_en" "Financier" 

Сценарий: _008003 User access profiles creation
	* Opening the form for filling in profiles
		И я открываю навигационную ссылку "e1cib/list/Catalog.AccessProfiles"
		И Пауза 2
	* User access profiles creation Commercial Agent
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Commercial Agent'
		И в поле с именем 'Description_tr' я ввожу текст 'Commercial Agent TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "Roles" я нажимаю на кнопку 'Update roles'
		И я настраиваю доступ для торгового агента
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'      | 'Use' |
				| 'IRP'           | 'Run mobile client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'    | 'Use' |
				| 'IRP'           | 'Run thin client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'   | 'Use' |
				| 'IRP'           | 'Run web client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation' | 'Use' |
				| 'IRP'           | 'Basic role'   | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
			И я жду закрытия окна 'User access profiles (create)' в течение 20 секунд
			И Пауза 5
	* User access profiles creation Manager
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Manager'
		И в поле с именем 'Description_tr' я ввожу текст 'Manager TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "Roles" я нажимаю на кнопку 'Update roles'
		И я указываю права доступа для менеджера
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'     | 'Use' |
				| 'IRP'           | 'Run thick client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'    | 'Use' |
				| 'IRP'           | 'Run thin client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'   | 'Use' |
				| 'IRP'           | 'Run web client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я жду закрытия окна 'User access profiles (create)' в течение 20 секунд
	* User access profiles creation Financier
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Financier'
		И в поле с именем 'Description_tr' я ввожу текст 'Financier TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "Roles" я нажимаю на кнопку 'Update roles'
		И я указываю права доступа для финансиста
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'    | 'Use' |
				| 'IRP'           | 'Run thin client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'   | 'Use' |
				| 'IRP'           | 'Run web client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И я жду закрытия окна 'User access profiles (create)' в течение 20 секунд
	* User access profiles creation Administrators
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Administrators'
		И в поле с именем 'Description_tr' я ввожу текст 'Administrators TR'
		И я нажимаю на кнопку 'Ok'
		И в таблице "Roles" я нажимаю на кнопку 'Update roles'
		И я указываю права доступа для админа
			И в таблице "Roles" я нажимаю на кнопку 'Update roles'
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation' | 'Use' |
				| 'IRP'           | 'Full access'  | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'     | 'Use' |
				| 'IRP'           | 'Run thick client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'    | 'Use' |
				| 'IRP'           | 'Run thin client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'   | 'Use' |
				| 'IRP'           | 'Run web client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation'      | 'Use' |
				| 'IRP'           | 'Run mobile client' | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И в таблице "Roles" я перехожу к строке:
				| 'Configuration' | 'Presentation' | 'Use' |
				| 'IRP'           | 'Basic role'   | 'No'  |
			И в таблице "Roles" я изменяю флаг 'Use'
			И в таблице "Roles" я завершаю редактирование строки
			И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
			И я жду закрытия окна 'User access profiles (create)' в течение 20 секунд
	* Checking for created elements
		Тогда В базе появился хотя бы один элемент справочника "AccessProfiles"
		Тогда я проверяю наличие элемента справочника "AccessProfiles" со значением поля "Description_en" "Commercial Agent"  
		Тогда я проверяю наличие элемента справочника "AccessProfiles" со значением поля "Description_en" "Manager"  
		Тогда я проверяю наличие элемента справочника "AccessProfiles" со значением поля "Description_en" "Financier"  
		Тогда я проверяю наличие элемента справочника "AccessProfiles" со значением поля "Description_en" "Administrators"  



Сценарий: _008004 filling in the "Users" catalog 
	* Opening the form for filling in users
		И я открываю навигационную ссылку "e1cib/list/Catalog.Users"
		И Пауза 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* User creation Commercial Agent 1
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Daniel Smith (Commercial Agent 1)'
		И в поле с именем 'Description_tr' я ввожу текст 'Daniel Smith (Commercial Agent 1) TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'DSmith'
		И в поле 'Localization code' я ввожу текст 'EN' 
		И в поле 'Interface localization code' я ввожу текст 'en' 
		И я устанавливаю флаг с именем "ShowInList"
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		Тогда В базе появился хотя бы один элемент справочника "Users"
	* User creation Commercial Agent 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Alexander Orlov (Commercial Agent 2)'
		И в поле с именем 'Description_tr' я ввожу текст 'Alexander Orlov (Commercial Agent 2) TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'AOrlov'
		И в поле 'Localization code' я ввожу текст 'tr' 
		И в поле 'Interface localization code' я ввожу текст 'tr'
		И я устанавливаю флаг с именем "ShowInList"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Alexander Orlov |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* User creation Commercial Agent 3
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Anna Petrova (Commercial Agent 3)'
		И в поле с именем 'Description_tr' я ввожу текст 'Anna Petrova (Commercial Agent 3) TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'APetrova'
		И в поле 'Localization code' я ввожу текст 'tr' 
		И в поле 'Interface localization code' я ввожу текст 'tr'
		И я устанавливаю флаг с именем "ShowInList"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Anna Petrova |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* User creation Manager 1
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Olivia Williams (Manager 1)'
		И в поле с именем 'Description_tr' я ввожу текст 'Olivia Williams (Manager 1) TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'OWilliams'
		И в поле 'Localization code' я ввожу текст 'tr' 
		И в поле 'Interface localization code' я ввожу текст 'tr'
		И я устанавливаю флаг с именем "ShowInList"
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* User creation Manager 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Emily Jones (Manager 2)'
		И в поле с именем 'Description_tr' я ввожу текст 'Emily Jones (Manager 2) TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'EJones'
		И в поле 'Localization code' я ввожу текст 'tr' 
		И в поле 'Interface localization code' я ввожу текст 'tr'
		И я устанавливаю флаг с именем "ShowInList"
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* User creation Manager 3
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Sofia Borisova (Manager 3)'
		И в поле с именем 'Description_tr' я ввожу текст 'Sofia Borisova (Manager 3) TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'SBorisova'
		И в поле 'Localization code' я ввожу текст 'tr' 
		И в поле 'Interface localization code' я ввожу текст 'tr'
		И я устанавливаю флаг с именем "ShowInList"
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* User creation Financier 1
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'David Romanov (Financier 1)'
		И в поле с именем 'Description_tr' я ввожу текст 'David Romanov (Financier 1) TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'DRomanov'
		И в поле 'Localization code' я ввожу текст 'tr' 
		И в поле 'Interface localization code' я ввожу текст 'tr'
		И я устанавливаю флаг с именем "ShowInList"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| David Romanov |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* User creation Financier 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Ella Zelenova (Financier 2)'
		И в поле с именем 'Description_tr' я ввожу текст 'Ella Zelenova (Financier 2) TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'EZelenova'
		И в поле 'Localization code' я ввожу текст 'tr' 
		И в поле 'Interface localization code' я ввожу текст 'tr'
		И я устанавливаю флаг с именем "ShowInList"
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* User creation Financier 3
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Arina Brown (Financier 3)'
		И в поле с именем 'Description_tr' я ввожу текст 'Arina Brown (Financier 3)TR'
		И я нажимаю на кнопку 'Ok'
		И в поле 'Login' я ввожу текст 'ABrown'
		И в поле 'Localization code' я ввожу текст 'tr' 
		И в поле 'Interface localization code' я ввожу текст 'tr'
		И я устанавливаю флаг с именем "ShowInList"
		И я нажимаю кнопку выбора у поля "Partner"
		И в таблице "List" я перехожу к строке:
			| Description |
			| Arina Brown |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Checking for created elements
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "Daniel Smith (Commercial Agent 1)"
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "Alexander Orlov (Commercial Agent 2)"  
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "Anna Petrova (Commercial Agent 3)"
		И Пауза 1
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "Olivia Williams (Manager 1)"
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "Emily Jones (Manager 2)"
		И Пауза 1
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "Sofia Borisova (Manager 3)"
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "David Romanov (Financier 1)"
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "Ella Zelenova (Financier 2)"
		И Пауза 1
		Тогда я проверяю наличие элемента справочника "Users" со значением поля "Description_en" "Arina Brown (Financier 3)"


Сценарий: _008005 assignment of access rights to users
	* Opening the User access groups catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.AccessGroups'
	* Assignment of access rights to sales rep
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Commercial Agent'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Profiles" я нажимаю на кнопку с именем 'ProfilesAdd'
		И в таблице "Profiles" я нажимаю кнопку выбора у реквизита "Profile"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Commercial Agent'       |
		И в таблице "List" я выбираю текущую строку
		И Пауза 1
		И я перехожу к закладке "Users"
		И в таблице "Profiles" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 3
		И я активизирую окно "Users"
		И в таблице "List" я перехожу к строке:
			| 'Login'  |
			| 'DSmith' |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
			| 'Login' |
			| 'AOrlov'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
			| 'Login' |
			| 'APetrova'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Assignment of access rights to managers
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Manager'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Profiles" я нажимаю на кнопку с именем 'ProfilesAdd'
		И в таблице "Profiles" я нажимаю кнопку выбора у реквизита "Profile"
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Commercial Agent'       |
		И в таблице "List" я выбираю текущую строку
		И Пауза 1
		И я перехожу к закладке "Users"
		И в таблице "Profiles" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
			| 'Login' |
			| 'OWilliams'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
				| 'Login' |
				| 'EJones'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
				| 'Login' |
				| 'SBorisova'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
	* Assignment of access rights to financiers
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Financier'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Profiles" я нажимаю на кнопку с именем 'ProfilesAdd'
		И в таблице "Profiles" я нажимаю кнопку выбора у реквизита "Profile"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Financier'       |
		И в таблице "List" я выбираю текущую строку
		И Пауза 1
		И я перехожу к закладке "Users"
		И в таблице "Profiles" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
				| 'Login' |
				| 'DRomanov'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
				| 'Login' |
				| 'EZelenova'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
				| 'Login' |
				| 'ABrown'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
	* Adding a user with administrator access (Turkish localization)
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Administrators'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Profiles" я нажимаю на кнопку с именем 'ProfilesAdd'
		И в таблице "Profiles" я нажимаю кнопку выбора у реквизита "Profile"
		И в таблице "List" я перехожу к строке:
				| 'Description' |
				| 'Administrators'       |
		И в таблице "List" я выбираю текущую строку
		И Пауза 1
		И я перехожу к закладке "Users"
		И в таблице "Profiles" я завершаю редактирование строки
		И в таблице "Users" я нажимаю на кнопку с именем 'UsersAdd'
		И в таблице "Users" я нажимаю кнопку выбора у реквизита "User"
		И Пауза 1
		И в таблице "List" я перехожу к строке:
				| 'Login' |
				| 'ABrown'       |
		И в таблице "List" я выбираю текущую строку
		И в таблице "Users" я завершаю редактирование строки
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5


Сценарий: _008006 creating Partner segments content (employee)
	* Opening the form for filling Partner segments content
		И я открываю навигационную ссылку 'e1cib/list/Catalog.PartnerSegments'
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
	* Filling in segment information Region 1
		И я изменяю флаг 'Managers'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Region 1'
		И в поле с именем 'Description_tr' я ввожу текст '1 Region'
		И я нажимаю на кнопку 'Ok'
	* Saving and checking the result
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 10
		Тогда я проверяю наличие элемента справочника "PartnerSegments" со значением поля "Description_en" "Region 1" 
	* Filling in segment information Region 2
		И я нажимаю на кнопку с именем 'FormCreate'
		И я изменяю флаг 'Managers'
		И я нажимаю на кнопку открытия поля с именем "Description_en"
		И в поле с именем 'Description_en' я ввожу текст 'Region 2'
		И в поле с именем 'Description_tr' я ввожу текст '2 Region'
		И я нажимаю на кнопку 'Ok'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 10
	* Checking for segment creation Region 2
		Тогда я проверяю наличие элемента справочника "PartnerSegments" со значением поля "Description_en" "Region 2" 


Сценарий: _008007 adding employees to the Region 1 (A+B) segment from the form
	* Opening Partners catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Adding "Alexander Orlov" to the segment Region 1
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Alexander Orlov' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Manager segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Region 1' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2
	* Adding "Anna Petrova" to the segment Region 1
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Anna Petrova' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Manager segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Region 1' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 2

Сценарий: _008008 adding employees to the Region 2 (A) segment from the form
	* Opening Partners catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	*  Adding Alexander Orlov to the segment Region 2
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Alexander Orlov' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Manager segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Region 2' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5


Сценарий: _008009 adding employees to the segment Region 1 from the form (the employee also is a client)
	* Opening Partners catalog
		И я открываю навигационную ссылку 'e1cib/list/Catalog.Partners'
	* Adding Anna Petrova to the segment Region 1
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Anna Petrova' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я изменяю флаг 'Customer'
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Anna Petrova' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Manager segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
				| 'Description'  |
				| 'Region 1' |
		И в таблице "List" я выбираю текущую строку
		И Пауза 2
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5



Сценарий: _008010 addition of employees to the segment Region 2 (C) in register
	* Opening register Partner segments content
		И я открываю навигационную ссылку 'e1cib/list/InformationRegister.PartnerSegments'
	* Adding David Romanov to the segment Region 1
		И я нажимаю на кнопку с именем 'FormCreate'
		И Пауза 2
		И я нажимаю кнопку выбора у поля "Segment"
		И Пауза 2
		И в таблице "List" я перехожу к строке:
			| 'Description' |
			| 'Region 1'  |
		И в таблице "List" я выбираю текущую строку
		Тогда открылось окно 'Partner segments content (create) *'
		И я нажимаю кнопку выбора у поля "Partner"
		И Пауза 5
		И в таблице "List" я перехожу к строке:
			| 'Description'  |
			| 'David Romanov' |
		И в таблице "List" я выбираю текущую строку
		И В открытой форме я нажимаю на кнопку с именем "FormWriteAndClose"
		И Пауза 5
		И таблица "List" содержит строки:
			| Segment | Partner |
			| Region 1 | David Romanov |
