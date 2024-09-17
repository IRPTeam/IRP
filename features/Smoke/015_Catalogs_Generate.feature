
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Catalogs - Generate
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Generate item Catalogs "RMQ event handlers (IAS)" (ОбработчикиСобытийRMQ)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ОбработчикиСобытийRMQ AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Catalogs ОбработчикиСобытийRMQ" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ОбработчикиСобытийRMQ" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Generate Catalogs ПодпискиНаОчередиСообщений
			Then '$ЗаголовокФормы$' window is opened
			If 'ФормаСправочникПодпискиНаОчередиСообщенийСоздатьНаОсновании' attribute is present on the form Then 
				And I click the button named 'ФормаСправочникПодпискиНаОчередиСообщенийСоздатьНаОсновании'
				If the warning is displayed then
					Then I raise "Failed to Generate Catalogs ПодпискиНаОчередиСообщений based on Catalogs ОбработчикиСобытийRMQ" exception 
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Generate Catalogs ПодпискиНаОчередиСообщений based on Catalogs ОбработчикиСобытийRMQ" exception
				Then '* (создание)' window is opened
				And I close '* (создание)'  window

Scenario: Generate item Catalogs "Service exchange history" (Unit_ServiceExchangeHistory)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Unit_ServiceExchangeHistory AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
			| 'QueryResult = Query.Execute();'						|
			| 'Selection = QueryResult.Select();'					|
			| 'While Selection.Next() Do'							|
			| 'Объект.ЗначениеНаСервере = GetURL(Selection.Ref);'	|
			| 'EndDo;'												|
		And I save 'Объект.ЗначениеНаСервере' in 'НавигационнаяСсылка' variable 

	If 'ValueIsFilled($НавигационнаяСсылка$)' then

		* Open form of an existing item
			Given I open hyperlink '$НавигационнаяСсылка$'
			If the warning is displayed then
				Then I raise "Could not open existing item Catalogs Unit_ServiceExchangeHistory" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Unit_ServiceExchangeHistory" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Generate Catalogs Unit_MockServiceData
			Then '$ЗаголовокФормы$' window is opened
			If 'ФормаСправочникUnit_MockServiceDataСоздатьНаОсновании' attribute is present on the form Then 
				And I click the button named 'ФормаСправочникUnit_MockServiceDataСоздатьНаОсновании'
				If the warning is displayed then
					Then I raise "Failed to Generate Catalogs Unit_MockServiceData based on Catalogs Unit_ServiceExchangeHistory" exception 
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Generate Catalogs Unit_MockServiceData based on Catalogs Unit_ServiceExchangeHistory" exception
				Then '* (создание)' window is opened
				And I close '* (создание)'  window
