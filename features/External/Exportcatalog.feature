﻿
#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: create a catalog element with the name Test
	And Delay 2
	And I click the button named "FormCreate"
	And Delay 2
	And I click Open button of the field named "Description_en"
	And I input "Test ENG" text in the field named "Description_en"
	And I input "Test TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click the button named "FormWrite"
	And Delay 5


Scenario: create setting to download the course (Forex Seling)
	* Creating a setting to download the Forex Seling course (tcmb.gov.tr)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Forex Seling" text in "Description" field
		And I input "ForexSeling" text in "Unique ID" field
		And I click "Save" button
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'          |
			| 'ExternalTCMBGovTr'    |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 10

Scenario: Create catalog Users and AccessProfiles objects (LimitedAccess)

	And I check or create catalog "AccessProfiles" objects:
		| 'Ref'                                                                    | 'DeletionMark' | 'Code' | 'Author'                                                        | 'Description_en'                     | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'SourceNodeID' | 'Editor'                                                        | 'CreateDate'          | 'ModifyDate'          |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'False'        | 1      | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | 'Unit profile'                       | ''                 | ''               | ''               | ''             | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | '10.01.2024 20:45:01' | '11.01.2024 13:11:43' |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' | 'False'        | 2      | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | 'AccumulationRegisters R2001T Sales' | ''                 | ''               | ''               | ''             | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | '11.01.2024 11:27:42' | '11.01.2024 13:22:21' |

	And I refill object tabular section "Roles":
		| 'Ref'                                                                    | 'Role'                               | 'Configuration' |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'BasicRole'                          | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'RunThinClient'                      | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_Accounting'               | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_Inventory'                | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_Manufacturing'            | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_MasterData'               | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_PurchaseAP'               | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_Reports'                  | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_Retail'                   | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_Salary'                   | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'Subsystem_SalesAR'                  | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'SubsystemTreasury'                  | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'TemplateAccumulationRegisters'      | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'TemplateCatalogs'                   | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'TemplateDocument'                   | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'TemplateInformationRegisters'       | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'UseAllFunctionsMode'                | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7a0d8de1a1c04c611ee1a4d84e42191' | 'TemplateChartOfCharacteristicTypes' | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' | 'BasicRole'                          | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' | 'RunThickClient'                     | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' | 'RunThinClient'                      | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' | 'TemplateCatalogs'                   | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' | 'UseAllFunctionsMode'                | 'IRP'           |
		| 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' | 'AccumulationRegisters_R2001T_Sales' | 'IRP'           |

	Given I open hyperlink "e1cib/list/Catalog.Users"	
	If "List" table does not contain lines Then
		| 'Description'   |
		| 'LimitedAccess' |
		| 'LimitedAccessRegisters' |
		And I check or create catalog "Users" objects:
			| 'Ref'                                                           | 'DeletionMark' | 'Code' | 'Description'               | 'InfobaseUserID'                       | 'Partner' | 'LocalizationCode' | 'ShowInList' | 'UserGroup' | 'InterfaceLocalizationCode' | 'FormScaleVariant' | 'Disable' | 'ChangePasswordOnNextLogin' | 'TimeZone' | 'UserID' | 'Description_en'            | 'Description_hash' | 'Description_ru' | 'Description_tr' |
			| 'e1cib/data/Catalog.Users?ref=b7a0d8de1a1c04c611ee1a4d84e42192' | 'False'        | 1      | 'LimitedAccess'             | '34ea67b1-2505-405f-8ca6-3ad54becf04f' | ''        | 'en'               | 'False'      | ''          | 'en'                        | ''                 | 'False'   | 'False'                     | ''         | ''       | 'LimitedAccess'             | ''                 | ''               | ''               |
			| 'e1cib/data/Catalog.Users?ref=b7a0d8de1a1c04c611ee1a4d84e42193' | 'False'        | 3      | 'LimitedAccessRegisters'    | '34ea67b1-2505-405f-8ca6-3ad54becf05f' | ''        | 'en'               | 'False'      | ''          | 'en'                        | ''                 | 'False'   | 'False'                     | ''         | ''       | 'LimitedAccessRegisters'    | ''                 | ''               | ''               |
			| 'e1cib/data/Catalog.Users?ref=b7a0d8de1a1c04c611ee1a4d84e42194' | 'False'        | 4      | 'LARegAccessDeny'           | '34ea67b1-2505-405f-8ca6-3ad54becf06f' | ''        | 'en'               | 'False'      | ''          | 'en'                        | ''                 | 'False'   | 'False'                     | ''         | ''       | 'LARegAccessDeny'           | ''                 | ''               | ''               |

