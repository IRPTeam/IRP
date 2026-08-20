#language: en
@tree
@Positive
@Accounting


Feature: accountant automated workplace

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _099200 preparation (accountant automated workplace)
	When set True value to the constant
	When set True value to the constant Use accounting
	* Load info (TestDB)
		When Create catalog Companies objects (test data base)
		When Create catalog ConfigurationMetadata objects (test data base)
		When Create catalog Partners objects (test data base)
		When Create catalog Agreements objects (test data base)
		When Create catalog Currencies objects (test data base)
	* Set important attributes for Purchase invoice
		// the flag is set at server: hierarchy navigation in the configuration metadata
		// list is unreliable when the catalog holds items outside the predefined groups
		And I execute 1C:Enterprise script at server
			| 'Q = New Query("SELECT Ref FROM Catalog.ConfigurationMetadata WHERE ObjectFullName = ""Document.PurchaseInvoice"""); S = Q.Execute().Select(); While S.Next() Do Obj = S.Ref.GetObject(); If Obj.ImportantAttributes.FindRows(New Structure("AttributeName", "Comment")).Count() = 0 Then R = Obj.ImportantAttributes.Add(); R.AttributeName = "Comment"; Obj.Write(); EndIf; EndDo;' |
	* Enable data history for Purchase invoice
		Given I open hyperlink "e1cib/app/DataProcessor.DataHistory"
		And I go to line in "MetadataTree" table
			| 'Name'      |
			| 'Documents' |
		And I activate "Name" field in "MetadataTree" table
		And I expand current line in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Name'            |
			| 'PurchaseInvoice' |
		And I set "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And in the table "MetadataTree" I click "Save settings" button
		And in the table "MetadataTree" I click "Update data history" button
	And I close all client application windows


Scenario: _0992001 check preparation
	When check preparation


Scenario: _099201 check accountant workplace opens with saved settings
	And I close all client application windows
	* First opening saves the form settings
		Given I open hyperlink "e1cib/app/DataProcessor.AccountantAutomatedWorkplace"
		And I click Choice button of the field named "Period"
		Then "Select period" window is opened
		And I input "01.01.2023" text in the field named "DateBegin"
		And I input "31.12.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I close current window
	* Second opening loads the saved settings
		Given I open hyperlink "e1cib/app/DataProcessor.AccountantAutomatedWorkplace"
		Then the form attribute named "Period" became equal to "01.01.2023 - 31.12.2025"
	And I close all client application windows


Scenario: _099202 check important attributes are marked in version history
	And I close all client application windows
	* Write the document to record the first history version
		// CheckImportantAttributesInVersion skips version 1, so two writes are needed
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '7'      |
		And I select current line in "List" table
		And I click "Save" button
	* Change an important attribute of a document
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click the hyperlink named "Comment"
		And I input "important change" text in the field named "Text"
		And I click "OK" button
		And I click the button named "FormWrite"
		And I close current window
	* Version history shows the new version
		Given I open hyperlink "e1cib/app/DataProcessor.AccountantAutomatedWorkplace"
		And I click Choice button of the field named "DocumentType"
		And I click "Check all" button
		And I click "Ok" button
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I select "All" exact value from the drop-down list named "FilesType"
		And I click "Find" button
		And I go to line in "DocumentList" table
			| 'Document'                                     |
			| 'Purchase invoice 7 dated 05.12.2023 12:00:00' |
		And "HistoryVersionTable" table contains lines
			| 'Version number' | 'Data change type' |
			| '2'              | 'Change'           |
	* The version is flagged as important
		// IsImportant drives only the row text color in conditional appearance,
		// so it cannot be asserted through the interface - checked at server
		And I execute 1C:Enterprise script at server
			| 'Ref = Documents.PurchaseInvoice.FindByNumber("7"); Important = CatConfigurationMetadataServer.GetCustomizedAttributesByObject(Ref).Important.Get(""); If Important = Undefined Or Important.Find("Comment") = Undefined Then Raise "Comment is not registered as an important attribute" EndIf;' |
	And I close all client application windows


