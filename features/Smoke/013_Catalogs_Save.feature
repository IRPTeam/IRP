
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Catalogs - Save
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Save item Catalogs "User access groups" (AccessGroups)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccessGroups AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AccessGroups" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccessGroups" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AccessGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AccessGroups" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AccessGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AccessGroups" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AccessGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AccessGroups" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AccessGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AccessGroups" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AccessGroups" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AccessGroups" exception

Scenario: Save item Catalogs "Access key" (AccessKey)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccessKey AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AccessKey" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccessKey" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AccessKey" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AccessKey" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AccessKey" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AccessKey" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AccessKey" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AccessKey" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AccessKey" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AccessKey" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AccessKey" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AccessKey" exception

Scenario: Save item Catalogs "User access profiles" (AccessProfiles)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccessProfiles AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AccessProfiles" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccessProfiles" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AccessProfiles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AccessProfiles" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AccessProfiles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AccessProfiles" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AccessProfiles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AccessProfiles" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AccessProfiles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AccessProfiles" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AccessProfiles" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AccessProfiles" exception

Scenario: Save item group Catalogs "Accounting operations" (AccountingOperations)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccountingOperations AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs AccountingOperations" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs AccountingOperations" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item group Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item group Catalogs AccountingOperations" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item group Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item group Catalogs AccountingOperations" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item group Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemgroup Catalogs AccountingOperations" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item group Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemgroup Catalogs AccountingOperations" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element group Catalogs AccountingOperations" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element group Catalogs AccountingOperations" exception

Scenario: Save item Catalogs "Accounting operations" (AccountingOperations)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccountingOperations AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs AccountingOperations" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccountingOperations" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AccountingOperations" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AccountingOperations" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AccountingOperations" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AccountingOperations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AccountingOperations" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AccountingOperations" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AccountingOperations" exception