Scenario: Create catalog AccessGroups objects (LimitedAccessRegisters)

	And I check or create catalog "AccessGroups" objects:
		| 'Ref'                                                                  | 'DeletionMark' | 'Code' | 'Author'                                                        | 'Description_en'                                   | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'SourceNodeID' | 'Editor'                                                        | 'CreateDate'          | 'ModifyDate'          | 'OnlyRegisters' |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68' | 'False'        | 2      | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | 'AccumulationRegisters R2001T Sales'               | ''                 | ''               | ''               | ''             | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | '11.01.2024 12:07:09' | '11.01.2024 12:15:39' | 'True'          |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d' | 'False'        | 3      | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | 'AccumulationRegisters R2001T Sales - Access Deny' | ''                 | ''               | ''               | ''             | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | '11.01.2024 13:00:16' | '11.01.2024 13:00:25' | 'True'          |

	And I refill object tabular section "Profiles":
		| 'Ref'                                                                  | 'Profile'                                                                |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68' | 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d' | 'e1cib/data/Catalog.AccessProfiles?ref=b7b4b80c227e00a211eeb0635de1ba67' |

	And I refill object tabular section "Users":
		| 'Ref'                                                                  | 'User'                                                          |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68' | 'e1cib/data/Catalog.Users?ref=b7a0d8de1a1c04c611ee1a4d84e42193' |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d' | 'e1cib/data/Catalog.Users?ref=b7a0d8de1a1c04c611ee1a4d84e42194' |

	And I refill object tabular section "ObjectAccess":
		| 'Ref'                                                                  | 'Key'       | 'AccessKey'                                      | 'ValueRef'                                                              | 'Modify' | 'DoNotControl' | 'Value' |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68' | 'Company'   | 'e1cib/data/Catalog.AccessKey?refName=Company'   | ''                                                                      | 'True'   | 'True'         | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68' | 'Branch'    | 'e1cib/data/Catalog.AccessKey?refName=Branch'    | 'e1cib/data/Catalog.BusinessUnits?ref=33333333333333333333333333333333' | 'True'   | 'False'        | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68' | 'Store'     | 'e1cib/data/Catalog.AccessKey?refName=Store'     | ''                                                                      | 'True'   | 'True'         | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68' | 'Account'   | 'e1cib/data/Catalog.AccessKey?refName=Account'   | 'e1cib/data/Catalog.CashAccounts?ref=33333333333333333333333333333333'  | 'True'   | 'False'        | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68' | 'PriceType' | 'e1cib/data/Catalog.AccessKey?refName=PriceType' | 'e1cib/data/Catalog.PriceTypes?ref=33333333333333333333333333333333'    | 'True'   | 'False'        | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d' | 'Company'   | 'e1cib/data/Catalog.AccessKey?refName=Company'   | 'e1cib/data/Catalog.Companies?ref=33333333333333333333333333333333'     | 'True'   | 'False'        | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d' | 'Branch'    | 'e1cib/data/Catalog.AccessKey?refName=Branch'    | 'e1cib/data/Catalog.BusinessUnits?ref=33333333333333333333333333333333' | 'True'   | 'False'        | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d' | 'Store'     | 'e1cib/data/Catalog.AccessKey?refName=Store'     | 'e1cib/data/Catalog.Stores?ref=33333333333333333333333333333333'        | 'True'   | 'False'        | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d' | 'Account'   | 'e1cib/data/Catalog.AccessKey?refName=Account'   | 'e1cib/data/Catalog.CashAccounts?ref=33333333333333333333333333333333'  | 'True'   | 'False'        | ''      |
		| 'e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d' | 'PriceType' | 'e1cib/data/Catalog.AccessKey?refName=PriceType' | 'e1cib/data/Catalog.PriceTypes?ref=33333333333333333333333333333333'    | 'True'   | 'False'        | ''      |


Scenario: filling Access key in the AccessGroups
		And I move to "Access" tab
		And I go to line in "ObjectAccess" table
			| 'Value ref'                |
			| 'Company Only read access' |
		And I select current line in "ObjectAccess" table
		And I select "comp" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'                     |
			| 'Company Read and Write Access' |
		And I select current line in "ObjectAccess" table
		And I select "compa" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'                    |
			| 'Branch Read and Write Access' |
		And I select current line in "ObjectAccess" table
		And I select "bra" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'               |
			| 'Branch Only read access' |
		And I select current line in "ObjectAccess" table
		And I select "bran" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'                   |
			| 'Store Read and Write Access' |
		And I select current line in "ObjectAccess" table
		And I select "store" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'              |
			| 'Store Only read access' |
		And I select current line in "ObjectAccess" table
		And I select "store" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'                         |
			| 'CashAccount Read and Write Access' |
		And I select current line in "ObjectAccess" table
		And I select "acc" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'                    |
			| 'CashAccount Only read access' |
		And I select current line in "ObjectAccess" table
		And I select "acc" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'                       |
			| 'PriceType Read and Write Access' |
		And I select current line in "ObjectAccess" table
		And I select "price" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table
		And I go to line in "ObjectAccess" table
			| 'Value ref'                  |
			| 'PriceType Only read access' |
		And I select current line in "ObjectAccess" table
		And I select "price" from "Access key" drop-down list by string in "ObjectAccess" table
		And I finish line editing in "ObjectAccess" table