Scenario: _099203 check chat message is sent for a document
	And I close all client application windows
	* Send a message for the selected document
		Given I open hyperlink "e1cib/app/DataProcessor.AccountantAutomatedWorkplace"
		And I click Choice button of the field named "DocumentType"
		And I click "Check all" button
		And I click "Ok" button
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I select "All" exact value from the drop-down list named "FilesType"
		And I click "Find" button
		And I go to line in "DocumentList" table
			| 'Document'                                     |
			| 'Purchase invoice 7 dated 05.12.2023 12:00:00' |
		And I input "test message from autotest" text in the field named "NewMessage"
		And I click the button named "SendMessage"
		// Chat is an HTML field - template assert on it wedges the test client, the sent flag is NewMessage being cleared
		Then the form attribute named "NewMessage" became equal to ""
	And I close all client application windows


Scenario: _099204 check accountant workplace settings form
	And I close all client application windows
	* Open the settings form and save it
		Given I open hyperlink "e1cib/app/DataProcessor.AccountantAutomatedWorkplace"
		And I click the button named "OpenSettings"
		Then "Settings" window is opened
		And I click the button named "FormSave"
		Then "Accountant automated workplace" window is opened
	And I close all client application windows


Scenario: _099205 check file preview and journal entry refresh
	And I close all client application windows
	* Find a document with files
		Given I open hyperlink "e1cib/app/DataProcessor.AccountantAutomatedWorkplace"
		And I click Choice button of the field named "DocumentType"
		And I click "Check all" button
		And I click "Ok" button
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I select "With files" exact value from the drop-down list named "FilesType"
		And I click "Find" button
		And I go to line in "DocumentList" table
			| 'Document'                                  |
			| 'Sales invoice 3 dated 30.03.2023 12:23:56' |
	* Switch the file preview on and check the file list
		And I set checkbox named "ShowFilePreview"
		And "FileTable" table contains lines
			| 'Name'                |
			| 'Test pdf 1 page.pdf' |
		And I go to line in "FileTable" table
			| 'Name'                |
			| 'Test pdf 1 page.pdf' |
	* Refresh the journal entry of the current document and open it
		And I click the button named "FormRefreshJE"
		And I click the button named "OpenJE"
		Then "JE Sales invoice * dated*" window is opened
		And I close current window
	And I close all client application windows

Scenario: _099206 check document lock and unlock from the workplace
	And I close all client application windows
	* Find the document
		Given I open hyperlink "e1cib/app/DataProcessor.AccountantAutomatedWorkplace"
		And I click Choice button of the field named "DocumentType"
		And I click "Check all" button
		And I click "Ok" button
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I select "All" exact value from the drop-down list named "FilesType"
		And I click "Find" button
		And I go to line in "DocumentList" table
			| 'Document'                                     |
			| 'Purchase invoice 7 dated 05.12.2023 12:00:00' |
	* Lock the document from the workplace
		// the Locked column is an icon and is not readable through the table data,
		// so the lock state is asserted at server
		And I click the button named "DocumentListLock"
		And I execute 1C:Enterprise script at server
			| 'If Not AuditLockPrivileged.LockIsSet(Documents.PurchaseInvoice.FindByNumber("7")) Then Raise "The workplace Lock command did not set the audit lock" EndIf;' |
	* Unlock the document from the workplace
		And I go to line in "DocumentList" table
			| 'Document'                                     |
			| 'Purchase invoice 7 dated 05.12.2023 12:00:00' |
		And I click the button named "DocumentListUnlock"
		And I execute 1C:Enterprise script at server
			| 'If AuditLockPrivileged.LockIsSet(Documents.PurchaseInvoice.FindByNumber("7")) Then Raise "The workplace Unlock command did not remove the audit lock" EndIf;' |
	And I close all client application windows
