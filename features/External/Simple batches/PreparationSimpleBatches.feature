#language: en
@tree
@IgnoreOnCIMainBuild
@ExportScenarios

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: Create catalog SimpleBatch objects

	And I check or create catalog "SimpleBatch" objects:
		| 'Ref'                                                                 | 'DeletionMark' | 'Code' | 'Description' |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033121bcd' | 'False'        | 1      | 'P001'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033121bce' | 'False'        | 2      | 'P002'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033123bcd' | 'False'        | 3      | 'P003'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033124bce' | 'False'        | 4      | 'P004'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033125bcd' | 'False'        | 5      | 'P005'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033126bce' | 'False'        | 6      | 'P006'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033127bcd' | 'False'        | 7      | 'P007'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033128bce' | 'False'        | 8      | 'P008'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033129bcd' | 'False'        | 9      | 'P009'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033130bce' | 'False'        | 10     | 'P010'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033131bcd' | 'False'        | 11     | 'P011'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033132bce' | 'False'        | 12     | 'P012'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033133bcd' | 'False'        | 13     | 'P013'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033134bce' | 'False'        | 14     | 'P014'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033135bcd' | 'False'        | 15     | 'P015'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033136bce' | 'False'        | 16     | 'P016'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033137bcd' | 'False'        | 17     | 'P017'        |
		| 'e1cib/data/Catalog.SimpleBatch?ref=b85de730704fc69511f0450033138bce' | 'False'        | 18     | 'P018'        |