Scenario: Save item Catalogs "Accrual and deduction types" (AccrualAndDeductionTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AccrualAndDeductionTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AccrualAndDeductionTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AccrualAndDeductionTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AccrualAndDeductionTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AccrualAndDeductionTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AccrualAndDeductionTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AccrualAndDeductionTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AccrualAndDeductionTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AccrualAndDeductionTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AccrualAndDeductionTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AccrualAndDeductionTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AccrualAndDeductionTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AccrualAndDeductionTypes" exception

Scenario: Save item Catalogs "Additional attribute sets" (AddAttributeAndPropertySets)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AddAttributeAndPropertySets AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AddAttributeAndPropertySets" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AddAttributeAndPropertySets" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AddAttributeAndPropertySets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AddAttributeAndPropertySets" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AddAttributeAndPropertySets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AddAttributeAndPropertySets" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AddAttributeAndPropertySets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AddAttributeAndPropertySets" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AddAttributeAndPropertySets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AddAttributeAndPropertySets" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AddAttributeAndPropertySets" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AddAttributeAndPropertySets" exception

Scenario: Save item Catalogs "Additional attribute values" (AddAttributeAndPropertyValues)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AddAttributeAndPropertyValues AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AddAttributeAndPropertyValues" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AddAttributeAndPropertyValues" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AddAttributeAndPropertyValues" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AddAttributeAndPropertyValues" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AddAttributeAndPropertyValues" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AddAttributeAndPropertyValues" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AddAttributeAndPropertyValues" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AddAttributeAndPropertyValues" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AddAttributeAndPropertyValues" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AddAttributeAndPropertyValues" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AddAttributeAndPropertyValues" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AddAttributeAndPropertyValues" exception

Scenario: Save item Catalogs "Addresses" (Addresses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Addresses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Addresses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Addresses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Addresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Addresses" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Addresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Addresses" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Addresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Addresses" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Addresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Addresses" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Addresses" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Addresses" exception

Scenario: Save item Catalogs "Aging periods" (AgingPeriods)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AgingPeriods AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AgingPeriods" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AgingPeriods" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AgingPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AgingPeriods" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AgingPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AgingPeriods" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AgingPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AgingPeriods" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AgingPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AgingPeriods" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AgingPeriods" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AgingPeriods" exception

Scenario: Save item Catalogs "Partner terms" (Agreements)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Agreements AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Agreements" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Agreements" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Agreements" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Agreements" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Agreements" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Agreements" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Agreements" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Agreements" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Agreements" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Agreements" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Agreements" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Agreements" exception

Scenario: Save item Catalogs "Attached document settings" (AttachedDocumentSettings)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.AttachedDocumentSettings AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs AttachedDocumentSettings" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs AttachedDocumentSettings" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs AttachedDocumentSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs AttachedDocumentSettings" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs AttachedDocumentSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs AttachedDocumentSettings" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs AttachedDocumentSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs AttachedDocumentSettings" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs AttachedDocumentSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs AttachedDocumentSettings" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs AttachedDocumentSettings" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs AttachedDocumentSettings" exception

Scenario: Save item Catalogs "Bank terms" (BankTerms)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.BankTerms AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs BankTerms" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs BankTerms" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs BankTerms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs BankTerms" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs BankTerms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs BankTerms" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs BankTerms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs BankTerms" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs BankTerms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs BankTerms" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs BankTerms" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs BankTerms" exception

Scenario: Save item Catalogs "Batches" (Batches)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Batches AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Batches" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Batches" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Batches" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Batches" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Batches" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Batches" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Batches" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Batches" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Batches" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Batches" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Batches" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Batches" exception

Scenario: Save item Catalogs "Batch keys" (BatchKeys)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.BatchKeys AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs BatchKeys" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs BatchKeys" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs BatchKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs BatchKeys" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs BatchKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs BatchKeys" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs BatchKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs BatchKeys" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs BatchKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs BatchKeys" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs BatchKeys" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs BatchKeys" exception

Scenario: Save item Catalogs "Bill of materials" (BillOfMaterials)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.BillOfMaterials AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs BillOfMaterials" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs BillOfMaterials" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs BillOfMaterials" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs BillOfMaterials" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs BillOfMaterials" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs BillOfMaterials" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs BillOfMaterials" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs BillOfMaterials" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs BillOfMaterials" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs BillOfMaterials" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs BillOfMaterials" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs BillOfMaterials" exception

Scenario: Save item Catalogs "Business units" (BusinessUnits)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.BusinessUnits AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs BusinessUnits" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs BusinessUnits" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs BusinessUnits" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs BusinessUnits" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs BusinessUnits" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs BusinessUnits" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs BusinessUnits" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs BusinessUnits" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs BusinessUnits" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs BusinessUnits" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs BusinessUnits" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs BusinessUnits" exception

Scenario: Save item Catalogs "Cancel/Return reasons" (CancelReturnReasons)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.CancelReturnReasons AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs CancelReturnReasons" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs CancelReturnReasons" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs CancelReturnReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs CancelReturnReasons" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs CancelReturnReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs CancelReturnReasons" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs CancelReturnReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs CancelReturnReasons" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs CancelReturnReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs CancelReturnReasons" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs CancelReturnReasons" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs CancelReturnReasons" exception

Scenario: Save item Catalogs "Cash/Bank accounts" (CashAccounts)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.CashAccounts AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs CashAccounts" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs CashAccounts" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs CashAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs CashAccounts" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs CashAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs CashAccounts" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs CashAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs CashAccounts" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs CashAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs CashAccounts" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs CashAccounts" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs CashAccounts" exception

Scenario: Save item Catalogs "Cash statement statuses" (CashStatementStatuses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.CashStatementStatuses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs CashStatementStatuses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs CashStatementStatuses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs CashStatementStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs CashStatementStatuses" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs CashStatementStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs CashStatementStatuses" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs CashStatementStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs CashStatementStatuses" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs CashStatementStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs CashStatementStatuses" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs CashStatementStatuses" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs CashStatementStatuses" exception

Scenario: Save item Catalogs "Cheque bonds" (ChequeBonds)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ChequeBonds AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ChequeBonds" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ChequeBonds" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ChequeBonds" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ChequeBonds" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ChequeBonds" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ChequeBonds" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ChequeBonds" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ChequeBonds" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ChequeBonds" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ChequeBonds" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ChequeBonds" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ChequeBonds" exception

Scenario: Save item Catalogs "Companies" (Companies)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Companies AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Companies" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Companies" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Companies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Companies" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Companies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Companies" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Companies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Companies" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Companies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Companies" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Companies" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Companies" exception

Scenario: Save item Catalogs "Configuration metadata" (ConfigurationMetadata)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ConfigurationMetadata AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ConfigurationMetadata" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ConfigurationMetadata" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ConfigurationMetadata" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ConfigurationMetadata" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ConfigurationMetadata" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ConfigurationMetadata" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ConfigurationMetadata" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ConfigurationMetadata" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ConfigurationMetadata" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ConfigurationMetadata" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ConfigurationMetadata" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ConfigurationMetadata" exception

Scenario: Save item Catalogs "Countries" (Countries)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Countries AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Countries" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Countries" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Countries" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Countries" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Countries" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Countries" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Countries" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Countries" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Countries" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Countries" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Countries" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Countries" exception

Scenario: Save item Catalogs "Currencies" (Currencies)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Currencies AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Currencies" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Currencies" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Currencies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Currencies" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Currencies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Currencies" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Currencies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Currencies" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Currencies" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Currencies" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Currencies" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Currencies" exception

Scenario: Save item Catalogs "Multi currency movement sets" (CurrencyMovementSets)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.CurrencyMovementSets AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs CurrencyMovementSets" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs CurrencyMovementSets" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs CurrencyMovementSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs CurrencyMovementSets" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs CurrencyMovementSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs CurrencyMovementSets" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs CurrencyMovementSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs CurrencyMovementSets" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs CurrencyMovementSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs CurrencyMovementSets" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs CurrencyMovementSets" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs CurrencyMovementSets" exception

Scenario: Save item Catalogs "Data areas" (DataAreas)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DataAreas AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs DataAreas" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs DataAreas" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs DataAreas" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs DataAreas" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs DataAreas" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs DataAreas" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs DataAreas" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs DataAreas" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs DataAreas" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs DataAreas" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs DataAreas" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs DataAreas" exception

Scenario: Save item Catalogs "Data base status" (DataBaseStatus)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DataBaseStatus AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs DataBaseStatus" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs DataBaseStatus" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs DataBaseStatus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs DataBaseStatus" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs DataBaseStatus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs DataBaseStatus" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs DataBaseStatus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs DataBaseStatus" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs DataBaseStatus" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs DataBaseStatus" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs DataBaseStatus" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs DataBaseStatus" exception

Scenario: Save item group Catalogs "Data mapping items" (DataMappingItems)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DataMappingItems AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs DataMappingItems" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs DataMappingItems" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item group Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item group Catalogs DataMappingItems" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item group Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item group Catalogs DataMappingItems" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item group Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemgroup Catalogs DataMappingItems" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item group Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemgroup Catalogs DataMappingItems" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element group Catalogs DataMappingItems" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element group Catalogs DataMappingItems" exception

Scenario: Save item Catalogs "Data mapping items" (DataMappingItems)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DataMappingItems AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs DataMappingItems" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs DataMappingItems" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs DataMappingItems" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs DataMappingItems" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs DataMappingItems" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs DataMappingItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs DataMappingItems" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs DataMappingItems" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs DataMappingItems" exception

Scenario: Save item Catalogs "Depreciation schedules" (DepreciationSchedules)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.DepreciationSchedules AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs DepreciationSchedules" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs DepreciationSchedules" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs DepreciationSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs DepreciationSchedules" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs DepreciationSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs DepreciationSchedules" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs DepreciationSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs DepreciationSchedules" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs DepreciationSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs DepreciationSchedules" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs DepreciationSchedules" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs DepreciationSchedules" exception

Scenario: Save item Catalogs "Employee positions" (EmployeePositions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.EmployeePositions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs EmployeePositions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs EmployeePositions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs EmployeePositions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs EmployeePositions" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs EmployeePositions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs EmployeePositions" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs EmployeePositions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs EmployeePositions" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs EmployeePositions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs EmployeePositions" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs EmployeePositions" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs EmployeePositions" exception

Scenario: Save item Catalogs "Employee schedule" (EmployeeSchedule)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.EmployeeSchedule AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs EmployeeSchedule" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs EmployeeSchedule" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs EmployeeSchedule" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs EmployeeSchedule" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs EmployeeSchedule" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs EmployeeSchedule" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs EmployeeSchedule" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs EmployeeSchedule" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs EmployeeSchedule" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs EmployeeSchedule" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs EmployeeSchedule" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs EmployeeSchedule" exception

Scenario: Save item Catalogs "Equipment drivers" (EquipmentDrivers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.EquipmentDrivers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs EquipmentDrivers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs EquipmentDrivers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs EquipmentDrivers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs EquipmentDrivers" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs EquipmentDrivers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs EquipmentDrivers" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs EquipmentDrivers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs EquipmentDrivers" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs EquipmentDrivers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs EquipmentDrivers" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs EquipmentDrivers" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs EquipmentDrivers" exception

Scenario: Save item Catalogs "Expense and revenue types" (ExpenseAndRevenueTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExpenseAndRevenueTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ExpenseAndRevenueTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ExpenseAndRevenueTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ExpenseAndRevenueTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ExpenseAndRevenueTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ExpenseAndRevenueTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ExpenseAndRevenueTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ExpenseAndRevenueTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ExpenseAndRevenueTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ExpenseAndRevenueTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ExpenseAndRevenueTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ExpenseAndRevenueTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ExpenseAndRevenueTypes" exception

Scenario: Save item Catalogs "Extensions" (Extensions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Extensions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Extensions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Extensions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Extensions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Extensions" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Extensions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Extensions" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Extensions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Extensions" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Extensions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Extensions" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Extensions" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Extensions" exception

Scenario: Save item group Catalogs "Plugins" (ExternalDataProc)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExternalDataProc AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs ExternalDataProc" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs ExternalDataProc" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item group Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item group Catalogs ExternalDataProc" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item group Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item group Catalogs ExternalDataProc" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item group Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemgroup Catalogs ExternalDataProc" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item group Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemgroup Catalogs ExternalDataProc" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element group Catalogs ExternalDataProc" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element group Catalogs ExternalDataProc" exception

Scenario: Save item Catalogs "Plugins" (ExternalDataProc)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExternalDataProc AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs ExternalDataProc" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ExternalDataProc" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ExternalDataProc" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ExternalDataProc" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ExternalDataProc" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ExternalDataProc" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ExternalDataProc" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ExternalDataProc" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ExternalDataProc" exception

Scenario: Save item group Catalogs "External functions" (ExternalFunctions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExternalFunctions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs ExternalFunctions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs ExternalFunctions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item group Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item group Catalogs ExternalFunctions" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item group Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item group Catalogs ExternalFunctions" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item group Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemgroup Catalogs ExternalFunctions" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item group Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemgroup Catalogs ExternalFunctions" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element group Catalogs ExternalFunctions" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element group Catalogs ExternalFunctions" exception

Scenario: Save item Catalogs "External functions" (ExternalFunctions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ExternalFunctions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs ExternalFunctions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ExternalFunctions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ExternalFunctions" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ExternalFunctions" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ExternalFunctions" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ExternalFunctions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ExternalFunctions" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ExternalFunctions" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ExternalFunctions" exception

Scenario: Save item Catalogs "Files" (Files)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Files AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Files" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Files" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Files" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Files" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Files" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Files" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Files" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Files" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Files" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Files" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Files" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Files" exception

Scenario: Save item Catalogs "File storages info" (FileStoragesInfo)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FileStoragesInfo AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FileStoragesInfo" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FileStoragesInfo" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs FileStoragesInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs FileStoragesInfo" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs FileStoragesInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs FileStoragesInfo" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs FileStoragesInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs FileStoragesInfo" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs FileStoragesInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs FileStoragesInfo" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs FileStoragesInfo" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs FileStoragesInfo" exception

Scenario: Save item Catalogs "File storage volumes" (FileStorageVolumes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FileStorageVolumes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FileStorageVolumes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FileStorageVolumes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs FileStorageVolumes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs FileStorageVolumes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs FileStorageVolumes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs FileStorageVolumes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs FileStorageVolumes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs FileStorageVolumes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs FileStorageVolumes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs FileStorageVolumes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs FileStorageVolumes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs FileStorageVolumes" exception

Scenario: Save item Catalogs "Filling templates" (FillingTemplates)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FillingTemplates AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FillingTemplates" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FillingTemplates" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs FillingTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs FillingTemplates" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs FillingTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs FillingTemplates" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs FillingTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs FillingTemplates" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs FillingTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs FillingTemplates" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs FillingTemplates" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs FillingTemplates" exception

Scenario: Save item Catalogs "Fixed assets" (FixedAssets)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FixedAssets AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FixedAssets" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FixedAssets" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs FixedAssets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs FixedAssets" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs FixedAssets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs FixedAssets" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs FixedAssets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs FixedAssets" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs FixedAssets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs FixedAssets" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs FixedAssets" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs FixedAssets" exception

Scenario: Save item Catalogs "Fixed assets ledger types" (FixedAssetsLedgerTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.FixedAssetsLedgerTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs FixedAssetsLedgerTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs FixedAssetsLedgerTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs FixedAssetsLedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs FixedAssetsLedgerTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs FixedAssetsLedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs FixedAssetsLedgerTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs FixedAssetsLedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs FixedAssetsLedgerTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs FixedAssetsLedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs FixedAssetsLedgerTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs FixedAssetsLedgerTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs FixedAssetsLedgerTypes" exception

Scenario: Save item Catalogs "Hardware" (Hardware)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Hardware AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Hardware" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Hardware" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Hardware" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Hardware" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Hardware" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Hardware" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Hardware" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Hardware" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Hardware" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Hardware" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Hardware" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Hardware" exception

Scenario: Save item Catalogs "Addresses hierarchy" (IDInfoAddresses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.IDInfoAddresses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs IDInfoAddresses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs IDInfoAddresses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs IDInfoAddresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs IDInfoAddresses" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs IDInfoAddresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs IDInfoAddresses" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs IDInfoAddresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs IDInfoAddresses" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs IDInfoAddresses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs IDInfoAddresses" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs IDInfoAddresses" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs IDInfoAddresses" exception

Scenario: Save item Catalogs "Contact info sets" (IDInfoSets)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.IDInfoSets AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs IDInfoSets" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs IDInfoSets" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs IDInfoSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs IDInfoSets" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs IDInfoSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs IDInfoSets" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs IDInfoSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs IDInfoSets" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs IDInfoSets" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs IDInfoSets" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs IDInfoSets" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs IDInfoSets" exception

Scenario: Save item Catalogs "Incoterms" (Incoterms)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Incoterms AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Incoterms" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Incoterms" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Incoterms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Incoterms" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Incoterms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Incoterms" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Incoterms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Incoterms" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Incoterms" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Incoterms" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Incoterms" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Incoterms" exception

Scenario: Save item Catalogs "Integration settings" (IntegrationSettings)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.IntegrationSettings AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs IntegrationSettings" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs IntegrationSettings" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs IntegrationSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs IntegrationSettings" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs IntegrationSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs IntegrationSettings" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs IntegrationSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs IntegrationSettings" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs IntegrationSettings" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs IntegrationSettings" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs IntegrationSettings" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs IntegrationSettings" exception

Scenario: Save item Catalogs "UI groups" (InterfaceGroups)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.InterfaceGroups AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs InterfaceGroups" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs InterfaceGroups" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs InterfaceGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs InterfaceGroups" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs InterfaceGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs InterfaceGroups" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs InterfaceGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs InterfaceGroups" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs InterfaceGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs InterfaceGroups" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs InterfaceGroups" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs InterfaceGroups" exception

Scenario: Save item Catalogs "Item keys" (ItemKeys)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ItemKeys AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ItemKeys" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ItemKeys" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ItemKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ItemKeys" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ItemKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ItemKeys" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ItemKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ItemKeys" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ItemKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ItemKeys" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ItemKeys" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ItemKeys" exception

Scenario: Save item Catalogs "Items" (Items)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Items AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Items" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Items" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Items" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Items" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Items" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Items" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Items" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Items" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Items" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Items" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Items" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Items" exception

Scenario: Save item Catalogs "Item segments" (ItemSegments)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ItemSegments AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ItemSegments" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ItemSegments" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ItemSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ItemSegments" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ItemSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ItemSegments" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ItemSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ItemSegments" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ItemSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ItemSegments" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ItemSegments" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ItemSegments" exception

Scenario: Save item group Catalogs "Item types" (ItemTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ItemTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs ItemTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs ItemTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item group Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item group Catalogs ItemTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item group Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item group Catalogs ItemTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item group Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemgroup Catalogs ItemTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item group Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemgroup Catalogs ItemTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element group Catalogs ItemTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element group Catalogs ItemTypes" exception

Scenario: Save item Catalogs "Item types" (ItemTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ItemTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs ItemTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ItemTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ItemTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ItemTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ItemTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ItemTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ItemTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ItemTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ItemTypes" exception

Scenario: Save item Catalogs "Ledger types" (LedgerTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.LedgerTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs LedgerTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs LedgerTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs LedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs LedgerTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs LedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs LedgerTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs LedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs LedgerTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs LedgerTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs LedgerTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs LedgerTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs LedgerTypes" exception

Scenario: Save item Catalogs "Ledger type variants" (LedgerTypeVariants)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.LedgerTypeVariants AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs LedgerTypeVariants" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs LedgerTypeVariants" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs LedgerTypeVariants" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs LedgerTypeVariants" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs LedgerTypeVariants" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs LedgerTypeVariants" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs LedgerTypeVariants" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs LedgerTypeVariants" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs LedgerTypeVariants" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs LedgerTypeVariants" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs LedgerTypeVariants" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs LedgerTypeVariants" exception

Scenario: Save item Catalogs "Legal name contracts" (LegalNameContracts)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.LegalNameContracts AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs LegalNameContracts" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs LegalNameContracts" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs LegalNameContracts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs LegalNameContracts" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs LegalNameContracts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs LegalNameContracts" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs LegalNameContracts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs LegalNameContracts" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs LegalNameContracts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs LegalNameContracts" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs LegalNameContracts" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs LegalNameContracts" exception

Scenario: Save item Catalogs "Lock data modification reasons" (LockDataModificationReasons)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.LockDataModificationReasons AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs LockDataModificationReasons" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs LockDataModificationReasons" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs LockDataModificationReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs LockDataModificationReasons" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs LockDataModificationReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs LockDataModificationReasons" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs LockDataModificationReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs LockDataModificationReasons" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs LockDataModificationReasons" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs LockDataModificationReasons" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs LockDataModificationReasons" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs LockDataModificationReasons" exception

Scenario: Save item Catalogs "Movement rules" (MovementRules)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.MovementRules AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs MovementRules" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs MovementRules" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs MovementRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs MovementRules" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs MovementRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs MovementRules" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs MovementRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs MovementRules" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs MovementRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs MovementRules" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs MovementRules" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs MovementRules" exception

Scenario: Save item Catalogs "Object access keys" (ObjectAccessKeys)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ObjectAccessKeys AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ObjectAccessKeys" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ObjectAccessKeys" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ObjectAccessKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ObjectAccessKeys" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ObjectAccessKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ObjectAccessKeys" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ObjectAccessKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ObjectAccessKeys" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ObjectAccessKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ObjectAccessKeys" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ObjectAccessKeys" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ObjectAccessKeys" exception

Scenario: Save item group Catalogs "Objects statuses" (ObjectStatuses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ObjectStatuses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs ObjectStatuses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs ObjectStatuses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item group Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item group Catalogs ObjectStatuses" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item group Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item group Catalogs ObjectStatuses" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item group Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemgroup Catalogs ObjectStatuses" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item group Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemgroup Catalogs ObjectStatuses" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element group Catalogs ObjectStatuses" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element group Catalogs ObjectStatuses" exception

Scenario: Save item Catalogs "Objects statuses" (ObjectStatuses)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ObjectStatuses AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs ObjectStatuses" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ObjectStatuses" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ObjectStatuses" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ObjectStatuses" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ObjectStatuses" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ObjectStatuses" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ObjectStatuses" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ObjectStatuses" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ObjectStatuses" exception

Scenario: Save item Catalogs "Partner items" (PartnerItems)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PartnerItems AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PartnerItems" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PartnerItems" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PartnerItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PartnerItems" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PartnerItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PartnerItems" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PartnerItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PartnerItems" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PartnerItems" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PartnerItems" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PartnerItems" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PartnerItems" exception

Scenario: Save item Catalogs "Partners" (Partners)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Partners AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Partners" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Partners" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Partners" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Partners" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Partners" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Partners" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Partners" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Partners" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Partners" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Partners" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Partners" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Partners" exception

Scenario: Save item Catalogs "Partners bank accounts" (PartnersBankAccounts)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PartnersBankAccounts AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PartnersBankAccounts" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PartnersBankAccounts" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PartnersBankAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PartnersBankAccounts" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PartnersBankAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PartnersBankAccounts" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PartnersBankAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PartnersBankAccounts" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PartnersBankAccounts" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PartnersBankAccounts" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PartnersBankAccounts" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PartnersBankAccounts" exception

Scenario: Save item Catalogs "Partner segments" (PartnerSegments)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PartnerSegments AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PartnerSegments" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PartnerSegments" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PartnerSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PartnerSegments" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PartnerSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PartnerSegments" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PartnerSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PartnerSegments" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PartnerSegments" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PartnerSegments" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PartnerSegments" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PartnerSegments" exception

Scenario: Save item Catalogs "Payment terms" (PaymentSchedules)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PaymentSchedules AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PaymentSchedules" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PaymentSchedules" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PaymentSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PaymentSchedules" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PaymentSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PaymentSchedules" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PaymentSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PaymentSchedules" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PaymentSchedules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PaymentSchedules" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PaymentSchedules" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PaymentSchedules" exception

Scenario: Save item Catalogs "Payment terminals" (PaymentTerminals)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PaymentTerminals AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PaymentTerminals" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PaymentTerminals" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PaymentTerminals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PaymentTerminals" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PaymentTerminals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PaymentTerminals" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PaymentTerminals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PaymentTerminals" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PaymentTerminals" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PaymentTerminals" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PaymentTerminals" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PaymentTerminals" exception

Scenario: Save item Catalogs "Payment types" (PaymentTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PaymentTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PaymentTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PaymentTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PaymentTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PaymentTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PaymentTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PaymentTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PaymentTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PaymentTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PaymentTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PaymentTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PaymentTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PaymentTypes" exception

Scenario: Save item Catalogs "Planning periods" (PlanningPeriods)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PlanningPeriods AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PlanningPeriods" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PlanningPeriods" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PlanningPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PlanningPeriods" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PlanningPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PlanningPeriods" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PlanningPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PlanningPeriods" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PlanningPeriods" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PlanningPeriods" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PlanningPeriods" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PlanningPeriods" exception

Scenario: Save item Catalogs "Price keys" (PriceKeys)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PriceKeys AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PriceKeys" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PriceKeys" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PriceKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PriceKeys" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PriceKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PriceKeys" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PriceKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PriceKeys" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PriceKeys" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PriceKeys" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PriceKeys" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PriceKeys" exception

Scenario: Save item Catalogs "Price types" (PriceTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PriceTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PriceTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PriceTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PriceTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PriceTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PriceTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PriceTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PriceTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PriceTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PriceTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PriceTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PriceTypes" exception
//				If current form name is "ErrorWindow" Then
//					Then I raise "Failed to Save and close an existing element Catalogs PriceTypes" exception

Scenario: Save item Catalogs "Print info" (PrintInfo)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PrintInfo AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PrintInfo" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PrintInfo" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PrintInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PrintInfo" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PrintInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PrintInfo" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PrintInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PrintInfo" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PrintInfo" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PrintInfo" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PrintInfo" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PrintInfo" exception

Scenario: Save item Catalogs "Print templates" (PrintTemplates)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.PrintTemplates AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs PrintTemplates" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs PrintTemplates" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs PrintTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs PrintTemplates" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs PrintTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs PrintTemplates" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs PrintTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs PrintTemplates" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs PrintTemplates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs PrintTemplates" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs PrintTemplates" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs PrintTemplates" exception

Scenario: Save item Catalogs "Projects" (Projects)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Projects AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Projects" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Projects" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Projects" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Projects" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Projects" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Projects" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Projects" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Projects" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Projects" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Projects" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Projects" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Projects" exception

Scenario: Save item Catalogs "Report options" (ReportOptions)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.ReportOptions AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs ReportOptions" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs ReportOptions" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs ReportOptions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs ReportOptions" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs ReportOptions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs ReportOptions" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs ReportOptions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs ReportOptions" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs ReportOptions" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs ReportOptions" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs ReportOptions" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs ReportOptions" exception

Scenario: Save item Catalogs "Retail customers" (RetailCustomers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.RetailCustomers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs RetailCustomers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs RetailCustomers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs RetailCustomers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs RetailCustomers" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs RetailCustomers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs RetailCustomers" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs RetailCustomers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs RetailCustomers" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs RetailCustomers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs RetailCustomers" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs RetailCustomers" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs RetailCustomers" exception

Scenario: Save item Catalogs "Row IDs" (RowIDs)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.RowIDs AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs RowIDs" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs RowIDs" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs RowIDs" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs RowIDs" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs RowIDs" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs RowIDs" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs RowIDs" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs RowIDs" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs RowIDs" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs RowIDs" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs RowIDs" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs RowIDs" exception

Scenario: Save item Catalogs "Salary calculation type" (SalaryCalculationType)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SalaryCalculationType AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SalaryCalculationType" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SalaryCalculationType" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs SalaryCalculationType" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs SalaryCalculationType" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs SalaryCalculationType" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs SalaryCalculationType" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs SalaryCalculationType" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs SalaryCalculationType" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs SalaryCalculationType" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs SalaryCalculationType" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs SalaryCalculationType" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs SalaryCalculationType" exception

Scenario: Save item Catalogs "Item serial/lot numbers" (SerialLotNumbers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SerialLotNumbers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SerialLotNumbers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SerialLotNumbers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs SerialLotNumbers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs SerialLotNumbers" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs SerialLotNumbers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs SerialLotNumbers" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs SerialLotNumbers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs SerialLotNumbers" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs SerialLotNumbers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs SerialLotNumbers" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs SerialLotNumbers" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs SerialLotNumbers" exception

Scenario: Save item Catalogs "Source of origins" (SourceOfOrigins)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SourceOfOrigins AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SourceOfOrigins" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SourceOfOrigins" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs SourceOfOrigins" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs SourceOfOrigins" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs SourceOfOrigins" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs SourceOfOrigins" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs SourceOfOrigins" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs SourceOfOrigins" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs SourceOfOrigins" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs SourceOfOrigins" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs SourceOfOrigins" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs SourceOfOrigins" exception

Scenario: Save item Catalogs "Special offer rules" (SpecialOfferRules)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SpecialOfferRules AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SpecialOfferRules" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SpecialOfferRules" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs SpecialOfferRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs SpecialOfferRules" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs SpecialOfferRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs SpecialOfferRules" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs SpecialOfferRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs SpecialOfferRules" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs SpecialOfferRules" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs SpecialOfferRules" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs SpecialOfferRules" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs SpecialOfferRules" exception

Scenario: Save item group Catalogs "Special offers" (SpecialOffers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SpecialOffers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item group Catalogs SpecialOffers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item group Catalogs SpecialOffers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item group Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item group Catalogs SpecialOffers" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item group Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item group Catalogs SpecialOffers" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item group Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemgroup Catalogs SpecialOffers" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item group Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemgroup Catalogs SpecialOffers" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element group Catalogs SpecialOffers" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element group Catalogs SpecialOffers" exception

Scenario: Save item Catalogs "Special offers" (SpecialOffers)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SpecialOffers AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined And Not CurrentDataSource.IsFolder";'	|
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
				Then I raise "Could not open existing item Catalogs SpecialOffers" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SpecialOffers" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs SpecialOffers" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs SpecialOffers" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs SpecialOffers" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs SpecialOffers" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs SpecialOffers" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs SpecialOffers" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs SpecialOffers" exception

Scenario: Save item Catalogs "Special offer types" (SpecialOfferTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.SpecialOfferTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs SpecialOfferTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs SpecialOfferTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs SpecialOfferTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs SpecialOfferTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs SpecialOfferTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs SpecialOfferTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs SpecialOfferTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs SpecialOfferTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs SpecialOfferTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs SpecialOfferTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs SpecialOfferTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs SpecialOfferTypes" exception

Scenario: Save item Catalogs "Specifications" (Specifications)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Specifications AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Specifications" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Specifications" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Specifications" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Specifications" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Specifications" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Specifications" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Specifications" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Specifications" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Specifications" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Specifications" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Specifications" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Specifications" exception

Scenario: Save item Catalogs "Stores" (Stores)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Stores AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Stores" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Stores" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Stores" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Stores" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Stores" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Stores" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Stores" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Stores" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Stores" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Stores" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Stores" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Stores" exception

Scenario: Save item Catalogs "Tax additional analytics" (TaxAnalytics)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.TaxAnalytics AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs TaxAnalytics" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs TaxAnalytics" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs TaxAnalytics" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs TaxAnalytics" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs TaxAnalytics" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs TaxAnalytics" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs TaxAnalytics" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs TaxAnalytics" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs TaxAnalytics" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs TaxAnalytics" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs TaxAnalytics" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs TaxAnalytics" exception

Scenario: Save item Catalogs "Tax types" (Taxes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Taxes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Taxes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Taxes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Taxes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Taxes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Taxes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Taxes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Taxes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Taxes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Taxes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Taxes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Taxes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Taxes" exception

Scenario: Save item Catalogs "Tax rates" (TaxRates)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.TaxRates AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs TaxRates" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs TaxRates" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs TaxRates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs TaxRates" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs TaxRates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs TaxRates" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs TaxRates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs TaxRates" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs TaxRates" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs TaxRates" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs TaxRates" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs TaxRates" exception



Scenario: Save item Catalogs "Item units" (Units)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Units AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs UnitsOfMeasurement" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs UnitsOfMeasurement" exception
			And I save form header as 'ЗаголовокФормы' variable


		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Units" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Units" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Units" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Units" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Units" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Units" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Units" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Units" exception

Scenario: Save item Catalogs "Units of measurement" (UnitsOfMeasurement)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.UnitsOfMeasurement AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs UnitsOfMeasurement" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs UnitsOfMeasurement" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs UnitsOfMeasurement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs UnitsOfMeasurement" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs UnitsOfMeasurement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs UnitsOfMeasurement" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs UnitsOfMeasurement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs UnitsOfMeasurement" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs UnitsOfMeasurement" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs UnitsOfMeasurement" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs UnitsOfMeasurement" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs UnitsOfMeasurement" exception

Scenario: Save item Catalogs "User groups" (UserGroups)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.UserGroups AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs UserGroups" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs UserGroups" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs UserGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs UserGroups" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs UserGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs UserGroups" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs UserGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs UserGroups" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs UserGroups" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs UserGroups" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs UserGroups" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs UserGroups" exception

Scenario: Save item Catalogs "Users" (Users)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Users AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Users" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Users" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Users" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Users" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Users" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Users" exception		


Scenario: Save item Catalogs "Vehicles" (Vehicles)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Vehicles AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Vehicles" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Vehicles" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Vehicles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Vehicles" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Vehicles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Vehicles" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Vehicles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Vehicles" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Vehicles" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Vehicles" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Vehicles" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Vehicles" exception

Scenario: Save item Catalogs "Vehicle types" (VehicleTypes)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.VehicleTypes AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs VehicleTypes" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs VehicleTypes" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs VehicleTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs VehicleTypes" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs VehicleTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs VehicleTypes" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs VehicleTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs VehicleTypes" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs VehicleTypes" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs VehicleTypes" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs VehicleTypes" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs VehicleTypes" exception

Scenario: Save item Catalogs "Workstations" (Workstations)

	* Search for a link to an existing item
		And I execute 1C:Enterprise script at server 
			| 'Query = Новый Query;'								|
			| 'Query.Text = "SELECT TOP 1 CurrentDataSource.Ref AS Ref FROM Catalog.Workstations AS CurrentDataSource WHERE Not CurrentDataSource.DeletionMark And Not CurrentDataSource.Predefined";'	|
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
				Then I raise "Could not open existing item Catalogs Workstations" exception
			If current form name is "ErrorWindow" Then
				Then I raise "Could not open existing item Catalogs Workstations" exception
			And I save form header as 'ЗаголовокФормы' variable

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Workstations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Workstations" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Workstations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Workstations" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Workstations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Workstations" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Workstations" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Workstations" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Workstations" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Workstations" exception

Scenario: Save item Catalogs "Service exchange history" (Unit_ServiceExchangeHistory)

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

		* Save an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWrite' attribute is present on the form Then
				And I click the button named 'FormWrite'
				If the warning is displayed then
					Then I raise "Failed to save an existing item Catalogs Unit_ServiceExchangeHistory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to save an existing item Catalogs Unit_ServiceExchangeHistory" exception

		* Reread an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormReread' attribute is present on the form Then
				And I click the button named 'FormReread'
				If the warning is displayed then
					Then I raise "Failed to Reread an existing item Catalogs Unit_ServiceExchangeHistory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Reread an existing item Catalogs Unit_ServiceExchangeHistory" exception

		* Mark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened'
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Mark to delete an existing item Catalogs Unit_ServiceExchangeHistory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Mark to delete an existing itemCatalogs Unit_ServiceExchangeHistory" exception

		* Unmark to delete an existing item
			Then '$ЗаголовокФормы$' window is opened
			If 'FormSetDeletionMark' attribute is present on the form Then
				And I click the button named 'FormSetDeletionMark'
				If '1C:Enterprise' window is opened then
					And I click the button named 'Button0'
				If the warning is displayed then
					Then I raise "Failed to Unmark to delete an existing item Catalogs Unit_ServiceExchangeHistory" exception
				If current form name is "ErrorWindow" Then
					Then I raise "Failed to Unmark to delete an existing itemCatalogs Unit_ServiceExchangeHistory" exception

		* Save and close an existing element
			Then '$ЗаголовокФормы$' window is opened
			If 'FormWriteAndClose' attribute is present on the form Then
				And I click the button named 'FormWriteAndClose'
				If the warning is displayed then
					Then I raise "Failed to Save and close an existing element Catalogs Unit_ServiceExchangeHistory" exception
				// If current form name is "ErrorWindow" Then
				// 	Then I raise "Failed to Save and close an existing element Catalogs Unit_ServiceExchangeHistory" exception
